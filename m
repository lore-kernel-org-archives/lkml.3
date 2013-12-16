Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3LPMBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:01:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab3LPMBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:01:19 -0500
Date: Mon, 16 Dec 2013 13:01:10 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Gleb Natapov <gleb@minantech.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        gleb@redhat.com, kvm@vger.kernel.org, pmatouse@redhat.com,
        stable@vger.kernel.org, larsbull@google.com
Subject: Re: [PATCH] KVM: x86: fix guest-initiated crash with x2apic
 (CVE-2013-6376)
Message-ID: <20131216120109.GA3324@hpx.cz>
References: <1386880614-23300-4-git-send-email-pbonzini@redhat.com>
 <20131213160754.GA20763@hpx.cz>
 <20131214094614.GF21068@minantech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131214094614.GF21068@minantech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-12-14 11:46+0200, Gleb Natapov:
> On Fri, Dec 13, 2013 at 05:07:54PM +0100, Radim Krčmář wrote:
> > 2013-12-12 21:36+0100, Paolo Bonzini:
> > > From: Gleb Natapov <gleb@redhat.com>
> > > 
> > > A guest can cause a BUG_ON() leading to a host kernel crash.
> > > When the guest writes to the ICR to request an IPI, while in x2apic
> > > mode the following things happen, the destination is read from
> > > ICR2, which is a register that the guest can control.
> > > 
> > > kvm_irq_delivery_to_apic_fast uses the high 16 bits of ICR2 as the
> > > cluster id.  A BUG_ON is triggered, which is a protection against
> > > accessing map->logical_map with an out-of-bounds access and manages
> > > to avoid that anything really unsafe occurs.
> > > 
> > > The logic in the code is correct from real HW point of view. The problem
> > > is that KVM supports only one cluster with ID 0 in clustered mode, but
> > > the code that has the bug does not take this into account.
> > 
> > The more I read about x2apic, the more confused I am ...
> > 
> >  - How was the cluster x2apic enabled?
> > 
> >    Linux won't enable cluster x2apic without interrupt remapping and I
> >    had no idea we were allowed to do it.
> > 
> Malicious code can do it.
> 
> >  - A hardware test-suite found this?
> > 
> >    This bug can only be hit when the destination cpu is > 256, so the
> >    request itself is buggy -- we don't support that many in kvm and it
> >    would crash when initializing the vcpus if we did.
> >    => It looks like we should just ignore the ipi, because we have no
> >       vcpus in that cluster.
> > 
> That's the nature of malicious code: it does what your code does not expects
> it to do :)

I was wondering if there wasn't malicious linux on the other side too :)

> >  - Where does the 'only one supported cluster' come from?
> > 
> "only one supported cluster" comes from 8 bit cpuid limitation of KVM's x2apic
> implementation. With 8 bit cpuid you can only address cluster 0 in logical mode.

One x2apic cluster has 16 cpus and we generate the x2apic LDR correctly,
so 8 bit cpuid can address first 16 clusters as well.

  u32 ldr = ((id >> 4) << 16) | (1 << (id & 0xf));

> >    I only see we use 'struct kvm_lapic *logical_map[16][16];', which
> >    supports 16 clusters of 16 apics = first 256 vcpus, so if we map
> >    everything to logical_map[0][0:15], we would not work correctly in
> >    the cluster x2apic, with > 16 vcpus.
> > 
> Such config cannot work today because of 8 bit cpuid limitation. When the limitation
> will be removed KMV_X2APIC_CID_BITS will be set to actual number of bits we want to support.

Even with KMV_X2APIC_CID_BITS = 4, which would allow us to support 8 bit
cpuid, we would still deliver interrupts destined for cpuid > 256 to
potentially plugged cpus.

> It will likely be smaller then 16 bit though since full 18 bit support will require huge tables.

Yeah, we'll have to do dynamic allocation if we are ever going to need
the full potential of x2apic.
(2^20-16 cpus in cluster and 2^32-1 in flat mode)
