Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313AbaGOKAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:00:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:46944 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530AbaGOKAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:00:07 -0400
Date: Tue, 15 Jul 2014 12:00:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ley Foon Tan <lftan@altera.com>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH v2 19/29] nios2: Time keeping
In-Reply-To: <1405413956-2772-20-git-send-email-lftan@altera.com>
Message-ID: <alpine.DEB.2.10.1407151152310.24854@nanos>
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <1405413956-2772-20-git-send-email-lftan@altera.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Ley Foon Tan wrote:
> --- /dev/null
> +++ b/arch/nios2/kernel/time.c
> @@ -0,0 +1,150 @@
> +/*
> + * Copyright (C) 2013 Altera Corporation
> + * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
> + * Copyright (C) 2004 Microtronix Datacom Ltd.
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License. See the file "COPYING" in the main directory of this archive
> + * for more details.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/sched.h>
> +#include <linux/interrupt.h>
> +#include <linux/time.h>
> +#include <linux/timex.h>
> +#include <linux/profile.h>
> +#include <linux/clocksource.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/io.h>
> +
> +#define	TICK_SIZE		(tick_nsec / 1000)
> +#define NIOS2_TIMER_PERIOD	(timer_freq / HZ)
> +
> +#define ALTERA_TIMER_STATUS_REG		0
> +#define ALTERA_TIMER_CONTROL_REG	4
> +#define ALTERA_TIMER_PERIODL_REG	8
> +#define ALTERA_TIMER_PERIODH_REG	12
> +#define ALTERA_TIMER_SNAPL_REG		16
> +#define ALTERA_TIMER_SNAPH_REG		20
> +
> +#define ALTERA_TIMER_CONTROL_ITO_MSK	(0x1)
> +#define ALTERA_TIMER_CONTROL_CONT_MSK	(0x2)
> +#define ALTERA_TIMER_CONTROL_START_MSK	(0x4)
> +#define ALTERA_TIMER_CONTROL_STOP_MSK	(0x8)
> +
> +static u32 nios2_timer_count;
> +static void __iomem *timer_membase;
> +static u32 timer_freq;
> +
> +static inline unsigned long read_timersnapshot(void)
> +{
> +	unsigned long count;
> +
> +	writew(0, timer_membase + ALTERA_TIMER_SNAPL_REG);
> +	count =
> +		readw(timer_membase + ALTERA_TIMER_SNAPH_REG) << 16 |
> +		readw(timer_membase + ALTERA_TIMER_SNAPL_REG);

So you're serious about having a new architecture with a timer
implementation which cant read 32bit in one go? I'm impressed ...

> +	return count;
> +}
> +
> +static inline void write_timerperiod(unsigned long period)
> +{
> +	writew(period, timer_membase + ALTERA_TIMER_PERIODL_REG);
> +	writew(period >> 16, timer_membase + ALTERA_TIMER_PERIODH_REG);
> +}
> +
> +/*
> + * timer_interrupt() needs to keep up the real-time clock,
> + * as well as call the "xtime_update()" routine every clocktick
> + */
> +irqreturn_t timer_interrupt(int irq, void *dummy)
> +{
> +	/* Clear the interrupt condition */
> +	writew(0, timer_membase + ALTERA_TIMER_STATUS_REG);
> +	nios2_timer_count += NIOS2_TIMER_PERIOD;
> +
> +	profile_tick(CPU_PROFILING);
> +
> +	xtime_update(1);
> +
> +	update_process_times(user_mode(get_irq_regs()));
> +
> +	return IRQ_HANDLED;

Please use the clock events infrastructure. New users of the old style
timer management are not welcome.

> +}
> +
> +static cycle_t nios2_timer_read(struct clocksource *cs)
> +{
> +	unsigned long flags;
> +	u32 cycles;
> +	u32 tcn;
> +
> +	local_irq_save(flags);
> +	tcn = NIOS2_TIMER_PERIOD - 1 - read_timersnapshot();
> +	cycles = nios2_timer_count;

This is wrong and completely pointless. The core code takes care about
the offset.

> +	local_irq_restore(flags);
> +
> +	return cycles + tcn;
> +}

Thanks,

	tglx
