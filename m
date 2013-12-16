Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab3LPMze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:55:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664Ab3LPMzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:55:32 -0500
Date: Mon, 16 Dec 2013 13:55:27 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Gleb Natapov <gleb@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pmatouse@redhat.com, stable@vger.kernel.org,
        larsbull@google.com
Subject: Re: [PATCH] KVM: x86: fix guest-initiated crash with x2apic
 (CVE-2013-6376)
Message-ID: <20131216125526.GC3324@hpx.cz>
References: <1386880614-23300-4-git-send-email-pbonzini@redhat.com>
 <20131213160754.GA20763@hpx.cz>
 <20131214094614.GF21068@minantech.com>
 <20131216120109.GA3324@hpx.cz>
 <20131216121637.GB24218@minantech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131216121637.GB24218@minantech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-12-16 14:16+0200, Gleb Natapov:
> On Mon, Dec 16, 2013 at 01:01:10PM +0100, Radim Krčmář wrote:
> > > >  - Where does the 'only one supported cluster' come from?
> > > > 
> > > "only one supported cluster" comes from 8 bit cpuid limitation of KVM's x2apic
> > > implementation. With 8 bit cpuid you can only address cluster 0 in logical mode.
> > 
> > One x2apic cluster has 16 cpus and we generate the x2apic LDR correctly,
> > so 8 bit cpuid can address first 16 clusters as well.
> > 
> >   u32 ldr = ((id >> 4) << 16) | (1 << (id & 0xf));
> > 
> Interrupt from a device cannot generate such ldr, only IPI can. Only
> 4 cpus in cluster zero are addressable in clustering mode by a
> device. Without irq remapping x2apic is a PV interface between host
> and guest where guest needs to know KVM implementation's limitation to
> use it.

Thanks, I'll read more about devices ... still no idea how could they
address cluster > 15.

>         I do not see a point in fixing problems in x2apic logical mode
> emulation right now since it will not make it usable, as long as
> there is not security problems there.

Agreed; I wanted to know why this patch was correct, if we cared.

> > > >    I only see we use 'struct kvm_lapic *logical_map[16][16];', which
> > > >    supports 16 clusters of 16 apics = first 256 vcpus, so if we map
> > > >    everything to logical_map[0][0:15], we would not work correctly in
> > > >    the cluster x2apic, with > 16 vcpus.
> > > > 
> > > Such config cannot work today because of 8 bit cpuid limitation. When the limitation
> > > will be removed KMV_X2APIC_CID_BITS will be set to actual number of bits we want to support.
> > 
> > Even with KMV_X2APIC_CID_BITS = 4, which would allow us to support 8 bit
> > cpuid, we would still deliver interrupts destined for cpuid > 256 to
> > potentially plugged cpus.
> Again, KMV_X2APIC_CID_BITS = 4 will not allow us to support 8 bit cpuids
> unfortunately, not sure what you mean by the second part of the sentence.

Sorry, I meant that with this change, we map all clusters to cluster 0,
which has two flaws:
 - in kvm_lapic_set_base(), the order of vcpu creation determines those
   assigned to cluster 0, and the rest is unaddressable (overwritten)
 - we can send IPI to an unplugged high cpuid and it arives in cluster 0
