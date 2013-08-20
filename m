Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab3HTJeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:34:05 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34658 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab3HTJaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:30:16 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Sudeep.KarkadaNagesha@arm.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH v4 08/19] ARM: topology: remove hwid/MPIDR dependency from cpu_capacity
Date: Tue, 20 Aug 2013 10:30:10 +0100
Message-Id: <1376991021-12160-9-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 20 Aug 2013 09:30:13.0318 (UTC) FILETIME=[DF524660:01CE9D87]
X-MC-Unique: 113082010301409401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7K9YBmX012327

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Currently the topology code computes cpu capacity and stores it in
the list along with hwid(which is MPIDR) as it parses the CPU nodes
in the device tree. This is required as it needs to be mapped to the
logical CPU later.

Since the CPU device nodes can be retrieved in the logical ordering
using DT/OF helpers, its possible to store cpu_capacity also in logical
ordering and avoid storing hwid for each entry.

This patch removes hwid by making use of of_get_cpu_node.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 arch/arm/kernel/topology.c | 61 +++++++++++++++-------------------------------
 1 file changed, 19 insertions(+), 42 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index c5a5954..85a8737 100644
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
+		cn = of_get_cpu_node(cpu, NULL);
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


