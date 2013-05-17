Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab3EQLCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:02:10 -0400
Received: from [213.199.154.187] ([213.199.154.187]:37900 "EHLO
	db8outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753940Ab3EQLCI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:02:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zz9371I103dK542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fhbe9i1155h)
From: Lu Jingchang-B35083 <B35083@freescale.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Subject: RE: [PATCH v3] clocksource: add MVF600 pit timer support
Thread-Topic: [PATCH v3] clocksource: add MVF600 pit timer support
Thread-Index: AQHOUgLKkKGGf9R2n0eRY3h+AwTdH5kH2KoAgADQtzA=
Date: Fri, 17 May 2013 11:01:08 +0000
Message-ID: <B56CDBE15CE27145A4B77D2D24263E851C9FBB@039-SN1MPN1-003.039d.mgd.msft.net>
References: <1368684924-1560-1-git-send-email-b35083@freescale.com>
 <alpine.LFD.2.02.1305161214570.1388@ionos>
In-Reply-To: <alpine.LFD.2.02.1305161214570.1388@ionos>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.27]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Thomas Gleixner [mailto:tglx@linutronix.de]
>Sent: Thursday, May 16, 2013 10:05 PM
>To: Lu Jingchang-B35083
>Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
>john.stultz@linaro.org; shawn.guo@linaro.org; s.hauer@pengutronix.de
>Subject: Re: [PATCH v3] clocksource: add MVF600 pit timer support
>
>> +static int pit_set_next_event(unsigned long delta,
>> +				struct clock_event_device *unused) {
>> +	pit_timer_disable();
>> +	__raw_writel(delta - 1, clkevt_base + PITLDVAL);
>> +	pit_irq_acknowledge();
>> +	pit_timer_enable();
>
>It would be much more interesting to comment, why you need to acknowlegde
>the timer here.
[Lu Jingchang-B35083] 
 The pit is a period load and count timer, ack here is to make sure the int flag is clear,
I will check if the ack here is needed and remove the redundant code. Thanks!
>
>> +static irqreturn_t pit_timer_interrupt(int irq, void *dev_id) {
>> +	struct clock_event_device *evt = &clockevent_pit;
>> +
>> +	pit_irq_acknowledge();
>> +
>> +	if (clockevent_mode == CLOCK_EVT_MODE_ONESHOT)
>> +		pit_timer_disable();
>
>So in oneshot mode you do:
>
>     pit_irq_ack()
>     pit_timer_disable()
>     ....
>	set_next_event()
>  	  pit_timer_disable()
>	  write_new_value()
>	  pit_irq_ack()
>	  pit_timer_enable()
>
>Not really the most efficient way in the interrupt fast path, right?
[Lu Jingchang-B35083] 
 The pit hardware doesn't support oneshot timer. So for oneshot mode event,
software need to disable and enable the timer each time.
 The timers generate interrupt at periodic intervals, when enabled. The timers load the start
values as specified in their LDVAL registers, count down to 0, generate an INT and then reload the respective
start value again. Each time a timer reaches 0, it will set the interrupt flag.
I will remove the redundant irq_ack.
Thanks!
>
>> +	evt->event_handler(evt);
>> +
>> +	clockevents_config_and_register(&clockevent_pit, c, 0x100,
>> +0xffffff00);
>
>0x100 and 0xffffff00 ?? Random numbers pulled out of what?
[Lu Jingchang-B35083] 
It seems too small delta is not reasonable, and the max delta value is not sensible.
So refer to some other platforms, I set it to 0x100-0xffffff00. I'm OK to set it to 0x2~0xffffffff.
Thanks!
>
>> +
>> +	timer_base = of_iomap(np, 0);
>> +	WARN_ON(!timer_base);
>
>Great, timer_base is NULL and you just emit a warning and then proceed? So
>instead of either bailing out or crashing the machine right away you let
>it randomly die with the first access.
[Lu Jingchang-B35083] 
I will use BUG_ON() instead of WARN_ON(). Thanks!
>
>> +
>> +	clk_prepare_enable(pit_clk);
>
>And while you're worried about the core code sending you random crap, you
>assume that this call always succeeds.
[Lu Jingchang-B35083] 
I will check the return value for that call. Thanks!

>> +	__raw_writel(0, clksrc_base + PITTCTRL);
>> +	__raw_writel(0xffffffff, clksrc_base + PITLDVAL);
>
>And of this? Why isn't the setup done in the relevant init functions?
[Lu Jingchang-B35083] 
I will move these to relevant init functions. Thanks!



