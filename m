Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab3FXJMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:12:52 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:60071 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883Ab3FXJMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:12:50 -0400
Message-ID: <51C80C64.3090208@st.com>
Date: Mon, 24 Jun 2013 10:07:48 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
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
References: <1371820267-12099-1-git-send-email-srinivas.kandagatla@st.com> <alpine.DEB.2.02.1306211634510.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306211634510.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thankyou for the comments.

On 21/06/13 16:56, Thomas Gleixner wrote:
> On Fri, 21 Jun 2013, Srinivas KANDAGATLA wrote:
>> +static void gt_clockevent_set_mode(enum clock_event_mode mode,
>> +				   struct clock_event_device *clk)
>> +{
>> +	unsigned long ctrl;
>> +
>> +	ctrl = readl(gt_base + GT_CONTROL);
>> +	switch (mode) {
>> +	case CLOCK_EVT_MODE_PERIODIC:
>> +		gt_compare_set(DIV_ROUND_CLOSEST(gt_clk_rate, HZ), 1);
>> +		break;
>> +	case CLOCK_EVT_MODE_ONESHOT:
>> +		ctrl &= ~(GT_CONTROL_AUTO_INC);
> 
> You should probably clear the irq enable bit as well. The core will
> program the next event right away.
Yep, it makes sense to clear the irq enable and comp enable in this case.
> 
>> +static irqreturn_t gt_clockevent_interrupt(int irq, void *dev_id)
>> +{
>> +	struct clock_event_device *evt = *(struct clock_event_device **)dev_id;
> 
> What kind of construct is this?
> 
> You are using request_percpu_irq() and the device id is pointing to
> per cpu memory. Why do you need this horrible pointer indirection?
> 
> Because a lot of other ARM code uses the same broken construct?

As Stephen already pointed out,

The reason for such a construct is ARM LOCAL TIMER apis, as ARM local
timer apis allocate struct clock_event_device. If the driver want to
reuse this clock event stucture it needs this double pointer. Which is
why we end up with this code.

On the other hand, The driver can ignore the struct clock_event_device
allocated by the local_timer code, and just use its own per cpu
clock_event which will remove this type of constructs. We do this for
boot cpu. I will go ahead doing this way because local_timer apis are
anyway going to be removed in near future (by Stephen's patch) and its
neat and obvious to manage allocations of clock_event structure with in
the driver.

> 
>> +static struct clock_event_device __percpu **gt_evt;
>> +static DEFINE_PER_CPU(struct clock_event_device, gt_clockevent);
> 
> So you have compile time allocated clock event device structures and
> then you allocate a percpu pointer area which holds pointers to the
> static area. Whatfor?
> 
> Why not doing the obvious?
> 
> static struct clock_event_device __percpu *gt_evt;
> 
> 	gt_evt = alloc_percpu(struct clock_event_device):
> 
> 	request_percpu_irq(......, gt_evt);
>  
> And in the interrupt handler
> 
> 	struct clock_event_device *evt = dev_id;
> 
>> +static int __cpuinit gt_clockevents_init(struct clock_event_device *clk)
>> +{
>> +	struct clock_event_device **this_cpu_clk;
>> +	int cpu = smp_processor_id();
>> +
>> +	clk->name = "ARM global timer clock event";
> 
> No spaces in the names please
Yep, replaced by "arm_global_timer"
> 

>> +static int __cpuinit gt_clockevents_setup(struct clock_event_device *clk)
>> +{
>> +	/* Use existing clock_event for boot cpu */
> 
> That comment is telling me what?
> 
Will re-comment it in more detail.

>> +	if (per_cpu(percpu_init_called, smp_processor_id()))
>> +		return 0;
> 
> And why do you need another percpu variable, if you can deduce the
> same information from clk as well.
> 
>       	return clk->name ? 0 : gt_clockevents_init(clk);

As it get rid of a percpu variable I will change it.

> 
> Hmm?
> 
>> +	/* already enabled in gt_clocksource_init. */
> 
> Huch?
> 
There is only one enable bit for all the cores in the global_timer IP.
I will add more comments here for clarity.

>> +	return gt_clockevents_init(clk);
>> +}
> 
>> +static void __init global_timer_of_register(struct device_node *np)
>> +{
>> +	gt_clk = of_clk_get(np, 0);
>> +	if (!IS_ERR(gt_clk)) {
>> +		err = clk_prepare_enable(gt_clk);
> 
> If that fails, you happily proceed, right?
I think there is a check missing here.

> 
>> +	} else {
>> +		pr_warn("global-timer: clk not found\n");
>> +		err = -EINVAL;
>> +		goto out_unmap;
>> +	}
>> +
>> +	gt_evt = alloc_percpu(struct clock_event_device *);
>> +	if (!gt_evt) {
>> +		pr_warn("global-timer: can't allocate memory\n");
>> +		err = -ENOMEM;
>> +		goto out_unmap;
> 
> Leaves the clock enabled and prepared.

Yes I will fix it by adding new label

out_clk:
clk_disable_unprepare(clk);


>> +
>> +	gt_clk_rate = clk_get_rate(gt_clk);
>> +	gt_clocksource_init();
>> +	gt_clockevents_init(evt);
>> +#ifdef CONFIG_LOCAL_TIMERS
>> +	err =  local_timer_register(&gt_lt_ops);
>> +	if (err) {
>> +		pr_warn("global-timer: unable to register local timer.\n");
>> +		free_percpu_irq(gt_ppi, gt_evt);
>> +		goto out_free;
> 
> So that frees your magic pointers, but you still have the clockevent
> registered for the boot cpu. The interrupt handler of that device is
> happily dereferencing the freed percpu memory.

Yes I agree, there is a error handling issue.

I think, not doing anything in error-case seems to be best option and
most of the drivers do this way. This will at-least leave the clockevent
on boot cpu unaffected and let the system boot. I will with this
approach as it will let the system boot with some debug.


Thanks,
srini
> 
> How is that supposed to work?
> 
> Thanks,
> 
> 	tglx
> 

