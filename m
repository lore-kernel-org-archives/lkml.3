Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab3EGMDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:03:20 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:28122 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757621Ab3EGMDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:03:19 -0400
X-IronPort-AV: E=Sophos;i="4.87,628,1363132800"; 
   d="scan'208";a="22584554"
Date: Tue, 7 May 2013 12:58:32 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH RFC v2 4/4] xen/arm: account for stolen
 ticks
In-Reply-To: <1367918270.26321.39.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1305071252350.4147@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305061532310.4756@kaball.uk.xensource.com>  <1367851878-21629-4-git-send-email-stefano.stabellini@eu.citrix.com> <1367918270.26321.39.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 May 2013, Ian Campbell wrote:
> On Mon, 2013-05-06 at 15:51 +0100, Stefano Stabellini wrote:
> > Register the runstate_memory_area with the hypervisor.
> > Use pv_time_ops.steal_clock to account for stolen ticks.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/arm/xen/enlighten.c |   23 +++++++++++++++++++++++
> >  1 files changed, 23 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > index ee86bfa..2a5cc82 100644
> > --- a/arch/arm/xen/enlighten.c
> > +++ b/arch/arm/xen/enlighten.c
> > @@ -14,7 +14,10 @@
> >  #include <xen/xen-ops.h>
> >  #include <asm/xen/hypervisor.h>
> >  #include <asm/xen/hypercall.h>
> > +#include <asm/arch_timer.h>
> >  #include <asm/system_misc.h>
> > +#include <asm/paravirt.h>
> > +#include <linux/jump_label.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/irqreturn.h>
> >  #include <linux/module.h>
> > @@ -152,6 +155,20 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
> >  }
> >  EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
> >  
> > +unsigned long long xen_stolen_accounting(int cpu)
> > +{
> > +	struct vcpu_runstate_info state;
> > +
> > +	if (cpu != get_cpu())
> 
> get_cpu disables preempt, so you need a matching put_cpu.

Oops, thanks.


> But actually I think you just want smp_processor_id and you probably
> want the BUG_ON form to get unlikely etc.
>
> That said, you don't use cpu for anything else, so why not drop it
> entirely?

Ah, that's right, legacy of the past. I'll do that.


> > +		BUG();
> > +
> > +	xen_get_runstate_snapshot(&state);
> > +
> > +	WARN_ON(state.state != RUNSTATE_running);
> > +
> > +	return state.time[RUNSTATE_runnable] + state.time[RUNSTATE_offline];
> > +}
> > +
> >  static void __init xen_percpu_init(void *unused)
> >  {
> >  	struct vcpu_register_vcpu_info info;
> > @@ -170,6 +187,8 @@ static void __init xen_percpu_init(void *unused)
> >  		BUG();
> >  	per_cpu(xen_vcpu, cpu) = vcpup;
> >  
> > +	xen_setup_runstate_info(cpu);
> > +
> >  	enable_percpu_irq(xen_events_irq, 0);
> >  }
> >  
> > @@ -301,6 +320,10 @@ static int __init xen_init_events(void)
> >  
> >  	on_each_cpu(xen_percpu_init, NULL, 0);
> >  
> > +	pv_time_ops.steal_clock = xen_stolen_accounting;
> > +	static_key_slow_inc(&paravirt_steal_enabled);
> > +	static_key_slow_inc(&paravirt_steal_rq_enabled);
> 
> We don't seem to do this on x86 -- is that a bug on x86 on Xen?

On x86 we do all the accounting in do_stolen_accounting, called from our
own interrupt handler (xen_timer_interrupt).
I don't think we would gain anything by using the common infrastructure,
we would actually loose the idle ticks accounting we do there.

Speaking of which, I don't think that pv_time_ops.steal_clock would
properly increase CPUTIME_IDLE the way we do in do_stolen_accounting.

How much of an issue is that?
