Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab3GDVmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 17:42:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:42589 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909Ab3GDVmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 17:42:37 -0400
Date: Thu, 4 Jul 2013 23:42:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, john.stultz@linaro.org, u.kleine-koenig@pengutronix.de,
        tomasz.figa@gmail.com, linus.walleij@linaro.org,
        thomas.petazzoni@free-electrons.com, arnd@arndb.de
Subject: Re: [PATCH v5] ARM: clocksource: add support for MOXA ART SoCs
In-Reply-To: <1372940383-5957-1-git-send-email-jonas.jensen@gmail.com>
Message-ID: <alpine.DEB.2.02.1307042211420.11637@ionos.tec.linutronix.de>
References: <1372687359-18235-1-git-send-email-jonas.jensen@gmail.com> <1372940383-5957-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jul 2013, Jonas Jensen wrote:

> This patch adds an clocksource driver for the main timer(s)
> found on MOXA ART SoCs.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
> 
> Notes:
>     Applies to next-20130703
>     
>     Changes since v4:
>     
>     1. add general cache for TIMER_CR register

What you implemented is not a register cache. A register cache is
caching the current value and not some initial constant.
 
> +static void moxart_clkevt_mode(enum clock_event_mode mode,
> +			       struct clock_event_device *clk)
> +{
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_RESUME:
> +	case CLOCK_EVT_MODE_ONESHOT:
> +		writel(timereg_cache & ~TIMEREG_CR_1_ENABLE, base + TIMER_CR);

You just modify bits on the "cache" variable. though you are not
caching it. As it seems to work it looks like this register simply can
be written with constants.

> +	timereg_cache = readl(base + TIMER_CR) | TIMEREG_CR_2_ENABLE;

Why are you reading that back? You know excactly which of the timers
you are using and none of those should be enabled before you reach
that code. If it one of them is enabled by the boot loader you better
disable it in this init function. 

Now if you disable all of those timers and just use a known set, then
you can do without a pseudo cache variable and just write constants
into the control register, right ?

Thanks,

	tglx


