Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaEWSQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:16:55 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35932 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaEWSQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:16:51 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, dietmar.eggemann@arm.com
Subject: [RFC PATCH 03/16] sched: Introduce sd energy data structures
Date: Fri, 23 May 2014 19:16:30 +0100
Message-Id: <1400869003-27769-4-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 23 May 2014 18:16:48.0416 (UTC) FILETIME=[297AA200:01CF76B3]
X-MC-Unique: 114052319164903901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s4NIIoBq005179

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

The struct sched_energy represents the per scheduler group related data
which is needed for the energy aware scheduler.

It contains a pointer to a struct capacity_state array which contains
(compute capacity, power consumption @ this compute capacity) tuples.

The struct sched_group_energy wraps struct sched_energy and an atomic
reference counter, latter is used for scheduler internal bookkeeping of
data allocation and freeing.

Allocation and freeing of struct sched_group_energy uses the existing
infrastructure of the scheduler which is currently used for the other sd
hierarchy data structures (e.g. struct sched_domain).  That's why struct
sd_data is provisioned with a per cpu struct sched_group_energy double
pointer.

The struct sched_group gets a pointer to a struct sched_group_energy.

The function ptr sched_domain_energy_f is introduced into struct
sched_domain_topology_level which will allow the arch to set a pass a
particular struct sd_energy from the topology shim layer into the
scheduler core.

The function ptr sched_domain_energy_f has an 'int cpu' parameter since
the folding of two adjacent sd levels via sd degenerate doesn't work
for all sd levels.  E.g. it is not possible to use this feature to
provide per-cpu sd energy in sd level DIE (former CPU) on ARM's TC2
platform.

It was discussed that the folding of sd levels approach is preferable
over the cpu parameter approach, simply because the user (the arch
specifying the sd topology table) can introduce less errors.  But since
it is not working, the 'int cpu' parameter is the only way out.  It's
possible to use the folding of sd levels approach for
sched_domain_flags_f and the cpu parameter approach for the
sched_domain_energy_f at the same time set-up though.  With the use of
the 'int cpu' parameter, an extra check function has to be provided to
make sure that all cpus spanned by a scheduler building block (e.g a
sched domain or a group) are provisioned with the same energy data.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 include/linux/sched.h |   24 ++++++++++++++++++++++++
 kernel/sched/sched.h  |   10 ++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 261a419..4eb149b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -909,6 +909,21 @@ struct sched_domain_attr {
 
 extern int sched_domain_level_max;
 
+#ifdef CONFIG_SCHED_ENERGY
+struct capacity_state {
+	int cap;	/* compute capacity */
+	int power;	/* power consumption at this compute capacity */
+};
+
+struct sched_energy {
+	long max_capacity;	/* maximal compute capacity */
+	int idle_power;		/* power consumption in idle state */
+	int wakeup_energy;	/* energy for wakeup->sleep cycle (x1024) */
+	int nr_cap_states;	/* number of capacity states */
+	struct capacity_state *cap_states; /* ptr to capacity state array */
+};
+#endif
+
 struct sched_group;
 
 struct sched_domain {
@@ -1007,6 +1022,9 @@ bool cpus_share_cache(int this_cpu, int that_cpu);
 
 typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
 typedef const int (*sched_domain_flags_f)(void);
+#ifdef CONFIG_SCHED_ENERGY
+typedef const struct sched_energy *(*sched_domain_energy_f)(int cpu);
+#endif
 
 #define SDTL_OVERLAP	0x01
 
@@ -1014,11 +1032,17 @@ struct sd_data {
 	struct sched_domain **__percpu sd;
 	struct sched_group **__percpu sg;
 	struct sched_group_power **__percpu sgp;
+#ifdef CONFIG_SCHED_ENERGY
+	struct sched_group_energy **__percpu sge;
+#endif
 };
 
 struct sched_domain_topology_level {
 	sched_domain_mask_f mask;
 	sched_domain_flags_f sd_flags;
+#ifdef CONFIG_SCHED_ENERGY
+	sched_domain_energy_f energy;
+#endif
 	int		    flags;
 	int		    numa_level;
 	struct sd_data      data;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 456e492..c566f5e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -755,12 +755,22 @@ struct sched_group_power {
 	unsigned long cpumask[0]; /* iteration mask */
 };
 
+#ifdef CONFIG_SCHED_ENERGY
+struct sched_group_energy {
+	atomic_t ref;
+	struct sched_energy data;
+};
+#endif
+
 struct sched_group {
 	struct sched_group *next;	/* Must be a circular list */
 	atomic_t ref;
 
 	unsigned int group_weight;
 	struct sched_group_power *sgp;
+#ifdef CONFIG_SCHED_ENERGY
+	struct sched_group_energy *sge;
+#endif
 
 	/*
 	 * The CPUs this group covers.
-- 
1.7.9.5


