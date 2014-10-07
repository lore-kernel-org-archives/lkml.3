Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaJGFVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 01:21:02 -0400
Received: from gate.crashing.org ([63.228.1.57]:35534 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbaJGFU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 01:20:59 -0400
Message-ID: <1412659233.30859.144.camel@pasglop>
Subject: Re: [PATCH v2 3/3] powerpc/powernv/cpuidle: Add workaround to
 enable fastsleep
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linux-pm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Date: Tue, 07 Oct 2014 16:20:33 +1100
In-Reply-To: <1412149560-2953-4-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1412149560-2953-1-git-send-email-shreyas@linux.vnet.ibm.com>
	 <1412149560-2953-4-git-send-email-shreyas@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 13:16 +0530, Shreyas B. Prabhu wrote:
> From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> 
> Fast sleep is an idle state, where the core and the L1 and L2
> caches are brought down to a threshold voltage. This also means that
> the communication between L2 and L3 caches have to be fenced. However
> the current P8 chips have a bug wherein this fencing between L2 and
> L3 caches get delayed by a cpu cycle. This can delay L3 response to
> the other cpus if they request for data during this time. Thus they
> would fetch the same data from the memory which could lead to data
> corruption if L3 cache is not flushed.
> 
> The cpu idle states save power at a core level and not at a thread level.
> Hence powersavings is based on the shallowest idle state that a thread
> of a core is in. The above issue in fastsleep will arise only when
> all the threads in a core either enter fastsleep or some of them enter
> any deeper idle states, with only a few being in fastsleep. This patch
> therefore implements a workaround this bug  by ensuring
> that, each time a cpu goes to fastsleep, it checks if it is the last
> thread in the core to enter fastsleep. If so, it needs to make an opal
> call to get around the above mentioned fastsleep problem in the hardware
> before issuing the sleep instruction.
> 
> Similarly when a thread in a core comes out of fastsleep, it needs
> to verify if its the first thread in the core to come out of fastsleep
> and issue the opal call to revert the changes made while entering
> fastsleep.
> 
> For the same reason mentioned above we need to take care of offline threads
> as well since we allow them to enter fastsleep and with support for
> deep winkle soon coming in they can enter winkle as well.  We therefore
> ensure that even offline threads make the above mentioned opal calls
> similarly, so that as long as the threads in a core are in and
> idle state >= fastsleep, we have the workaround in place. Whenever a
> thread comes out of either of these states, it needs to verify if the
> opal call has been made and if so it will revert it. For now this patch
> ensures that offline threads enter fastsleep.
> 
> We need to be able to synchronize the cpus in a core which are entering
> and exiting fastsleep so as to ensure that the last thread in the core
> to enter fastsleep and the first to exit fastsleep *only* issue the opal
> call. To do so, we need a per-core lock and counter. The counter is
> required to keep track of the number of threads in a core which are in
> idle state >= fastsleep. To make the implementation of this simple, we
> introduce a per-cpu lock and counter and every thread always takes the
> primary thread's lock, modifies the primary thread's counter. This
> effectively makes them per-core entities.
> 
> But the workaround is abstracted in the powernv core code and neither
> the hotplug path nor the cpuidle driver need to bother about it. All
> they need to know is if fastsleep, with error or no error is present as
> an idle state.
> 
> Cc: linux-pm@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> ---
>  arch/powerpc/include/asm/machdep.h             |   3 +
>  arch/powerpc/include/asm/opal.h                |   3 +
>  arch/powerpc/include/asm/processor.h           |   4 +-
>  arch/powerpc/kernel/idle.c                     |  19 ++++
>  arch/powerpc/kernel/idle_power7.S              |   2 +-
>  arch/powerpc/platforms/powernv/opal-wrappers.S |   1 +
>  arch/powerpc/platforms/powernv/setup.c         | 139 ++++++++++++++++++-------
>  drivers/cpuidle/cpuidle-powernv.c              |   8 +-
>  8 files changed, 140 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
> index b125cea..f37014f 100644
> --- a/arch/powerpc/include/asm/machdep.h
> +++ b/arch/powerpc/include/asm/machdep.h
> @@ -298,6 +298,9 @@ struct machdep_calls {
>  #ifdef CONFIG_MEMORY_HOTREMOVE
>  	int (*remove_memory)(u64, u64);
>  #endif
> +	/* Idle handlers */
> +	void		(*setup_idle)(void);
> +	unsigned long	(*power7_sleep)(void);
>  };

Do we need that ppc_md hook ? Since we are going to use idle states in
the CPU unplug loop, I would think we should do the necessary
initializations at boot time regardless of whether the cpuidle driver
is loaded or not, so we probably don't need this, or am I missing
something ?

>  extern void e500_idle(void);
> diff --git a/arch/powerpc/include/asm/opal.h b/arch/powerpc/include/asm/opal.h
> index 28b8342..166d572 100644
> --- a/arch/powerpc/include/asm/opal.h
> +++ b/arch/powerpc/include/asm/opal.h
> @@ -149,6 +149,7 @@ struct opal_sg_list {
>  #define OPAL_DUMP_INFO2				94
>  #define OPAL_PCI_EEH_FREEZE_SET			97
>  #define OPAL_HANDLE_HMI				98
> +#define OPAL_CONFIG_IDLE_STATE			99
>  #define OPAL_REGISTER_DUMP_REGION		101
>  #define OPAL_UNREGISTER_DUMP_REGION		102
>  
> @@ -775,6 +776,7 @@ extern struct device_node *opal_node;
>  /* Flags used for idle state discovery from the device tree */
>  #define IDLE_INST_NAP	0x00010000 /* nap instruction can be used */
>  #define IDLE_INST_SLEEP	0x00020000 /* sleep instruction can be used */
> +#define IDLE_INST_SLEEP_ER1	0x00080000 /* Use sleep with work around*/

Usual comment about names.
 
>  /* API functions */
>  int64_t opal_invalid_call(void);
> @@ -975,6 +977,7 @@ extern int opal_handle_hmi_exception(struct pt_regs *regs);
>  
>  extern void opal_shutdown(void);
>  extern int opal_resync_timebase(void);
> +int64_t opal_config_idle_state(uint64_t state, uint64_t enter);
>  
>  extern void opal_lpc_init(void);
>  
> diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
> index dda7ac4..41953cd 100644
> --- a/arch/powerpc/include/asm/processor.h
> +++ b/arch/powerpc/include/asm/processor.h
> @@ -451,8 +451,10 @@ extern unsigned long cpuidle_disable;
>  enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_POWERSAVE_OFF};
>  
>  extern int powersave_nap;	/* set if nap mode can be used in idle loop */
> +extern void arch_setup_idle(void);
>  extern void power7_nap(int check_irq);
> -extern void power7_sleep(void);
> +extern unsigned long power7_sleep(void);
> +extern unsigned long __power7_sleep(void);
>  extern void flush_instruction_cache(void);
>  extern void hard_reset_now(void);
>  extern void poweroff_now(void);
> diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
> index d7216c9..1f268e0 100644
> --- a/arch/powerpc/kernel/idle.c
> +++ b/arch/powerpc/kernel/idle.c
> @@ -32,6 +32,9 @@
>  #include <asm/machdep.h>
>  #include <asm/runlatch.h>
>  #include <asm/smp.h>
> +#include <asm/cputhreads.h>
> +#include <asm/firmware.h>
> +#include <asm/opal.h>
>  
> 
>  unsigned long cpuidle_disable = IDLE_NO_OVERRIDE;
> @@ -78,6 +81,22 @@ void arch_cpu_idle(void)
>  	HMT_medium();
>  	ppc64_runlatch_on();
>  }
> +void arch_setup_idle(void)
> +{
> +	if (ppc_md.setup_idle)
> +		ppc_md.setup_idle();
> +}

