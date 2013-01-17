Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475Ab3AQBnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:43:25 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:46720 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758457Ab3AQBnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:43:23 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/17] workqueue: rename nr_running variables
Date: Wed, 16 Jan 2013 17:42:48 -0800
Message-Id: <1358386969-945-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename per-cpu and unbound nr_running variables such that they match
the pool variables.

This patch doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4bddf52..52ca95b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -449,14 +449,15 @@ static bool workqueue_freezing;		/* W: have wqs started freezing? */
  */
 static DEFINE_PER_CPU_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
 			      cpu_std_worker_pools);
-static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t, pool_nr_running[NR_STD_WORKER_POOLS]);
+static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t [NR_STD_WORKER_POOLS],
+				     cpu_std_pool_nr_running);
 
 /*
  * Standard worker pools and nr_running counter for unbound CPU.  The pools
  * have POOL_DISASSOCIATED set, and all workers have WORKER_UNBOUND set.
  */
 static struct worker_pool unbound_std_worker_pools[NR_STD_WORKER_POOLS];
-static atomic_t unbound_pool_nr_running[NR_STD_WORKER_POOLS] = {
+static atomic_t unbound_std_pool_nr_running[NR_STD_WORKER_POOLS] = {
 	[0 ... NR_STD_WORKER_POOLS - 1]	= ATOMIC_INIT(0),	/* always 0 */
 };
 
@@ -514,9 +515,9 @@ static atomic_t *get_pool_nr_running(struct worker_pool *pool)
 	int idx = std_worker_pool_pri(pool);
 
 	if (cpu != WORK_CPU_UNBOUND)
-		return &per_cpu(pool_nr_running, cpu)[idx];
+		return &per_cpu(cpu_std_pool_nr_running, cpu)[idx];
 	else
-		return &unbound_pool_nr_running[idx];
+		return &unbound_std_pool_nr_running[idx];
 }
 
 static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
-- 
1.8.0.2

