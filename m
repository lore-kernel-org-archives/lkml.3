Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab3JDNUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:20:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37646 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab3JDNUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:20:43 -0400
Date: Fri, 4 Oct 2013 09:20:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Frediano Ziglio <frediano.ziglio@citrix.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen: Fix possible user space selector
 corruption
Message-ID: <20131004132033.GA26673@phenom.dumpdata.com>
References: <1380788677.30462.1.camel@hamster.uk.xensource.com>
 <524D4132.3000809@citrix.com>
 <1380804692.30462.3.camel@hamster.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380804692.30462.3.camel@hamster.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 01:51:32PM +0100, Frediano Ziglio wrote:
> On Thu, 2013-10-03 at 11:04 +0100, Andrew Cooper wrote:
> > On 03/10/13 09:24, Frediano Ziglio wrote:
> > > Due to the way kernel is initialized under Xen is possible that the ring1
> > > selector used by the kernel for the boot cpu end up to be copied to
> > > userspace leading to segmentation fault in the userspace.
> > >
> > >
> > > Xen code in the kernel initialize no-boot cpus with correct selectors (ds
> > > and es set to __USER_DS) but the boot one keep the ring1 (passed by Xen).
> > > On task context switch (switch_to) we assume that ds, es and cs already
> > > point to __USER_DS and __KERNEL_CSso these selector are not changed.
> > >
> > > If processor is an Intel that support sysenter instruction sysenter/sysexit
> > > is used so ds and es are not restored switching back from kernel to
> > > userspace. In the case the selectors point to a ring1 instead of __USER_DS
> > > the userspace code will crash on first memory access attempt (to be
> > > precise Xen on the emulated iret used to do sysexit will detect and set ds
> > > and es to zero which lead to GPF anyway).
> > >
> > > Now if an userspace process call kernel using sysenter and get rescheduled
> > > (for me it happen on a specific init calling wait4) could happen that the
> > > ring1 selector is set to ds and es.
> > >
> > > This is quite hard to detect cause after a while these selectors are fixed
> > > (__USER_DS seems sticky).
> > >
> > > Bisecting the code commit 7076aada1040de4ed79a5977dbabdb5e5ea5e249 appears
> > > to be the first one that have this issue.
> > >
> > > Signed-off-by: Frediano Ziglio <frediano.ziglio@citrix.com>
> > 
> > In terms of the correctness of the fix,
> > 
> > Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>

Should this also go in stable tree?
> > 
> > However, I am not sure the comment is necessary.  The prevailing style
> > is for no justification of loads of segment selectors on boot, and the
> > comment itself refers simply to an interaction issue of 32bit on Xen
> > when making use of sysenter.
> > 
> 
> Suggestion for the comment ??
> 
> Frediano
> 
> > > ---
> > >  arch/x86/xen/smp.c |   12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > >
> > > diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> > > index d1e4777..2a47241 100644
> > > --- a/arch/x86/xen/smp.c
> > > +++ b/arch/x86/xen/smp.c
> > > @@ -278,6 +278,18 @@ static void __init xen_smp_prepare_boot_cpu(void)
> > >  		   old memory can be recycled */
> > >  		make_lowmem_page_readwrite(xen_initial_gdt);
> > >  
> > > +#ifdef CONFIG_X86_32
> > > +		/*
> > > +		 * Assure we use segments with user level access.
> > > +		 * During switching of task these segments got not reloaded
> > > +		 * so it could happen that userspace tasks get Xen ring1
> > > +		 * selector causing exit with sysenter failures on next
> > > +		 * userspace memory operation.
> > > +		 */
> > > +		loadsegment(ds, __USER_DS);
> > > +		loadsegment(es, __USER_DS);
> > > +#endif
> > > +
> > >  		xen_filter_cpu_maps();
> > >  		xen_setup_vcpu_info_placement();
> > >  	}
> > 
> 
> 
