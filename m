Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbbATKws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:52:48 -0500
Received: from www.linutronix.de ([62.245.132.108]:47826 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbbATKwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:52:46 -0500
Date: Tue, 20 Jan 2015 11:51:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
cc: John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] clocksource: track usage
In-Reply-To: <1421427439-11699-2-git-send-email-alexandre.belloni@free-electrons.com>
Message-ID: <alpine.DEB.2.11.1501201148550.5526@nanos>
References: <1421427439-11699-1-git-send-email-alexandre.belloni@free-electrons.com> <1421427439-11699-2-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015, Alexandre Belloni wrote:
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index abcafaa20b86..7735902fc5f6 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -210,6 +210,8 @@ struct clocksource {
>  #define CLOCK_SOURCE_SUSPEND_NONSTOP		0x80
>  #define CLOCK_SOURCE_RESELECT			0x100
>  
> +#define CLOCK_SOURCE_USED			0x200

You track whether the clocksource is enabled or not, right?

>  /* simplify initialization of mask field */
>  #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
>  
> @@ -282,6 +284,8 @@ static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
>  
>  extern int clocksource_register(struct clocksource*);
>  extern int clocksource_unregister(struct clocksource*);
> +extern int clocksource_enable(struct clocksource *);
> +extern void clocksource_disable(struct clocksource *);

This should be in kernel/time/timekeeping_internal.h

>  extern void clocksource_touch_watchdog(void);
>  extern struct clocksource* clocksource_get_next(void);
>  extern void clocksource_change_rating(struct clocksource *cs, int rating);
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index b79f39bda7e1..03cfc5a08e3b 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -889,6 +889,36 @@ int clocksource_unregister(struct clocksource *cs)
>  }
>  EXPORT_SYMBOL(clocksource_unregister);
>  
> +/**
> + * clocksource_enable - enable a registered clocksource
> + * @cs:	clocksource to enable
> + */
> +int clocksource_enable(struct clocksource *cs)
> +{
> +	int ret = 0;
> +
> +	if (cs->enable)
> +		ret = cs->enable(cs);
> +
> +	if (!ret)
> +		cs->flags |= CLOCK_SOURCE_USED;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(clocksource_enable);

Why on earth do you want to export that?

> +/**
> + * clocksource_disable - disable a registered clocksource
> + * @cs:	clocksource to disable
> + */
> +void clocksource_disable(struct clocksource *cs)
> +{
> +	cs->flags &= ~CLOCK_SOURCE_USED;
> +	if (cs->disable)
> +		cs->disable(cs);
> +}
> +EXPORT_SYMBOL(clocksource_disable);

Ditto.

Thanks,

	tglx
