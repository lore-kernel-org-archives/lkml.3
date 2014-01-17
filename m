Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaAQVVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 16:21:32 -0500
Received: from shelob.surriel.com ([74.92.59.67]:59184 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaAQVV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 16:21:29 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, chegu_vinod@hp.com, peterz@infradead.org,
        mgorman@suse.de, mingo@redhat.com
Subject: [PATCH 7/7] numa,sched: do statistics calculation using local variables only
Date: Fri, 17 Jan 2014 16:12:09 -0500
Message-Id: <1389993129-28180-8-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389993129-28180-1-git-send-email-riel@redhat.com>
References: <1389993129-28180-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

The current code in task_numa_placement calculates the difference
between the old and the new value, but also temporarily stores half
of the old value in the per-process variables.

The NUMA balancing code looks at those per-process variables, and
having other tasks temporarily see halved statistics could lead to
unwanted numa migrations. This can be avoided by doing all the math
in local variables.

This change also simplifies the code a little.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0d395a0..0f48382 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1484,12 +1484,9 @@ static void task_numa_placement(struct task_struct *p)
 			long diff, f_diff, f_weight;
 
 			i = task_faults_idx(nid, priv);
-			diff = -p->numa_faults[i];
-			f_diff = -p->numa_faults_from[i];
 
 			/* Decay existing window, copy faults since last scan */
-			p->numa_faults[i] >>= 1;
-			p->numa_faults[i] += p->numa_faults_buffer[i];
+			diff = p->numa_faults_buffer[i] - p->numa_faults[i] / 2;
 			fault_types[priv] += p->numa_faults_buffer[i];
 			p->numa_faults_buffer[i] = 0;
 
@@ -1503,13 +1500,12 @@ static void task_numa_placement(struct task_struct *p)
 			f_weight = (1024 * runtime *
 				   p->numa_faults_from_buffer[i]) /
 				   (total_faults * period + 1);
-			p->numa_faults_from[i] >>= 1;
-			p->numa_faults_from[i] += f_weight;
+			f_diff = f_weight - p->numa_faults_from[i] / 2;
 			p->numa_faults_from_buffer[i] = 0;
 
+			p->numa_faults[i] += diff;
+			p->numa_faults_from[i] += f_diff;
 			faults += p->numa_faults[i];
-			diff += p->numa_faults[i];
-			f_diff += p->numa_faults_from[i];
 			p->total_numa_faults += diff;
 			if (p->numa_group) {
 				/* safe because we can only change our own group */
-- 
1.8.4.2

