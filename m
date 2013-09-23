Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3IWN0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:26:30 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37539 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3IWN03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:26:29 -0400
Date: Mon, 23 Sep 2013 09:26:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: xen-devel@lists.xen.org, david.vrabel@citrix.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 3/5] xen/PMU: Initialization code for Xen PMU
Message-ID: <20130923132618.GD3175@phenom.dumpdata.com>
References: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com>
 <1378827110-4192-4-git-send-email-boris.ostrovsky@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378827110-4192-4-git-send-email-boris.ostrovsky@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 11:31:48AM -0400, Boris Ostrovsky wrote:
> Map shared data structure that will hold CPU registers, VPMU context,
> VCPU/PCPI IDs of the VCPU interrupted by PMU interrupt. Hypervisor
> fills this information in its handler and passes it to the guest for
> further processing.
> 
> Set up PMU VIRQ.
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
>  arch/x86/xen/Makefile          |   2 +-
>  arch/x86/xen/pmu.c             | 122 +++++++++++++++++++++++++++++++++++++++++
>  arch/x86/xen/pmu.h             |  12 ++++
>  arch/x86/xen/smp.c             |  31 ++++++++++-
>  include/xen/interface/xen.h    |   1 +
>  include/xen/interface/xenpmu.h |  77 ++++++++++++++++++++++++++
>  6 files changed, 243 insertions(+), 2 deletions(-)
>  create mode 100644 arch/x86/xen/pmu.c
>  create mode 100644 arch/x86/xen/pmu.h
> 
> diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
> index 96ab2c0..b187df5 100644
> --- a/arch/x86/xen/Makefile
> +++ b/arch/x86/xen/Makefile
> @@ -13,7 +13,7 @@ CFLAGS_mmu.o			:= $(nostackp)
>  obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
>  			time.o xen-asm.o xen-asm_$(BITS).o \
>  			grant-table.o suspend.o platform-pci-unplug.o \
> -			p2m.o
> +			p2m.o pmu.o

Perhaps guard the build of this based on CONFIG_PERF_EVENTS?

That would of course mean you also have to create in xenpmu.h
static inline empy functions for xen_pmu_finish and xen_pmu_init in case
CONFIG_PERF_EVENTS is not set.


