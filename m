Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab3EHRDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 13:03:12 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:48814 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab3EHRDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 13:03:10 -0400
X-IronPort-AV: E=Sophos;i="4.87,636,1363132800"; 
   d="scan'208";a="22930359"
Date: Wed, 8 May 2013 18:03:07 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v3 4/4] xen/arm: account for stolen ticks
In-Reply-To: <518A7836.4030705@arm.com>
Message-ID: <alpine.DEB.2.02.1305081712390.18865@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305081446580.18865@kaball.uk.xensource.com> <1368027714-14506-4-git-send-email-stefano.stabellini@eu.citrix.com> <518A7836.4030705@arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 May 2013, Marc Zyngier wrote:
> Hi Stefano,
> 
> On 08/05/13 16:41, Stefano Stabellini wrote:
> > Register the runstate_memory_area with the hypervisor.
> > Use pv_time_ops.steal_clock to account for stolen ticks.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > Changes in v3:
> > - use BUG_ON and smp_processor_id.
> > ---
> >  arch/arm/xen/enlighten.c |   22 ++++++++++++++++++++++
> >  1 files changed, 22 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > index 13609e0..dfa7738 100644
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
> > @@ -152,6 +155,19 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
> >  }
> >  EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
> >  
> > +unsigned long long xen_stolen_accounting(int cpu)
> > +{
> > +	struct vcpu_runstate_info state;
> > +
> > +	BUG_ON(cpu != smp_processor_id());
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
> > @@ -169,6 +185,8 @@ static void __init xen_percpu_init(void *unused)
> >  	BUG_ON(err);
> >  	per_cpu(xen_vcpu, cpu) = vcpup;
> >  
> > +	xen_setup_runstate_info(cpu);
> > +
> >  	enable_percpu_irq(xen_events_irq, 0);
> >  }
> >  
> > @@ -300,6 +318,10 @@ static int __init xen_init_events(void)
> >  
> >  	on_each_cpu(xen_percpu_init, NULL, 0);
> >  
> > +	pv_time_ops.steal_clock = xen_stolen_accounting;
> 
> What guarantee do we have that this is done before the rest of the
> kernel calls paravirt_steal_clock()?

That's not a problem: paravirt_steal_clock is not called unless
paravirt_steal_enabled or paravirt_steal_rq_enabled are set. Also
steal_clock is always increasing so loosing the first few updates is not
an issue.


> What if we have Xen support enabled but don't run as a Xen guest?

That's fine as long as the Xen runstate_memory_area interface is
available.
Usually I am a great fun of feature flags, so that every feature can be
dynamically enabled or disabled and an hypervisor interface can be only
partially implemented.

However the runstate_memory_area is very old and I would consider it
one of the core interfaces that need to be available in order to claim
"Xen compatibility".


> > +	static_key_slow_inc(&paravirt_steal_enabled);
> > +	static_key_slow_inc(&paravirt_steal_rq_enabled);
> > +
> >  	return 0;
> >  }
> >  postcore_initcall(xen_init_events);
> > 
