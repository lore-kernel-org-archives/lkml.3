Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbaGCQ1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:27:32 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49596 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678AbaGCQ13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:27:29 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 07/23] sched: Introduce system-wide sched_energy
Date: Thu,  3 Jul 2014 17:25:54 +0100
Message-Id: <1404404770-323-8-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 03 Jul 2014 16:26:11.0694 (UTC) FILETIME=[809EF8E0:01CF96DB]
X-MC-Unique: 114070317261301101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s63GReTd010652

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

The energy aware algorithm needs system wide energy information on certain
platforms (e.g. a one socket SMP system). Unfortunately, there is no
sched_group that covers all cpus in the system, so there is no place to
attach a system wide sched_group_energy data structure. In such a system,
the energy data is only attached to the sched groups for the individual
cpus in the sched domain (sd) MC level.

This patch adds a _hack_ to provide system-wide energy data via the
sched_domain_topology_level table for such a system.

The problem is that the sched_domain_topology_level table is not an
interface to provide system-wide data but we want to keep the
configuration of all energy related data in one place.

The sched_domain_energy_f of the last entry (the one which is
initialized with {NULL, }) of the sched_domain_topology_level table is
set to cpu_sys_energy(). Since the sched_domain_mask_f of this entry
stays NULL it is still not considered for the existing scheduler set-up
code (see for_each_sd_topology()).

A second call to init_sched_energy() with an sd pointer argument set to
NULL initializes the system-wide energy structure sse.

There is no system-wide power management on the example platform (ARM TC2)
which could potentially interact with the scheduler so struct
sched_group_energy *sse stays NULL.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 arch/arm/kernel/topology.c |    7 ++++++-
 kernel/sched/core.c        |   34 ++++++++++++++++++++++++++++++----
 kernel/sched/sched.h       |    2 ++
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index a7d5a6e..70915b1 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -386,6 +386,11 @@ static inline const struct sched_group_energy *cpu_core_energy(int cpu)
 			&energy_core_a15;
 }
 
+static inline const struct sched_group_energy *cpu_sys_energy(int cpu)
+{
+	return NULL;
+}
+
 static inline const int cpu_corepower_flags(void)
 {
 	return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
@@ -396,7 +401,7 @@ static struct sched_domain_topology_level arm_topology[] = {
 	{ cpu_coregroup_mask, cpu_corepower_flags, cpu_core_energy, SD_INIT_NAME(MC) },
 #endif
 	{ cpu_cpu_mask, 0, cpu_cluster_energy, SD_INIT_NAME(DIE) },
-	{ NULL, },
+	{ NULL,	0, cpu_sys_energy},
 };
 
 /*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7fecc63..2d7544a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5954,20 +5954,44 @@ static void init_sched_groups_capacity(int cpu, struct sched_domain *sd)
 	atomic_set(&sg->sgc->nr_busy_cpus, sg->group_weight);
 }
 
+/* System-wide energy information. */
+struct sched_group_energy *sse;
+
 static void init_sched_energy(int cpu, struct sched_domain *sd,
 			      struct sched_domain_topology_level *tl)
 {
-	struct sched_group *sg = sd->groups;
-	struct sched_group_energy *energy = sg->sge;
+	struct sched_group *sg = sd ? sd->groups : NULL;
+	struct sched_group_energy *energy = sd ? sg->sge : sse;
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
+		energy = sse = kzalloc(sizeof(struct sched_group_energy) +
+				       fn(cpu)->nr_idle_states*
+				       sizeof(struct idle_state) +
+				       fn(cpu)->nr_cap_states*
+				       sizeof(struct capacity_state),
+				       GFP_KERNEL);
+		BUG_ON(!energy);
+
+		energy->idle_states = (struct idle_state *)
+				      ((void *)&energy->cap_states +
+				       sizeof(energy->cap_states));
+
+		energy->cap_states = (struct capacity_state *)
+				     ((void *)&energy->cap_states +
+				      sizeof(energy->cap_states) +
+				      fn(cpu)->nr_idle_states*
+				      sizeof(struct idle_state));
+	}
+
 	energy->nr_idle_states = fn(cpu)->nr_idle_states;
 	memcpy(energy->idle_states, fn(cpu)->idle_states,
 	       energy->nr_idle_states*sizeof(struct idle_state));
@@ -6655,6 +6679,8 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 			claim_allocations(i, sd);
 			init_sched_groups_capacity(i, sd);
 		}
+
+		init_sched_energy(i, NULL, tl);
 	}
 
 	/* Attach the domains */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1a5f1ee..c971359 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -747,6 +747,8 @@ struct sched_group_capacity {
 	unsigned long cpumask[0]; /* iteration mask */
 };
 
+extern struct sched_group_energy *sse;
+
 struct sched_group {
 	struct sched_group *next;	/* Must be a circular list */
 	atomic_t ref;
-- 
1.7.9.5


