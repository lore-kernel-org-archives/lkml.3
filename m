Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423093Ab3FUP4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:56:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:40162 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422915Ab3FUP4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:56:15 -0400
Date: Fri, 21 Jun 2013 17:56:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
cc: John Stultz <john.stultz@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4] clocksource:arm_global_timer: Add ARM global timer
 support.
In-Reply-To: <1371820267-12099-1-git-send-email-srinivas.kandagatla@st.com>
Message-ID: <alpine.DEB.2.02.1306211634510.4013@ionos.tec.linutronix.de>
References: <1371820267-12099-1-git-send-email-srinivas.kandagatla@st.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jun 2013, Srinivas KANDAGATLA wrote:
> +static void gt_clockevent_set_mode(enum clock_event_mode mode,
> +				   struct clock_event_device *clk)
> +{
> +	unsigned long ctrl;
> +
> +	ctrl = readl(gt_base + GT_CONTROL);
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_PERIODIC:
> +		gt_compare_set(DIV_ROUND_CLOSEST(gt_clk_rate, HZ), 1);
> +		break;
> +	case CLOCK_EVT_MODE_ONESHOT:
> +		ctrl &= ~(GT_CONTROL_AUTO_INC);

You should probably clear the irq enable bit as well. The core will
program the next event right away.

> +static irqreturn_t gt_clockevent_interrupt(int irq, void *dev_id)
> +{
> +	struct clock_event_device *evt = *(struct clock_event_device **)dev_id;

What kind of construct is this?

You are using request_percpu_irq() and the device id is pointing to
per cpu memory. Why do you need this horrible pointer indirection?

Because a lot of other ARM code uses the same broken construct?

> +static struct clock_event_device __percpu **gt_evt;
> +static DEFINE_PER_CPU(struct clock_event_device, gt_clockevent);

So you have compile time allocated clock event device structures and
then you allocate a percpu pointer area which holds pointers to the
static area. Whatfor?

Why not doing the obvious?

static struct clock_event_device __percpu *gt_evt;

	gt_evt = alloc_percpu(struct clock_event_device):

	request_percpu_irq(......, gt_evt);
 
And in the interrupt handler

	struct clock_event_device *evt = dev_id;

> +static int __cpuinit gt_clockevents_init(struct clock_event_device *clk)
> +{
> +	struct clock_event_device **this_cpu_clk;
> +	int cpu = smp_processor_id();
> +
> +	clk->name = "ARM global timer clock event";

No spaces in the names please

> +	clk->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
> +	clk->set_mode = gt_clockevent_set_mode;
> +	clk->set_next_event = gt_clockevent_set_next_event;
> +	this_cpu_clk = __this_cpu_ptr(gt_evt);
> +	*this_cpu_clk = clk;
> +	clk->cpumask = cpumask_of(cpu);
> +	clk->irq = gt_ppi;
> +	clockevents_config_and_register(clk, gt_clk_rate,
> +					1, 0xffffffff);
> +	per_cpu(percpu_init_called, cpu) = true;
> +	enable_percpu_irq(clk->irq, IRQ_TYPE_NONE);
> +	return 0;
> +}
> +
> +static void gt_clockevents_stop(struct clock_event_device *clk)
> +{
> +	gt_clockevent_set_mode(CLOCK_EVT_MODE_UNUSED, clk);
> +	disable_percpu_irq(clk->irq);
> +}
> +
> +static int __cpuinit gt_clockevents_setup(struct clock_event_device *clk)
> +{
> +	/* Use existing clock_event for boot cpu */

That comment is telling me what?

> +	if (per_cpu(percpu_init_called, smp_processor_id()))
> +		return 0;

And why do you need another percpu variable, if you can deduce the
same information from clk as well.

      	return clk->name ? 0 : gt_clockevents_init(clk);

Hmm?

> +	/* already enabled in gt_clocksource_init. */

Huch?

> +	return gt_clockevents_init(clk);
> +}

> +static void __init global_timer_of_register(struct device_node *np)
> +{
> +	gt_clk = of_clk_get(np, 0);
> +	if (!IS_ERR(gt_clk)) {
> +		err = clk_prepare_enable(gt_clk);

If that fails, you happily proceed, right?

> +	} else {
> +		pr_warn("global-timer: clk not found\n");
> +		err = -EINVAL;
> +		goto out_unmap;
> +	}
> +
> +	gt_evt = alloc_percpu(struct clock_event_device *);
> +	if (!gt_evt) {
> +		pr_warn("global-timer: can't allocate memory\n");
> +		err = -ENOMEM;
> +		goto out_unmap;

Leaves the clock enabled and prepared.

> +	}
> +
> +	err = request_percpu_irq(gt_ppi, gt_clockevent_interrupt,
> +				 "gt", gt_evt);
> +	if (err) {
> +		pr_warn("global-timer: can't register interrupt %d (%d)\n",
> +			gt_ppi, err);
> +		goto out_free;

Ditto

> +	}
> +
> +	gt_clk_rate = clk_get_rate(gt_clk);
> +	gt_clocksource_init();
> +	gt_clockevents_init(evt);
> +#ifdef CONFIG_LOCAL_TIMERS
> +	err =  local_timer_register(&gt_lt_ops);
> +	if (err) {
> +		pr_warn("global-timer: unable to register local timer.\n");
> +		free_percpu_irq(gt_ppi, gt_evt);
> +		goto out_free;

So that frees your magic pointers, but you still have the clockevent
registered for the boot cpu. The interrupt handler of that device is
happily dereferencing the freed percpu memory.

How is that supposed to work?

Thanks,

	tglx
