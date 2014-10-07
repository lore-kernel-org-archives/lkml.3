Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaJGFGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 01:06:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:35747 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaJGFGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 01:06:48 -0400
Message-ID: <1412658376.30859.132.camel@pasglop>
Subject: Re: [PATCH v2 1/3] powerpc/powernv: Enable Offline CPUs to enter
 deep idle states
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, "Srivatsa S. Bhat" <srivatsa@mit.edu>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        "Preeti U. Murthy" <preeti@linux.vnet.ibm.com>
Date: Tue, 07 Oct 2014 16:06:16 +1100
In-Reply-To: <1412149560-2953-2-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1412149560-2953-1-git-send-email-shreyas@linux.vnet.ibm.com>
	 <1412149560-2953-2-git-send-email-shreyas@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 13:15 +0530, Shreyas B. Prabhu wrote:
> From: "Srivatsa S. Bhat" <srivatsa@mit.edu>
> 
> The offline cpus

Arguably "cpus" here should be "secondary threads" to make the commit
message a bit more comprehensible. A few more nits below...

> should enter deep idle states so as to gain maximum
> powersavings when the entire core is offline. To do so the offline path
> must be made aware of the available deepest idle state. Hence probe the
> device tree for the possible idle states in powernv core code and
> expose the deepest idle state through flags.
> 
> Since the  device tree is probed by the cpuidle driver as well, move
> the parameters required to discover the idle states into an appropriate
> common place to both the driver and the powernv core code.
> 
> Another point is that fastsleep idle state may require workarounds in
> the kernel to function properly. This workaround is introduced in the
> subsequent patches. However neither the cpuidle driver or the hotplug
> path need be bothered about this workaround.
> 
> They will be taken care of by the core powernv code.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: linux-pm@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa@mit.edu>
> Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
> [ Changelog modified by preeti@linux.vnet.ibm.com ]
> Signed-off-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
> ---
>  arch/powerpc/include/asm/opal.h          |  4 +++
>  arch/powerpc/platforms/powernv/powernv.h |  7 +++++
>  arch/powerpc/platforms/powernv/setup.c   | 51 ++++++++++++++++++++++++++++++++
>  arch/powerpc/platforms/powernv/smp.c     | 11 ++++++-
>  drivers/cpuidle/cpuidle-powernv.c        |  7 ++---
>  5 files changed, 75 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/opal.h b/arch/powerpc/include/asm/opal.h
> index 86055e5..28b8342 100644
> --- a/arch/powerpc/include/asm/opal.h
> +++ b/arch/powerpc/include/asm/opal.h
> @@ -772,6 +772,10 @@ extern struct kobject *opal_kobj;
>  /* /ibm,opal */
>  extern struct device_node *opal_node;
>  
> +/* Flags used for idle state discovery from the device tree */
> +#define IDLE_INST_NAP	0x00010000 /* nap instruction can be used */
> +#define IDLE_INST_SLEEP	0x00020000 /* sleep instruction can be used */

Please provide a better explanation if what this is about, maybe a
commend describing the device-tree property. Also those macros have
names too likely to collide or be confused with other uses. Use
something a bit less ambiguous such as OPAL_PM_NAP_AVAILABLE,
OPAL_PM_SLEEP_ENABLED,...

Also put that in the part of opal.h that isn't the linux internal
implementation, but instead the "API" part. This will help when we
finally split the file.

>  /* API functions */
>  int64_t opal_invalid_call(void);
>  int64_t opal_console_write(int64_t term_number, __be64 *length,
> diff --git a/arch/powerpc/platforms/powernv/powernv.h b/arch/powerpc/platforms/powernv/powernv.h
> index 75501bf..31ece13 100644
> --- a/arch/powerpc/platforms/powernv/powernv.h
> +++ b/arch/powerpc/platforms/powernv/powernv.h
> @@ -23,6 +23,13 @@ static inline int pnv_pci_dma_set_mask(struct pci_dev *pdev, u64 dma_mask)
>  }
>  #endif
>  
> +/* Flags to indicate which of the CPU idle states are available for use */
> +
> +#define IDLE_USE_NAP		(1UL << 0)
> +#define IDLE_USE_SLEEP		(1UL << 1)

This somewhat duplicates the opal.h definitions, can't we just re-use
them ?

> +extern unsigned int pnv_get_supported_cpuidle_states(void);
> +
>  extern void pnv_lpc_init(void);
>  
>  bool cpu_core_split_required(void);
> diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
> index 5a0e2dc..2dca1d8 100644
> --- a/arch/powerpc/platforms/powernv/setup.c
> +++ b/arch/powerpc/platforms/powernv/setup.c
> @@ -282,6 +282,57 @@ static void __init pnv_setup_machdep_rtas(void)
>  }
>  #endif /* CONFIG_PPC_POWERNV_RTAS */
>  
> +static unsigned int supported_cpuidle_states;
> +
> +unsigned int pnv_get_supported_cpuidle_states(void)
> +{
> +	return supported_cpuidle_states;
> +}

