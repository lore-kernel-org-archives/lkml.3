Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaEWSTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:19:44 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36143 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaEWSQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:16:53 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, dietmar.eggemann@arm.com
Subject: [RFC PATCH 08/16] sched: Introduce SD_SHARE_CAP_STATES sched_domain flag
Date: Fri, 23 May 2014 19:16:35 +0100
Message-Id: <1400869003-27769-9-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 23 May 2014 18:16:51.0541 (UTC) FILETIME=[2B577850:01CF76B3]
X-MC-Unique: 114052319165200101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s4NIJmF3005199

cpufreq is currently keeping it a secret which cpus are sharing
clock source. The scheduler needs to know about clock domains as well
to become more energy aware. The SD_SHARE_CAP_STATES domain indicates
whether cpus belonging to the domain share capacity states (P-states).

There is no connection with cpufreq (yet). The flag must be set by
the arch specific topology code.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 arch/arm/kernel/topology.c |    3 ++-
 include/linux/sched.h      |    1 +
 kernel/sched/core.c        |   10 +++++++---
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 0b9c1e0..c78d497 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -383,7 +383,8 @@ static inline const struct sched_energy *cpu_sys_energy(int cpu)
 
 static inline const int cpu_corepower_flags(void)
 {
-	return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
+	return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN | \
+		SD_SHARE_CAP_STATES;
 }
 
 static struct sched_domain_topology_level arm_topology[] = {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4eb149b..62d61b5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -877,6 +877,7 @@ enum cpu_idle_type {
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
 #define SD_NUMA			0x4000	/* cross-node balancing */
+#define SD_SHARE_CAP_STATES	0x8000  /* Domain members share capacity state */
 
 #ifdef CONFIG_SCHED_SMT
 static inline const int cpu_smt_flags(void)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 530a348..49b895a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5322,7 +5322,8 @@ static int sd_degenerate(struct sched_domain *sd)
 			 SD_BALANCE_EXEC |
 			 SD_SHARE_CPUPOWER |
 			 SD_SHARE_PKG_RESOURCES |
-			 SD_SHARE_POWERDOMAIN)) {
+			 SD_SHARE_POWERDOMAIN |
+			 SD_SHARE_CAP_STATES)) {
 		if (sd->groups != sd->groups->next)
 			return 0;
 	}
@@ -5354,7 +5355,8 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 				SD_SHARE_CPUPOWER |
 				SD_SHARE_PKG_RESOURCES |
 				SD_PREFER_SIBLING |
-				SD_SHARE_POWERDOMAIN);
+				SD_SHARE_POWERDOMAIN |
+				SD_SHARE_CAP_STATES);
 		if (nr_node_ids == 1)
 			pflags &= ~SD_SERIALIZE;
 	}
@@ -6016,6 +6018,7 @@ static int sched_domains_curr_level;
  * SD_SHARE_PKG_RESOURCES - describes shared caches
  * SD_NUMA                - describes NUMA topologies
  * SD_SHARE_POWERDOMAIN   - describes shared power domain
+ * SD_SHARE_CAP_STATES    - describes shared capacity states
  *
  * Odd one out:
  * SD_ASYM_PACKING        - describes SMT quirks
@@ -6025,7 +6028,8 @@ static int sched_domains_curr_level;
 	 SD_SHARE_PKG_RESOURCES |	\
 	 SD_NUMA |			\
 	 SD_ASYM_PACKING |		\
-	 SD_SHARE_POWERDOMAIN)
+	 SD_SHARE_POWERDOMAIN |		\
+	 SD_SHARE_CAP_STATES)
 
 static struct sched_domain *
 sd_init(struct sched_domain_topology_level *tl, int cpu)
-- 
1.7.9.5


