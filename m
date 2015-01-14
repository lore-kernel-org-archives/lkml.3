Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbbANRpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:45:50 -0500
Received: from gloria.sntech.de ([95.129.55.99]:50411 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbbANRpt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:45:49 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: tglx@linutronix.de, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH] clockevents: rockchip: Add rockchip timer for rk3288
Date: Wed, 14 Jan 2015 18:45:38 +0100
Message-ID: <4543438.UYNY2cLhNF@phil>
User-Agent: KMail/4.14.2 (Linux/3.16.0-4-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <54B694F0.1000405@linaro.org>
References: <1420542233-16897-1-git-send-email-daniel.lezcano@linaro.org> <3085252.tjZK7l7tBp@phil> <54B694F0.1000405@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Am Mittwoch, 14. Januar 2015, 17:10:24 schrieb Daniel Lezcano:
> On 01/13/2015 12:20 AM, Heiko Stübner wrote:
> >> +- clock-frequency: the frequency the timer is running
> >> +
> >> +Example:
> >> +	timer: timer@ff810000 {
> >> +		compatible = "rockchip,rk3288-timer";
> >> +		reg = <0xff810000 0x20>;
> >> +		interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
> >> +		clock-frequency = <24000000>;
> > 
> > wouldn't it make sense to use the actual supplying clock?
> > 
> > For the timer you want to use it is just the non-gateable &xin24m, but the
> > timers in the other block (timer0-5) actually do have gateable clocks.
> > 
> > Similarly there is a pclk_timer supplying at least one of the two actual
> > blocks. I'll try to inquire how the blocks are actually supplied.
> 
> Ok, are you suggesting I should use another timer so we can gate it for
> power efficiency ?

As you want a timer that is running during suspend, I think the one you're 
using right now is the correct one ... the others (timer0-5) are in the cpu-
domain instead of the alive-domain

My intention was more to not have a clock-frequency property, but to simply 
use the correct cock frequency.

clocks = <&xin24m>, <&cru PCLK_TIMER>;
clock-names = "timer", "pclk";

[same binding as dw_apb_timer]


rockchip_timer.c:

tclk = of_clk_get_by_name(np, "timer");
clk_prepare_enable(tclk);
bc_timer.freq = clk_get_rate(tclk);

etc...

essentially like db_apb_timer_of.c does it :-)


We currently don't implement the gates Jack mentioned, but as they're open 
anyway we can just use xin24m directly for now.
And the pclk should probably be enabled too, as with 3.19-rc it gets disabled 
when unused.


Heiko
