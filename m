Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaEHKpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:45:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33289 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbaEHKpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:45:12 -0400
Date: Thu, 8 May 2014 03:44:09 -0700
From: tip-bot for Vincent Guittot <tipbot@zytor.com>
Message-ID: <tip-d77b3ed5c9f8ebedf154b52b5e943c461f3d37e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        dietmar.eggemann@arm.com, vincent.guittot@linaro.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, dietmar.eggemann@arm.com,
        peterz@infradead.org, vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <1397209481-28542-5-git-send-email-vincent.guittot@linaro.org>
References: <1397209481-28542-5-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Add a new SD_SHARE_POWERDOMAIN for sched_domain
Git-Commit-ID: d77b3ed5c9f8ebedf154b52b5e943c461f3d37e6
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

Commit-ID:  d77b3ed5c9f8ebedf154b52b5e943c461f3d37e6
Gitweb:     http://git.kernel.org/tip/d77b3ed5c9f8ebedf154b52b5e943c461f3d37e6
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Fri, 11 Apr 2014 11:44:40 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 13:33:52 +0200

sched: Add a new SD_SHARE_POWERDOMAIN for sched_domain

A new flag SD_SHARE_POWERDOMAIN is created to reflect whether groups of CPUs
in a sched_domain level can or not reach different power state. As an example,
the flag should be cleared at CPU level if groups of cores can be power gated
independently. This information can be used in the load balance decision or to
add load balancing level between group of CPUs that can power gate
independantly.
This flag is part of the topology flags that can be set by arch.

Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: tony.luck@intel.com
Cc: fenghua.yu@intel.com
Cc: schwidefsky@de.ibm.com
Cc: cmetcalf@tilera.com
Cc: benh@kernel.crashing.org
Cc: preeti@linux.vnet.ibm.com
Link: http://lkml.kernel.org/r/1397209481-28542-5-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |  1 +
 kernel/sched/core.c   | 10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 439a153..accb66b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -870,6 +870,7 @@ enum cpu_idle_type {
 #define SD_BALANCE_WAKE		0x0010  /* Balance on wakeup */
 #define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
 #define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
+#define SD_SHARE_POWERDOMAIN	0x0100	/* Domain members share power domain */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
 #define SD_ASYM_PACKING		0x0800  /* Place busy groups earlier in the domain */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7e348e2..1c9c3b7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5261,7 +5261,8 @@ static int sd_degenerate(struct sched_domain *sd)
 			 SD_BALANCE_FORK |
 			 SD_BALANCE_EXEC |
 			 SD_SHARE_CPUPOWER |
-			 SD_SHARE_PKG_RESOURCES)) {
+			 SD_SHARE_PKG_RESOURCES |
+			 SD_SHARE_POWERDOMAIN)) {
 		if (sd->groups != sd->groups->next)
 			return 0;
 	}
@@ -5292,7 +5293,8 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 				SD_BALANCE_EXEC |
 				SD_SHARE_CPUPOWER |
 				SD_SHARE_PKG_RESOURCES |
-				SD_PREFER_SIBLING);
+				SD_PREFER_SIBLING |
+				SD_SHARE_POWERDOMAIN);
 		if (nr_node_ids == 1)
 			pflags &= ~SD_SERIALIZE;
 	}
@@ -5901,6 +5903,7 @@ static int sched_domains_curr_level;
  * SD_SHARE_CPUPOWER      - describes SMT topologies
  * SD_SHARE_PKG_RESOURCES - describes shared caches
  * SD_NUMA                - describes NUMA topologies
+ * SD_SHARE_POWERDOMAIN   - describes shared power domain
  *
  * Odd one out:
  * SD_ASYM_PACKING        - describes SMT quirks
@@ -5909,7 +5912,8 @@ static int sched_domains_curr_level;
 	(SD_SHARE_CPUPOWER |		\
 	 SD_SHARE_PKG_RESOURCES |	\
 	 SD_NUMA |			\
-	 SD_ASYM_PACKING)
+	 SD_ASYM_PACKING |		\
+	 SD_SHARE_POWERDOMAIN)
 
 static struct sched_domain *
 sd_init(struct sched_domain_topology_level *tl, int cpu)
