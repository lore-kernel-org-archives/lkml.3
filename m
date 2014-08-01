Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaHACJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 22:09:37 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:39568 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaHACJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 22:09:36 -0400
Date: Thu, 31 Jul 2014 19:09:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 01/10] rcu: Add call_rcu_tasks()
Message-ID: <20140801020928.GJ11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53D9F084.7000706@cn.fujitsu.com>
 <20140731160924.GR11241@linux.vnet.ibm.com>
 <53DAE512.5030302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DAE512.5030302@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080102-9332-0000-0000-0000018FFFBB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 08:53:38AM +0800, Lai Jiangshan wrote:
> On 08/01/2014 12:09 AM, Paul E. McKenney wrote:
> 
> > 
> >>> +		/*
> >>> +		 * There were callbacks, so we need to wait for an
> >>> +		 * RCU-tasks grace period.  Start off by scanning
> >>> +		 * the task list for tasks that are not already
> >>> +		 * voluntarily blocked.  Mark these tasks and make
> >>> +		 * a list of them in rcu_tasks_holdouts.
> >>> +		 */
> >>> +		rcu_read_lock();
> >>> +		for_each_process_thread(g, t) {
> >>> +			if (t != current && ACCESS_ONCE(t->on_rq) &&
> >>> +			    !is_idle_task(t)) {
> >>
> >> What happen when the trampoline is on the idle task?
> >>
> >> I think we need to use schedule_on_each_cpu() to replace one of
> >> the synchronize_sched() in this function. (or other stuff which can
> >> cause real schedule for *ALL* online CPUs).
> > 
> > Well, that is one of the questions in the 0/10 cover letter.  If it turns
> > out to be necessary to worry about idle-task trampolines, it should be
> > possible to avoid hammering all idle CPUs in the common case.  Though maybe
> > battery-powered devices won't need RCU-tasks.
> 
> trampolines on NO_HZ idle CPU can be arbitrary long, (example, SMI happens
> inside the trampoline).  So only the real schedule on idle CPU is reliable
> to me.

You might well be right, but first let's see if Steven needs this to
work in the idle task to begin with.  If he doesn't, then there is no
point in worrying about it.  If he does, I bet I can come up with a
trick or two.  ;-)

							Thanx, Paul

