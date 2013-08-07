Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab3HGMwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 08:52:18 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:58350 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890Ab3HGMwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 08:52:16 -0400
Date: Wed, 7 Aug 2013 05:38:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        C.Emde@osadl.org
Subject: Re: [PATCH 0/8] rcu: Ensure rcu read site is deadlock-immunity
Message-ID: <20130807123827.GB4306@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080712-7408-0000-0000-000012BF03AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 06:24:56PM +0800, Lai Jiangshan wrote:
> Although all articles declare that rcu read site is deadlock-immunity.
> It is not true for rcu-preempt, it will be deadlock if rcu read site
> overlaps with scheduler lock.

The real rule is that if the scheduler does its outermost rcu_read_unlock()
with one of those locks held, it has to have avoided enabling preemption
through the entire RCU read-side critical section.

That said, avoiding the need for this rule would be a good thing.

How did you test this?  The rcutorture tests will not exercise this.
(Intentionally so, given that it can deadlock!)

> ec433f0c, 10f39bb1 and 016a8d5b just partially solve it. But rcu read site
> is still not deadlock-immunity. And the problem described in 016a8d5b
> is still existed(rcu_read_unlock_special() calls wake_up).
> 
> The problem is fixed in patch5.

This is going to require some serious review and testing.  One requirement
is that RCU priority boosting not persist significantly beyond the
re-enabling of interrupts associated with the irq-disabled lock.  To do
otherwise breaks RCU priority boosting.  At first glance, the added
set_need_resched() might handle this, but that is part of the review
and testing required.

Steven, would you and Carsten be willing to try this and see if it
helps with the issues you are seeing in -rt?  (My guess is "no", since
a deadlock would block forever rather than waking up after a couple
thousand seconds, but worth a try.)

							Thanx, Paul

> Lai Jiangshan (8):
>   rcu: add a warn to rcu_preempt_note_context_switch()
>   rcu: rcu_read_unlock_special() can be nested in irq/softirq 10f39bb1
>   rcu: keep irqs disabled in rcu_read_unlock_special()
>   rcu: delay task rcu state cleanup in exit_rcu()
>   rcu: eliminate rcu read site deadlock
>   rcu: call rcu_read_unlock_special() in rcu_preempt_check_callbacks()
>   rcu: add # of deferred _special() statistics
>   rcu: remove irq work for rsp_wakeup()
> 
>  include/linux/rcupdate.h |    2 +-
>  kernel/rcupdate.c        |    2 +-
>  kernel/rcutree.c         |   17 +--------
>  kernel/rcutree.h         |    2 +-
>  kernel/rcutree_plugin.h  |   82 ++++++++++++++++++++++++++++++++++-----------
>  kernel/rcutree_trace.c   |    1 +
>  6 files changed, 68 insertions(+), 38 deletions(-)
> 
> -- 
> 1.7.4.4
> 

