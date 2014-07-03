Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbaGCQ2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:28:36 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53540 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbaGCQ2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:28:33 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 06/23] arm: topology: Define TC2 energy and provide it to the scheduler
Date: Thu,  3 Jul 2014 17:25:53 +0100
Message-Id: <1404404770-323-7-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 03 Jul 2014 16:26:10.0725 (UTC) FILETIME=[800B1D50:01CF96DB]
X-MC-Unique: 114070317261009801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s63GSeLc010670

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

This patch is only here to be able to test provisioning of energy related
data from an arch topology shim layer to the scheduler. Since there is no
code today which deals with extracting energy related data from the dtb or
acpi, and process it in the topology shim layer, the content of the
sched_group_energy structures as well as the idle_state and capacity_state
arrays are hard-coded here.

This patch defines the sched_group_energy structure as well as the
idle_state and capacity_state array for the cluster (relates to sched
groups (sg's) in DIE sched domain (sd) level) and for the core (relates
to sg's in MC sd level) for a Cortex A7 as well as for a Cortex A15.
It further provides related implementations of the sched_domain_energy_f
functions (cpu_cluster_energy() and cpu_core_energy()).

To be able to propagate this information from the topology shim layer to
the scheduler, the elements of the arm_topology[] table have been
provisioned with the appropriate sched_domain_energy_f functions.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 arch/arm/kernel/topology.c |  116 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 113 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index d42a7db..a7d5a6e 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -275,6 +275,117 @@ void store_cpu_topology(unsigned int cpuid)
 		cpu_topology[cpuid].socket_id, mpidr);
 }
 
