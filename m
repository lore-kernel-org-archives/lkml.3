Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab3EHPc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:32:27 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:52187 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753181Ab3EHPcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:32:25 -0400
Message-ID: <518A69FC.1090600@st.com>
Date: Wed, 08 May 2013 16:06:36 +0100
From: Stuart MENEFY <stuart.menefy@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>, linux@arm.linux.org.uk,
        will.deacon@arm.com, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>, Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Pitre <nico@linaro.org>, Dave Martin <dave.martin@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: Re: [RFC 2/8] ARM:global_timer: Add ARM global timer support.
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <1368022260-2197-1-git-send-email-srinivas.kandagatla@st.com> <518A6099.8070505@gmail.com>
In-Reply-To: <518A6099.8070505@gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/13 15:26, Rob Herring wrote:
> On 05/08/2013 09:11 AM, Srinivas KANDAGATLA wrote:
>> From: Stuart Menefy <stuart.menefy@st.com>
>>
>> This is a simple driver for the global timer module found in the Cortex
>> A9-MP cores from revision r1p0 onwards. This should be able to perform
>> the functions of the system timer and the local timer in an SMP system.
>>
>> The global timer has the following features:
>>     The global timer is a 64-bit incrementing counter with an
>> auto-incrementing feature. It continues incrementing after sending
>> interrupts. The global timer is memory mapped in the private memory
>> region.
>>     The global timer is accessible to all Cortex-A9 processors in the
>> cluster. Each Cortex-A9 processor has a private 64-bit comparator that
>> is used to assert a private interrupt when the global timer has reached
>> the comparator value. All the Cortex-A9 processors in a design use the
>> banked ID, ID27, for this interrupt. ID27 is sent to the Interrupt
>> Controller as a Private Peripheral Interrupt. The global timer is
>> clocked by PERIPHCLK.
> 
> PERIPHCLK scales with cpu clock typically so the global timer is not a
> suitable clocksource if you use cpufreq. You can deal with the scaling
> on clockevents, but not a clocksource. I imagine the global timers is
> also typically power-gated in some low power modes. This is why no one
> has added support already. Are neither of those an issue or going to be
> an issue for you?

I agree but we're limited by the available hardware, the SoC designers
didn't put down any general purpose timers unfortunately, so we have to
use the global timer as a clocksource.

The full version of this code has a cpufreq notifier to try and cope with
changes, but we didn't include that as the rest of the cpufreq code is
missing in this first post. There will be inaccuracies of course, but its
the best we can do.

There is no power gating on these devices, and clock gating only occurs
at the clock input to the A9 subsystem including the cores and timers,
so we don't have that issue.

Stuart

