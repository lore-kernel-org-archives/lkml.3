Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab3FXMyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:54:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:48916 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3FXMyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:54:44 -0400
Date: Mon, 24 Jun 2013 14:54:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kirill Tkhai <tkhai@yandex.ru>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] sched: Add schedule_(raw_)spin_unlock and
 schedule_(raw_)spin_unlock_irq
In-Reply-To: <1981131371569812@web20h.yandex.ru>
Message-ID: <alpine.DEB.2.02.1306241441440.4013@ionos.tec.linutronix.de>
References: <1981131371569812@web20h.yandex.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013, Kirill Tkhai wrote:
> +/*
> + * schedule_raw_spin_unlock() -- should be used instead of pattern:
> + *
> + *     raw_spin_unlock(lock);
> + *     schedule();
> + *
> + * It's the same, but prevents preempt_schedule() call during the unlocking.
> + */
> +static inline void schedule_raw_spin_unlock(raw_spinlock_t *lock)

This should be raw_spin_unlock_and_schedule().

schedule_raw_spin_unlock() sounds like we schedule a raw_spin_unlock()
for some point in the future.

> +{
> +	_raw_spin_unlock_no_resched(lock);

No, please do not expose such an interface. Instead of that implement
it as:

raw_spin_unlock_and_schedule()
{
	spin_release(&lock->dep_map, 1, _RET_IP_);
	do_raw_spin_unlock(lock);
	preempt_enable_no_resched();
	schedule();  
}

And this goes into the spinlock header and not into sched.h.

Thanks,

	tglx
