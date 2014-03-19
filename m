Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934243AbaCSQZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:25:27 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37523 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934019AbaCSQYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:24:15 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, fenghua.yu@intel.com, schwidefsky@de.ibm.com,
        james.hogan@imgtec.com, cmetcalf@tilera.com, benh@kernel.crashing.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: dietmar.eggemann@arm.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v3 4/6] sched: add a new SD_SHARE_POWERDOMAIN for sched_domain
Date: Wed, 19 Mar 2014 17:22:43 +0100
Message-Id: <1395246165-31150-5-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395246165-31150-1-git-send-email-vincent.guittot@linaro.org>
References: <1395246165-31150-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new flag SD_SHARE_POWERDOMAIN is created to reflect whether groups of CPUs
in a sched_domain level can or not reach different power state. As an example,
the flag should be cleared at CPU level if groups of cores can be power gated
independently. This information can be used in the load balance decision or to
add load balancing level between group of CPUs that can power gate
independantly.
This flag is part of the topology flags that can be set by arch.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 include/linux/sched.h |  1 +
 kernel/sched/core.c   | 10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6479de4..7048369 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -861,6 +861,7 @@ enum cpu_idle_type {
 #define SD_BALANCE_WAKE		0x0010  /* Balance on wakeup */
 #define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
 #define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
+#define SD_SHARE_POWERDOMAIN	0x0100	/* Domain members share power domain */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0b51ee3..29b0c90 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5298,7 +5298,8 @@ static int sd_degenerate(struct sched_domain *sd)
 			 SD_BALANCE_FORK |
 			 SD_BALANCE_EXEC |
 			 SD_SHARE_CPUPOWER |
-			 SD_SHARE_PKG_RESOURCES)) {
+			 SD_SHARE_PKG_RESOURCES |
+			 SD_SHARE_POWERDOMAIN)) {
 		if (sd->groups != sd->groups->next)
 			return 0;
 	}
@@ -5329,7 +5330,8 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 				SD_BALANCE_EXEC |
 				SD_SHARE_CPUPOWER |
 				SD_SHARE_PKG_RESOURCES |
-				SD_PREFER_SIBLING);
+				SD_PREFER_SIBLING |
+				SD_SHARE_POWERDOMAIN);
 		if (nr_node_ids == 1)
 			pflags &= ~SD_SERIALIZE;
 	}
@@ -5938,6 +5940,7 @@ static int sched_domains_curr_level;
  * SD_SHARE_CPUPOWER      - describes SMT topologies
  * SD_SHARE_PKG_RESOURCES - describes shared caches
  * SD_NUMA                - describes NUMA topologies
+ * SD_SHARE_POWERDOMAIN   - describes shared power domain
  *
  * Odd one out:
  * SD_ASYM_PACKING        - describes SMT quirks
@@ -5946,7 +5949,8 @@ static int sched_domains_curr_level;
 	(SD_SHARE_CPUPOWER |		\
 	 SD_SHARE_PKG_RESOURCES |	\
 	 SD_NUMA |			\
-	 SD_ASYM_PACKING)
+	 SD_ASYM_PACKING |		\
+	 SD_SHARE_POWERDOMAIN)
 
 static struct sched_domain *
 sd_init(struct sched_domain_topology_level *tl, int cpu)
-- 
1.9.0

