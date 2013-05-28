Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934046Ab3E1NMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:12:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50249 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933986Ab3E1NMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:12:38 -0400
Date: Tue, 28 May 2013 06:11:51 -0700
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-1a55af2e45cce0ff13bc33c8ee99da84e188b615@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, pjt@google.com,
        zhong@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, efault@gmx.de, peterz@infradead.org,
        zhong@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1365724262-20142-5-git-send-email-fweisbec@gmail.com>
References: <1365724262-20142-5-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Update rq clock earlier in unthrottle_cfs_rq
Git-Commit-ID: 1a55af2e45cce0ff13bc33c8ee99da84e188b615
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

Commit-ID:  1a55af2e45cce0ff13bc33c8ee99da84e188b615
Gitweb:     http://git.kernel.org/tip/1a55af2e45cce0ff13bc33c8ee99da84e188b615
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 12 Apr 2013 01:51:01 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:40:25 +0200

sched: Update rq clock earlier in unthrottle_cfs_rq

In this function we are making use of rq->clock right before the
update of the rq clock, let's just call update_rq_clock() just
before that to avoid using a stale rq clock value.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Turner <pjt@google.com>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1365724262-20142-5-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f76ca21..1c8762a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2319,12 +2319,14 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
 	cfs_rq->throttled = 0;
+
+	update_rq_clock(rq);
+
 	raw_spin_lock(&cfs_b->lock);
 	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_clock;
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
 
-	update_rq_clock(rq);
 	/* update hierarchical throttle state */
 	walk_tg_tree_from(cfs_rq->tg, tg_nop, tg_unthrottle_up, (void *)rq);
 
