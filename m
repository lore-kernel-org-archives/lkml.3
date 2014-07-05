Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbaGETBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 15:01:19 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55454 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752824AbaGETBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 15:01:18 -0400
Date: Sat, 5 Jul 2014 20:01:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: pawandeep oza <oza.contri.linux.kernel@gmail.com>
Cc: akpm@linux-foundation.org, holt@sgi.com, mingo@kernel.org,
        sboyd@codeaurora.org, k.khlebnikov@samsung.com,
        u.kleine-koenig@pengutronix.de,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.or, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] machine_power_off: not only local_irq_disable but also
	do disable preemption
Message-ID: <20140705190105.GR21766@n2100.arm.linux.org.uk>
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
> Hi,
> 
> I am referring to this version of spin lock apis.
> 
> static inline void __raw_spin_lock(raw_spinlock_t *lock)
> {
> preempt_disable();
> spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
> LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
> }
> 
> 
> static inline void __raw_spin_unlock(raw_spinlock_t *lock)
> {
> spin_release(&lock->dep_map, 1, _RET_IP_);
> do_raw_spin_unlock(lock);
> preempt_enable();
> }
> 
> poweroff path runs with irqs disabled, but what is some one (valid
> scenerio) try to have spin_lock and spin_unlock for its own reasons.
> 
> spin_unlock doesn preempt_enable at the end...
> which in turn does following.
> 
> #define preempt_enable() \
> do { \
> preempt_enable_no_resched(); \
> barrier(); \
> preempt_check_resched(); \
> } while (0)
> 
> 
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

This seems to be a generic code bug - if interrupts are disabled (they
are) then we should not schedule at all.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
