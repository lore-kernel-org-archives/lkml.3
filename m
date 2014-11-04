Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbaKDQL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:11:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59515 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbaKDQLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:11:53 -0500
Date: Tue, 4 Nov 2014 08:10:51 -0800
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-308a623a40ce168eb234ea82c2bd13ff85a098d9@git.kernel.org>
Cc: ktkhai@parallels.com, juri.lelli@arm.com, tglx@linutronix.de,
        rostedt@goodmis.org, mingo@kernel.org, wanpeng.li@linux.intel.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hpa@zytor.com
Reply-To: hpa@zytor.com, peterz@infradead.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, wanpeng.li@linux.intel.com,
        mingo@kernel.org, rostedt@goodmis.org, juri.lelli@arm.com,
        tglx@linutronix.de, ktkhai@parallels.com
In-Reply-To: <1414708776-124078-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1414708776-124078-1-git-send-email-wanpeng.li@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Clean up check_preempt_equal_prio()
Git-Commit-ID: 308a623a40ce168eb234ea82c2bd13ff85a098d9
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

Commit-ID:  308a623a40ce168eb234ea82c2bd13ff85a098d9
Gitweb:     http://git.kernel.org/tip/308a623a40ce168eb234ea82c2bd13ff85a098d9
Author:     Wanpeng Li <wanpeng.li@linux.intel.com>
AuthorDate: Fri, 31 Oct 2014 06:39:31 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Nov 2014 07:17:52 +0100

sched/rt: Clean up check_preempt_equal_prio()

This patch checks if current can be pushed/pulled somewhere else
in advance to make logic clear, the same behavior as dl class.

- If current can't be migrated, useless to reschedule, let's hope
  task can move out.
- If task is migratable, so let's not schedule it and see if it
  can be pushed or pulled somewhere else.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1414708776-124078-1-git-send-email-wanpeng.li@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index d024e6c..3d14312 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1351,16 +1351,22 @@ out:
 
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 {
-	if (rq->curr->nr_cpus_allowed == 1)
+	/*
+	 * Current can't be migrated, useless to reschedule,
+	 * let's hope p can move out.
+	 */
+	if (rq->curr->nr_cpus_allowed == 1 ||
+	    !cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
 		return;
 
+	/*
+	 * p is migratable, so let's not schedule it and
+	 * see if it is pushed or pulled somewhere else.
+	 */
 	if (p->nr_cpus_allowed != 1
 	    && cpupri_find(&rq->rd->cpupri, p, NULL))
 		return;
 
-	if (!cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
-		return;
-
 	/*
 	 * There appears to be other cpus that can accept
 	 * current and none to run 'p', so lets reschedule