See comment about hook

> +unsigned long power7_sleep(void)
> +{
> +	unsigned long ret;
> +
> +	if (ppc_md.power7_sleep)
> +		ret = ppc_md.power7_sleep();
> +	else
> +		ret = __power7_sleep();
> +	return ret;
> +}

This is in the wrong place. In fact, it should probably be power8 and
not power7 and it should be somewhere in powernv, not in generic code.

We don't need the ppc_md. hook, we can just check if the workaround
is needed from the ppc_md code.
 
>  int powersave_nap;
>  
> diff --git a/arch/powerpc/kernel/idle_power7.S b/arch/powerpc/kernel/idle_power7.S
> index be05841..c3481c9 100644
> --- a/arch/powerpc/kernel/idle_power7.S
> +++ b/arch/powerpc/kernel/idle_power7.S
> @@ -129,7 +129,7 @@ _GLOBAL(power7_nap)
>  	b	power7_powersave_common
>  	/* No return */
>  
> -_GLOBAL(power7_sleep)
> +_GLOBAL(__power7_sleep)
>  	li	r3,1
>  	li	r4,1
>  	b	power7_powersave_common
> diff --git a/arch/powerpc/platforms/powernv/opal-wrappers.S b/arch/powerpc/platforms/powernv/opal-wrappers.S
> index 2e6ce1b..8d1e724 100644
> --- a/arch/powerpc/platforms/powernv/opal-wrappers.S
> +++ b/arch/powerpc/platforms/powernv/opal-wrappers.S
> @@ -245,5 +245,6 @@ OPAL_CALL(opal_sensor_read,			OPAL_SENSOR_READ);
>  OPAL_CALL(opal_get_param,			OPAL_GET_PARAM);
>  OPAL_CALL(opal_set_param,			OPAL_SET_PARAM);
>  OPAL_CALL(opal_handle_hmi,			OPAL_HANDLE_HMI);
> +OPAL_CALL(opal_config_idle_state,		OPAL_CONFIG_IDLE_STATE);
>  OPAL_CALL(opal_register_dump_region,		OPAL_REGISTER_DUMP_REGION);
>  OPAL_CALL(opal_unregister_dump_region,		OPAL_UNREGISTER_DUMP_REGION);
> diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
> index 2dca1d8..9d9a898 100644
> --- a/arch/powerpc/platforms/powernv/setup.c
> +++ b/arch/powerpc/platforms/powernv/setup.c
> @@ -36,9 +36,20 @@
>  #include <asm/opal.h>
>  #include <asm/kexec.h>
>  #include <asm/smp.h>
> +#include <asm/cputhreads.h>
>  
>  #include "powernv.h"
>  
> +/* Per-cpu structures to keep track of cpus of a core that
> + * are in idle states >= fastsleep so as to call opal for
> + * sleep setup when the entire core is ready to go to fastsleep.
> + *
> + * We need sometihng similar to a per-core lock. For now we
> + * achieve this by taking the lock of the primary thread in the core.
> + */
> +static DEFINE_PER_CPU(spinlock_t, fastsleep_override_lock);
> +static DEFINE_PER_CPU(int, fastsleep_cnt);
> +
>  static void __init pnv_setup_arch(void)
>  {
>  	set_arch_panic_timeout(10, ARCH_PANIC_TIMEOUT);
> @@ -254,35 +265,8 @@ static unsigned long pnv_memory_block_size(void)
>  }
>  #endif
>  
> -static void __init pnv_setup_machdep_opal(void)
> -{
> -	ppc_md.get_boot_time = opal_get_boot_time;
> -	ppc_md.get_rtc_time = opal_get_rtc_time;
> -	ppc_md.set_rtc_time = opal_set_rtc_time;
> -	ppc_md.restart = pnv_restart;
> -	ppc_md.power_off = pnv_power_off;
> -	ppc_md.halt = pnv_halt;
> -	ppc_md.machine_check_exception = opal_machine_check;
> -	ppc_md.mce_check_early_recovery = opal_mce_check_early_recovery;
> -	ppc_md.hmi_exception_early = opal_hmi_exception_early;
> -	ppc_md.handle_hmi_exception = opal_handle_hmi_exception;
> -}
> -
> -#ifdef CONFIG_PPC_POWERNV_RTAS
> -static void __init pnv_setup_machdep_rtas(void)
> -{
> -	if (rtas_token("get-time-of-day") != RTAS_UNKNOWN_SERVICE) {
> -		ppc_md.get_boot_time = rtas_get_boot_time;
> -		ppc_md.get_rtc_time = rtas_get_rtc_time;
> -		ppc_md.set_rtc_time = rtas_set_rtc_time;
> -	}
> -	ppc_md.restart = rtas_restart;
> -	ppc_md.power_off = rtas_power_off;
> -	ppc_md.halt = rtas_halt;
> -}
> -#endif /* CONFIG_PPC_POWERNV_RTAS */

