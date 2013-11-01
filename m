Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab3KAWJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:09:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48587 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab3KAWJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:09:04 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>
Subject: [PATCH 05/11] ARM: Introduce CPU_METHOD_OF_DECLARE() for cpu hotplug/smp
Date: Fri,  1 Nov 2013 15:08:53 -0700
Message-Id: <1383343739-23080-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2.564.g0d6cf24
In-Reply-To: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of multi-platform kernels is to remove the need for mach
directories and machine descriptors. To further that goal,
introduce CPU_METHOD_OF_DECLARE() to allow cpu hotplug/smp
support to be separated from the machine descriptors.
Implementers should specify an enable-method property in their
cpus node and then implement a matching set of smp_ops in their
hotplug/smp code, wiring it up with the CPU_METHOD_OF_DECLARE()
macro. When the kernel is compiled we'll collect all the
enable-method smp_ops into one section for use at boot.

At boot time we'll look for an enable-method in each cpu node and
try to match that against all known CPU enable methods in the
kernel. If there are no enable-methods in the cpu nodes we
fallback to the cpus node and try to use any enable-method found
there. If that doesn't work we fall back to the old way of using
the machine descriptor.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/include/asm/smp.h        |  9 +++++++++
 arch/arm/kernel/devtree.c         | 38 ++++++++++++++++++++++++++++++++++++++
 include/asm-generic/vmlinux.lds.h | 10 ++++++++++
 3 files changed, 57 insertions(+)

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index a8cae71c..c27ec55 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -112,6 +112,15 @@ struct smp_operations {
 #endif
 };
 
+struct of_cpu_method {
+	const char *method;
+	struct smp_operations *ops;
+};
+
+#define CPU_METHOD_OF_DECLARE(name, _method, _ops)			\
+	static const struct of_cpu_method __cpu_method_of_table_##name	\
+		__used __section(__cpu_method_of_table)			\
+		= { .method = _method, .ops = _ops }
 /*
  * set platform specific SMP operations
  */
diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index f35906b..71a8592 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -25,6 +25,7 @@
 #include <asm/smp_plat.h>
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
+#include <asm/smp.h>
 
 void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 {
@@ -63,6 +64,36 @@ void __init arm_dt_memblock_reserve(void)
 	}
 }
 
+#ifdef CONFIG_SMP
+extern struct of_cpu_method __cpu_method_of_table[];
+
+static const struct of_cpu_method __cpu_method_of_table_sentinel
+	__used __section(__cpu_method_of_table_end);
+
+static int __init set_smp_ops_by_method(struct device_node *node)
+{
+	const char *method;
+	struct of_cpu_method *m = __cpu_method_of_table;
+
+	if (of_property_read_string(node, "enable-method", &method))
+		return 0;
+
+	for (; m != &__cpu_method_of_table_sentinel; m++)
+		if (!strcmp(m->method, method)) {
+			smp_set_ops(m->ops);
+			return 1;
+		}
+
+	return 0;
+}
+#else
+static inline int set_smp_ops_by_method(struct device_node *node)
+{
+	return 1;
+}
+#endif
+
+
 /*
  * arm_dt_init_cpu_maps - Function retrieves cpu nodes from the device tree
  * and builds the cpu logical map array containing MPIDR values related to
@@ -79,6 +110,7 @@ void __init arm_dt_init_cpu_maps(void)
 	 * read as 0.
 	 */
 	struct device_node *cpu, *cpus;
+	int found_method = 0;
 	u32 i, j, cpuidx = 1;
 	u32 mpidr = is_smp() ? read_cpuid_mpidr() & MPIDR_HWID_BITMASK : 0;
 
@@ -150,8 +182,14 @@ void __init arm_dt_init_cpu_maps(void)
 		}
 
 		tmp_map[i] = hwid;
+
+		if (!found_method)
+			found_method = set_smp_ops_by_method(cpu);
 	}
 
+	if (!found_method)
+		set_smp_ops_by_method(cpus);
+
 	if (!bootcpu_valid) {
 		pr_warn("DT missing boot CPU MPIDR[23:0], fall back to default cpu_logical_map\n");
 		return;
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 83e2c31..918b1b5 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -167,6 +167,15 @@
 #define CLK_OF_TABLES()
 #endif
 
+#ifdef CONFIG_SMP
+#define CPU_METHOD_OF_TABLES() . = ALIGN(8);				\
+			   VMLINUX_SYMBOL(__cpu_method_of_table) = .;	\
+			   *(__cpu_method_of_table)			\
+			   *(__cpu_method_of_table_end)
+#else
+#define CPU_METHOD_OF_TABLES()
+#endif
+
 #define KERNEL_DTB()							\
 	STRUCT_ALIGN();							\
 	VMLINUX_SYMBOL(__dtb_start) = .;				\
@@ -490,6 +499,7 @@
 	MEM_DISCARD(init.rodata)					\
 	CLK_OF_TABLES()							\
 	CLKSRC_OF_TABLES()						\
+	CPU_METHOD_OF_TABLES()						\
 	KERNEL_DTB()							\
 	IRQCHIP_OF_MATCH_TABLE()
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

