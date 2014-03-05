Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbaCEHUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:20:51 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63501 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbaCEHTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:19:22 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, fenghua.yu@intel.com, schwidefsky@de.ibm.com,
        james.hogan@imgtec.com, cmetcalf@tilera.com, benh@kernel.crashing.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: dietmar.eggemann@arm.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC 5/6] sched: add a new SD_SHARE_POWERDOMAIN for sched_domain
Date: Wed,  5 Mar 2014 15:18:25 +0800
Message-Id: <1394003906-11630-6-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
References: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new flag SD_SHARE_POWERDOMAIN is created to reflect whether groups of CPUs
in a sched_domain level can or not reach different power state. As an example,
the flag should be cleared at CPU level if groups of cores can be power gated
independently. This information can be used to add load balancing level between
group of CPUs than can power gate independantly. The default behavior of the
scheduler is to spread tasks across CPUs and groups of CPUs so the flag is set
into all sched_domains.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |    9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index dbc35dd..182a080 100644
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
index 7606de0..b28cff0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5283,7 +5283,8 @@ static int sd_degenerate(struct sched_domain *sd)
 			 SD_BALANCE_FORK |
 			 SD_BALANCE_EXEC |
 			 SD_SHARE_CPUPOWER |
-			 SD_SHARE_PKG_RESOURCES)) {
+			 SD_SHARE_PKG_RESOURCES |
+			 SD_SHARE_POWERDOMAIN)) {
 		if (sd->groups != sd->groups->next)
 			return 0;
 	}
@@ -5314,7 +5315,8 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 				SD_BALANCE_EXEC |
 				SD_SHARE_CPUPOWER |
 				SD_SHARE_PKG_RESOURCES |
-				SD_PREFER_SIBLING);
+				SD_PREFER_SIBLING |
+				SD_SHARE_POWERDOMAIN);
 		if (nr_node_ids == 1)
 			pflags &= ~SD_SERIALIZE;
 	}
@@ -5932,7 +5934,8 @@ static struct cpumask ***sched_domains_numa_masks;
 	(SD_SHARE_CPUPOWER |		\
 	 SD_SHARE_PKG_RESOURCES |	\
 	 SD_NUMA |			\
-	 SD_ASYM_PACKING)
+	 SD_ASYM_PACKING |		\
+	 SD_SHARE_POWERDOMAIN)
 
 static struct sched_domain *
 sd_init(struct sched_domain_topology_level *tl, int cpu)
-- 
1.7.9.5

