Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaEWSUC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:20:02 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36075 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaEWSQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:16:52 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, dietmar.eggemann@arm.com
Subject: [RFC PATCH 07/16] sched: Introduce system-wide sched_energy
Date: Fri, 23 May 2014 19:16:34 +0100
Message-Id: <1400869003-27769-8-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 23 May 2014 18:16:50.0932 (UTC) FILETIME=[2AFA8B40:01CF76B3]
X-MC-Unique: 114052319165102701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s4NIKdAx005211

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

The Energy-aware algorithm needs system wide sched energy information on
certain platforms (e.g. a one socket system with multiple cpus).

In such a system, the sched energy data is only attached to the sched
groups for the individual cpus in the sched domain MC level.

For those systems, this patch adds a _hack_ to provide system-wide sched
energy data via the sched_domain_topology_level table.

The problem is that the sched_domain_topology_level table is not an
interface to provide system-wide data but we want to keep the
configuration of all sched energy related data in one place.

The sched_domain_energy_f of the last entry (the one which is
initialized with {NULL, }) of the sched_domain_topology_level table is
set to cpu_sys_energy(). Since the sched_domain_mask_f of this entry
stays NULL it is still not considered for the existing scheduler set-up
code (see for_each_sd_topology()).

A second call to init_sched_energy() with a struct sched_domain pointer
equal NULL as an argument will initialize the system-wide sched energy
structure sse.

For the example platform (ARM TC2 (MC and DIE sd level)), the
system-wide sched_domain_energy_f returns NULL, so struct sched_energy
*sse stays NULL.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 arch/arm/kernel/topology.c |    8 +++++++-
 kernel/sched/core.c        |   26 ++++++++++++++++++++++----
 kernel/sched/sched.h       |    2 ++
 3 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 4050348..0b9c1e0 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -374,6 +374,11 @@ static inline const struct sched_energy *cpu_core_energy(int cpu)
 	return cpu_topology[cpu].socket_id ? &energy_core_a7 :
 			&energy_core_a15;
 }
+
+static inline const struct sched_energy *cpu_sys_energy(int cpu)
+{
+	return NULL;
+}
 #endif /* CONFIG_SCHED_ENERGY */
 
 static inline const int cpu_corepower_flags(void)
@@ -392,10 +397,11 @@ static struct sched_domain_topology_level arm_topology[] = {
 #endif
 #ifdef CONFIG_SCHED_ENERGY
 	{ cpu_cpu_mask, 0, cpu_cluster_energy, SD_INIT_NAME(DIE) },
+	{ NULL,	0, cpu_sys_energy},
 #else
 	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
+	{ NULL,	},
 #endif
-	{ NULL, },
 };
 
 /*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 096fa55..530a348 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5866,20 +5866,35 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 }
 
 #ifdef CONFIG_SCHED_ENERGY
+/* System-wide energy information. */
+struct sched_energy *sse;
+
 static void init_sched_energy(int cpu, struct sched_domain *sd,
 			      struct sched_domain_topology_level *tl)
 {
-	struct sched_group *sg = sd->groups;
-	struct sched_energy *energy = &sg->sge->data;
+	struct sched_group *sg = sd ? sd->groups : NULL;
+	struct sched_energy *energy = sd ? &sg->sge->data : sse;
 	sched_domain_energy_f fn = tl->energy;
-	struct cpumask *mask = sched_group_cpus(sg);
+	const struct cpumask *mask = sd ? sched_group_cpus(sg) :
+					  cpu_cpu_mask(cpu);
 
-	if (!fn || !fn(cpu))
+	if (!fn || !fn(cpu) || (!sd && energy))
 		return;
 
 	if (cpumask_weight(mask) > 1)
 		check_sched_energy_data(cpu, fn, mask);
 
+	if (!sd) {
+		energy = sse = kzalloc_node(sizeof(struct sched_energy) +
+					    fn(cpu)->nr_cap_states*
+					    sizeof(struct capacity_state),
+					    GFP_KERNEL, cpu_to_node(cpu));
+		BUG_ON(!energy);
+
+		energy->cap_states = (struct capacity_state *)((void *)energy +
+				sizeof(struct sched_energy));
+	}
+
 	energy->max_capacity = fn(cpu)->max_capacity;
 	energy->idle_power = fn(cpu)->idle_power;
 	energy->wakeup_energy = fn(cpu)->wakeup_energy;
@@ -6579,6 +6594,9 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 			claim_allocations(i, sd);
 			init_sched_groups_power(i, sd);
 		}
+#ifdef CONFIG_SCHED_ENERGY
+		init_sched_energy(i, NULL, tl);
+#endif
 	}
 
 	/* Attach the domains */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 6726437..9ff67a7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -760,6 +760,8 @@ struct sched_group_energy {
 	atomic_t ref;
 	struct sched_energy data;
 };
+
+extern struct sched_energy *sse;
 #endif
 
 struct sched_group {
-- 
1.7.9.5


