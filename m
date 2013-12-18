Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3LRMM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 07:12:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45153 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab3LRMM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 07:12:26 -0500
Date: Wed, 18 Dec 2013 13:12:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 05/13] rcu: Fix unraised IPI to timekeeping CPU
Message-ID: <20131218121204.GS13532@twins.programming.kicks-ass.net>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-6-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387320692-28460-6-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 11:51:24PM +0100, Frederic Weisbecker wrote:
> -			rcu_kick_nohz_cpu(tick_do_timer_cpu);
> +			smp_send_reschedule(tick_do_timer_cpu);

Hurm.. so I don't really like this (same for the other patches doing the
similar change).

Why not have a function called: wake_time_keeper_cpu(), and have that do
the right thing?

Also, afaict, all you want is that remote cpu to run
tick_nohz_full_check(), right?

So why are you (ab)using the scheduler_ipi for this at all? Why not have
something like:

static DEFINE_PER_CPU(struct call_single_data, nohz_full_csd);

int init_nohz_full(void)
{
	int cpu;

	for_each_possible_cpu(cpu) {
		struct call_single_data *csd = &per_cpu(nohz_full_csd, cpu);

		csd->flags = 0;
		csd->func = &tick_nohz_full_check;
		csd->info = NULL;
	}

	return 0;
}

void wake_time_keeper_cpu(void)
{
	int cpu = pick_timekeeper_cpu();
	struct single_call_data *csd = &per_cpu(nohz_full_csd, cpu);

	__smp_call_function_single(cpu, csd, 0);
}
