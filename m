Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaHBBSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 21:18:22 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:64044 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaHBBSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 21:18:21 -0400
From: Zhihui Zhang <zzhsuny@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [sched] Rename a misleading variable in build_overlap_sched_groups()
Date: Fri,  1 Aug 2014 21:18:03 -0400
Message-Id: <1406942283-18249-1-git-send-email-zzhsuny@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The child variable in build_overlap_sched_groups() actually refers to the
peer or sibling domain of the given CPU. Rename it to sibling to be consistent
with the naming in build_group_mask().

Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
---
 kernel/sched/core.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bc1638b..8ba66006 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5720,7 +5720,7 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 	const struct cpumask *span = sched_domain_span(sd);
 	struct cpumask *covered = sched_domains_tmpmask;
 	struct sd_data *sdd = sd->private;
-	struct sched_domain *child;
+	struct sched_domain *sibling;
 	int i;
 
 	cpumask_clear(covered);
@@ -5731,10 +5731,10 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		if (cpumask_test_cpu(i, covered))
 			continue;
 
-		child = *per_cpu_ptr(sdd->sd, i);
+		sibling = *per_cpu_ptr(sdd->sd, i);
 
 		/* See the comment near build_group_mask(). */
-		if (!cpumask_test_cpu(i, sched_domain_span(child)))
+		if (!cpumask_test_cpu(i, sched_domain_span(sibling)))
 			continue;
 
 		sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
@@ -5744,10 +5744,9 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 			goto fail;
 
 		sg_span = sched_group_cpus(sg);
-		if (child->child) {
-			child = child->child;
-			cpumask_copy(sg_span, sched_domain_span(child));
-		} else
+		if (sibling->child)
+			cpumask_copy(sg_span, sched_domain_span(sibling->child));
+		else
 			cpumask_set_cpu(i, sg_span);
 
 		cpumask_or(covered, covered, sg_span);
-- 
1.8.1.2