>> Signed-off-by: Stuart Menefy <stuart.menefy@st.com>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>> ---
>>  Documentation/devicetree/bindings/arm/gt.txt |   21 ++
>>  arch/arm/Kconfig                             |    6 +
>>  arch/arm/include/asm/global_timer.h          |   12 +
>>  arch/arm/kernel/Makefile                     |    1 +
>>  arch/arm/kernel/global_timer.c               |  325 ++++++++++++++++++++++++++
>>  5 files changed, 365 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/arm/gt.txt
>>  create mode 100644 arch/arm/include/asm/global_timer.h
>>  create mode 100644 arch/arm/kernel/global_timer.c
>>
>> diff --git a/Documentation/devicetree/bindings/arm/gt.txt b/Documentation/devicetree/bindings/arm/gt.txt
>> new file mode 100644
>> index 0000000..4ec5fb0
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/gt.txt
>> @@ -0,0 +1,21 @@
>> +
>> +* ARM Global Timer
>> +	Cortex-A9 are often associated with a per-core Global timer.
>> +
>> +** Timer node required properties:
>> +
>> +- compatible : Should be one of:
>> +	"arm,cortex-a9-global-timer"
>> +
>> +- interrupts : One interrupt to each core
>> +
>> +- reg : Specify the base address and the size of the GT timer
>> +	register window.
>> +
>> +Example:
>> +
>> +	gt-timer@2c000600 {
>> +		compatible = "arm,cortex-a9-global-timer";
>> +		reg = <0x2c000600 0x20>;
>> +		interrupts = <1 13 0xf01>;
>> +	};
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index 1cacda4..c8c524e 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -1606,6 +1606,12 @@ config HAVE_ARM_TWD
>>  	help
>>  	  This options enables support for the ARM timer and watchdog unit
>>  
>> +config HAVE_ARM_GT
>> +	bool
>> +	select CLKSRC_OF if OF
>> +	help
>> +	  This options enables support for the ARM global timer unit
>> +
>>  choice
>>  	prompt "Memory split"
>>  	default VMSPLIT_3G
>> diff --git a/arch/arm/include/asm/global_timer.h b/arch/arm/include/asm/global_timer.h
>> new file mode 100644
>> index 0000000..46f9188
>> --- /dev/null
>> +++ b/arch/arm/include/asm/global_timer.h
>> @@ -0,0 +1,12 @@
>> +/*
>> + * arch/arm/include/asm/global_timer.h
>> + *
>> + * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
>> + * Author: Stuart Menefy <stuart.menefy@st.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +int __init global_timer_init(void __iomem *base, unsigned int timer_irq);
>> diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
>> index 5f3338e..af51808 100644
>> --- a/arch/arm/kernel/Makefile
>> +++ b/arch/arm/kernel/Makefile
>> @@ -35,6 +35,7 @@ obj-$(CONFIG_ARM_CPU_SUSPEND)	+= sleep.o suspend.o
>>  obj-$(CONFIG_SMP)		+= smp.o smp_tlb.o
>>  obj-$(CONFIG_HAVE_ARM_SCU)	+= smp_scu.o
>>  obj-$(CONFIG_HAVE_ARM_TWD)	+= smp_twd.o
>> +obj-$(CONFIG_HAVE_ARM_GT)	+= global_timer.o
>>  obj-$(CONFIG_ARM_ARCH_TIMER)	+= arch_timer.o
>>  obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o insn.o
>>  obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o insn.o
>> diff --git a/arch/arm/kernel/global_timer.c b/arch/arm/kernel/global_timer.c
>> new file mode 100644
>> index 0000000..0ab1af3
>> --- /dev/null
>> +++ b/arch/arm/kernel/global_timer.c
>> @@ -0,0 +1,325 @@
>> +/*
>> + * linux/arch/arm/kernel/global_timer.c
>> + *
>> + * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
>> + * Author: Stuart Menefy <stuart.menefy@st.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/clocksource.h>
>> +#include <linux/clockchips.h>
>> +#include <linux/clk.h>
>> +#include <linux/clkdev.h>
>> +#include <linux/err.h>
>> +#include <linux/io.h>
>> +#include <linux/of.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/of_address.h>
>> +
>> +#include <asm/mach/irq.h>
>> +#include <asm/global_timer.h>
>> +#include <asm/localtimer.h>
>> +
>> +#define GT_COUNTER0	0x00
>> +#define GT_COUNTER1	0x04
>> +
>> +#define GT_CONTROL	0x08
>> +#define GT_CONTROL_TIMER_ENABLE		BIT(0)
>> +#define GT_CONTROL_COMP_ENABLE		BIT(1)	/* banked */
>> +#define GT_CONTROL_IRQ_ENABLE		BIT(2)	/* banked */
>> +#define GT_CONTROL_AUTO_INC		BIT(3)	/* banked */
>> +
>> +#define GT_INT_STATUS	0x0c
>> +#define GT_INT_STATUS_EVENT_FLAG	BIT(0)
>> +
>> +#define GT_COMP0	0x10
>> +#define GT_COMP1	0x14
>> +#define GT_AUTO_INC	0x18
>> +
>> +/*
>> + * We are expecting to be clocked by the ARM peripheral clock.
>> + *
>> + * Note: it is assumed we are using a prescaler value of zero, so this is
>> + * the units for all operations.
>> + */
>> +static void __iomem *gt_base;
>> +static struct clk *gt_clk;
>> +static unsigned long gt_clk_rate;
>> +static int gt_ppi;
>> +static struct clock_event_device __percpu **gt_evt;
>> +static DEFINE_PER_CPU(bool, percpu_init_called);
>> +static DEFINE_PER_CPU(struct clock_event_device, gt_clockevent);
>> +
>> +union gt_counter {
>> +	cycle_t cycles;
>> +	struct {
>> +		uint32_t lower;
>> +		uint32_t upper;
>> +	};
>> +};
>> +
>> +static union gt_counter gt_counter_read(void)
>> +{
>> +	union gt_counter res;
>> +	uint32_t upper;
>> +
>> +	upper = readl(gt_base + GT_COUNTER1);
>> +	do {
>> +		res.upper = upper;
>> +		res.lower = readl(gt_base + GT_COUNTER0);
>> +		upper = readl(gt_base + GT_COUNTER1);
>> +	} while (upper != res.upper);
>> +
>> +	return res;
>> +}
>> +
>> +static void gt_compare_set(unsigned long delta, int periodic)
>> +{
>> +	union gt_counter counter = gt_counter_read();
>> +	unsigned long ctrl = readl(gt_base + GT_CONTROL);
>> +
>> +	BUG_ON(!(ctrl & GT_CONTROL_TIMER_ENABLE));
>> +	BUG_ON(ctrl & (GT_CONTROL_COMP_ENABLE |
>> +		       GT_CONTROL_IRQ_ENABLE |
>> +		       GT_CONTROL_AUTO_INC));
>> +
>> +	counter.cycles += delta;
>> +	writel(counter.lower, gt_base + GT_COMP0);
>> +	writel(counter.upper, gt_base + GT_COMP1);
>> +
>> +	ctrl |= GT_CONTROL_COMP_ENABLE | GT_CONTROL_IRQ_ENABLE;
>> +
>> +	if (periodic) {
>> +		writel(delta, gt_base + GT_AUTO_INC);
>> +		ctrl |= GT_CONTROL_AUTO_INC;
>> +	}
>> +
>> +	writel(ctrl, gt_base + GT_CONTROL);
>> +}
>> +
>> +static void gt_clockevent_set_mode(enum clock_event_mode mode,
>> +				   struct clock_event_device *clk)
>> +{
>> +	switch (mode) {
>> +	case CLOCK_EVT_MODE_PERIODIC:
>> +		gt_compare_set(gt_clk_rate/HZ, 1);
>> +		break;
>> +	case CLOCK_EVT_MODE_ONESHOT:
>> +		/* period set, and timer enabled in 'next_event' hook */
>> +		BUG_ON(readl(gt_base + GT_CONTROL) &
>> +		       (GT_CONTROL_COMP_ENABLE |
>> +			GT_CONTROL_IRQ_ENABLE |
>> +			GT_CONTROL_AUTO_INC));
>> +		/* Fall through */
>> +	case CLOCK_EVT_MODE_UNUSED:
>> +	case CLOCK_EVT_MODE_SHUTDOWN:
>> +	default:
>> +		writel(GT_CONTROL_TIMER_ENABLE, gt_base + GT_CONTROL);
>> +		break;
>> +	}
>> +}
>> +
>> +static int gt_clockevent_set_next_event(unsigned long evt,
>> +					struct clock_event_device *unused)
>> +{
>> +	gt_compare_set(evt, 0);
>> +	return 0;
>> +}
>> +
>> +static irqreturn_t gt_clockevent_interrupt(int irq, void *dev_id)
>> +{
>> +	struct clock_event_device *evt = *(struct clock_event_device **)dev_id;
>> +
>> +	writel(GT_INT_STATUS_EVENT_FLAG, gt_base + GT_INT_STATUS);
>> +	evt->event_handler(evt);
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static int __cpuinit gt_clockevents_init(struct clock_event_device *clk)
>> +{
>> +	struct clock_event_device **this_cpu_clk;
>> +	int cpu = smp_processor_id();
>> +
>> +	clk->name = "Global Timer CE";
>> +	clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
>> +	clk->set_mode = gt_clockevent_set_mode;
>> +	clk->set_next_event = gt_clockevent_set_next_event;
>> +	this_cpu_clk = __this_cpu_ptr(gt_evt);
>> +	*this_cpu_clk = clk;
>> +	clk->irq = gt_ppi;
>> +	clockevents_config_and_register(clk, gt_clk_rate,
>> +					0xf, 0xffffffff);
>> +	per_cpu(percpu_init_called, cpu) = true;
>> +	enable_percpu_irq(clk->irq, IRQ_TYPE_NONE);
>> +	return 0;
>> +}
>> +
>> +static void gt_clockevents_stop(struct clock_event_device *clk)
>> +{
>> +	gt_clockevent_set_mode(CLOCK_EVT_MODE_UNUSED, clk);
>> +	disable_percpu_irq(clk->irq);
>> +}
>> +
>> +static int __cpuinit gt_clockevents_setup(struct clock_event_device *clk)
>> +{
>> +	int cpu = smp_processor_id();
>> +
>> +	/* Use existing clock_event for boot cpu */
>> +	if (per_cpu(percpu_init_called, cpu))
>> +		return 0;
>> +
>> +	writel(0, gt_base + GT_CONTROL);
>> +	writel(0, gt_base + GT_COUNTER0);
>> +	writel(0, gt_base + GT_COUNTER1);
>> +	writel(GT_CONTROL_TIMER_ENABLE, gt_base + GT_CONTROL);
>> +
>> +	return gt_clockevents_init(clk);
>> +}
>> +
>> +static cycle_t gt_clocksource_read(struct clocksource *cs)
>> +{
>> +	union gt_counter res = gt_counter_read();
>> +	return res.cycles;
>> +}
>> +
>> +static struct clocksource gt_clocksource = {
>> +	.name	= "Global Timer CS",
>> +	.rating	= 300,
>> +	.read	= gt_clocksource_read,
>> +	.mask	= CLOCKSOURCE_MASK(64),
>> +	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
>> +};
>> +
>> +static void __init gt_clocksource_init(void)
>> +{
>> +	writel(0, gt_base + GT_CONTROL);
>> +	writel(0, gt_base + GT_COUNTER0);
>> +	writel(0, gt_base + GT_COUNTER1);
>> +	writel(GT_CONTROL_TIMER_ENABLE, gt_base + GT_CONTROL);
>> +
>> +	gt_clocksource.shift = 20;
>> +	gt_clocksource.mult =
>> +		clocksource_hz2mult(gt_clk_rate, gt_clocksource.shift);
>> +	clocksource_register(&gt_clocksource);
>> +}
>> +
>> +static struct clk *gt_get_clock(void)
>> +{
>> +	struct clk *clk;
>> +	int err;
>> +
>> +	clk = clk_get_sys("gt", NULL);
>> +	if (IS_ERR(clk)) {
>> +		pr_err("global-timer: clock not found: %ld\n", PTR_ERR(clk));
>> +		return clk;
>> +	}
>> +
>> +	err = clk_prepare_enable(clk);
>> +	if (err) {
>> +		pr_err("global-timer: clock prepare+enable failed: %d\n", err);
>> +		clk_put(clk);
>> +		return ERR_PTR(err);
>> +	}
>> +
>> +	return clk;
>> +}
>> +
>> +static struct local_timer_ops gt_lt_ops __cpuinitdata = {
>> +	.setup	= gt_clockevents_setup,
>> +	.stop	= gt_clockevents_stop,
>> +};
>> +
>> +int __init global_timer_init(void __iomem *base, unsigned int timer_irq)
>> +{
>> +	unsigned int cpu = smp_processor_id();
>> +	struct clock_event_device *evt = &per_cpu(gt_clockevent, cpu);
>> +	int err = 0;
>> +
>> +	if (gt_base) {
>> +		pr_warn("global-timer: invalid base address\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	gt_clk = gt_get_clock();
>> +	if (IS_ERR(gt_clk)) {
>> +		pr_warn("global-timer: clk not found\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	gt_evt = alloc_percpu(struct clock_event_device *);
>> +	if (!gt_evt) {
>> +		pr_warn("global-timer: can't allocate memory\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	err = request_percpu_irq(timer_irq, gt_clockevent_interrupt,
>> +				 "gt", gt_evt);
>> +	if (err) {
>> +		pr_warn("global-timer: can't register interrupt %d (%d)\n",
>> +			timer_irq, err);
>> +		goto out_free;
>> +	}
>> +
>> +	gt_base = base;
>> +	gt_clk_rate = clk_get_rate(gt_clk);
>> +
>> +	evt->irq = timer_irq;
>> +	gt_ppi = timer_irq;
>> +	evt->cpumask = cpumask_of(cpu);
>> +
>> +	gt_clocksource_init();
>> +	gt_clockevents_init(evt);
>> +	err =  local_timer_register(&gt_lt_ops);
>> +	if (err) {
>> +		pr_warn("global-timer: unable to register local timer.\n");
>> +		goto out_irq;
>> +	}
>> +
>> +	return 0;
>> +
>> +out_irq:
>> +	free_percpu_irq(timer_irq, gt_evt);
>> +out_free:
>> +	free_percpu(gt_evt);
>> +	return err;
>> +}
>> +
>> +#ifdef CONFIG_OF
>> +static void __init global_timer_of_register(struct device_node *np)
>> +{
>> +	struct clk *clk;
>> +	int err = 0;
>> +	int gt_ppi;
>> +	static void __iomem *gt_base;
>> +
>> +	gt_ppi = irq_of_parse_and_map(np, 0);
>> +	if (!gt_ppi) {
>> +		err = -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	gt_base = of_iomap(np, 0);
>> +	if (!gt_base) {
>> +		err = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	clk = of_clk_get(np, 0);
>> +	if (!IS_ERR(clk))
>> +		clk_register_clkdev(clk, NULL, "gt");
>> +
>> +	global_timer_init(gt_base, gt_ppi);
>> +
>> +out:
>> +	WARN(err, "Global timer register failed (%d)\n", err);
>> +}
>> +
>> +CLOCKSOURCE_OF_DECLARE(arm_gt_a9, "arm,cortex-a9-global-timer",
>> +			global_timer_of_register);
>> +#endif
>>
> 


