Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab3HBTJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:09:46 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46747 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab3HBTJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:09:45 -0400
Date: Fri, 2 Aug 2013 15:09:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: Mike Rapoport <mike.rapoport@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, xen-devel@lists.xensource.com
Subject: Re: [QUERY] lguest64
Message-ID: <20130802190934.GA4354@phenom.dumpdata.com>
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com>
 <51E97779.3020103@zytor.com>
 <87zjte9iah.fsf@rustcorp.com.au>
 <CABpLfohrweJd0=0eFJDO7dv2HHxx_mbP0uySMDrsZZZXExdXug@mail.gmail.com>
 <51F9005F.30501@zytor.com>
 <20130731131757.GB22124@phenom.dumpdata.com>
 <51F91030.9060606@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F91030.9060606@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 06:25:04AM -0700, H. Peter Anvin wrote:
> On 07/31/2013 06:17 AM, Konrad Rzeszutek Wilk wrote:
> >>
> >> The big problem with pvops is that they are a permanent tax on future
> >> development -- a classic case of "the hooks problem."  As such it is
> >> important that there be a real, significant, use case with enough users
> >> to make the pain worthwhile.  With Xen looking at sunsetting PV support
> >> with a long horizon, it might currently be possible to remove pvops some
> > 
> > PV MMU parts specifically.
> > 
> 
> Pretty much stuff that is driverized on plain hardware doesn't matter.
> What are you looking at with respect to the basic CPU control state?


CC-ing Mukesh here.

Let me iterate down what the experimental patch uses:

         struct pv_init_ops pv_init_ops;                                         
		[still use xen_patch, but I think that is not needed anymore]

         struct pv_time_ops pv_time_ops;                                         
		[we need that as we are using the PV clock source]

         struct pv_cpu_ops pv_cpu_ops;                                           
		[only end up using cpuid. This one is a tricky one. We could
		 arguable remove it but it does do some filtering - for example
	 	 THERM is turned off, or MWAIT if a certain hypercall tells us to
		 disable that. Since this is now a trapped operation this could be
		 handled in the hypervisor - but then it would be in charge of
		 filtering certain CPUID - and this is at bootup - so there is not
		 user interaction. This needs a bit more of thinking]

         struct pv_irq_ops pv_irq_ops;                                           
		[none so far, we use normal sti/cli

         struct pv_apic_ops pv_apic_ops;                                         
		[we over-write them without own event channel logic for IPI's, etc.
		Thought with virtualized APIC this could be done differently and
		some Intel engineers told me that they have it on their roadmap]
	
         struct pv_mmu_ops pv_mmu_ops;                                           
		[we use two:
		- .flush_tlb_others (xen_flush_tlb_others) - and I think we
		  actually remove that. Mukesh, do you recall why we need it?
		 - .pagetable_init - but that can be moved out as the
		only reason it does that is to use a new address (__va)
		on the shared page (it swaps out of using the __kva to
		using __va).]

         struct pv_lock_ops pv_lock_ops;   
		[still using that]


Please please take this with a grain of salt. The patches are still experimental
so we might be missing something and this is not set in stone.


