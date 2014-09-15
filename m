Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaIOT2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:28:53 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46369 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbaIOT2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:28:50 -0400
Date: Mon, 15 Sep 2014 15:28:36 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>, roger.pau@citrix.com
Cc: Mukesh Rathor <mukesh.rathor@oracle.com>, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [V5 PATCH 1/1] x86/xen: Set EFER.NX and EFER.SCE in
 PVH guests
Message-ID: <20140915192836.GE3683@laptop.dumpdata.com>
References: <1410392166-16388-1-git-send-email-mukesh.rathor@oracle.com>
 <1410392166-16388-2-git-send-email-mukesh.rathor@oracle.com>
 <20140912204258.GA24846@laptop.dumpdata.com>
 <5416FBA1.2060902@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5416FBA1.2060902@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 03:45:53PM +0100, David Vrabel wrote:
> On 12/09/14 21:42, Konrad Rzeszutek Wilk wrote:
> > On Wed, Sep 10, 2014 at 04:36:06PM -0700, Mukesh Rathor wrote:
> >> 
> >> @@ -413,15 +417,18 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
> >>  					(unsigned long)xen_failsafe_callback;
> >>  		ctxt->user_regs.cs = __KERNEL_CS;
> >>  		per_cpu(xen_cr3, cpu) = __pa(swapper_pg_dir);
> >> -#ifdef CONFIG_X86_32
> >>  	}
> >> -#else
> >> -	} else
> >> -		/* N.B. The user_regs.eip (cpu_bringup_and_idle) is called with
> >> -		 * %rdi having the cpu number - which means are passing in
> >> -		 * as the first parameter the cpu. Subtle!
> >> +#ifdef CONFIG_XEN_PVH
> >> +	else {
> >> +		/*
> >> +		 * The vcpu comes on kernel page tables which have the NX pte
> >> +		 * bit set. This means before DS/SS is touched, NX in
> >> +		 * EFER must be set. Hence the following assembly glue code.
> > 
> > And you ripped out the nice 'N.B' comment I added. Sad :-(
> 
> I think I removed that.
> 
> I don't think passing parameters to a function is particularly subtle
> and this comment is largely superseded by the comment for
> xen_pvh_early_cpu_init() itself.

Good point.
> 
> >> +#ifdef CONFIG_XEN_PVH
> >> +/*
> >> + * xen_pvh_early_cpu_init() - early PVH VCPU initialization
> >> + * @cpu: this cpu number (%rdi)
> >> + * @flag: boolean flag true to indicate this is a secondary vcpu coming up
> >> + *        on this entry point or the primary cpu coming back online.
> > 
> > Why do we do this? Why not just piggyback on the first parameter - the 'cpu'?
> > 
> > If it is zero it is boot CPU.
> 
> "Changes in v5 (Mukesh):
>   - Jan reminded us that vcpu 0 could go offline/online. So, add flag back"

Right, totally forgot about that.

With that I think I think you can tack on 'Reviewed-by: Konrad Rzeszutek
Wilk <konrad.wilk@oracle.com>'.

Granted the PVH ABI doc needs to go in Xen base first as David requested.
Even a draft that explains some of this would be good. 

CC-ing Roger - perhaps v1 of the draft could be posted and we can flesh it
out more?
> 
> David
