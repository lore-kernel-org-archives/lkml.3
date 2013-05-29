Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965843Ab3E2LD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:03:56 -0400
Received: from smtp.citrix.com ([66.165.176.89]:35866 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965804Ab3E2LDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:03:46 -0400
X-IronPort-AV: E=Sophos;i="4.87,763,1363132800"; 
   d="scan'208";a="27941724"
Date: Wed, 29 May 2013 12:03:26 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <marc.zyngier@arm.com>,
        <will.deacon@arm.com>, <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v4 1/4] xen: move xen_setup_runstate_info and
 get_runstate_snapshot to drivers/xen/time.c
In-Reply-To: <20130528181515.GB27718@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1305291159220.4799@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305281835080.4799@kaball.uk.xensource.com> <1369763672-12919-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130528181515.GB27718@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 May 2013, Konrad Rzeszutek Wilk wrote:
> On Tue, May 28, 2013 at 06:54:29PM +0100, Stefano Stabellini wrote:
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Acked-by: Ian Campbell <ian.campbell@citrix.com>
> > CC: konrad.wilk@oracle.com
> > 
> > Changes in v2:
> > - leave do_stolen_accounting in arch/x86/xen/time.c;
> > - use the new common functions in arch/ia64/xen/time.c.
> 
> So you also modify the function.

do_stolen_accounting? Just enought to call the new common function
xen_get_runstate_snapshot instead of the old x86 specific
get_runstate_snapshot.


