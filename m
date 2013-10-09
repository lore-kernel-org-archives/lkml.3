Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3JIR14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:27:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56091 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab3JIR1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:27:53 -0400
Date: Wed, 9 Oct 2013 10:27:11 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-688b7585d16ab57a17aa4422a3b290b3a55fa679@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-21-git-send-email-mgorman@suse.de>
References: <1381141781-10992-21-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Select a preferred node with the most numa hinting faults
Git-Commit-ID: 688b7585d16ab57a17aa4422a3b290b3a55fa679
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:27:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  688b7585d16ab57a17aa4422a3b290b3a55fa679
Gitweb:     http://git.kernel.org/tip/688b7585d16ab57a17aa4422a3b290b3a55fa679
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:28:58 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:40:23 +0200

sched/numa: Select a preferred node with the most numa hinting faults

This patch selects a preferred node for a task to run on based on the
NUMA hinting faults. This information is later used to migrate tasks
towards the node during balancing.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-21-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |  1 +
 kernel/sched/core.c   |  1 +
 kernel/sched/fair.c   | 17 +++++++++++++++--
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a810e95..b1fc75e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1344,6 +1344,7 @@ struct task_struct {
 	struct callback_head numa_work;
 
 	unsigned long *numa_faults;
+	int numa_preferred_nid;
 #endif /* CONFIG_NUMA_BALANCING */
 
 	struct rcu_head rcu;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6808d35..d15cd70 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1633,6 +1633,7 @@ static void __sched_fork(struct task_struct *p)
 	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
 	p->numa_migrate_seq = p->mm ? p->mm->numa_scan_seq - 1 : 0;
 	p->numa_scan_period = sysctl_numa_balancing_scan_delay;
+	p->numa_preferred_nid = -1;
 	p->numa_work.next = &p->numa_work;
 	p->numa_faults = NULL;
 #endif /* CONFIG_NUMA_BALANCING */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0bb3e0a..9efd34f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -879,7 +879,8 @@ static unsigned int task_scan_max(struct task_struct *p)
 
 static void task_numa_placement(struct task_struct *p)
 {
-	int seq;
+	int seq, nid, max_nid = -1;
+	unsigned long max_faults = 0;
 
 	if (!p->mm)	/* for example, ksmd faulting in a user's mm */
 		return;
@@ -889,7 +890,19 @@ static void task_numa_placement(struct task_struct *p)
 	p->numa_scan_seq = seq;
 	p->numa_scan_period_max = task_scan_max(p);
 
-	/* FIXME: Scheduling placement policy hints go here */
+	/* Find the node with the highest number of faults */
+	for_each_online_node(nid) {
+		unsigned long faults = p->numa_faults[nid];
+		p->numa_faults[nid] >>= 1;
+		if (faults > max_faults) {
+			max_faults = faults;
+			max_nid = nid;
+		}
+	}
+
+	/* Update the tasks preferred node if necessary */
+	if (max_faults && max_nid != p->numa_preferred_nid)
+		p->numa_preferred_nid = max_nid;
 }
 
 /*
