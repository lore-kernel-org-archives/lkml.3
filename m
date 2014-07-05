Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbaGEKp4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:45:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58041 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbaGEKpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:45:54 -0400
Date: Sat, 5 Jul 2014 03:45:05 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-1c5d3eb3759013bc7ee4197aa0a9f245bdb6eb90@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1403538378-31571-4-git-send-email-riel@redhat.com>
References: <1403538378-31571-4-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Simplify task_numa_compare()
Git-Commit-ID: 1c5d3eb3759013bc7ee4197aa0a9f245bdb6eb90
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

Commit-ID:  1c5d3eb3759013bc7ee4197aa0a9f245bdb6eb90
Gitweb:     http://git.kernel.org/tip/1c5d3eb3759013bc7ee4197aa0a9f245bdb6eb90
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 23 Jun 2014 11:46:15 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:17:37 +0200

sched/numa: Simplify task_numa_compare()

When a task is part of a numa_group, the comparison should always use
the group weight, in order to make workloads converge.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: chegu_vinod@hp.com
Cc: mgorman@suse.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1403538378-31571-4-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d6526d2..cebb312 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1154,7 +1154,7 @@ static void task_numa_compare(struct task_numa_env *env,
 	struct task_group *tg;
 	long src_load, dst_load;
 	long load;
-	long imp = (groupimp > 0) ? groupimp : taskimp;
+	long imp = env->p->numa_group ? groupimp : taskimp;
 
 	rcu_read_lock();
 	cur = ACCESS_ONCE(dst_rq->curr);
@@ -1192,11 +1192,6 @@ static void task_numa_compare(struct task_numa_env *env,
 			 * itself (not part of a group), use the task weight
 			 * instead.
 			 */
-			if (env->p->numa_group)
-				imp = groupimp;
-			else
-				imp = taskimp;
-
 			if (cur->numa_group)
 				imp += group_weight(cur, env->src_nid) -
 				       group_weight(cur, env->dst_nid);
