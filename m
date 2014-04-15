Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751019AbaDOWSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:18:04 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52765 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaDOWSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:18:01 -0400
Date: Tue, 15 Apr 2014 15:17:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: cl@linux.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tj@kernel.org,
        grygorii.strashko@ti.com, peterz@infradead.org
Subject: How do I increment a per-CPU variable without warning?
Message-ID: <20140415221755.GA27188@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041522-8236-0000-0000-0000018E7BA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph,

I have a patch that currently uses __this_cpu_inc_return() to increment a
per-CPU variable, but without preemption disabled.  Of course, given that
preemption is enabled, it might well end up picking up one CPU's counter,
adding one to it, then storing the result into some other CPU's counter.
But this is OK, the test can be probabilistic.  And when I run this
against v3.14 and earlier, it works fine.

But now there is 188a81409ff7 (percpu: add preemption checks to
__this_cpu ops), which gives me lots of splats.

My current admittedly crude workaround is as follows:

	static inline bool rcu_should_resched(void)
	{
		int t;

	#ifdef CONFIG_DEBUG_PREEMPT
		preempt_disable();
	#endif /* #ifdef CONFIG_DEBUG_PREEMPT */
		t = __this_cpu_read(rcu_cond_resched_count) + 1;
		if (t < RCU_COND_RESCHED_LIM) {
			__this_cpu_write(rcu_cond_resched_count, t);
	#ifdef CONFIG_DEBUG_PREEMPT
			preempt_enable();
	#endif /* #ifdef CONFIG_DEBUG_PREEMPT */
			return false;
		}
	#ifdef CONFIG_DEBUG_PREEMPT
		preempt_enable();
	#endif /* #ifdef CONFIG_DEBUG_PREEMPT */
		return true;
	}

This is arguably better than the original __this_cpu_read() because it
avoids overflow, but I thought I should check to see if there was some
better way to do this.

							Thanx, Paul

