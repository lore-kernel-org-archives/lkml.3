Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477AbaHGPoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:44:07 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51104 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbaHGPoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:44:05 -0400
Date: Thu, 7 Aug 2014 08:43:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140807154358.GC5821@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53DEE1CD.4000705@cn.fujitsu.com>
 <20140804074620.GH9918@twins.programming.kicks-ass.net>
 <53DF41ED.2020508@cn.fujitsu.com>
 <20140804115043.GA31903@linux.vnet.ibm.com>
 <20140804122515.GR19379@twins.programming.kicks-ass.net>
 <20140804145648.GE3588@twins.programming.kicks-ass.net>
 <53E029BB.2010200@cn.fujitsu.com>
 <20140805215510.GT8101@linux.vnet.ibm.com>
 <20140807084921.GK19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807084921.GK19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080715-9332-0000-0000-0000019F7AB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 10:49:21AM +0200, Peter Zijlstra wrote:
> On Tue, Aug 05, 2014 at 02:55:10PM -0700, Paul E. McKenney wrote:
> > +/* Check for nohz_full CPUs executing in userspace. */
> > +static void check_no_hz_full_tasks(void)
> > +{
> > +#ifdef CONFIG_NO_HZ_FULL
> > +	int cpu;
> > +	struct task_struct *t;
> > +
> > +	for_each_online_cpu(cpu) {
> > +		cond_resched();
> > +		rcu_read_lock();
> > +		t = rcu_dynticks_task_cur(cpu);
> > +		if (t == NULL || is_idle_task(t)) {
> > +			rcu_read_unlock();
> > +			continue;
> > +		}
> > +		if (ACCESS_ONCE(t->rcu_tasks_holdout))
> > +			ACCESS_ONCE(t->rcu_tasks_holdout) = 0;
> > +		rcu_read_unlock();
> > +	}
> > +#endif /* #ifdef CONFIG_NO_HZ_FULL */
> > +}
> 
> That's not hotplug safe afaict, and I've no idea if someone pointed that
> out already because people refuse to trim email and I can't be arsed to
> wade through pages and pages of quoting.

Hmmm...  That does look a bit suspicious, now that you mention it.
After all, if a CPU is offline, its idle tasks cannot be on a
trampoline.

							Thanx, Paul

