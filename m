Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaDRNHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:07:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38774 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaDRNHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:07:31 -0400
Date: Fri, 18 Apr 2014 06:06:34 -0700
From: tip-bot for Kirill V Tkhai <tipbot@zytor.com>
Message-ID: <tip-10447917551e0fffb8d1892d46e633c3e0a9c1ec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
In-Reply-To: <20140312061833.3a43aa64@gandalf.local.home>
References: <20140312061833.3a43aa64@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt:
  Do not try to push tasks if pinned task switches to RT
Git-Commit-ID: 10447917551e0fffb8d1892d46e633c3e0a9c1ec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10447917551e0fffb8d1892d46e633c3e0a9c1ec
Gitweb:     http://git.kernel.org/tip/10447917551e0fffb8d1892d46e633c3e0a9c1ec
Author:     Kirill V Tkhai <tkhai@yandex.ru>
AuthorDate: Wed, 12 Mar 2014 06:18:33 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 12:07:23 +0200

sched/rt: Do not try to push tasks if pinned task switches to RT

Just switched pinned task is not able to be pushed. If the rq had had
several RT tasks before they have already been considered as candidates
to be pushed (or pulled).

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140312061833.3a43aa64@gandalf.local.home
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index bd2267a..1e4992e 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1892,9 +1892,9 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
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
