Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbaHASoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 14:44:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaHASoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 14:44:22 -0400
Date: Fri, 1 Aug 2014 20:40:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140801184059.GB10718@redhat.com>
References: <20140731215445.GA21933@linux.vnet.ibm.com> <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com> <20140801141144.GA30293@redhat.com> <20140801182837.GI4784@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801182837.GI4784@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Paul E. McKenney wrote:
>
> On Fri, Aug 01, 2014 at 04:11:44PM +0200, Oleg Nesterov wrote:
> > Not sure this makes any sense, but perhaps we can check for the new
> > callbacks and start the next gp. IOW, the main loop roughly does
> >
> > 	for (;;) {
> > 		list = rcu_tasks_cbs_head;
> > 		rcu_tasks_cbs_head = NULL;
> >
> > 		if (!list)
> > 			sleep();
> >
> > 		synchronize_sched();
> >
> > 		wait_for_rcu_tasks_holdout();
> >
> > 		synchronize_sched();
> >
> > 		process_callbacks(list);
> > 	}
> >
> > we can "join" 2 synchronize_sched's and do
> >
> > 	ready_list = NULL;
> > 	for (;;) {
> > 		list = rcu_tasks_cbs_head;
> > 		rcu_tasks_cbs_head = NULL;
> >
> > 		if (!list && !ready_list)
> > 			sleep();
> >
> > 		synchronize_sched();
> >
> > 		if (ready_list) {
> > 			process_callbacks(ready_list);
> > 			ready_list = NULL;
> > 		}
> >
> > 		if (!list)
> > 			continue;
> >
> > 		wait_for_rcu_tasks_holdout();
> > 		ready_list = list;
> > 	}
>
> The lack of barriers for the updates I am checking mean that I really
> do need a synchronize_sched() on either side of the grace-period wait.

Yes,

> The grace period needs to guarantee that anything that happened on any
> CPU before the start of the grace period happens before anything that
> happens on any CPU after the end of the grace period.  If I leave off
> either synchronize_sched(), we lose this guarantee.

But the 2nd variant still has synchronize_sched() on both sides?

Oleg.

