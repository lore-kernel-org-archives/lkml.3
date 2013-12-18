Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab3LRRK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:10:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52887 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3LRRK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:10:56 -0500
Date: Wed, 18 Dec 2013 18:10:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 05/13] rcu: Fix unraised IPI to timekeeping CPU
Message-ID: <20131218171036.GW21999@twins.programming.kicks-ass.net>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-6-git-send-email-fweisbec@gmail.com>
 <20131218121204.GS13532@twins.programming.kicks-ass.net>
 <20131218153857.GF18464@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218153857.GF18464@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 04:38:59PM +0100, Frederic Weisbecker wrote:
> BTW this warning in __smp_call_function_single() looks wrong:
> 
>     WARN_ON_ONCE(cpu_online(smp_processor_id()) && wait && irqs_disabled()
>     	      && !oops_in_progress)
> 
> I think we want to warn on irqs_disabled() even if !wait, because we wait for csd lock
> anyway before raising the IPI.
> 
> Anyway so what I need is an IPI that can be raised with irqs disabled. And abusing the
> scheduler IPI with ugliness after the other is obsviously not what we want.

Ah indeed, so you can actually make it work but its a little more
involved.

struct foo {
	struct call_single_data csd;
	unsigned int msg;
};

static DEFINE_PER_CPU_ALIGNED(struct foo, foo_csd);

/*
 * set @bit in @msg, return true if its the first bit set
 */
static bool foo_set_msg(unsigned int *msg, int bit)
{
	unsigned int old_msg, new_msg;

	for (;;) {
		old_msg = new_msg = *msg;
		new_msg |= 1U << bit;
		if (cmpxchg(msg, old_msg, new_msg) == old_msg)
			break;
	}

	return old_msg == 0;
}

/*
 * clear @bit in @msg, return true if its the last bit cleared
 */
static bool foo_clear_msg(unsigned int *msg, int bit)
{
	unsigned int old_msg, new_msg;

	for (;;) {
		old_msg = new_msg = *msg;
		new_msg &= ~(1U << bit);
		if (cmpxchg(msg, old_msg, new_msg) == old_msg)
			break;
	}

	return new_msg == 0;
}

/*
 * handle @bit msg
 */
static void foo_handle_msg(int bit)
{
	switch (bit) {
	case 0:
		/* .... */
		break;

		/* ... */
	}
}

static void foo_call(void *info)
{
	struct foo *foo_csd = info;
	int bit;

	for (;;) {
		for (bit = 0; bit < 32; bit++) {
			if (ACCESS_ONCE(foo_csd->msg) & (1U << bit)) {
				foo_handle_msg(bit);
				if (foo_clear_msg(bit))
					return;
			}
		}
	}
}

int foo_init(void)
{
	int cpu;

	for_each_possible_cpu(cpu) {
		struct foo *foo_csd = &per_cpu(foo_csd, cpu);

		foo_csd->csd.flags = 0;
		foo_csd->csd.func = foo_call;
		foo_csd->csd.info = foo_csd;
		foo_csd->msg = 0;
	}

	return 0;
}

void foo_msg(int cpu, int bit)
{
	struct foo *foo_csd = &per_cpu(foo_csd, cpu);

	/*
	 * Only send the IPI if this is the first msg bit set;
	 * otherwise the handler is already pending/running and
	 * will pick it up.
	 *
	 * This will not deadlock on csd_lock because the atomic
	 * msg manipulation ensures there's only ever one csd per cpu
	 * active.
	 */
	if (foo_set_msg(&foo_csd->msg, bit))
		__smp_call_function_single(cpu, &foo_csd->csd, 0);
}
