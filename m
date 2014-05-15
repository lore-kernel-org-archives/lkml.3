Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbaEOW7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 18:59:22 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:54070 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaEOW7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 18:59:21 -0400
Subject: [PATCH] sched: fix exec_start/task_hot on migrated tasks
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
From: Ben Segall <bsegall@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 15 May 2014 15:59:20 -0700
Message-ID: <20140515225920.7179.13924.stgit@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_hot checks exec_start on any runnable task, but if it has been
migrated since the it last ran, then exec_start is a clock_task from
another cpu. If the old cpu's clock_task was sufficiently far ahead of
this cpu's then the task will not be considered for another migration
until it has run. Instead reset exec_start whenever a task is migrated,
since it is presumably no longer hot anyway.

Signed-off-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/fair.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 28ccf50..9f8dfeb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4544,6 +4544,9 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 		atomic_long_add(se->avg.load_avg_contrib,
 						&cfs_rq->removed_load);
 	}
+
+	/* We have migrated, no longer consider this task hot */
+	se.exec_start = 0;
 }
 #endif /* CONFIG_SMP */
 

