Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbaFWPt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:49:29 -0400
Received: from shelob.surriel.com ([74.92.59.67]:54947 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306AbaFWPt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:49:27 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: chegu_vinod@hp.com, peterz@infradead.com, mgorman@suse.de,
        mingo@kernel.org
Subject: [PATCH 7/7] sched,numa: change scan period code to match intent
Date: Mon, 23 Jun 2014 11:41:35 -0400
Message-Id: <1403538095-31256-8-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1403538095-31256-1-git-send-email-riel@redhat.com>
References: <1403538095-31256-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Reading through the scan period code and comment, it appears the
intent was to slow down NUMA scanning when a majority of accesses
are on the local node, specifically a local:remote ratio of 3:1.

However, the code actually tests local / (local + remote), and
the actual cut-off point was around 30% local accesses, well before
a task has actually converged on a node.

Changing the threshold to 7 means scanning slows down when a task
has around 70% of its accesses local, which appears to match the
intent of the code more closely.

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ee35576..1aaa3b4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1452,12 +1452,12 @@ static void update_numa_active_node_mask(struct numa_group *numa_group)
 /*
  * When adapting the scan rate, the period is divided into NUMA_PERIOD_SLOTS
  * increments. The more local the fault statistics are, the higher the scan
- * period will be for the next scan window. If local/remote ratio is below
- * NUMA_PERIOD_THRESHOLD (where range of ratio is 1..NUMA_PERIOD_SLOTS) the
- * scan period will decrease
+ * period will be for the next scan window. If local/(local+remote) ratio is
+ * below NUMA_PERIOD_THRESHOLD (where range of ratio is 1..NUMA_PERIOD_SLOTS)
+ * the scan period will decrease. Aim for 70% local accesses.
  */
 #define NUMA_PERIOD_SLOTS 10
-#define NUMA_PERIOD_THRESHOLD 3
+#define NUMA_PERIOD_THRESHOLD 7
 
 /*
  * Increase the scan period (slow down scanning) if the majority of
-- 
1.8.5.3

