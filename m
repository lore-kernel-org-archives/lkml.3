Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab3JIRhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:37:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56482 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399Ab3JIRdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:33:11 -0400
Date: Wed, 9 Oct 2013 10:32:22 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-7dbd13ed06513b047216a7ffc718bad9df0660f1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-52-git-send-email-mgorman@suse.de>
References: <1381141781-10992-52-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Prevent parallel updates to group stats during placement
Git-Commit-ID: 7dbd13ed06513b047216a7ffc718bad9df0660f1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:32:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7dbd13ed06513b047216a7ffc718bad9df0660f1
Gitweb:     http://git.kernel.org/tip/7dbd13ed06513b047216a7ffc718bad9df0660f1
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:29:29 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 14:48:02 +0200

sched/numa: Prevent parallel updates to group stats during placement

Having multiple tasks in a group go through task_numa_placement
simultaneously can lead to a task picking a wrong node to run on, because
the group stats may be in the middle of an update. This patch avoids
parallel updates by holding the numa_group lock during placement
decisions.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-52-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c4df2de..1473499 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1233,6 +1233,7 @@ static void task_numa_placement(struct task_struct *p)
 {
 	int seq, nid, max_nid = -1, max_group_nid = -1;
 	unsigned long max_faults = 0, max_group_faults = 0;
+	spinlock_t *group_lock = NULL;
 
 	seq = ACCESS_ONCE(p->mm->numa_scan_seq);
 	if (p->numa_scan_seq == seq)
@@ -1241,6 +1242,12 @@ static void task_numa_placement(struct task_struct *p)
 	p->numa_migrate_seq++;
 	p->numa_scan_period_max = task_scan_max(p);
 
+	/* If the task is part of a group prevent parallel updates to group stats */
+	if (p->numa_group) {
+		group_lock = &p->numa_group->lock;
+		spin_lock(group_lock);
+	}
+
 	/* Find the node with the highest number of faults */
 	for_each_online_node(nid) {
 		unsigned long faults = 0, group_faults = 0;
@@ -1279,20 +1286,24 @@ static void task_numa_placement(struct task_struct *p)
 		}
 	}
 
-	/*
-	 * If the preferred task and group nids are different,
-	 * iterate over the nodes again to find the best place.
-	 */
-	if (p->numa_group && max_nid != max_group_nid) {
-		unsigned long weight, max_weight = 0;
-
-		for_each_online_node(nid) {
-			weight = task_weight(p, nid) + group_weight(p, nid);
-			if (weight > max_weight) {
-				max_weight = weight;
-				max_nid = nid;
+	if (p->numa_group) {
+		/*
+		 * If the preferred task and group nids are different,
+		 * iterate over the nodes again to find the best place.
+		 */
+		if (max_nid != max_group_nid) {
+			unsigned long weight, max_weight = 0;
+
+			for_each_online_node(nid) {
+				weight = task_weight(p, nid) + group_weight(p, nid);
+				if (weight > max_weight) {
+					max_weight = weight;
+					max_nid = nid;
+				}
 			}
 		}
+
+		spin_unlock(group_lock);
 	}
 
 	/* Preferred node as the node with the most faults */
