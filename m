Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbbAPKjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:39:18 -0500
Received: from down.free-electrons.com ([37.187.137.238]:33040 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752398AbbAPKjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:39:17 -0500
Date: Fri, 16 Jan 2015 11:39:13 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] clocksource: track usage
Message-ID: <20150116113913.13ece0f6@bbrezillon>
In-Reply-To: <1421399874-29119-2-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421399874-29119-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1421399874-29119-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On Fri, 16 Jan 2015 10:17:53 +0100
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> Track whether the clocksource is enabled or disabled.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  include/linux/clocksource.h |  4 ++++
>  kernel/time/clocksource.c   | 26 ++++++++++++++++++++++++++
>  kernel/time/timekeeping.c   |  8 +++-----
>  3 files changed, 33 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index abcafaa20b86..7735902fc5f6 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -210,6 +210,8 @@ struct clocksource {
>  #define CLOCK_SOURCE_SUSPEND_NONSTOP		0x80
>  #define CLOCK_SOURCE_RESELECT			0x100
>  
> +#define CLOCK_SOURCE_USED			0x200
> +
>  /* simplify initialization of mask field */
>  #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
>  
> @@ -282,6 +284,8 @@ static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
>  
>  extern int clocksource_register(struct clocksource*);
>  extern int clocksource_unregister(struct clocksource*);
> +extern int clocksource_enable(struct clocksource *);
> +extern void clocksource_disable(struct clocksource *);
>  extern void clocksource_touch_watchdog(void);
>  extern struct clocksource* clocksource_get_next(void);
>  extern void clocksource_change_rating(struct clocksource *cs, int rating);
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index b79f39bda7e1..920a4da58eb0 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -889,6 +889,32 @@ int clocksource_unregister(struct clocksource *cs)
>  }
>  EXPORT_SYMBOL(clocksource_unregister);
>  
> +/**
> + * clocksource_enable - enable a registered clocksource
> + * @cs:	clocksource to enable
> + */
> +int clocksource_enable(struct clocksource *cs)
> +{
> +	cs->flags |= CLOCK_SOURCE_USED;
> +	if (cs->enable)
> +		return cs->enable(cs);

I guess you should check cs->enable() return code before setting the
CLOCK_SOURCE_USED flag.




-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
