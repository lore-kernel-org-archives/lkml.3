Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbaGETZu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 15:25:50 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55476 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754882AbaGETZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 15:25:49 -0400
Date: Sat, 5 Jul 2014 20:25:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: pawandeep oza <oza.contri.linux.kernel@gmail.com>
Cc: akpm@linux-foundation.org, holt@sgi.com, mingo@kernel.org,
        sboyd@codeaurora.org, k.khlebnikov@samsung.com,
        u.kleine-koenig@pengutronix.de,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.or, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] machine_power_off: not only local_irq_disable but also
	do disable preemption
Message-ID: <20140705192533.GS21766@n2100.arm.linux.org.uk>
References: <CAA-nRyoO_NmrD8aRa3OyVXz4b133Fxi0=biGXTzSPDuSuNJJxQ@mail.gmail.com> <20140705181015.GQ21766@n2100.arm.linux.org.uk> <CAA-nRyp5pPC2qZs7RhAXJdXaK_k4fKNZuq=yRTSTPLQsgPxqxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA-nRyp5pPC2qZs7RhAXJdXaK_k4fKNZuq=yRTSTPLQsgPxqxQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2014 at 12:20:03AM +0530, pawandeep oza wrote:
> preempt_check_resched would check TIF_NEED_RESCHED
> #define preempt_check_resched() \
> do { \
> if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
> preempt_schedule(); \
> } while (0)
> 
> there is a chance that just beofre we disabled irqs, somebody would have
> marked the flag to current, and
> later on, it might happen that, current gets replaced by the process which
> tries to hold a spin_lock which has already been previosuly held by CPU1
> when
> was being plugged out by smp_send_stop.

And preempt_schedule() contains:

        /*
         * If there is a non-zero preempt_count or interrupts are disabled,
         * we do not want to preempt the current task. Just return..
         */
        if (likely(!preemptible()))
                return;

where preemptible() is defined as:

	(preempt_count() == 0 && !irqs_disabled())

which means... if interrupts are disabled (as they are) we don't
return from preempt_schedule() without doing anything.

Scheduling with interrupts disabled is a bug.  If you need to add
preempt_disable() before local_irq_disable() to prevent it, then
there's a bug somewhere else, and we don't "fix" that by adding
preempt_disable().  The real bug needs to be found and fixed.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
