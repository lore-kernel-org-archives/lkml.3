Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3JRLzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:55:33 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36691 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab3JRLz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:55:28 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        pjt@google.com, Morten.Rasmussen@arm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org, lorenzo.pieralisi@arm.com,
        devicetree@vger.kernel.org, rob.herring@calxeda.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: rjw@sisk.pl, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, l.majewski@samsung.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC][PATCH v5 02/14] ARM: sched: clear SD_SHARE_POWERDOMAIN
Date: Fri, 18 Oct 2013 13:54:53 +0200
Message-Id: <1382097293-30245-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM platforms take advantage of packing tasks on few cores if the latters
can be powergated independantly. We use DT and the cpu topology descirption
to define at which level a core can be independantly powergated to the others
and the SD_SHARE_POWERDOMAIN will be set accordingly at MC and CPU sched_domain
level.

The power-gate properties should be added with the value 1 in cpu and cluster
node when then can power gate independantly from the other.

As an example of a quad cores system which can power gate each core
independantly, we should have a DT similar to the example below

	cpus {
		#address-cells = <1>;
		#size-cells = <0>;

	       cpu-map {
	               cluster0 {
				power-gate = <1>;
				core0 {
	                               cpu = <&cpu0>;
					power-gate = <1>;
				};
				core1 {
				        cpu = <&cpu1>;
					power-gate = <1>;
				};
				core2 {
					cpu = <&cpu2>;
					power-gate = <1>;
				};
				core3 {
					cpu = <&cpu3>;
					power-gate = <1>;
				};
			};
		};

	...

	};

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 arch/arm/include/asm/topology.h |    4 ++++
 arch/arm/kernel/topology.c      |   50 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/topology.h b/arch/arm/include/asm/topology.h
index 58b8b84..5102847 100644
--- a/arch/arm/include/asm/topology.h
+++ b/arch/arm/include/asm/topology.h
@@ -5,12 +5,16 @@
 
 #include <linux/cpumask.h>
 
+#define CPU_CORE_GATE		0x1
+#define CPU_CLUSTER_GATE	0x2
+
 struct cputopo_arm {
 	int thread_id;
 	int core_id;
 	int socket_id;
 	cpumask_t thread_sibling;
 	cpumask_t core_sibling;
+	int flags;
 };
 
 extern struct cputopo_arm cpu_topology[NR_CPUS];
diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 85a8737..f38f1f9 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -24,6 +24,7 @@
 
 #include <asm/cputype.h>
 #include <asm/topology.h>
+#include <asm/smp_plat.h>
 
 /*
  * cpu power scale management
@@ -79,6 +80,51 @@ unsigned long *__cpu_capacity;
 
 unsigned long middle_capacity = 1;
 
+static int __init get_dt_power_topology(struct device_node *topo)
+{
+	const u32 *reg;
+	int len, power = 0;
+	int flag = CPU_CORE_GATE;
+
+	for (; topo; topo = of_get_next_parent(topo)) {
+		reg = of_get_property(topo, "power-gate", &len);
+		if (reg && len == 4 && be32_to_cpup(reg))
+			power |= flag;
+		flag <<= 1;
+	}
+
+	return power;
+}
+
+#define for_each_subnode_with_property(dn, pn, prop_name) \
+	for (dn = of_find_node_with_property(pn, prop_name); dn; \
+	     dn = of_find_node_with_property(dn, prop_name))
+
+static void __init init_dt_power_topology(void)
+{
+	struct device_node *cn, *topo;
+
+	/* Get power domain topology information */
+	cn = of_find_node_by_path("/cpus/cpu-map");
+	if (!cn) {
+		pr_warn("Missing cpu-map node, bailing out\n");
+		return;
+	}
+
+	for_each_subnode_with_property(topo, cn, "cpu") {
+		struct device_node *cpu;
+
+		cpu = of_parse_phandle(topo, "cpu", 0);
+		if (cpu) {
+			u32 hwid;
+
+			of_property_read_u32(cpu, "reg", &hwid);
+			cpu_topology[get_logical_index(hwid)].flags = get_dt_power_topology(topo);
+
+		}
+	}
+}
+
 /*
  * Iterate all CPUs' descriptor in DT and compute the efficiency
  * (as per table_efficiency). Also calculate a middle efficiency
@@ -151,6 +197,8 @@ static void __init parse_dt_topology(void)
 		middle_capacity = ((max_capacity / 3)
 				>> (SCHED_POWER_SHIFT-1)) + 1;
 
+	/* Retrieve power topology information from DT */
+	init_dt_power_topology();
 }
 
 /*
@@ -283,7 +331,7 @@ void __init init_cpu_topology(void)
 		cpu_topo->socket_id = -1;
 		cpumask_clear(&cpu_topo->core_sibling);
 		cpumask_clear(&cpu_topo->thread_sibling);
-
+		cpu_topo->flags = 0;
 		set_power_scale(cpu, SCHED_POWER_SCALE);
 	}
 	smp_wmb();
-- 
1.7.9.5

