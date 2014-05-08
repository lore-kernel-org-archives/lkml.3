Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaEHKnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:43:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33189 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaEHKnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:43:51 -0400
Date: Thu, 8 May 2014 03:42:53 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-5085e2a328849bdee6650b32d52c87c3788ab01c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        chegu_vinod@hp.com, mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        chegu_vinod@hp.com, mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <1397235629-16328-3-git-send-email-riel@redhat.com>
References: <1397235629-16328-3-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Retry placement more frequently when misplaced
Git-Commit-ID: 5085e2a328849bdee6650b32d52c87c3788ab01c
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

Commit-ID:  5085e2a328849bdee6650b32d52c87c3788ab01c
Gitweb:     http://git.kernel.org/tip/5085e2a328849bdee6650b32d52c87c3788ab01c
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Fri, 11 Apr 2014 13:00:28 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 13:33:46 +0200

sched/numa: Retry placement more frequently when misplaced

When tasks have not converged on their preferred nodes yet, we want
to retry fairly often, to make sure we do not migrate a task's memory
to an undesirable location, only to have to move it again later.

This patch reduces the interval at which migration is retried,
when the task's numa_scan_period is small.

Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: Vinod Chegu <chegu_vinod@hp.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1397235629-16328-3-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f6457b6..ecea8d9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1326,12 +1326,15 @@ static int task_numa_migrate(struct task_struct *p)
 /* Attempt to migrate a task to a CPU on the preferred node. */
 static void numa_migrate_preferred(struct task_struct *p)
 {
+	unsigned long interval = HZ;
+
 	/* This task has no NUMA fault statistics yet */
 	if (unlikely(p->numa_preferred_nid == -1 || !p->numa_faults_memory))
 		return;
 
 	/* Periodically retry migrating the task to the preferred node */
-	p->numa_migrate_retry = jiffies + HZ;
+	interval = min(interval, msecs_to_jiffies(p->numa_scan_period) / 16);
+	p->numa_migrate_retry = jiffies + interval;
 
 	/* Success if task is already running on preferred CPU */
 	if (task_node(p) == p->numa_preferred_nid)
