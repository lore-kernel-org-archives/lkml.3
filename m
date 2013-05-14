Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab3ENIDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:03:47 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:33472 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab3ENIDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:03:43 -0400
MIME-Version: 1.0
In-Reply-To: <1368332581-94691-5-git-send-email-dt.tangr@gmail.com>
References: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com>
	<1368332581-94691-5-git-send-email-dt.tangr@gmail.com>
Date: Tue, 14 May 2013 10:03:42 +0200
Message-ID: <CACRpkdZBFbOnQ9rCehO0yKDN7fH9VR3VYCa_NkOGJz7KN+02FQ@mail.gmail.com>
Subject: Re: [RFC PATCHv3 4/6] clocksource: Add TI-Nspire timer drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Tang <dt.tangr@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 6:22 AM, Daniel Tang <dt.tangr@gmail.com> wrote:

> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>

A commit message does not hurt.

>  drivers/clocksource/Makefile               |   1 +
>  drivers/clocksource/nspire-classic-timer.c | 199 +++++++++++++++++++++++++++++

This subsystem is managed by Thomas Gleixner and John Stultz so you
should include
them on the To: line in reviewes.

> +++ b/drivers/clocksource/nspire-classic-timer.c
(...)
> +struct nspire_timer {
> +       void __iomem *base;
> +       void __iomem *timer1, *timer2;
> +       void __iomem *interrupt_regs;
> +
> +       int irqnr;
> +
> +       struct clk *clk;
> +       struct clock_event_device clkevt;
> +       struct irqaction clkevt_irq;
> +
> +       char clocksource_name[64];
> +       char clockevent_name[64];
> +};
> +
> +static int nspire_timer_set_event(unsigned long delta,
> +               struct clock_event_device *dev)
> +{
> +       unsigned long flags;
> +       struct nspire_timer *timer = container_of(dev,
> +                       struct nspire_timer,
> +                       clkevt);
> +
> +       local_irq_save(flags);
> +
> +       writel(delta, timer->timer1 + IO_CURRENT_VAL);
> +       writel(CNTL_RUN_TIMER | CNTL_DEC | CNTL_MATCH1,
> +                       timer->timer1 + IO_CONTROL);
> +
> +       local_irq_restore(flags);
> +
> +       return 0;
> +}
> +static void nspire_timer_set_mode(enum clock_event_mode mode,
> +               struct clock_event_device *evt)
> +{
> +       evt->mode = mode;

So you support any mode?

Atleast handle CLOCK_EVT_MODE_SHUTDOWN and CLOCK_EVT_UNUSED
like any well-behaved clock event driver.

> +}
> +
> +static irqreturn_t nspire_timer_interrupt(int irq, void *dev_id)
> +{
> +       struct nspire_timer *timer = dev_id;
> +
> +       writel((1<<0), timer->interrupt_regs + IO_INTR_ACK);

write(0x1, timer->interrupt_regs + IO_INTR_ACK);

is no less intelligible, if you really want to point out that you're
setting bit 0, include <linux/bitops.h> and use BIT(0).

If there is a status bit you're clearing, maybe you should check
it first to watch for spurious IRQs?

> +       writel(CNTL_STOP_TIMER, timer->timer1 + IO_CONTROL);
> +
> +       if (timer->clkevt.event_handler)
> +               timer->clkevt.event_handler(&timer->clkevt);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static int __init nspire_timer_add(struct device_node *node)
> +{
> +       struct nspire_timer *timer;
> +       struct resource res;
> +       int ret;
> +
> +       timer = kzalloc(sizeof(*timer), GFP_ATOMIC);
> +       if (!timer)
> +               return -ENOMEM;
> +
> +       timer->base = of_iomap(node, 0);
> +       if (!timer->base) {
> +               ret = -EINVAL;
> +               goto error_free;
> +       }
> +       timer->timer1 = timer->base + IO_TIMER1;
> +       timer->timer2 = timer->base + IO_TIMER2;
> +
> +       timer->clk = of_clk_get(node, 0);
> +       if (IS_ERR(timer->clk)) {
> +               ret = PTR_ERR(timer->clk);
> +               pr_err("Timer clock not found! (error %d)\n", ret);
> +               goto error_unmap;
> +       }
> +
> +       timer->interrupt_regs = of_iomap(node, 1);

Check for errors.

> +       timer->irqnr = irq_of_parse_and_map(node, 0);

Check for errors.

> +
> +       of_address_to_resource(node, 0, &res);
> +       scnprintf(timer->clocksource_name, sizeof(timer->clocksource_name),
> +                       "%llx.%s_clocksource",
> +                       (unsigned long long)res.start, node->name);
> +
> +       scnprintf(timer->clockevent_name, sizeof(timer->clockevent_name),
> +                       "%llx.%s_clockevent",
> +                       (unsigned long long)res.start, node->name);
> +
> +       if (timer->interrupt_regs && timer->irqnr) {
> +               timer->clkevt.name      = timer->clockevent_name;
> +               timer->clkevt.set_next_event = nspire_timer_set_event;
> +               timer->clkevt.set_mode  = nspire_timer_set_mode;
> +               timer->clkevt.rating    = 200;
> +               timer->clkevt.shift     = 32;

Delete this shift. It will be set by clockevents_config_and_register().

> +               timer->clkevt.cpumask   = cpu_all_mask;
> +               timer->clkevt.features  =
> +                       CLOCK_EVT_FEAT_ONESHOT;
> +
> +               writel(CNTL_STOP_TIMER, timer->timer1 + IO_CONTROL);
> +               writel(0, timer->timer1 + IO_DIVIDER);

For a 16-bit counter I don't think it's wise to set the divider to 0
unless the clock frequency is very low. See further comments
below. (Assumes this is some prescaler.)

> +               /* Mask out interrupts except the one we're using */
> +               writel((1<<0), timer->interrupt_regs + IO_INTR_MSK);

Just 0x1 or BIT(0).

> +               writel(0x3F, timer->interrupt_regs + IO_INTR_ACK);

Hm magic number, I guess it's clearing all IRQ lines...

> +
> +               /* Interrupt to occur when timer value matches 0 */
> +               writel(0, timer->base + IO_MATCH1);
> +
> +               timer->clkevt_irq.name  = timer->clockevent_name;
> +               timer->clkevt_irq.handler = nspire_timer_interrupt;
> +               timer->clkevt_irq.dev_id = timer;
> +               timer->clkevt_irq.flags =
> +                       IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL;
> +
> +               setup_irq(timer->irqnr, &timer->clkevt_irq);
> +
> +               clockevents_config_and_register(&timer->clkevt,
> +                               clk_get_rate(timer->clk), 0x0001, 0xfffe);
> +               pr_info("Added %s as clockevent\n", timer->clockevent_name);
> +       }
> +
> +       writel(CNTL_RUN_TIMER | CNTL_FOREVER | CNTL_INC,
> +                       timer->timer2 + IO_CONTROL);
> +
> +       clocksource_mmio_init(timer->timer2 + IO_CURRENT_VAL,
> +                       timer->clocksource_name,
> +                       clk_get_rate(timer->clk),
> +                       200, 16,
> +                       clocksource_mmio_readw_up);

If this timer is really just 16 bits, it's a *pretty* good idea to use
the prescaler (I guess this is what IO_DIVIDER is) beacuse else you
will get short sleep times with CONFIG_NO_HZ_IDLE on this system,
and wake up unnecessarily often.

The same goes for the clock event.

See how we calculate the prescaler in arch/arm/mach-integrator/integrator_ap.c
for example.

Yours,
Linus Walleij