That patch is ugly because of moving the above. You should instead
change the previous patch to put pnv_probe_idle_states above the above
two functions so that this patch has a lot less impact and is more
reviewable.

>  static unsigned int supported_cpuidle_states;
> +static int need_fastsleep_workaround;

bool ?
 
>  unsigned int pnv_get_supported_cpuidle_states(void)
>  {
> @@ -292,12 +276,13 @@ unsigned int pnv_get_supported_cpuidle_states(void)
>  static int __init pnv_probe_idle_states(void)
>  {
>  	struct device_node *power_mgt;
> -	struct property *prop;
>  	int dt_idle_states;
> -	u32 *flags;

Fix the previous one to use __be ? IE. Previous patch is endian broken
and this one fixes it. Don't do that.

> +	const __be32 *idle_state_flags;
> +	u32 len_flags, flags;
>  	int i;
>  
>  	supported_cpuidle_states = 0;
> +	need_fastsleep_workaround = 0;
>  
>  	if (cpuidle_disable != IDLE_NO_OVERRIDE)
>  		return 0;
> @@ -311,21 +296,28 @@ static int __init pnv_probe_idle_states(void)
>  		return 0;
>  	}
>  
> -	prop = of_find_property(power_mgt, "ibm,cpu-idle-state-flags", NULL);
> -	if (!prop) {
> +	idle_state_flags = of_get_property(power_mgt,
> +			"ibm,cpu-idle-state-flags", &len_flags);
> +	if (!idle_state_flags) {
>  		pr_warn("DT-PowerMgmt: missing ibm,cpu-idle-state-flags\n");
>  		return 0;
>  	}
>  
> -	dt_idle_states = prop->length / sizeof(u32);
> -	flags = (u32 *) prop->value;
> +	dt_idle_states = len_flags / sizeof(u32);
>  
>  	for (i = 0; i < dt_idle_states; i++) {
> -		if (flags[i] & IDLE_INST_NAP)
> +
> +		flags = be32_to_cpu(idle_state_flags[i]);
> +		if (flags & IDLE_INST_NAP)
>  			supported_cpuidle_states |= IDLE_USE_NAP;
>  
> -		if (flags[i] & IDLE_INST_SLEEP)
> +		if (flags & IDLE_INST_SLEEP)
>  			supported_cpuidle_states |= IDLE_USE_SLEEP;
> +
> +		if (flags & IDLE_INST_SLEEP_ER1) {
> +			supported_cpuidle_states |= IDLE_USE_SLEEP;
> +			need_fastsleep_workaround = 1;
> +		}
>  	}
>  
>  	return 0;
> @@ -333,6 +325,81 @@ static int __init pnv_probe_idle_states(void)
>  
>  subsys_initcall(pnv_probe_idle_states);
>  
> +static void pnv_setup_idle(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		spin_lock_init(&per_cpu(fastsleep_override_lock, cpu));
> +		per_cpu(fastsleep_cnt, cpu) = threads_per_core;
> +	}
> +}

That can be done from probe_idle_states no ?

That locking construct and counter per-core (not per-CPU really) should
probably be documented somewhere and to be safe we should probably
initialize the secondary threads counters to some crazy value like -1
and BUG_ON on it in the use case.

> +static void
> +pnv_apply_fastsleep_workaround(bool enter_fastsleep, int primary_thread)
> +{
> +	if (enter_fastsleep) {
> +		spin_lock(&per_cpu(fastsleep_override_lock, primary_thread));
> +		if (--(per_cpu(fastsleep_cnt, primary_thread)) == 0)
> +			opal_config_idle_state(1, 1);
> +		spin_unlock(&per_cpu(fastsleep_override_lock, primary_thread));
> +	} else {
> +		spin_lock(&per_cpu(fastsleep_override_lock, primary_thread));
> +		if ((per_cpu(fastsleep_cnt, primary_thread)) == 0)
> +			opal_config_idle_state(1, 0);
> +		per_cpu(fastsleep_cnt, primary_thread)++;
> +		spin_unlock(&per_cpu(fastsleep_override_lock, primary_thread));
> +	}

Make two separate functions, one for enter and one to exit. IE.

pnv_enter_sleep_workaround();

vs.

pnv_exit_sleep_workaround();

> +
> +static unsigned long pnv_power7_sleep(void)
> +{
> +	int cpu, primary_thread;
> +	unsigned long srr1;
> +
> +	cpu = smp_processor_id();
> +	primary_thread = cpu_first_thread_sibling(cpu);
> +
> +	if (need_fastsleep_workaround) {
> +		pnv_apply_fastsleep_workaround(1, primary_thread);
> +		srr1 = __power7_sleep();
> +		pnv_apply_fastsleep_workaround(0, primary_thread);
> +	} else {
> +		srr1 = __power7_sleep();
> +	}
> +	return srr1;
> +}

Just pnv_sleep() and you can remove the __ in power7_sleep

> +static void __init pnv_setup_machdep_opal(void)
> +{
> +	ppc_md.get_boot_time = opal_get_boot_time;
> +	ppc_md.get_rtc_time = opal_get_rtc_time;
> +	ppc_md.set_rtc_time = opal_set_rtc_time;
> +	ppc_md.restart = pnv_restart;
> +	ppc_md.power_off = pnv_power_off;
> +	ppc_md.halt = pnv_halt;
> +	ppc_md.machine_check_exception = opal_machine_check;
> +	ppc_md.mce_check_early_recovery = opal_mce_check_early_recovery;
> +	ppc_md.hmi_exception_early = opal_hmi_exception_early;
> +	ppc_md.handle_hmi_exception = opal_handle_hmi_exception;
> +	ppc_md.setup_idle = pnv_setup_idle;
> +	ppc_md.power7_sleep = pnv_power7_sleep;
> +}

Just export pnv_sleep() and call it from the pnv cpuidle driver
directly.

> +#ifdef CONFIG_PPC_POWERNV_RTAS
> +static void __init pnv_setup_machdep_rtas(void)
> +{
> +	if (rtas_token("get-time-of-day") != RTAS_UNKNOWN_SERVICE) {
> +		ppc_md.get_boot_time = rtas_get_boot_time;
> +		ppc_md.get_rtc_time = rtas_get_rtc_time;
> +		ppc_md.set_rtc_time = rtas_set_rtc_time;
> +	}
> +	ppc_md.restart = rtas_restart;
> +	ppc_md.power_off = rtas_power_off;
> +	ppc_md.halt = rtas_halt;
> +}
> +#endif /* CONFIG_PPC_POWERNV_RTAS */
> +
>  static int __init pnv_probe(void)
>  {
>  	unsigned long root = of_get_flat_dt_root();
> diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
> index 23d2743..8ad97a9 100644
> --- a/drivers/cpuidle/cpuidle-powernv.c
> +++ b/drivers/cpuidle/cpuidle-powernv.c
> @@ -18,6 +18,7 @@
>  #include <asm/firmware.h>
>  #include <asm/opal.h>
>  #include <asm/runlatch.h>
> +#include <asm/processor.h>
>  
>  /* Flags and constants used in PowerNV platform */
>  
> @@ -195,7 +196,8 @@ static int powernv_add_idle_states(void)
>  			nr_idle_states++;
>  		}
>  
> -		if (flags & IDLE_INST_SLEEP) {
> +		if ((flags & IDLE_INST_SLEEP_ER1) ||
> +				(flags & IDLE_INST_SLEEP)) {
>  			/* Add FASTSLEEP state */
>  			strcpy(powernv_states[nr_idle_states].name, "FastSleep");
>  			strcpy(powernv_states[nr_idle_states].desc, "FastSleep");
> @@ -247,6 +249,10 @@ static int __init powernv_processor_idle_init(void)
>  
>  	register_cpu_notifier(&setup_hotplug_notifier);
>  	printk(KERN_DEBUG "powernv_idle_driver registered\n");
> +
> +	/* If any idle states require special
> +	 * initializations before cpuidle kicks in */
> +	arch_setup_idle();
>  	return 0;
>  }
>  


