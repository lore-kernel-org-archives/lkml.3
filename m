Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbaGEKql (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:46:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58068 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965344AbaGEKqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:46:24 -0400
Date: Sat, 5 Jul 2014 03:45:31 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-db015daedb56251b73f956f70b3b8813f80d8ee1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1403538095-31256-7-git-send-email-riel@redhat.com>
References: <1403538095-31256-7-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Rework best node setting in task_numa_migrate()
Git-Commit-ID: db015daedb56251b73f956f70b3b8813f80d8ee1
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

Commit-ID:  db015daedb56251b73f956f70b3b8813f80d8ee1
Gitweb:     http://git.kernel.org/tip/db015daedb56251b73f956f70b3b8813f80d8ee1
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 23 Jun 2014 11:41:34 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:17:39 +0200

sched/numa: Rework best node setting in task_numa_migrate()

Fix up the best node setting in task_numa_migrate() to deal with a task
in a pseudo-interleaved NUMA group, which is already running in the
best location.

Set the task's preferred nid to the current nid, so task migration is
not retried at a high rate.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: mgorman@suse.de
Cc: chegu_vinod@hp.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1403538095-31256-7-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9d1734a..7bb2f46 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1354,10 +1354,6 @@ static int task_numa_migrate(struct task_struct *p)
 		}
 	}
 
-	/* No better CPU than the current one was found. */
-	if (env.best_cpu == -1)
-		return -EAGAIN;
-
 	/*
 	 * If the task is part of a workload that spans multiple NUMA nodes,
 	 * and is migrating into one of the workload's active nodes, remember
@@ -1366,8 +1362,19 @@ static int task_numa_migrate(struct task_struct *p)
 	 * A task that migrated to a second choice node will be better off
 	 * trying for a better one later. Do not set the preferred node here.
 	 */
-	if (p->numa_group && node_isset(env.dst_nid, p->numa_group->active_nodes))
-		sched_setnuma(p, env.dst_nid);
+	if (p->numa_group) {
+		if (env.best_cpu == -1)
+			nid = env.src_nid;
+		else
+			nid = env.dst_nid;
+
+		if (node_isset(nid, p->numa_group->active_nodes))
+			sched_setnuma(p, env.dst_nid);
+	}
+
+	/* No better CPU than the current one was found. */
+	if (env.best_cpu == -1)
+		return -EAGAIN;
 
 	/*
 	 * Reset the scan period if the task is being rescheduled on an
