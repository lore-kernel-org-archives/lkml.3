Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaHLOxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:53:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37014 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaHLOxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:53:42 -0400
Date: Tue, 12 Aug 2014 07:52:53 -0700
From: tip-bot for Zhihui Zhang <tipbot@zytor.com>
Message-ID: <tip-aaecac4ad46b35ad308245384d019633fb9bc21b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, zzhsuny@gmail.com, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zzhsuny@gmail.com, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <1406942283-18249-1-git-send-email-zzhsuny@gmail.com>
References: <1406942283-18249-1-git-send-email-zzhsuny@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Rename a misleading variable in build_overlap_sched_groups()
Git-Commit-ID: aaecac4ad46b35ad308245384d019633fb9bc21b
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

Commit-ID:  aaecac4ad46b35ad308245384d019633fb9bc21b
Gitweb:     http://git.kernel.org/tip/aaecac4ad46b35ad308245384d019633fb9bc21b
Author:     Zhihui Zhang <zzhsuny@gmail.com>
AuthorDate: Fri, 1 Aug 2014 21:18:03 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 12 Aug 2014 12:48:21 +0200

sched: Rename a misleading variable in build_overlap_sched_groups()

The child variable in build_overlap_sched_groups() actually refers to the
peer or sibling domain of the given CPU. Rename it to sibling to be consistent
with the naming in build_group_mask().

Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Link: http://lkml.kernel.org/r/1406942283-18249-1-git-send-email-zzhsuny@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1211575..7d1ec6e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5739,7 +5739,7 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 	const struct cpumask *span = sched_domain_span(sd);
 	struct cpumask *covered = sched_domains_tmpmask;
 	struct sd_data *sdd = sd->private;
-	struct sched_domain *child;
+	struct sched_domain *sibling;
 	int i;
 
 	cpumask_clear(covered);
@@ -5750,10 +5750,10 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		if (cpumask_test_cpu(i, covered))
 			continue;
 
-		child = *per_cpu_ptr(sdd->sd, i);
+		sibling = *per_cpu_ptr(sdd->sd, i);
 
 		/* See the comment near build_group_mask(). */
-		if (!cpumask_test_cpu(i, sched_domain_span(child)))
+		if (!cpumask_test_cpu(i, sched_domain_span(sibling)))
 			continue;
 
 		sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
@@ -5763,10 +5763,9 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
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
