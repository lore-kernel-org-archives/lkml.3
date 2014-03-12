Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaCLKSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:18:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:55386 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752350AbaCLKSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:18:35 -0400
Date: Wed, 12 Mar 2014 06:18:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH]sched/rt: Do not try to push tasks if pinned task
 switches to RT
Message-ID: <20140312061833.3a43aa64@gandalf.local.home>
In-Reply-To: <4451359470707@web16g.yandex.ru>
References: <4451359470707@web16g.yandex.ru>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

I'm going through my inbox (over a year old), and found this patch from
Kirill. It looks fine to me. You can apply it with my

  Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

[PATCH]sched/rt: Do not try to push tasks if pinned task switches to RT

Just switched pinned task is not able to be pushed. If the rq had had
several RT tasks before they have already been considered as candidates
to be pushed (or pulled).

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>
---
 kernel/sched/rt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 4e8f0f4..5aab032 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1925,9 +1925,9 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
 	 */
 	if (p->on_rq && rq->curr != p) {
 #ifdef CONFIG_SMP
-		if (rq->rt.overloaded && push_rt_task(rq) &&
+		if (p->nr_cpus_allowed > 1 && rq->rt.overloaded &&
 		    /* Don't resched if we changed runqueues */
-		    rq != task_rq(p))
+		    push_rt_task(rq) && rq != task_rq(p))
 			check_resched = 0;
 #endif /* CONFIG_SMP */
 		if (check_resched && p->prio < rq->curr->prio)