Will this be used by a module ? Doesn't it need to be exported ? Also
keep the prefix pnv on the variable, I don't like globals with such a
confusing name.

> +static int __init pnv_probe_idle_states(void)
> +{
> +	struct device_node *power_mgt;
> +	struct property *prop;
> +	int dt_idle_states;
> +	u32 *flags;
> +	int i;
> +
> +	supported_cpuidle_states = 0;
> +
> +	if (cpuidle_disable != IDLE_NO_OVERRIDE)
> +		return 0;
> +
> +	if (!firmware_has_feature(FW_FEATURE_OPALv3))
> +		return 0;
> +
> +	power_mgt = of_find_node_by_path("/ibm,opal/power-mgt");
> +	if (!power_mgt) {
> +		pr_warn("opal: PowerMgmt Node not found\n");
> +		return 0;
> +	}
> +
> +	prop = of_find_property(power_mgt, "ibm,cpu-idle-state-flags", NULL);
> +	if (!prop) {
> +		pr_warn("DT-PowerMgmt: missing ibm,cpu-idle-state-flags\n");
> +		return 0;
> +	}
> +
> +	dt_idle_states = prop->length / sizeof(u32);
> +	flags = (u32 *) prop->value;
> +
> +	for (i = 0; i < dt_idle_states; i++) {
> +		if (flags[i] & IDLE_INST_NAP)
> +			supported_cpuidle_states |= IDLE_USE_NAP;
> +
> +		if (flags[i] & IDLE_INST_SLEEP)
> +			supported_cpuidle_states |= IDLE_USE_SLEEP;
> +	}
> +
> +	return 0;
> +}
> +
> +subsys_initcall(pnv_probe_idle_states);
> +
>  static int __init pnv_probe(void)
>  {
>  	unsigned long root = of_get_flat_dt_root();
> diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
> index 5fcfcf4..3ad31d2 100644
> --- a/arch/powerpc/platforms/powernv/smp.c
> +++ b/arch/powerpc/platforms/powernv/smp.c
> @@ -149,6 +149,7 @@ static int pnv_smp_cpu_disable(void)
>  static void pnv_smp_cpu_kill_self(void)
>  {
>  	unsigned int cpu;
> +	unsigned long idle_states;
>  
>  	/* Standard hot unplug procedure */
>  	local_irq_disable();
> @@ -159,13 +160,21 @@ static void pnv_smp_cpu_kill_self(void)
>  	generic_set_cpu_dead(cpu);
>  	smp_wmb();
>  
> +	idle_states = pnv_get_supported_cpuidle_states();
> +
>  	/* We don't want to take decrementer interrupts while we are offline,
>  	 * so clear LPCR:PECE1. We keep PECE2 enabled.
>  	 */
>  	mtspr(SPRN_LPCR, mfspr(SPRN_LPCR) & ~(u64)LPCR_PECE1);
>  	while (!generic_check_cpu_restart(cpu)) {
>  		ppc64_runlatch_off();
> -		power7_nap(1);
> +
> +		/* If sleep is supported, go to sleep, instead of nap */
> +		if (idle_states & IDLE_USE_SLEEP)
> +			power7_sleep();
> +		else
> +			power7_nap(1);
> +
>  		ppc64_runlatch_on();
>  
>  		/* Reenable IRQs briefly to clear the IPI that woke us */
> diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
> index a64be57..23d2743 100644
> --- a/drivers/cpuidle/cpuidle-powernv.c
> +++ b/drivers/cpuidle/cpuidle-powernv.c
> @@ -16,13 +16,12 @@
>  
>  #include <asm/machdep.h>
>  #include <asm/firmware.h>
> +#include <asm/opal.h>
>  #include <asm/runlatch.h>
>  
>  /* Flags and constants used in PowerNV platform */
>  
>  #define MAX_POWERNV_IDLE_STATES	8
> -#define IDLE_USE_INST_NAP	0x00010000 /* Use nap instruction */
> -#define IDLE_USE_INST_SLEEP	0x00020000 /* Use sleep instruction */
>  
>  struct cpuidle_driver powernv_idle_driver = {
>  	.name             = "powernv_idle",
> @@ -185,7 +184,7 @@ static int powernv_add_idle_states(void)
>  	for (i = 0; i < dt_idle_states; i++) {
>  
>  		flags = be32_to_cpu(idle_state_flags[i]);
> -		if (flags & IDLE_USE_INST_NAP) {
> +		if (flags & IDLE_INST_NAP) {
>  			/* Add NAP state */
>  			strcpy(powernv_states[nr_idle_states].name, "Nap");
>  			strcpy(powernv_states[nr_idle_states].desc, "Nap");
> @@ -196,7 +195,7 @@ static int powernv_add_idle_states(void)
>  			nr_idle_states++;
>  		}
>  
> -		if (flags & IDLE_USE_INST_SLEEP) {
> +		if (flags & IDLE_INST_SLEEP) {
>  			/* Add FASTSLEEP state */
>  			strcpy(powernv_states[nr_idle_states].name, "FastSleep");
>  			strcpy(powernv_states[nr_idle_states].desc, "FastSleep");


