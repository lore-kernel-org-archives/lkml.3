Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbaGYHGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:06:05 -0400
Received: from relay.parallels.com ([195.214.232.42]:54273 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaGYHGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:06:03 -0400
Message-ID: <1406271955.3526.91.camel@tkhai>
Subject: Re: [PATCH 4/5] sched/fair: Remove double_lock_balance() from
 active_load_balance_cpu_stop()
From: Kirill Tkhai <ktkhai@parallels.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Ingo Molnar" <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        <tkhai@yandex.ru>
Date: Fri, 25 Jul 2014 11:05:55 +0400
In-Reply-To: <1406246651.2970.841.camel@schen9-DESK>
References: <20140722102425.29682.24086.stgit@tkhai>
	 <1406028628.3526.22.camel@tkhai> <1406246651.2970.841.camel@schen9-DESK>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Чт, 24/07/2014 в 17:04 -0700, Tim Chen пишет:
> On Tue, 2014-07-22 at 15:30 +0400, Kirill Tkhai wrote:
> > Bad situation:
> > 
> > double_lock_balance() drops busiest_rq lock. The busiest_rq is *busiest*,
> > and a lot of tasks and context switches there. We are dropping the lock
> > and waiting for it again.
> > 
> > Let's just detach the task and once finally unlock it!
> > 
> > Warning: this admits unlocked using of can_migrate_task(), throttled_lb_pair(),
> > and task_hot(). I added comments about that.
> > 
> 
> Wonder if we should also consider removing double_lock_balance usage
> from rt.c and deadline.c? Then those two schedulers will also not
> lock both the source and destination queues at the same time
> for load balancing.

rt.c and deadline.c are similar, so we are able to discuss about one of them.

There are two places with double_lock_balance() in rt.c:

1)push_rt_task()->find_lock_lowest_rq()

We can't detach a task before we are locked lowest_rq. It's unknown whether
it will still be suitable to be attached to lowest_rq after we are locked it,
because the highest prioriry of lowest_rq may change. We have the race there.

2)pull_rt_task()

The same with here. The situation may change. We must keep both locks locked
to be sure the priorities won't change. For example, somebody may wake a high
priority task on src_rq, or somebody can pull a task there.

RT balancing is stricter than fair's..

Regards,
	Kirill

