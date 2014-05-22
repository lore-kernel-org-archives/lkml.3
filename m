Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbaEVM1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:27:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51228 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbaEVM10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:27:26 -0400
Date: Thu, 22 May 2014 05:26:37 -0700
From: tip-bot for Ben Segall <tipbot@zytor.com>
Message-ID: <tip-3944a9274ef6cda0cc282daf0739832f661670f7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140515225920.7179.13924.stgit@sword-of-the-dawn.mtv.corp.google.com>
References: <20140515225920.7179.13924.stgit@sword-of-the-dawn.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix exec_start/task_hot on migrated tasks
Git-Commit-ID: 3944a9274ef6cda0cc282daf0739832f661670f7
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

Commit-ID:  3944a9274ef6cda0cc282daf0739832f661670f7
Gitweb:     http://git.kernel.org/tip/3944a9274ef6cda0cc282daf0739832f661670f7
Author:     Ben Segall <bsegall@google.com>
AuthorDate: Thu, 15 May 2014 15:59:20 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 22 May 2014 11:16:25 +0200

sched: Fix exec_start/task_hot on migrated tasks

task_hot checks exec_start on any runnable task, but if it has been
migrated since the it last ran, then exec_start is a clock_task from
another cpu. If the old cpu's clock_task was sufficiently far ahead of
this cpu's then the task will not be considered for another migration
until it has run. Instead reset exec_start whenever a task is migrated,
since it is presumably no longer hot anyway.

Signed-off-by: Ben Segall <bsegall@google.com>
[ Made it compile. ]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140515225920.7179.13924.stgit@sword-of-the-dawn.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 28ccf50..dd3fa14 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4544,6 +4544,9 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 		atomic_long_add(se->avg.load_avg_contrib,
 						&cfs_rq->removed_load);
 	}
+
+	/* We have migrated, no longer consider this task hot */
+	se->exec_start = 0;
 }
 #endif /* CONFIG_SMP */
 