>  
>  obj-$(CONFIG_EVENT_TRACING) += trace.o
>  
> diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
> new file mode 100644
> index 0000000..da061d4
> --- /dev/null
> +++ b/arch/x86/xen/pmu.c
> @@ -0,0 +1,122 @@
> +#include <linux/types.h>
> +#include <linux/interrupt.h>
> +
> +#include <asm/xen/hypercall.h>
> +#include <xen/page.h>
> +#include <xen/interface/xen.h>
> +#include <xen/interface/vcpu.h>
> +#include <xen/interface/xenpmu.h>
> +
> +#include "xen-ops.h"
> +#include "pmu.h"
> +
> +/* x86_pmu.handle_irq definition */
> +#include <../kernel/cpu/perf_event.h>
> +
> +
> +/* Shared page between hypervisor and domain */
> +DEFINE_PER_CPU(struct xenpmu_data *, xenpmu_shared);
> +
> +/* perf callbacks*/
> +int xen_is_in_guest(void)
> +{
> +	struct xenpmu_data *xenpmu_data = per_cpu(xenpmu_shared,
> +						  smp_processor_id());
> +
> +	if (!xen_initial_domain() ||
> +	    xenpmu_data->domain_id > DOMID_SELF || xenpmu_data->domain_id == 0)
> +		return 0;
> +
> +	return 1;
> +}
> +
> +static int xen_is_user_mode(void)
> +{
> +	struct xenpmu_data *xenpmu_data = per_cpu(xenpmu_shared,
> +						  smp_processor_id());
> +	return ((xenpmu_data->regs.cs & 3) == 3);
> +}
> +
> +static unsigned long xen_get_guest_ip(void)
> +{
> +	struct xenpmu_data *xenpmu_data = per_cpu(xenpmu_shared,
> +						  smp_processor_id());
> +	return xenpmu_data->regs.eip;
> +}
> +
> +static struct perf_guest_info_callbacks xen_guest_cbs = {
> +	.is_in_guest            = xen_is_in_guest,
> +	.is_user_mode           = xen_is_user_mode,
> +	.get_guest_ip           = xen_get_guest_ip,
> +};
> +
> +/* Convert registers from Xen's format to Linux' */
> +static void xen_convert_regs(struct cpu_user_regs *xen_regs,
> +			     struct pt_regs *regs)
> +{
> +	regs->ip = xen_regs->eip;
> +	regs->cs = xen_regs->cs;
> +}
> +
> +irqreturn_t xen_pmu_irq_handler(int irq, void *dev_id)
> +{
> +	int ret = IRQ_NONE;
> +	struct pt_regs regs;
> +	struct xenpmu_data *xenpmu_data = per_cpu(xenpmu_shared,
> +						  smp_processor_id());
> +
> +	xen_convert_regs(&xenpmu_data->regs, &regs);
> +	if (x86_pmu.handle_irq(&regs))
> +		ret = IRQ_HANDLED;
> +
> +	return ret;
> +}
> +
> +int xen_pmu_init(int cpu)
> +{
> +	int ret = 0;
> +	struct xenpmu_params xp;
> +	unsigned long pfn;
> +	struct xenpmu_data *xenpmu_data;
> +
> +	BUILD_BUG_ON(sizeof(struct xenpmu_data) > PAGE_SIZE);
> +	xenpmu_data = vmalloc(PAGE_SIZE);
> +	if (!xenpmu_data) {
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +	pfn = vmalloc_to_pfn((char *)xenpmu_data);
> +
> +	xp.mfn = pfn_to_mfn(pfn);
> +	xp.vcpu = cpu;
> +	xp.version.maj = XENPMU_VER_MAJ;
> +	xp.version.min = XENPMU_VER_MIN;
> +	ret = HYPERVISOR_xenpmu_op(XENPMU_init, &xp);
> +	if (ret)
> +		goto fail;
> +
> +	per_cpu(xenpmu_shared, cpu) = xenpmu_data;
> +
> +	if (cpu == 0)
> +		perf_register_guest_info_callbacks(&xen_guest_cbs);
> +
> +	return ret;
> +
> +fail:
> +	vfree(xenpmu_data);
> +	return ret;
> +}
> +
> +void xen_pmu_finish(int cpu)
> +{
> +	struct xenpmu_params xp;
> +
> +	xp.vcpu = cpu;
> +	xp.version.maj = XENPMU_VER_MAJ;
> +	xp.version.min = XENPMU_VER_MIN;
> +
> +	(void)HYPERVISOR_xenpmu_op(XENPMU_finish, &xp);
> +
> +	vfree(per_cpu(xenpmu_shared, cpu));
> +	per_cpu(xenpmu_shared, cpu) = NULL;

I think you are missing:

perf_unregister_guest_info_callbacks when this is the bootup CPU.

And you should probably move this around to be:

	if (cpu == 0 && num_online_cpus() == 1)
		perf_unregister_guest_info_callbacks(..)
	per_cpu(xenpmu_shared, cpu) = NULL;
	vfree(per_cpu(xenpmu_shared, cpu))

?
> +}
> diff --git a/arch/x86/xen/pmu.h b/arch/x86/xen/pmu.h
> new file mode 100644
> index 0000000..51de7d2
> --- /dev/null
> +++ b/arch/x86/xen/pmu.h
> @@ -0,0 +1,12 @@
> +#ifndef __XEN_PMU_H
> +#define __XEN_PMU_H
> +
> +#include <xen/interface/xenpmu.h>
> +
> +irqreturn_t xen_pmu_irq_handler(int irq, void *dev_id);
> +int xen_pmu_init(int cpu);
> +void xen_pmu_finish(int cpu);
> +
> +DECLARE_PER_CPU(struct xenpmu_data *, xenpmu_shared);
> +
> +#endif /* __XEN_PMU_H */
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index ca92754..17a88d1 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -26,6 +26,7 @@
>  
>  #include <xen/interface/xen.h>
>  #include <xen/interface/vcpu.h>
> +#include <xen/interface/xenpmu.h>
>  
>  #include <asm/xen/interface.h>
>  #include <asm/xen/hypercall.h>
> @@ -37,6 +38,7 @@
>  #include <xen/hvc-console.h>
>  #include "xen-ops.h"
>  #include "mmu.h"
> +#include "pmu.h"
>  
>  cpumask_var_t xen_cpu_initialized_map;
>  
> @@ -49,6 +51,7 @@ static DEFINE_PER_CPU(struct xen_common_irq, xen_callfunc_irq) = { .irq = -1 };
>  static DEFINE_PER_CPU(struct xen_common_irq, xen_callfuncsingle_irq) = { .irq = -1 };
>  static DEFINE_PER_CPU(struct xen_common_irq, xen_irq_work) = { .irq = -1 };
>  static DEFINE_PER_CPU(struct xen_common_irq, xen_debug_irq) = { .irq = -1 };
> +static DEFINE_PER_CPU(struct xen_common_irq, xen_pmu_irq) = { .irq = -1 };
>  
>  static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
>  static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id);
> @@ -139,11 +142,18 @@ static void xen_smp_intr_free(unsigned int cpu)
>  		kfree(per_cpu(xen_irq_work, cpu).name);
>  		per_cpu(xen_irq_work, cpu).name = NULL;
>  	}
> +
> +	if (per_cpu(xen_pmu_irq, cpu).irq >= 0) {
> +		unbind_from_irqhandler(per_cpu(xen_pmu_irq, cpu).irq, NULL);
> +		per_cpu(xen_pmu_irq, cpu).irq = -1;
> +		kfree(per_cpu(xen_pmu_irq, cpu).name);
> +		per_cpu(xen_pmu_irq, cpu).name = NULL;
> +	}
>  };
>  static int xen_smp_intr_init(unsigned int cpu)
>  {
>  	int rc;
> -	char *resched_name, *callfunc_name, *debug_name;
> +	char *resched_name, *callfunc_name, *debug_name, *pmu_name;
>  
>  	resched_name = kasprintf(GFP_KERNEL, "resched%d", cpu);
>  	rc = bind_ipi_to_irqhandler(XEN_RESCHEDULE_VECTOR,
> @@ -209,6 +219,18 @@ static int xen_smp_intr_init(unsigned int cpu)
>  	per_cpu(xen_irq_work, cpu).irq = rc;
>  	per_cpu(xen_irq_work, cpu).name = callfunc_name;
>  
> +	if (per_cpu(xenpmu_shared, cpu)) {
> +		pmu_name = kasprintf(GFP_KERNEL, "pmu%d", cpu);
> +		rc = bind_virq_to_irqhandler(VIRQ_XENPMU, cpu,
> +					     xen_pmu_irq_handler,
> +					     IRQF_PERCPU|IRQF_NOBALANCING,
> +					     pmu_name, NULL);
> +		if (rc < 0)
> +			goto fail;
> +		per_cpu(xen_pmu_irq, cpu).irq = rc;
> +		per_cpu(xen_pmu_irq, cpu).name = pmu_name;
> +	}
> +
>  	return 0;
>  
>   fail:
> @@ -307,6 +329,9 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
>  	}
>  	set_cpu_sibling_map(0);
>  
> +	if (xen_pmu_init(0))
> +		pr_err("Could not initialize VPMU for VCPU 0\n");
> +
>  	if (xen_smp_intr_init(0))
>  		BUG();
>  
> @@ -427,6 +452,9 @@ static int xen_cpu_up(unsigned int cpu, struct task_struct *idle)
>  		/* Just in case we booted with a single CPU. */
>  		alternatives_enable_smp();
>  
> +	if (xen_pmu_init(cpu))
> +		pr_err("Could not initialize VPMU for VCPU %u\n", cpu);
> +
>  	rc = xen_smp_intr_init(cpu);
>  	if (rc)
>  		return rc;
> @@ -468,6 +496,7 @@ static void xen_cpu_die(unsigned int cpu)
>  	xen_smp_intr_free(cpu);
>  	xen_uninit_lock_cpu(cpu);
>  	xen_teardown_timer(cpu);
> +	xen_pmu_finish(cpu);
>  }
>  
>  static void xen_play_dead(void) /* used only with HOTPLUG_CPU */

That all looks OK
