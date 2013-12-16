Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3LPMQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:16:53 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:34859 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab3LPMQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:16:51 -0500
Date: Mon, 16 Dec 2013 14:16:38 +0200
From: Gleb Natapov <gleb@kernel.org>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pmatouse@redhat.com, stable@vger.kernel.org,
        larsbull@google.com
Subject: Re: [PATCH] KVM: x86: fix guest-initiated crash with x2apic
 (CVE-2013-6376)
Message-ID: <20131216121637.GB24218@minantech.com>
References: <1386880614-23300-4-git-send-email-pbonzini@redhat.com>
 <20131213160754.GA20763@hpx.cz>
 <20131214094614.GF21068@minantech.com>
 <20131216120109.GA3324@hpx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20131216120109.GA3324@hpx.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 01:01:10PM +0100, Radim Krčmář wrote:
> > >  - Where does the 'only one supported cluster' come from?
> > > 
> > "only one supported cluster" comes from 8 bit cpuid limitation of KVM's x2apic
> > implementation. With 8 bit cpuid you can only address cluster 0 in logical mode.
> 
> One x2apic cluster has 16 cpus and we generate the x2apic LDR correctly,
> so 8 bit cpuid can address first 16 clusters as well.
> 
>   u32 ldr = ((id >> 4) << 16) | (1 << (id & 0xf));
> 
Interrupt from a device cannot generate such ldr, only IPI can. Only
4 cpus in cluster zero are addressable in clustering mode by a
device. Without irq remapping x2apic is a PV interface between host
and guest where guest needs to know KVM implementation's limitation to
use it. I do not see a point in fixing problems in x2apic logical mode
emulation right now since it will not make it usable, as long as
there is not security problems there.

> > >    I only see we use 'struct kvm_lapic *logical_map[16][16];', which
> > >    supports 16 clusters of 16 apics = first 256 vcpus, so if we map
> > >    everything to logical_map[0][0:15], we would not work correctly in
> > >    the cluster x2apic, with > 16 vcpus.
> > > 
> > Such config cannot work today because of 8 bit cpuid limitation. When the limitation
> > will be removed KMV_X2APIC_CID_BITS will be set to actual number of bits we want to support.
> 
> Even with KMV_X2APIC_CID_BITS = 4, which would allow us to support 8 bit
> cpuid, we would still deliver interrupts destined for cpuid > 256 to
> potentially plugged cpus.
Again, KMV_X2APIC_CID_BITS = 4 will not allow us to support 8 bit cpuids
unfortunately, not sure what you mean by the second part of the sentence.

--
			Gleb.
