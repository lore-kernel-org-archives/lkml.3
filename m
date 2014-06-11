Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaFKTda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:33:30 -0400
Received: from forward4l.mail.yandex.net ([84.201.143.137]:34651 "EHLO
	forward4l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaFKTd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:33:29 -0400
X-Yandex-Uniq: 29926c94-ffc9-4ebe-9523-f7edf44dc83e
Authentication-Results: smtp9.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1402515194.10391.9.camel@localhost.localdomain>
Subject: Re: [PATCH 1/2] sched: Rework migrate_tasks()
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tkhai Kirill <ktkhai@parallels.com>
Date: Wed, 11 Jun 2014 23:33:14 +0400
In-Reply-To: <4032471402494232@web2m.yandex.ru>
References: <20140611093417.27807.2288.stgit@tkhai>
	 <1402480330.32126.14.camel@tkhai>
	 <20140611112411.GA21191@linux.vnet.ibm.com>
	 <3732251402489254@web2m.yandex.ru>
	 <20140611131536.GB21191@linux.vnet.ibm.com>
	 <4032471402494232@web2m.yandex.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Ср, 11/06/2014 в 17:43 +0400, Kirill Tkhai пишет:
> 
> 11.06.2014, 17:15, "Srikar Dronamraju" <srikar@linux.vnet.ibm.com>:
> >>>  * Kirill Tkhai <ktkhai@parallels.com> [2014-06-11 13:52:10]:
> >>>>   Currently migrate_tasks() skips throttled tasks,
> >>>>   because they are not pickable by pick_next_task().
> >>>  Before migrate_tasks() is called, we do call set_rq_offline(), in
> >>>  migration_call().
> >>>
> >>>  Shouldnt this take care of unthrottling the tasks and making sure that
> >>>  they can be picked by pick_next_task().
> >>  If we do this separate for every class, we'll have to do this 3 times.
> >>  Furthermore, deadline class does not have a list of throttled tasks.
> >>  So we'll have to the same as I did: to lock tasklist_lock and to iterate
> >>  throw all of the tasks in the system just to found deadline tasks.
> >
> > I think you misread my comment.
> >
> > Currently migrate_task() gets called from migration_call() and in the
> > migration_call() before migrate_tasks(), set_rq_offline() should put
> > tasks back using unthrottle_cfs_rq().
> >
> > So my question is: Why are these tasks not getting unthrottled
> > through we are calling set_rq_offline? To me set_rq_offline is
> > calling the actual sched class routines to do the needful.
> >
> > I can understand about deadline tasks, because we don't have a deadline
> > But thats the only tasks that we need to fix.
> 
> Hm, I tested that on fair class tasks. They used to disappear from
> /proc/sched_debug and used to hang. I'll check all once again.
> 
> I'm agree with you, if set_rq_offline() already presents, we should use it.
> 
> /me went to clarify why it does not work in my test.

Ok, it looks like the problem is that unthrottled cfs_rq may become throttled
again ;)

__migrate_task()->dequeue_task() calls update_rq_clock(), which throttles
just unthrottle cfs_rq after a first picked task is moved.

Hope, something like above helps, I'll check if there are no other problem
and write again.

---
 kernel/sched/core.c | 8 ++++++++
 1 file changed, 8 insertions(+)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d0d1565..b5fd6f0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4843,6 +4843,12 @@ static void migrate_tasks(unsigned int dead_cpu)
 	 */
 	update_rq_clock(rq);
 
+	/*
+	 * Prevent rq->clock update from __migrate_task()->dequeue_task()
+	 * to do not throttle sched_class queues and tasks.
+	 */
+	rq->skip_clock_update = 1;
+
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only
@@ -4864,6 +4870,8 @@ static void migrate_tasks(unsigned int dead_cpu)
 		raw_spin_lock(&rq->lock);
 	}
 
+	rq->skip_clock_update = 0; /* Reset it back */
+
 	rq->stop = stop;
 }
 


