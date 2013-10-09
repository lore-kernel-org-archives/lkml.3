Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab3JIR2C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:28:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56097 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab3JIR17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:27:59 -0400
Date: Wed, 9 Oct 2013 10:27:21 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-745d61476ddb737aad3495fa6d9a8f8c2ee59f86@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-22-git-send-email-mgorman@suse.de>
References: <1381141781-10992-22-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Update NUMA hinting faults once per scan
Git-Commit-ID: 745d61476ddb737aad3495fa6d9a8f8c2ee59f86
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:27:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  745d61476ddb737aad3495fa6d9a8f8c2ee59f86
Gitweb:     http://git.kernel.org/tip/745d61476ddb737aad3495fa6d9a8f8c2ee59f86
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:28:59 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:40:25 +0200

sched/numa: Update NUMA hinting faults once per scan

NUMA hinting fault counts and placement decisions are both recorded in the
same array which distorts the samples in an unpredictable fashion. The values
linearly accumulate during the scan and then decay creating a sawtooth-like
pattern in the per-node counts. It also means that placement decisions are
time sensitive. At best it means that it is very difficult to state that
the buffer holds a decaying average of past faulting behaviour. At worst,
it can confuse the load balancer if it sees one node with an artifically high
count due to very recent faulting activity and may create a bouncing effect.

This patch adds a second array. numa_faults stores the historical data
which is used for placement decisions. numa_faults_buffer holds the
fault activity during the current scan window. When the scan completes,
numa_faults decays and the values from numa_faults_buffer are copied
across.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-22-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h | 13 +++++++++++++
 kernel/sched/core.c   |  1 +
 kernel/sched/fair.c   | 16 +++++++++++++---
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b1fc75e..a463bc3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1343,7 +1343,20 @@ struct task_struct {
 	u64 node_stamp;			/* migration stamp  */
 	struct callback_head numa_work;
 
+	/*
+	 * Exponential decaying average of faults on a per-node basis.
+	 * Scheduling placement decisions are made based on the these counts.
+	 * The values remain static for the duration of a PTE scan
+	 */
 	unsigned long *numa_faults;
+
+	/*
+	 * numa_faults_buffer records faults per node during the current
+	 * scan window. When the scan completes, the counts in numa_faults
+	 * decay and these values are copied.
+	 */
+	unsigned long *numa_faults_buffer;
+
 	int numa_preferred_nid;
 #endif /* CONFIG_NUMA_BALANCING */
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d15cd70..064a0af 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1636,6 +1636,7 @@ static void __sched_fork(struct task_struct *p)
 	p->numa_preferred_nid = -1;
 	p->numa_work.next = &p->numa_work;
 	p->numa_faults = NULL;
+	p->numa_faults_buffer = NULL;
 #endif /* CONFIG_NUMA_BALANCING */
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9efd34f..3abc651 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -892,8 +892,14 @@ static void task_numa_placement(struct task_struct *p)
 
 	/* Find the node with the highest number of faults */
 	for_each_online_node(nid) {
-		unsigned long faults = p->numa_faults[nid];
+		unsigned long faults;
+
+		/* Decay existing window and copy faults since last scan */
 		p->numa_faults[nid] >>= 1;
+		p->numa_faults[nid] += p->numa_faults_buffer[nid];
+		p->numa_faults_buffer[nid] = 0;
+
+		faults = p->numa_faults[nid];
 		if (faults > max_faults) {
 			max_faults = faults;
 			max_nid = nid;
@@ -919,9 +925,13 @@ void task_numa_fault(int node, int pages, bool migrated)
 	if (unlikely(!p->numa_faults)) {
 		int size = sizeof(*p->numa_faults) * nr_node_ids;
 
-		p->numa_faults = kzalloc(size, GFP_KERNEL|__GFP_NOWARN);
+		/* numa_faults and numa_faults_buffer share the allocation */
+		p->numa_faults = kzalloc(size * 2, GFP_KERNEL|__GFP_NOWARN);
 		if (!p->numa_faults)
 			return;
+
+		BUG_ON(p->numa_faults_buffer);
+		p->numa_faults_buffer = p->numa_faults + nr_node_ids;
 	}
 
 	/*
@@ -939,7 +949,7 @@ void task_numa_fault(int node, int pages, bool migrated)
 
 	task_numa_placement(p);
 
-	p->numa_faults[node] += pages;
+	p->numa_faults_buffer[node] += pages;
 }
 
 static void reset_ptenuma_scan(struct task_struct *p)
