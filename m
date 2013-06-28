Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab3F1Nes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:34:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:46261 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3F1Ner (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:34:47 -0400
Date: Fri, 28 Jun 2013 15:34:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, john.stultz@linaro.org, u.kleine-koenig@pengutronix.de,
        tomasz.figa@gmail.com, linus.walleij@linaro.org,
        thomas.petazzoni@free-electrons.com, arnd@arndb.de
Subject: Re: [PATCH v3] ARM: clocksource: add support for MOXA ART SoCs
In-Reply-To: <1372332203-30228-1-git-send-email-jonas.jensen@gmail.com>
Message-ID: <alpine.DEB.2.02.1306281518380.4013@ionos.tec.linutronix.de>
References: <1372258383-24524-1-git-send-email-jonas.jensen@gmail.com> <1372332203-30228-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013, Jonas Jensen wrote:
> +#define TIMER_CR			0x30
> +#define TIMER_INTR_STATE	0x34
> +#define TIMER_INTR_MASK		0x38

Please use the same indent level for all.

> +
> +static void moxart_clkevt_mode(enum clock_event_mode mode,
> +	struct clock_event_device *clk)

Please align it like this:

static void moxart_clkevt_mode(enum clock_event_mode mode,
       	    		       struct clock_event_device *clk)

Makes the code way simpler to read.

> +{
> +static int moxart_clkevt_next_event(unsigned long cycles,
> +	struct clock_event_device *unused)

Ditto.

> +{
> +	u32 u;

Newline between variable declaration and code please. All over the
place.

> +	u = readl(base + TIMER1_BASE + REG_COUNT) - cycles;
> +	writel(u, base + TIMER1_BASE + REG_MATCH1);

Is this a real match functionality, i.e. is the trigger on == ?

If yes, how is guaranteed, that for a small cycles value the counter
has not passed the match value already?

> +	u = readl(base + TIMER_CR) | TIMEREG_CR_1_ENABLE;
> +	writel(u, base + TIMER_CR);
> +	return 0;
> +}
> +
> +static struct clock_event_device moxart_clockevent = {
> +	.name = "moxart_timer",

Could you please align the assigned values? i.e.

      .name	 = "moxart_timer",
      .rating	 = 200,

Way better readable than:

> +	.rating = 200,
> +	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,


> +static void __init moxart_timer_init(struct device_node *node)
> +{
> +	int ret, irq;
> +	unsigned long pclk;
> +	struct clk *clk;
> +
> +	base = of_iomap(node, 0);
> +	if (!base)
> +		panic("%s: failed to map base\n", node->full_name);
> +
> +	irq = irq_of_parse_and_map(node, 0);
> +	if (irq <= 0)
> +		panic("%s: can't parse IRQ\n", node->full_name);
> +
> +	ret = setup_irq(irq, &moxart_timer_irq);
> +	if (ret) {
> +		pr_err("%s: failed to setup IRQ %d\n", node->full_name, irq);
> +		return;

This is inconsistent. You panic on the first two checks and then you
simply return.

> +	}
> +
> +	clk = of_clk_get(node, 0);
> +	if (IS_ERR(clk)) {
> +		pr_err("%s: of_clk_get failed\n", __func__);

Your pr_errs are inconsistent. node->full_name in one and __func__ in
the next. __func__ is really not important. The node_name or simply
"moxatimer" is describing for what the clk_get failed.

> +		return;
> +	}
> +
> +	pclk = clk_get_rate(clk);
> +	clock_count_per_tick = DIV_ROUND_CLOSEST(pclk, HZ);
> +
> +	writel(~0, base + TIMER2_BASE + REG_LOAD);
> +
> +	writel(TIMEREG_CR_2_ENABLE, base + TIMER_CR);
> +
> +	if (clocksource_mmio_init(base + TIMER2_BASE + REG_COUNT,
> +					"moxart_timer", pclk, 200, 32,
> +					clocksource_mmio_readl_down)) {

Please align the arguments consistently.

	if (clocksource_mmio_init(base + TIMER2_BASE + REG_COUNT,
				  "moxart_timer", pclk, 200, 32,
				  clocksource_mmio_readl_down)) {


> +	clockevents_config_and_register(&moxart_clockevent, pclk,
> +					0x4, 0xf0000000);

How did you come up with 0xf0000000? Random number generator?

> +	pr_info("%s: %s finished pclk=%lu HZ=%d IRQ=%d\n",
> +			node->full_name, __func__, pclk, HZ, irq);

We really do not need to know about the function name and "finished"
is completely pointless information as well.

Thanks,

	tglx
