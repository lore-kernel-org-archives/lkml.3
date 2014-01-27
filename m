Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbaA0KyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:54:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51809 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaA0KyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:54:15 -0500
Date: Mon, 27 Jan 2014 11:54:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>,
        trinity@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_rr_get_interval NULL pointer OOPS
Message-ID: <20140127105413.GC11314@laptop.programming.kicks-ass.net>
References: <CA+ydwtpvqv7pHFiQsPX+DeRyjKVvxvS2SKxXEttdT=PQr6qqFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ydwtpvqv7pHFiQsPX+DeRyjKVvxvS2SKxXEttdT=PQr6qqFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 10:55:56PM +0200, Tommi Rantala wrote:
> Hello,
> 
> Trinity triggered the following bug in two separate qemu virtual
> machines after fuzzing v3.13-3995-g0dc3fd0 for a day or two. I have
> not been running Trinity in a while, so no idea if this is a
> regression or not.
> 
> If I'm reading this right, it's oopsing in kernel/sched/core.c:
> 
> SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
>     struct timespec __user *, interval)
> {
> ...
>     rq = task_rq_lock(p, &flags);
>     time_slice = p->sched_class->get_rr_interval(rq, p);   <==
>     task_rq_unlock(rq, p, &flags);
> ...


---
Subject: sched: make sched_class::get_rr_interval optional

Not all classes implement (or can implement) a useful get_rr_interval()
function, default to a 0 time-slice for them.

Reported-by: Tommi Rantala <tt.rantala@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
Index: linux-2.6/kernel/sched/core.c
===================================================================
--- linux-2.6.orig/kernel/sched/core.c
+++ linux-2.6/kernel/sched/core.c
@@ -4324,7 +4324,9 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
 		goto out_unlock;
 
 	rq = task_rq_lock(p, &flags);
-	time_slice = p->sched_class->get_rr_interval(rq, p);
+	time_slice = 0;
+	if (p->sched_class->get_rr_interval)
+		time_slice = p->sched_class->get_rr_interval(rq, p);
 	task_rq_unlock(rq, p, &flags);
 
 	rcu_read_unlock();
