Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab3EVJsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:48:08 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:55349
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445Ab3EVJsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:48:05 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zzbb2dI98dI9371Ic89bh103dK542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz177df4h17326ah8275bh8275dh11f642sz2dh2a8h668h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fhbe9i1155h)
From: Lu Jingchang-B35083 <B35083@freescale.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Subject: RE: [PATCH v4] clocksource: add Vybrid Family pit timer support
Thread-Topic: [PATCH v4] clocksource: add Vybrid Family pit timer support
Thread-Index: AQHOVfrXUIemq0KYlUGsqCQt69s5DpkPa+sAgAEG0+A=
Date: Wed, 22 May 2013 09:47:37 +0000
Message-ID: <B56CDBE15CE27145A4B77D2D24263E851CBE88@039-SN1MPN1-003.039d.mgd.msft.net>
References: <1369121274-9371-1-git-send-email-b35083@freescale.com>
 <519B48F4.8050005@linaro.org>
In-Reply-To: <519B48F4.8050005@linaro.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.27]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4M9mGSe027101



>-----Original Message-----
>From: Daniel Lezcano [mailto:daniel.lezcano@linaro.org]
>Sent: Tuesday, May 21, 2013 6:14 PM
>To: Lu Jingchang-B35083
>Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
>john.stultz@linaro.org; tglx@linutronix.de; shawn.guo@linaro.org;
>s.hauer@pengutronix.de
>Subject: Re: [PATCH v4] clocksource: add Vybrid Family pit timer support
>
>On 05/21/2013 09:27 AM, Jingchang Lu wrote:
>> Add Freescale Vybrid Family period interrupt timer support.
>>
>> Signed-off-by: Jingchang Lu <b35083@freescale.com>
>> ---
>> v4:
>>   use family name names driver and symbol instead of SoC name.
>>   remove redundant code.
>>   use BUG_ON instead of WARN_ON.
>>   add necessory comment information.
>>
>>  drivers/clocksource/Kconfig         |   5 +
>>  drivers/clocksource/Makefile        |   1 +
>>  drivers/clocksource/mvf_pit_timer.c | 187
>> ++++++++++++++++++++++++++++++++++++
>>  3 files changed, 193 insertions(+)
>>  create mode 100644 drivers/clocksource/mvf_pit_timer.c
>
>[ ... ]
>
>> +
>> +static int pit_set_next_event(unsigned long delta,
>> +				struct clock_event_device *unused) {
>> +	/*
>> +	 * set a new value to PITLDVAL register will not restart the timer,
>> +	 * to abort the current cycle and start a timer period with the new
>> +	 * value, the timer must be disabled and enabled again.
>> +	 * and the PITLAVAL should be set to delta minus one.
>
>Why delta "minus one" ?
[Lu Jingchang-B35083] 
This is required by the PIT hardware, it is a down counter, the PITLAVAL register should be set to (delta-1), it will raise an interrupt when it counts down to 0. Thanks!
>
>> +	 */
>> +	pit_timer_disable();
>> +	__raw_writel(delta - 1, clkevt_base + PITLDVAL);
>> +	pit_timer_enable();
>> +
>> +	return 0;
>> +}
>> +
>> +static void pit_set_mode(enum clock_event_mode mode,
>> +				struct clock_event_device *evt)
>> +{
>> +	switch (mode) {
>> +	case CLOCK_EVT_MODE_PERIODIC:
>> +		pit_timer_disable();
>> +		__raw_writel(cycle_per_jiffy - 1, clkevt_base + PITLDVAL);
>> +		pit_timer_enable();
>
>You can call pit_set_next_event(cycle_per_jiffy, evt) instead of adding
>redundant code, no ?
[Lu Jingchang-B35083] 
 Yes, I will do that. Thanks!
>
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +}
>
>[ ... ]
>
>> +
>> +static struct clock_event_device clockevent_pit = {
>> +	.name		= "MVF pit timer",
>> +	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
>> +	.set_mode	= pit_set_mode,
>> +	.set_next_event	= pit_set_next_event,
>> +	.rating		= 300,
>> +};
>> +
>> +static struct irqaction pit_timer_irq = {
>> +	.name		= "MVF pit timer",
>> +	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
>
>Did you take into account Thomas's comment ?
[Lu Jingchang-B35083] 
Sorry, I misunderstand Thomas's meaning, I will remove IRQF_DISABLED flag. Thanks! 
>
>> +	.handler	= pit_timer_interrupt,
>> +	.dev_id		= &clockevent_pit,
>> +};
>> +
>> +static int __init pit_clockevent_init(struct clk *pit_clk, int irq) {
>> +	unsigned int c = clk_get_rate(pit_clk);
>> +
>> +	__raw_writel(0, clkevt_base + PITTCTRL);
>> +	__raw_writel(PITTFLG_TIF, clkevt_base + PITTFLG);
>> +
>> +	clockevent_pit.cpumask = cpumask_of(0);
>
>The irq initialization is missing.
>
>	clockevent_pit.irq = irq;
>
[Lu Jingchang-B35083] 
Yes, I will add this. Thanks!

>> +	clockevents_config_and_register(&clockevent_pit, c, 2, 0xffffffff);
>
>Is it possible to have a comment with the justification for these values ?
[Lu Jingchang-B35083] 
Yes, I will add a comment for these values. Thanks!
>
>> +
>> +	BUG_ON(setup_irq(irq, &pit_timer_irq));
>> +	return 0;
>
>Everything is ok if you can't setup your timer ?
>
>> +}
>> +
>> +static void __init pit_timer_init(struct device_node *np) {
>> +	struct clk *pit_clk;
>> +	void __iomem *timer_base;
>> +	int irq;
>> +
>> +	timer_base = of_iomap(np, 0);
>> +	BUG_ON(!timer_base);
>
>You raise a bug and then you go ahead setting up the address with an
>invalid value, leading to a random crash.
[Lu Jingchang-B35083] 
The BUG_ON() will call BUG() if condition is true. It will print the stack trace and the current process will die, it won't go ahead, won't it? Thanks! 
>
>> +	/*
>> +	 * PIT0 and PIT1 can be chained to build a 64-bit timer,
>> +	 * so choose PIT2 as clocksource, PIT3 as clockevent device,
>> +	 * and leave PIT0 and PIT1 unused for anyone else who needs them.
>> +	 */
>> +	clksrc_base = timer_base + PITn_OFFSET(2);
>> +	clkevt_base = timer_base + PITn_OFFSET(3);
>> +
>> +	irq = irq_of_parse_and_map(np, 0);
>> +
>> +	pit_clk = of_clk_get(np, 0);
>> +	BUG_ON(IS_ERR(pit_clk));
>> +
>> +	BUG_ON(clk_prepare_enable(pit_clk));
>
>Same here.
>
>> +	cycle_per_jiffy = clk_get_rate(pit_clk)/(HZ);
>> +
>> +	/* enable the pit module */
>> +	__raw_writel(~PITMCR_MDIS, timer_base + PITMCR);
>> +
>> +	BUG_ON(pit_clocksource_init(pit_clk));
>> +
>> +	pit_clockevent_init(pit_clk, irq);
>
>Please, remove these BUG_ON, this is inconsistent especially with a one
>call init function. If pit_timer_init can't be initialized, just pr_err
>+ BUG.
[Lu Jingchang-B35083] 
Do you mean that I should not use the BUG_ON or I need print an error information by pr_err before BUG. Thanks!
>
>Thanks
>  -- Daniel
>
>
>--
> <http://www.linaro.org/> Linaro.org â”‚ Open source software for ARM SoCs
>
>Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
><http://twitter.com/#!/linaroorg> Twitter | <http://www.linaro.org/linaro-
>blog/> Blog
>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
