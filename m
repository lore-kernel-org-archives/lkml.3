Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab3IZJFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 05:05:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41257 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3IZJFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 05:05:51 -0400
Date: Thu, 26 Sep 2013 11:05:44 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC, PATCH] clocksource: provide timekeeping for efm32 SoCs
Message-ID: <20130926090544.GJ16106@pengutronix.de>
References: <1379324644-20934-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <5242F434.7060702@linaro.org>
 <20130925153207.GG16106@pengutronix.de>
 <524376A0.7020405@linaro.org>
 <20130926082059.GI16106@pengutronix.de>
 <5243F5CD.6090709@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5243F5CD.6090709@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Daniel,

On Thu, Sep 26, 2013 at 10:52:29AM +0200, Daniel Lezcano wrote:
> On 09/26/2013 10:20 AM, Uwe Kleine-König wrote:
> >Hello Daniel,
> >
> >On Thu, Sep 26, 2013 at 01:49:52AM +0200, Daniel Lezcano wrote:
> >>On 09/25/2013 05:32 PM, Uwe Kleine-König wrote:
> >>>>>+static void __init efm32_timer_init(struct device_node *np)
> >>>>>+{
> >>>>>+	static int has_clocksource, has_clockevent;
> >>>>>+	int ret;
> >>>>>+
> >>>>>+	if (!has_clocksource) {
> >>>>>+		ret = efm32_clocksource_init(np);
> >>>>>+		if (!ret) {
> >>>>>+			has_clocksource = 1;
> >>>>>+			return;
> >>>>>+		}
> >>>>>+	}
> >>>>>+
> >>>>>+	if (!has_clockevent) {
> >>>>>+		ret = efm32_clockevent_init(np);
> >>>>>+		if (!ret) {
> >>>>>+			has_clockevent = 1;
> >>>>>+			return;
> >>>>>+		}
> >>>>>+	}
> >>>>>+}
> >>>>
> >>>>I don't get the purpose of this initialization, can you explain ?
> >>>An efm32 SoC has four timer blocks. A single block can only be used for
> >>>one of clocksource or clockevent device and having more than one
> >>>clocksource or clockevent device doesn't make sense. So this routine
> >>>asserts that the first timer is used as clocksource and the second as
> >>>clockevent device. The others are unused.
> >>
> >>Shouldn't be up to the dt to give the timers you want ?
> >The dt looks as follows:
> >
> >                 timer0: timer@40010000 {
> >                         compatible = "efm32,timer";
> >                         reg = <0x40010000 0x400>;
> >                         interrupts = <2>;
> >                         clocks = <&cmu clk_HFPERCLKTIMER0>;
> >                 };
> >
> >                 timer1: timer@40010400 {
> >                         compatible = "efm32,timer";
> >                         reg = <0x40010400 0x400>;
> >                         interrupts = <12>;
> >                         clocks = <&cmu clk_HFPERCLKTIMER1>;
> >                 };
> >
> >                 timer2: timer@40010800 {
> >                         compatible = "efm32,timer";
> >                         reg = <0x40010800 0x400>;
> >                         interrupts = <13>;
> >                         clocks = <&cmu clk_HFPERCLKTIMER2>;
> >                 };
> >
> >                 timer3: timer@40010c00 {
> >                         compatible = "efm32,timer";
> >                         reg = <0x40010c00 0x400>;
> >                         interrupts = <14>;
> >                         clocks = <&cmu clk_HFPERCLKTIMER3>;
> >                 };
> >
> >What is your suggestion now?
> >Add a property that specifies if the block
> >should be used as clocksource or clockevent_device? That isn't a
> >hardware description and so shouldn't go into the device tree.
> 
> At this point, I just asked a question and did not make any suggestion.
I thought your question implied knowing a better way. I'd be happy if it
did.
 
> >Provide two drivers that match on "efm32,timer", one for clocksource and
> >another for clockevent_device? That wouldn't work, too, as the first
> >driver to be loaded would grab all four timers and the second would get
> >none.
> 
> Thanks, now I understand the purpose of this routine, it is very
> similar than:
> 
> http://www.spinics.net/lists/arm-kernel/msg273984.html
> 
> right ?
Right. And as tglx points out in that post, it's not pretty, but I don't
have an idea how to do it nicer. (BTW, I wonder if the of_node_put in
that snipplet is correct, also the three static functions being called
could be marked __init.) At least my implementation is a bit more robust
as it handles the case that the timer intended to be used as clockevent
device doesn't have an irq while the dw_apb_timer driver simply BUGs
then.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
