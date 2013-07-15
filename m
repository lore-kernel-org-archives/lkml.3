Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab3GOKZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:25:34 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33688 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab3GOKWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:22:24 -0400
From: Sudeep.KarkadaNagesha@arm.com
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: cpufreq@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        lorenzo.pieralisi@arm.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, rjw@sisk.pl, viresh.kumar@linaro.org,
        gregkh@linuxfoundation.org, gregory.clement@free-electrons.com,
        kernel@pengutronix.de, shawn.guo@linaro.org, linux@arm.linux.org.uk,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [RFC PATCH 03/11] ARM: topology: remove hwid/MPIDR dependency from cpu_capacity
Date: Mon, 15 Jul 2013 11:22:04 +0100
Message-Id: <1373883732-26303-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1373883732-26303-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 15 Jul 2013 10:22:20.0331 (UTC) FILETIME=[304B97B0:01CE8145]
X-MC-Unique: 113071511222209601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6FAPiXN007673

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Currently the topology code computes cpu capacity and stores it in
the list along with hwid(which is MPIDR) as it parses the CPU nodes
in the device tree. This is required as it needs to be mapped to the
logical CPU later.

Since the CPU device nodes can be retrieved in the logical ordering
using helpers, its possible to store cpu_capacity also in logical
ordering and avoid storing hwid for each entry.

This patch removes hwid by making use of arch_of_get_cpu_node.

Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 arch/arm/kernel/topology.c | 61 +++++++++++++++-------------------------------
 1 file changed, 19 insertions(+), 42 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index c5a5954..c1a8f05 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -74,12 +74,8 @@ struct cpu_efficiency table_efficiency[] = {
 	{NULL, },
 };
 
-struct cpu_capacity {
-	unsigned long hwid;
-	unsigned long capacity;
-};
-
-struct cpu_capacity *cpu_capacity;
+unsigned long *__cpu_capacity;
+#define cpu_capacity(cpu)	__cpu_capacity[cpu]
 
 unsigned long middle_capacity = 1;
 
@@ -100,15 +96,19 @@ static void __init parse_dt_topology(void)
 	unsigned long capacity = 0;
 	int alloc_size, cpu = 0;
 
-	alloc_size = nr_cpu_ids * sizeof(struct cpu_capacity);
-	cpu_capacity = kzalloc(alloc_size, GFP_NOWAIT);
+	alloc_size = nr_cpu_ids * sizeof(*__cpu_capacity);
+	__cpu_capacity = kzalloc(alloc_size, GFP_NOWAIT);
 
-	while ((cn = of_find_node_by_type(cn, "cpu"))) {
-		const u32 *rate, *reg;
+	for_each_possible_cpu(cpu) {
+		const u32 *rate;
 		int len;
 
-		if (cpu >= num_possible_cpus())
-			break;
+		/* too early to use cpu->of_node */
+		cn = arch_of_get_cpu_node(cpu);
+		if (!cn) {
+			pr_err("missing device node for CPU %d\n", cpu);
+			continue;
+		}
 
 		for (cpu_eff = table_efficiency; cpu_eff->compatible; cpu_eff++)
 			if (of_device_is_compatible(cn, cpu_eff->compatible))
@@ -124,12 +124,6 @@ static void __init parse_dt_topology(void)
 			continue;
 		}
 
-		reg = of_get_property(cn, "reg", &len);
-		if (!reg || len != 4) {
-			pr_err("%s missing reg property\n", cn->full_name);
-			continue;
-		}
-
 		capacity = ((be32_to_cpup(rate)) >> 20) * cpu_eff->efficiency;
 
 		/* Save min capacity of the system */
@@ -140,13 +134,9 @@ static void __init parse_dt_topology(void)
 		if (capacity > max_capacity)
 			max_capacity = capacity;
 
-		cpu_capacity[cpu].capacity = capacity;
-		cpu_capacity[cpu++].hwid = be32_to_cpup(reg);
+		cpu_capacity(cpu) = capacity;
 	}
 
-	if (cpu < num_possible_cpus())
-		cpu_capacity[cpu].hwid = (unsigned long)(-1);
-
 	/* If min and max capacities are equals, we bypass the update of the
 	 * cpu_scale because all CPUs have the same capacity. Otherwise, we
 	 * compute a middle_capacity factor that will ensure that the capacity
@@ -154,9 +144,7 @@ static void __init parse_dt_topology(void)
 	 * SCHED_POWER_SCALE, which is the default value, but with the
 	 * constraint explained near table_efficiency[].
 	 */
-	if (min_capacity == max_capacity)
-		cpu_capacity[0].hwid = (unsigned long)(-1);
-	else if (4*max_capacity < (3*(max_capacity + min_capacity)))
+	if (4*max_capacity < (3*(max_capacity + min_capacity)))
 		middle_capacity = (min_capacity + max_capacity)
 				>> (SCHED_POWER_SHIFT+1);
 	else
@@ -170,23 +158,12 @@ static void __init parse_dt_topology(void)
  * boot. The update of all CPUs is in O(n^2) for heteregeneous system but the
  * function returns directly for SMP system.
  */
-void update_cpu_power(unsigned int cpu, unsigned long hwid)
+void update_cpu_power(unsigned int cpu)
 {
-	unsigned int idx = 0;
-
-	/* look for the cpu's hwid in the cpu capacity table */
-	for (idx = 0; idx < num_possible_cpus(); idx++) {
-		if (cpu_capacity[idx].hwid == hwid)
-			break;
-
-		if (cpu_capacity[idx].hwid == -1)
-			return;
-	}
-
-	if (idx == num_possible_cpus())
+	if (!cpu_capacity(cpu))
 		return;
 
-	set_power_scale(cpu, cpu_capacity[idx].capacity / middle_capacity);
+	set_power_scale(cpu, cpu_capacity(cpu) / middle_capacity);
 
 	printk(KERN_INFO "CPU%u: update cpu_power %lu\n",
 		cpu, arch_scale_freq_power(NULL, cpu));
@@ -194,7 +171,7 @@ void update_cpu_power(unsigned int cpu, unsigned long hwid)
 
 #else
 static inline void parse_dt_topology(void) {}
-static inline void update_cpu_power(unsigned int cpuid, unsigned int mpidr) {}
+static inline void update_cpu_power(unsigned int cpuid) {}
 #endif
 
  /*
@@ -281,7 +258,7 @@ void store_cpu_topology(unsigned int cpuid)
 
 	update_siblings_masks(cpuid);
 
-	update_cpu_power(cpuid, mpidr & MPIDR_HWID_BITMASK);
+	update_cpu_power(cpuid);
 
 	printk(KERN_INFO "CPU%u: thread %d, cpu %d, socket %d, mpidr %x\n",
 		cpuid, cpu_topology[cpuid].thread_id,
-- 
1.8.1.2