> > ---
> >  arch/ia64/xen/time.c  |   48 +++----------------------
> >  arch/x86/xen/time.c   |   76 +----------------------------------------
> >  drivers/xen/Makefile  |    2 +-
> >  drivers/xen/time.c    |   91 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/xen/xen-ops.h |    5 +++
> >  5 files changed, 104 insertions(+), 118 deletions(-)
> >  create mode 100644 drivers/xen/time.c
> > 
> > diff --git a/arch/ia64/xen/time.c b/arch/ia64/xen/time.c
> > index 1f8244a..79a0b8c 100644
> > --- a/arch/ia64/xen/time.c
> > +++ b/arch/ia64/xen/time.c
> > @@ -34,53 +34,17 @@
> >  
> >  #include "../kernel/fsyscall_gtod_data.h"
> >  
> > -static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate);
> >  static DEFINE_PER_CPU(unsigned long, xen_stolen_time);
> >  static DEFINE_PER_CPU(unsigned long, xen_blocked_time);
> >  
> >  /* taken from i386/kernel/time-xen.c */
> >  static void xen_init_missing_ticks_accounting(int cpu)
> >  {
> > -	struct vcpu_register_runstate_memory_area area;
> > -	struct vcpu_runstate_info *runstate = &per_cpu(xen_runstate, cpu);
> > -	int rc;
> > +	xen_setup_runstate_info(&runstate);
> >  
> > -	memset(runstate, 0, sizeof(*runstate));
> > -
> > -	area.addr.v = runstate;
> > -	rc = HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area, cpu,
> > -				&area);
> > -	WARN_ON(rc && rc != -ENOSYS);
> > -
> > -	per_cpu(xen_blocked_time, cpu) = runstate->time[RUNSTATE_blocked];
> > -	per_cpu(xen_stolen_time, cpu) = runstate->time[RUNSTATE_runnable]
> > -					    + runstate->time[RUNSTATE_offline];
> > -}
> > -
> > -/*
> > - * Runstate accounting
> > - */
> > -/* stolen from arch/x86/xen/time.c */
> > -static void get_runstate_snapshot(struct vcpu_runstate_info *res)
> > -{
> > -	u64 state_time;
> > -	struct vcpu_runstate_info *state;
> > -
> > -	BUG_ON(preemptible());
> > -
> > -	state = &__get_cpu_var(xen_runstate);
> > -
> > -	/*
> > -	 * The runstate info is always updated by the hypervisor on
> > -	 * the current CPU, so there's no need to use anything
> > -	 * stronger than a compiler barrier when fetching it.
> > -	 */
> > -	do {
> > -		state_time = state->state_entry_time;
> > -		rmb();
> > -		*res = *state;
> > -		rmb();
> > -	} while (state->state_entry_time != state_time);
> > +	per_cpu(xen_blocked_time, cpu) = runstate.time[RUNSTATE_blocked];
> > +	per_cpu(xen_stolen_time, cpu) = runstate.time[RUNSTATE_runnable]
> > +					    + runstate.time[RUNSTATE_offline];
> >  }
> >  
> >  #define NS_PER_TICK (1000000000LL/HZ)
> > @@ -94,7 +58,7 @@ consider_steal_time(unsigned long new_itm)
> >  	struct vcpu_runstate_info runstate;
> >  	struct task_struct *p = current;
> >  
> > -	get_runstate_snapshot(&runstate);
> > +	xen_get_runstate_snapshot(&runstate);
> >  
> >  	/*
> >  	 * Check for vcpu migration effect
> > @@ -202,7 +166,7 @@ static unsigned long long xen_sched_clock(void)
> >  	 */
> >  	now = ia64_native_sched_clock();
> >  
> > -	get_runstate_snapshot(&runstate);
> > +	xen_get_runstate_snapshot(&runstate);
> >  
> >  	WARN_ON(runstate.state != RUNSTATE_running);
> >  
> > diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> > index 3d88bfd..c0ca15e 100644
> > --- a/arch/x86/xen/time.c
> > +++ b/arch/x86/xen/time.c
> > @@ -30,9 +30,6 @@
> >  #define TIMER_SLOP	100000
> >  #define NS_PER_TICK	(1000000000LL / HZ)
> >  
> > -/* runstate info updated by Xen */
> > -static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate);
> > -
> >  /* snapshots of runstate info */
> >  static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate_snapshot);
> >  
> > @@ -40,77 +37,6 @@ static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate_snapshot);
> >  static DEFINE_PER_CPU(u64, xen_residual_stolen);
> >  static DEFINE_PER_CPU(u64, xen_residual_blocked);
> >  
> > -/* return an consistent snapshot of 64-bit time/counter value */
> > -static u64 get64(const u64 *p)
> > -{
> > -	u64 ret;
> > -
> > -	if (BITS_PER_LONG < 64) {
> > -		u32 *p32 = (u32 *)p;
> > -		u32 h, l;
> > -
> > -		/*
> > -		 * Read high then low, and then make sure high is
> > -		 * still the same; this will only loop if low wraps
> > -		 * and carries into high.
> > -		 * XXX some clean way to make this endian-proof?
> > -		 */
> > -		do {
> > -			h = p32[1];
> > -			barrier();
> > -			l = p32[0];
> > -			barrier();
> > -		} while (p32[1] != h);
> > -
> > -		ret = (((u64)h) << 32) | l;
> > -	} else
> > -		ret = *p;
> > -
> > -	return ret;
> > -}
> > -
> > -/*
> > - * Runstate accounting
> > - */
> > -static void get_runstate_snapshot(struct vcpu_runstate_info *res)
> > -{
> > -	u64 state_time;
> > -	struct vcpu_runstate_info *state;
> > -
> > -	BUG_ON(preemptible());
> > -
> > -	state = &__get_cpu_var(xen_runstate);
> > -
> > -	/*
> > -	 * The runstate info is always updated by the hypervisor on
> > -	 * the current CPU, so there's no need to use anything
> > -	 * stronger than a compiler barrier when fetching it.
> > -	 */
> > -	do {
> > -		state_time = get64(&state->state_entry_time);
> > -		barrier();
> > -		*res = *state;
> > -		barrier();
> > -	} while (get64(&state->state_entry_time) != state_time);
> > -}
> > -
> > -/* return true when a vcpu could run but has no real cpu to run on */
> > -bool xen_vcpu_stolen(int vcpu)
> > -{
> > -	return per_cpu(xen_runstate, vcpu).state == RUNSTATE_runnable;
> > -}
> > -
> > -void xen_setup_runstate_info(int cpu)
> > -{
> > -	struct vcpu_register_runstate_memory_area area;
> > -
> > -	area.addr.v = &per_cpu(xen_runstate, cpu);
> > -
> > -	if (HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area,
> > -			       cpu, &area))
> > -		BUG();
> > -}
> > -
> >  static void do_stolen_accounting(void)
> >  {
> >  	struct vcpu_runstate_info state;
> > @@ -118,7 +44,7 @@ static void do_stolen_accounting(void)
> >  	s64 blocked, runnable, offline, stolen;
> >  	cputime_t ticks;
> >  
> > -	get_runstate_snapshot(&state);
> > +	xen_get_runstate_snapshot(&state);
> >  
> >  	WARN_ON(state.state != RUNSTATE_running);
> >  
> > diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> > index eabd0ee..2bf461a 100644
> > --- a/drivers/xen/Makefile
> > +++ b/drivers/xen/Makefile
> > @@ -3,7 +3,7 @@ obj-y	+= manage.o
> >  obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
> >  endif
> >  obj-$(CONFIG_X86)			+= fallback.o
> > -obj-y	+= grant-table.o features.o events.o balloon.o
> > +obj-y	+= grant-table.o features.o events.o balloon.o time.o
> >  obj-y	+= xenbus/
> >  
> >  nostackp := $(call cc-option, -fno-stack-protector)
> > diff --git a/drivers/xen/time.c b/drivers/xen/time.c
> > new file mode 100644
> > index 0000000..c2e39d3
> > --- /dev/null
> > +++ b/drivers/xen/time.c
> > @@ -0,0 +1,91 @@
> > +/*
> > + * Xen stolen ticks accounting.
> > + */
> > +#include <linux/kernel.h>
> > +#include <linux/kernel_stat.h>
> > +#include <linux/math64.h>
> > +#include <linux/gfp.h>
> > +
> > +#include <asm/xen/hypervisor.h>
> > +#include <asm/xen/hypercall.h>
> > +
> > +#include <xen/events.h>
> > +#include <xen/features.h>
> > +#include <xen/interface/xen.h>
> > +#include <xen/interface/vcpu.h>
> > +#include <xen/xen-ops.h>
> > +
> > +/* runstate info updated by Xen */
> > +static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate);
> > +
> > +/* return an consistent snapshot of 64-bit time/counter value */
> > +static u64 get64(const u64 *p)
> > +{
> > +	u64 ret;
> > +
> > +	if (BITS_PER_LONG < 64) {
> > +		u32 *p32 = (u32 *)p;
> > +		u32 h, l;
> > +
> > +		/*
> > +		 * Read high then low, and then make sure high is
> > +		 * still the same; this will only loop if low wraps
> > +		 * and carries into high.
> > +		 * XXX some clean way to make this endian-proof?
> > +		 */
> > +		do {
> > +			h = p32[1];
> > +			barrier();
> > +			l = p32[0];
> > +			barrier();
> > +		} while (p32[1] != h);
> > +
> > +		ret = (((u64)h) << 32) | l;
> > +	} else
> > +		ret = *p;
> > +
> > +	return ret;
> > +}
> > +
> > +/*
> > + * Runstate accounting
> > + */
> > +void xen_get_runstate_snapshot(struct vcpu_runstate_info *res)
> > +{
> > +	u64 state_time;
> > +	struct vcpu_runstate_info *state;
> > +
> > +	BUG_ON(preemptible());
> > +
> > +	state = &__get_cpu_var(xen_runstate);
> > +
> > +	/*
> > +	 * The runstate info is always updated by the hypervisor on
> > +	 * the current CPU, so there's no need to use anything
> > +	 * stronger than a compiler barrier when fetching it.
> > +	 */
> > +	do {
> > +		state_time = get64(&state->state_entry_time);
> > +		barrier();
> > +		*res = *state;
> > +		barrier();
> > +	} while (get64(&state->state_entry_time) != state_time);
> > +}
> > +
> > +/* return true when a vcpu could run but has no real cpu to run on */
> > +bool xen_vcpu_stolen(int vcpu)
> > +{
> > +	return per_cpu(xen_runstate, vcpu).state == RUNSTATE_runnable;
> > +}
> > +
> > +void xen_setup_runstate_info(int cpu)
> > +{
> > +	struct vcpu_register_runstate_memory_area area;
> > +
> > +	area.addr.v = &per_cpu(xen_runstate, cpu);
> > +
> > +	if (HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area,
> > +			       cpu, &area))
> > +		BUG();
> 
> The original code did:
> 
> -       rc = HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area, cpu,
> -                               &area);
> -       WARN_ON(rc && rc != -ENOSYS);
> -
> Any reason not to do this?

The original x86 code just BUGs out: I took that version over the ia64
version.
