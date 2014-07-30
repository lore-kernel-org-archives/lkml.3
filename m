Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbaG3SYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 14:24:49 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:33470 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbaG3SYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 14:24:47 -0400
Date: Wed, 30 Jul 2014 11:24:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 8/9] rcu: Make RCU-tasks track exiting
 tasks
Message-ID: <20140730182440.GR11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1406588180-21933-8-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140730170442.GA29577@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730170442.GA29577@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073018-0928-0000-0000-000003BC48B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 07:04:42PM +0200, Oleg Nesterov wrote:
> On 07/28, Paul E. McKenney wrote:
> >
> > This commit adds synchronization with exiting tasks, so that RCU-tasks
> > avoids waiting on tasks that no longer exist.
> 
> I don't understand this patch yet, but it seems that it adds more than
> just synchronization with exiting tasks?

There was also a bit of code reorganization to keep indentation level
down to a dull roar.

> > +		ACCESS_ONCE(t->rcu_tasks_holdout) = 1;
> > +		spin_unlock(&t->rcu_tasks_lock);
> > +		smp_mb();  /* Order ->rcu_tasks_holdout store before "if". */
> > +		if (t == current || !ACCESS_ONCE(t->on_rq) || is_idle_task(t)) {
> > +			smp_store_release(&t->rcu_tasks_holdout, 0);
> > +			goto next_thread;
> > +		}
> 
> This should avoid the race with schedule()->rcu_note_voluntary_context_switch(),
> right?
> 
> > -		rcu_read_lock();
> > -		do_each_thread(g, t) {
> > -			if (t != current && ACCESS_ONCE(t->on_rq) &&
> > -			    !is_idle_task(t)) {
> > -				t->rcu_tasks_holdout = 1;
> 
> Because before this patch the code looks obviously racy, a task can do
> sleep(FOREVER) and block rcu_tasks_kthread() if it reads ->on_rq == 1
> after rcu_note_voluntary_context_switch() was already called.
> 
> However, I am not sure this race is actually closed even after this
> change... why rcu_note_voluntary_context_switch() can not miss
> ->rcu_tasks_holdout != 0 ?

Good point, I need to add a !ACCESS_ONCE(t->on_rq) when scanning the list
of tasks blocking the grace period.  I also need to handle NO_HZ_FULL,
but that comes later.

							Thanx, Paul

> OK, it seems that you are going to send the next version anyway, so
> please ignore.
> 
> Oleg.
> 