+/*
+ * ARM TC2 specific energy cost model data. There are no unit requirements for
+ * the data. Data can be normalized to any reference point, but the
+ * normalization must be consistent. That is, one bogo-joule/watt must be the
+ * same quantity for all data, but we don't care what it is.
+ */
+static struct idle_state idle_states_cluster_a7[] = {
+	 { .power = 10, .wu_energy = 6 /* << 10 */, },
+	};
+
+static struct idle_state idle_states_cluster_a15[] = {
+	 { .power = 25, .wu_energy = 210 /* << 10 */, },
+	};
+
+static struct capacity_state cap_states_cluster_a7[] = {
+	/* Cluster only power */
+	 { .cap =  358, .power = 2967, }, /*  350 MHz */
+	 { .cap =  410, .power = 2792, }, /*  400 MHz */
+	 { .cap =  512, .power = 2810, }, /*  500 MHz */
+	 { .cap =  614, .power = 2815, }, /*  600 MHz */
+	 { .cap =  717, .power = 2919, }, /*  700 MHz */
+	 { .cap =  819, .power = 2847, }, /*  800 MHz */
+	 { .cap =  922, .power = 3917, }, /*  900 MHz */
+	 { .cap = 1024, .power = 4905, }, /* 1000 MHz */
+	};
+
+static struct capacity_state cap_states_cluster_a15[] = {
+	/* Cluster only power */
+	 { .cap =  840, .power =  7920, }, /*  500 MHz */
+	 { .cap = 1008, .power =  8165, }, /*  600 MHz */
+	 { .cap = 1176, .power =  8172, }, /*  700 MHz */
+	 { .cap = 1343, .power =  8195, }, /*  800 MHz */
+	 { .cap = 1511, .power =  8265, }, /*  900 MHz */
+	 { .cap = 1679, .power =  8446, }, /* 1000 MHz */
+	 { .cap = 1847, .power = 11426, }, /* 1100 MHz */
+	 { .cap = 2015, .power = 15200, }, /* 1200 MHz */
+	};
+
+static struct sched_group_energy energy_cluster_a7 = {
+	  .nr_idle_states = ARRAY_SIZE(idle_states_cluster_a7),
+	  .idle_states    = idle_states_cluster_a7,
+	  .nr_cap_states  = ARRAY_SIZE(cap_states_cluster_a7),
+	  .cap_states     = cap_states_cluster_a7,
+};
+
+static struct sched_group_energy energy_cluster_a15 = {
+	  .nr_idle_states = ARRAY_SIZE(idle_states_cluster_a15),
+	  .idle_states    = idle_states_cluster_a15,
+	  .nr_cap_states  = ARRAY_SIZE(cap_states_cluster_a15),
+	  .cap_states     = cap_states_cluster_a15,
+};
+
+static struct idle_state idle_states_core_a7[] = {
+	 { .power = 0 /* No power gating */, .wu_energy = 0 /* << 10 */, },
+	};
+
+static struct idle_state idle_states_core_a15[] = {
+	 { .power = 0 /* No power gating */, .wu_energy = 5 /* << 10 */, },
+	};
+
+static struct capacity_state cap_states_core_a7[] = {
+	/* Power per cpu */
+	 { .cap =  358, .power =  187, }, /*  350 MHz */
+	 { .cap =  410, .power =  275, }, /*  400 MHz */
+	 { .cap =  512, .power =  334, }, /*  500 MHz */
+	 { .cap =  614, .power =  407, }, /*  600 MHz */
+	 { .cap =  717, .power =  447, }, /*  700 MHz */
+	 { .cap =  819, .power =  549, }, /*  800 MHz */
+	 { .cap =  922, .power =  761, }, /*  900 MHz */
+	 { .cap = 1024, .power = 1024, }, /* 1000 MHz */
+	};
+
+static struct capacity_state cap_states_core_a15[] = {
+	/* Power per cpu */
+	 { .cap =  840, .power = 2021, }, /*  500 MHz */
+	 { .cap = 1008, .power = 2312, }, /*  600 MHz */
+	 { .cap = 1176, .power = 2756, }, /*  700 MHz */
+	 { .cap = 1343, .power = 3125, }, /*  800 MHz */
+	 { .cap = 1511, .power = 3524, }, /*  900 MHz */
+	 { .cap = 1679, .power = 3846, }, /* 1000 MHz */
+	 { .cap = 1847, .power = 5177, }, /* 1100 MHz */
+	 { .cap = 2015, .power = 6997, }, /* 1200 MHz */
+	};
+
+static struct sched_group_energy energy_core_a7 = {
+	  .nr_idle_states = ARRAY_SIZE(idle_states_core_a7),
+	  .idle_states    = idle_states_core_a7,
+	  .nr_cap_states  = ARRAY_SIZE(cap_states_core_a7),
+	  .cap_states     = cap_states_core_a7,
+};
+
+static struct sched_group_energy energy_core_a15 = {
+	  .nr_idle_states = ARRAY_SIZE(idle_states_core_a15),
+	  .idle_states    = idle_states_core_a15,
+	  .nr_cap_states  = ARRAY_SIZE(cap_states_core_a15),
+	  .cap_states     = cap_states_core_a15,
+};
+
+/* sd energy functions */
+static inline const struct sched_group_energy *cpu_cluster_energy(int cpu)
+{
+	return cpu_topology[cpu].socket_id ? &energy_cluster_a7 :
+			&energy_cluster_a15;
+}
+
+static inline const struct sched_group_energy *cpu_core_energy(int cpu)
+{
+	return cpu_topology[cpu].socket_id ? &energy_core_a7 :
+			&energy_core_a15;
+}
+
 static inline const int cpu_corepower_flags(void)
 {
 	return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
@@ -282,10 +393,9 @@ static inline const int cpu_corepower_flags(void)
 
 static struct sched_domain_topology_level arm_topology[] = {
 #ifdef CONFIG_SCHED_MC
-	{ cpu_corepower_mask, cpu_corepower_flags, SD_INIT_NAME(GMC) },
-	{ cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
+	{ cpu_coregroup_mask, cpu_corepower_flags, cpu_core_energy, SD_INIT_NAME(MC) },
 #endif
-	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
+	{ cpu_cpu_mask, 0, cpu_cluster_energy, SD_INIT_NAME(DIE) },
 	{ NULL, },
 };
 
-- 
1.7.9.5


