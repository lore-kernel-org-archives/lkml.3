Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaJYVKl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 17:10:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:51187 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaJYVKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 17:10:39 -0400
Date: Sat, 25 Oct 2014 23:10:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ley Foon Tan <lftan@altera.com>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        lftan.linux@gmail.com, cltang@codesourcery.com
Subject: Re: [PATCH v5 21/29] nios2: Time keeping
In-Reply-To: <1414139071-3818-22-git-send-email-lftan@altera.com>
Message-ID: <alpine.DEB.2.11.1410252258570.5308@nanos>
References: <1414139071-3818-1-git-send-email-lftan@altera.com> <1414139071-3818-22-git-send-email-lftan@altera.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014, Ley Foon Tan wrote:
> +#ifndef _ASM_NIOS2_TIMEX_H
> +#define _ASM_NIOS2_TIMEX_H
> +
> +typedef unsigned long cycles_t;
> +
> +extern cycles_t get_cycles(void);
> +
> +#define ARCH_HAS_READ_CURRENT_TIMER

Why does NIOS need that? Does it have a hardware implementation
dependent clock frequency which needs to be calibrated at boot time?

> +struct nios2_clockevent_dev {
> +	struct nios2_timer timer;
> +	struct clock_event_device ced;
> +	struct irqaction irqaction;
> +};

Why does this need its private irqaction? Timers are setup after the
interrupt subsystem, so request_irq() is good enough.

> +static void nios2_timer_config(struct nios2_timer *timer, unsigned long period,
> +	enum clock_event_mode mode)
> +{
> +	u16 ctrl;
> +
> +	/* The timer's actual period is one cycle greater than the value
> +	 * stored in the period register. */
> +	if (period)
> +		period--;

Pointless conditional. Set ce->min_delta_ticks to 1, so the core code
will never call this with period == 0 and you can unconditionally
decrement period.

> +static __init void nios2_clockevent_init(struct device_node *timer)
> +{
> +	struct nios2_clockevent_dev *ce;
> +	void __iomem *iobase;
> +	u32 freq;
> +	int irq;
> +
> +	ce = kzalloc(sizeof(*ce), GFP_KERNEL);
> +	if (!ce)
> +		panic("Failed to allocate memory for %s\n", timer->name);

What's the point of this allocation? You only install one of those, so
you can really make that whole thing statically allocated and
initialized. Or do you expect systems which use a different timer IP
for this?

> +static __init void nios2_clocksource_init(struct device_node *timer)
> +{
> +	unsigned int ctrl;
> +	void __iomem *iobase;
> +	u32 freq;
> +
> +	nios2_cs = kzalloc(sizeof(*nios2_cs), GFP_KERNEL);
> +	if (!nios2_cs)
> +		panic("Failed to allocate memory for %s\n", timer->name);

Ditto.

> +/*
> + * The first timer instance will use as a clockevent. If there are two or
> + * more instances, the second one gets used as clocksource and all
> + * others are unused.
> +*/
> +static int num_called;

This thing, horrible as it is, wants to be at least inside the
nios2_time_init() function. It has no other scope and should go away
after init along with the function itself.

> +static void __init nios2_time_init(struct device_node *timer)

Thanks,

	tglx
