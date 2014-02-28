Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaB1Cu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 21:50:58 -0500
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:40978
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751232AbaB1Cu4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 21:50:56 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "Peter Zijlstra" <peterz@infradead.org>, x86 <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxdrivers <devel@linuxdriverproject.org>
Subject: RE: [patch 25/26] x86: hyperv: Cleanup the irq mess
Thread-Topic: [patch 25/26] x86: hyperv: Cleanup the irq mess
Thread-Index: AQHPMN/cB0XcplfKTkOLs+jEGSB3RZrF35iAgAB5BgCAA5oEoA==
Date: Fri, 28 Feb 2014 02:50:52 +0000
Message-ID: <1f575bbe5adf469b9a2482686d06fc98@BY2PR03MB299.namprd03.prod.outlook.com>
References: <20140223212703.511977310@linutronix.de>
 <20140223212739.028307673@linutronix.de>
 <379403385de44bcab2ad8a676d9cd49b@BY2PR03MB299.namprd03.prod.outlook.com>
 <alpine.DEB.2.02.1402251959560.21251@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402251959560.21251@ionos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [167.220.233.2]
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(164054003)(24454002)(13464003)(189002)(199002)(377454003)(81342001)(49866001)(95666003)(4396001)(81542001)(47976001)(50986001)(47736001)(51856001)(53806001)(87266001)(2656002)(76482001)(54356001)(54316002)(56776001)(87936001)(74876001)(74366001)(74316001)(46102001)(95416001)(63696002)(94946001)(86612001)(79102001)(31966008)(74662001)(74502001)(47446002)(92566001)(56816005)(90146001)(83072002)(85852003)(94316002)(93136001)(86362001)(93516002)(83322001)(19580405001)(19580395003)(81686001)(81816001)(80976001)(74706001)(59766001)(77982001)(80022001)(66066001)(65816001)(76576001)(76796001)(76786001)(33646001)(69226001)(85306002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB596;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:167.220.233.2;FPR:B41251F9.B7F2A388.713E30B7.42E410B1.20595;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Tuesday, February 25, 2014 11:10 AM
> To: KY Srinivasan
> Cc: LKML; Ingo Molnar; Peter Zijlstra; x86; Greg Kroah-Hartman; linuxdrivers
> Subject: RE: [patch 25/26] x86: hyperv: Cleanup the irq mess
> 
> On Tue, 25 Feb 2014, KY Srinivasan wrote:
> > > -----Original Message-----
> > > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > > Sent: Sunday, February 23, 2014 1:40 PM
> > > To: LKML
> > > Cc: Ingo Molnar; Peter Zijlstra; x86; KY Srinivasan; Greg
> > > Kroah-Hartman; linuxdrivers
> > > Subject: [patch 25/26] x86: hyperv: Cleanup the irq mess
> > >
> > > The vmbus/hyperv interrupt handling is another complete trainwreck
> > > and probably the worst of all currently in tree.
> > >
> > > If CONFIG_HYPERV=y then the interrupt delivery to the vmbus happens
> > > via the direct HYPERVISOR_CALLBACK_VECTOR. So far so good, but:
> > >
> > >   The driver requests first a normal device interrupt. The only reason
> > >   to do so is to increment the interrupt stats of that device
> > >   interrupt.
> > >
> > >   We have proper accounting mechanisms for direct vectors, but of
> > >   course it's too much effort to add that 5 lines of code.
> > >
> > >   Aside of that the alloc_intr_gate() is not protected against
> > >   reallocation which makes module reload impossible.
> > >
> > > If CONFIG_HYPERV=n then the vmbus request a regular device interrupt
> > > via
> > > request_irq() and installs it's own private flow handler. Of course
> > > this lacks any explanation why it can't use the standard flow
> > > handler or the existing handle_percpu_irq handler.
> > >
> > > Solution to the problem is simple to rip out the whole mess and
> > > implement it correctly.
> > Thomas,
> >
> > Thank you for cleaning up this code. When CONFIG_HYPERV== n, none of
> > the VMBUS code is active.  The special case can go away as you have
> > noted.
> 
> So, if CONFIG_HYPERV=n then you do not need the request_irq() fallback at
> all, right? Somehow I missed the HYPERV dependency of the VMBUS stuff
> 
> That makes stuff even simpler as we can get rid of those extra cases including
> the extra flow handler.
> 
> New patch below.

Thanks Thomas.

Acked-by: K. Y. Srinivasan <kys@microsoft.com>

> 
> Thanks,
> 
> 	tglx
> ---
> 
>  arch/x86/include/asm/mshyperv.h |    4 +-
>  arch/x86/kernel/cpu/mshyperv.c  |   78 ++++++++++++++++++++-------------
> -------
>  drivers/hv/vmbus_drv.c          |   39 ++------------------
>  3 files changed, 47 insertions(+), 74 deletions(-)
> 
> Index: tip/arch/x86/include/asm/mshyperv.h
> ==========================================================
> =========
> --- tip.orig/arch/x86/include/asm/mshyperv.h
> +++ tip/arch/x86/include/asm/mshyperv.h
> @@ -2,6 +2,7 @@
>  #define _ASM_X86_MSHYPER_H
> 
>  #include <linux/types.h>
> +#include <linux/interrupt.h>
>  #include <asm/hyperv.h>
> 
>  struct ms_hyperv_info {
> @@ -16,6 +17,7 @@ void hyperv_callback_vector(void);  #define
> trace_hyperv_callback_vector hyperv_callback_vector  #endif  void
> hyperv_vector_handler(struct pt_regs *regs); -void
> hv_register_vmbus_handler(int irq, irq_handler_t handler);
> +int hv_setup_vmbus_irq(int irq, irq_handler_t handler, void *dev_id);
> +void hv_remove_vmbus_irq(int irq, void *dev_id);
> 
>  #endif
> Index: tip/arch/x86/kernel/cpu/mshyperv.c
> ==========================================================
> =========
> --- tip.orig/arch/x86/kernel/cpu/mshyperv.c
> +++ tip/arch/x86/kernel/cpu/mshyperv.c
> @@ -17,6 +17,7 @@
>  #include <linux/hardirq.h>
>  #include <linux/efi.h>
>  #include <linux/interrupt.h>
> +#include <linux/irq.h>
>  #include <asm/processor.h>
>  #include <asm/hypervisor.h>
>  #include <asm/hyperv.h>
> @@ -30,6 +31,45 @@
>  struct ms_hyperv_info ms_hyperv;
>  EXPORT_SYMBOL_GPL(ms_hyperv);
> 
> +#ifdef CONFIG_HYPERV
> +static irq_handler_t *vmbus_handler;
> +
> +void hyperv_vector_handler(struct pt_regs *regs) {
> +	struct pt_regs *old_regs = set_irq_regs(regs);
> +
> +	irq_enter();
> +	exit_idle();
> +
> +	inc_irq_stat(irq_hv_callback_count);
> +	if (vmbus_handler)
> +		vmbus_handler();
> +
> +	irq_exit();
> +	set_irq_regs(old_regs);
> +}
> +
> +int hv_setup_vmbus_irq(int irq, irq_handler_t *handler, void *dev_id) {
> +	vmbus_handler = handler;
> +	/*
> +	 * Setup the IDT for hypervisor callback. Prevent reallocation
> +	 * at module reload.
> +	 */
> +	if (!test_bit(HYPERVISOR_CALLBACK_VECTOR, used_vectors))
> +		alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR,
> +				hyperv_callback_vector);
> +}
> +
> +void hv_remove_vmbus_irq(unsigned int irq, void *dev_id) {
> +	/* We have no way to deallocate the interrupt gate */
> +	vmbus_handler = NULL;
> +}
> +EXPORT_SYMBOL_GPL(hv_setup_vmbus_irq);
> +EXPORT_SYMBOL_GPL(hv_remove_vmbus_irq);
> +#endif
> +
>  static uint32_t  __init ms_hyperv_platform(void)  {
>  	u32 eax;
> @@ -113,41 +153,3 @@ const __refconst struct hypervisor_x86 x
>  	.init_platform		= ms_hyperv_init_platform,
>  };
>  EXPORT_SYMBOL(x86_hyper_ms_hyperv);
> -
> -#if IS_ENABLED(CONFIG_HYPERV)
> -static int vmbus_irq = -1;
> -static irq_handler_t vmbus_isr;
> -
> -void hv_register_vmbus_handler(int irq, irq_handler_t handler) -{
> -	/*
> -	 * Setup the IDT for hypervisor callback.
> -	 */
> -	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR,
> hyperv_callback_vector);
> -
> -	vmbus_irq = irq;
> -	vmbus_isr = handler;
> -}
> -
> -void hyperv_vector_handler(struct pt_regs *regs) -{
> -	struct pt_regs *old_regs = set_irq_regs(regs);
> -	struct irq_desc *desc;
> -
> -	irq_enter();
> -	exit_idle();
> -
> -	desc = irq_to_desc(vmbus_irq);
> -
> -	if (desc)
> -		generic_handle_irq_desc(vmbus_irq, desc);
> -
> -	irq_exit();
> -	set_irq_regs(old_regs);
> -}
> -#else
> -void hv_register_vmbus_handler(int irq, irq_handler_t handler) -{ -} -#endif
> -EXPORT_SYMBOL_GPL(hv_register_vmbus_handler);
> Index: tip/drivers/hv/vmbus_drv.c
> ==========================================================
> =========
> --- tip.orig/drivers/hv/vmbus_drv.c
> +++ tip/drivers/hv/vmbus_drv.c
> @@ -25,7 +25,6 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/device.h>
> -#include <linux/irq.h>
>  #include <linux/interrupt.h>
>  #include <linux/sysctl.h>
>  #include <linux/slab.h>
> @@ -558,9 +557,6 @@ static struct bus_type  hv_bus = {
>  	.dev_groups =		vmbus_groups,
>  };
> 
> -static const char *driver_name = "hyperv";
> -
> -
>  struct onmessage_work_context {
>  	struct work_struct work;
>  	struct hv_message msg;
> @@ -677,19 +673,6 @@ static irqreturn_t vmbus_isr(int irq, vo  }
> 
>  /*
> - * vmbus interrupt flow handler:
> - * vmbus interrupts can concurrently occur on multiple CPUs and
> - * can be handled concurrently.
> - */
> -
> -static void vmbus_flow_handler(unsigned int irq, struct irq_desc *desc) -{
> -	kstat_incr_irqs_this_cpu(irq, desc);
> -
> -	desc->action->handler(irq, desc->action->dev_id);
> -}
> -
> -/*
>   * vmbus_bus_init -Main vmbus driver initialization routine.
>   *
>   * Here, we
> @@ -715,26 +698,13 @@ static int vmbus_bus_init(int irq)
>  	if (ret)
>  		goto err_cleanup;
> 
> -	ret = request_irq(irq, vmbus_isr, 0, driver_name, hv_acpi_dev);
> +	ret = hv_setup_vmbus_irq(irq, vmbus_isr, hv_acpi_dev);
> 
>  	if (ret != 0) {
> -		pr_err("Unable to request IRQ %d\n",
> -			   irq);
> +		pr_err("Unable to request IRQ %d\n", irq);
>  		goto err_unregister;
>  	}
> 
> -	/*
> -	 * Vmbus interrupts can be handled concurrently on
> -	 * different CPUs. Establish an appropriate interrupt flow
> -	 * handler that can support this model.
> -	 */
> -	irq_set_handler(irq, vmbus_flow_handler);
> -
> -	/*
> -	 * Register our interrupt handler.
> -	 */
> -	hv_register_vmbus_handler(irq, vmbus_isr);
> -
>  	ret = hv_synic_alloc();
>  	if (ret)
>  		goto err_alloc;
> @@ -753,7 +723,7 @@ static int vmbus_bus_init(int irq)
> 
>  err_alloc:
>  	hv_synic_free();
> -	free_irq(irq, hv_acpi_dev);
> +	hv_remove_vmbus_irq(irq, hv_acpi_dev);
> 
>  err_unregister:
>  	bus_unregister(&hv_bus);
> @@ -978,8 +948,7 @@ cleanup:
> 
>  static void __exit vmbus_exit(void)
>  {
> -
> -	free_irq(irq, hv_acpi_dev);
> +	hv_remove_vmbus_irq(irq, hv_acpi_dev);
>  	vmbus_free_channels();
>  	bus_unregister(&hv_bus);
>  	hv_cleanup();
> 
> 
> 
> 
> 
> 

