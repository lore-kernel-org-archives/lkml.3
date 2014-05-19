Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaESNJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:09:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59323 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbaESNJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:09:02 -0400
Date: Mon, 19 May 2014 06:07:54 -0700
From: tip-bot for Ben Segall <tipbot@zytor.com>
Message-ID: <tip-763e54552ad8eebb213db1fc591724067d83d95d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, bsegall@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        mingo@redhat.com, linux-kernel@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <20140515225920.7179.13924.stgit@sword-of-the-dawn.mtv.corp.google.com>
References: <20140515225920.7179.13924.stgit@sword-of-the-dawn.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix exec_start/task_hot on migrated tasks
Git-Commit-ID: 763e54552ad8eebb213db1fc591724067d83d95d
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

Commit-ID:  763e54552ad8eebb213db1fc591724067d83d95d
Gitweb:     http://git.kernel.org/tip/763e54552ad8eebb213db1fc591724067d83d95d
Author:     Ben Segall <bsegall@google.com>
AuthorDate: Thu, 15 May 2014 15:59:20 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 22:02:39 +0900

sched: Fix exec_start/task_hot on migrated tasks

task_hot checks exec_start on any runnable task, but if it has been
migrated since the it last ran, then exec_start is a clock_task from
another cpu. If the old cpu's clock_task was sufficiently far ahead of
this cpu's then the task will not be considered for another migration
until it has run. Instead reset exec_start whenever a task is migrated,
since it is presumably no longer hot anyway.

Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Ben Segall <bsegall@google.com>
[peterz: made it compile]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140515225920.7179.13924.stgit@sword-of-the-dawn.mtv.corp.google.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
 
