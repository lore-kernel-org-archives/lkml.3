Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaAUVvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:51:21 -0500
Received: from mail-yk0-f175.google.com ([209.85.160.175]:41759 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaAUVvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:51:15 -0500
From: bsegall@google.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, daniel.lezcano@linaro.org,
        pjt@google.com
Subject: Re: [PATCH 8/9] sched/fair: Optimize cgroup pick_next_task_fair
References: <20140121111754.580142558@infradead.org>
	<20140121112258.708117448@infradead.org>
	<xm2661pdkuiw.fsf@sword-of-the-dawn.mtv.corp.google.com>
	<20140121193759.GR11314@laptop.programming.kicks-ass.net>
	<xm261u01kspx.fsf@sword-of-the-dawn.mtv.corp.google.com>
	<20140121204312.GS11314@laptop.programming.kicks-ass.net>
Date: Tue, 21 Jan 2014 13:43:32 -0800
In-Reply-To: <20140121204312.GS11314@laptop.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Tue, 21 Jan 2014 21:43:12 +0100")
Message-ID: <xm26wqhtj9iz.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Tue, Jan 21, 2014 at 12:03:38PM -0800, bsegall@google.com wrote:
>
>> > Indeed, in that case we can miss something... we could try to call
>> > check_cfs_rq_runtime() from the initial top-down selection loop? When
>> > true, just put the entire stack and don't pretend to be smart?
>> 
>> Yeah, I think that should work. I wasn't sure if there could be a
>> problem of doing throttle_cfs_rq(parent); throttle_cfs_rq(child);, but
>> thinking about, that has to be ok, because schedule can do that if
>> deactivate throttled the parent, schedule calls update_rq_clock, and
>> then put_prev throttled the child.
>
> Maybe something like the below? Completely untested and everything.
>
> There's the obviuos XXX fail that was also in the previous version; not
> sure how to deal with that yet, either we need to change the interface
> to take struct task_struct **prev, or get smarter :-)
>
> Any other obvious fails in here?

prev can be NULL to start with, hrtick should be handled in both paths.
How about this on top of your patch (equally untested) to fix those and
the XXX? The double-check on nr_running is annoying, but necessary when
prev slept.

---
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4528,14 +4528,8 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev)
        if (!cfs_rq->nr_running)
                return NULL;
 
-       if (!IS_ENABLED(CONFIG_FAIR_GROUP_SCHED) ||
-           (prev->sched_class != &fair_sched_class)) {
-               prev->sched_class->put_prev_task(rq, prev);
-               prev = NULL;
-       }
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
-       if (!prev)
+       if (!prev || prev->sched_class != &fair_sched_class)
                goto simple;
 
        do {
@@ -4552,10 +4546,8 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev)
                else
                        curr = NULL;
 
-               if (unlikely(check_cfs_rq_runtime(cfs_rq))) {
-                       put_prev_task_fair(rq, prev);
+               if (unlikely(check_cfs_rq_runtime(cfs_rq)))
                        goto simple;
-               }
 
                se = pick_next_entity(cfs_rq, curr);
                cfs_rq = group_cfs_rq(se);
@@ -4589,15 +4581,19 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev)
                set_next_entity(cfs_rq, se);
        }
 
+       if (hrtick_enabled(rq))
+               hrtick_start_fair(rq, p);
+
        return p;
 simple:
 #endif
        cfs_rq = &rq->cfs;
 
-       if (!cfs_rq->nr_running) {
-               // XXX FAIL we should never return NULL after putting @prev
+       if (!cfs_rq->nr_running)
                return NULL;
-       }
+
+       if (prev)
+               prev->sched_class->put_prev_task(rq, prev);
 
        do {
                se = pick_next_entity(cfs_rq, NULL);
