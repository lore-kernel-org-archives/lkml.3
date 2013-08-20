Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab3HTJfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:35:54 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34419 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab3HTJaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:30:13 -0400
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
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v4 04/19] of: move of_get_cpu_node implementation to DT core library
Date: Tue, 20 Aug 2013 10:30:06 +0100
Message-Id: <1376991021-12160-5-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 20 Aug 2013 09:30:10.0099 (UTC) FILETIME=[DD671830:01CE9D87]
X-MC-Unique: 113082010301108401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7K9ZxKo012369

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

This patch moves the generalized implementation of of_get_cpu_node from
PowerPC to DT core library, thereby adding support for retrieving cpu
node for a given logical cpu index on any architecture.

The CPU subsystem can now use this function to assign of_node in the
cpu device while registering CPUs.

It is recommended to use these helper function only in pre-SMP/early
initialisation stages to retrieve CPU device node pointers in logical
ordering. Once the cpu devices are registered, it can be retrieved easily
from cpu device of_node which avoids unnecessary parsing and matching.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Acked-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 arch/powerpc/include/asm/prom.h |  3 --
 arch/powerpc/kernel/prom.c      | 57 -------------------------
 drivers/of/base.c               | 95 +++++++++++++++++++++++++++++++++++++++++
 include/linux/cpu.h             |  1 +
 include/linux/of.h              |  7 +++
 5 files changed, 103 insertions(+), 60 deletions(-)

diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index bc2da15..ac204e0 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -43,9 +43,6 @@ void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
 
 extern void kdump_move_device_tree(void);
 
-/* CPU OF node matching */
-struct device_node *of_get_cpu_node(int cpu, unsigned int *thread);
-
 /* cache lookup */
 struct device_node *of_find_next_cache_node(struct device_node *np);
 
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index f7b8c0b..1c14cd4 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -870,63 +870,6 @@ bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
 	return (int)phys_id == get_hard_smp_processor_id(cpu);
 }
 
-static bool __of_find_n_match_cpu_property(struct device_node *cpun,
-			const char *prop_name, int cpu, unsigned int *thread)
-{
-	const __be32 *cell;
-	int ac, prop_len, tid;
-	u64 hwid;
-
-	ac = of_n_addr_cells(cpun);
-	cell = of_get_property(cpun, prop_name, &prop_len);
-	if (!cell)
-		return false;
-	prop_len /= sizeof(*cell);
-	for (tid = 0; tid < prop_len; tid++) {
-		hwid = of_read_number(cell, ac);
-		if (arch_match_cpu_phys_id(cpu, hwid)) {
-			if (thread)
-				*thread = tid;
-			return true;
-		}
-		cell += ac;
-	}
-	return false;
-}
-
-/* Find the device node for a given logical cpu number, also returns the cpu
- * local thread number (index in ibm,interrupt-server#s) if relevant and
- * asked for (non NULL)
- */
-struct device_node *of_get_cpu_node(int cpu, unsigned int *thread)
-{
-	struct device_node *cpun, *cpus;
-
-	cpus = of_find_node_by_path("/cpus");
-	if (!cpus) {
-		pr_warn("Missing cpus node, bailing out\n");
-		return NULL;
-	}
-
-	for_each_child_of_node(cpus, cpun) {
-		if (of_node_cmp(cpun->type, "cpu"))
-			continue;
-
-		/* Check for non-standard "ibm,ppc-interrupt-server#s" property
-		 * for thread ids on PowerPC. If it doesn't exist fallback to
-		 * standard "reg" property.
-		 */
-		if (__of_find_n_match_cpu_property(cpun,
-				"ibm,ppc-interrupt-server#s", cpu, thread))
-			return cpun;
-
-		if (__of_find_n_match_cpu_property(cpun, "reg", cpu, thread))
-			return cpun;
-	}
-	return NULL;
-}
-EXPORT_SYMBOL(of_get_cpu_node);
-
 #if defined(CONFIG_DEBUG_FS) && defined(DEBUG)
 static struct debugfs_blob_wrapper flat_dt_blob;
 
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 5c54279..605afa9 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -18,6 +18,7 @@
  *      2 of the License, or (at your option) any later version.
  */
 #include <linux/ctype.h>
+#include <linux/cpu.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/spinlock.h>
@@ -230,6 +231,100 @@ const void *of_get_property(const struct device_node *np, const char *name,
 }
 EXPORT_SYMBOL(of_get_property);
 
+/*
+ * arch_match_cpu_phys_id - Match the given logical CPU and physical id
+ *
+ * @cpu: logical cpu index of a core/thread
+ * @phys_id: physical identifier of a core/thread
+ *
+ * CPU logical to physical index mapping is architecture specific.
+ * However this __weak function provides a default match of physical
+ * id to logical cpu index. phys_id provided here is usually values read
+ * from the device tree which must match the hardware internal registers.
+ *
+ * Returns true if the physical identifier and the logical cpu index
+ * correspond to the same core/thread, false otherwise.
+ */
+bool __weak arch_match_cpu_phys_id(int cpu, u64 phys_id)
+{
+	return (u32)phys_id == cpu;
+}
+
+/**
+ * Checks if the given "prop_name" property holds the physical id of the
+ * core/thread corresponding to the logical cpu 'cpu'. If 'thread' is not
+ * NULL, local thread number within the core is returned in it.
+ */
+static bool __of_find_n_match_cpu_property(struct device_node *cpun,
+			const char *prop_name, int cpu, unsigned int *thread)
+{
+	const __be32 *cell;
+	int ac, prop_len, tid;
+	u64 hwid;
+
+	ac = of_n_addr_cells(cpun);
+	cell = of_get_property(cpun, prop_name, &prop_len);
+	if (!cell)
+		return false;
+	prop_len /= sizeof(*cell);
+	for (tid = 0; tid < prop_len; tid++) {
+		hwid = of_read_number(cell, ac);
+		if (arch_match_cpu_phys_id(cpu, hwid)) {
+			if (thread)
+				*thread = tid;
+			return true;
+		}
+		cell += ac;
+	}
+	return false;
+}
+
+/**
+ * of_get_cpu_node - Get device node associated with the given logical CPU
+ *
+ * @cpu: CPU number(logical index) for which device node is required
+ * @thread: if not NULL, local thread number within the physical core is
+ *          returned
+ *
+ * The main purpose of this function is to retrieve the device node for the
+ * given logical CPU index. It should be used to initialize the of_node in
+ * cpu device. Once of_node in cpu device is populated, all the further
+ * references can use that instead.
+ *
+ * CPU logical to physical index mapping is architecture specific and is built
+ * before booting secondary cores. This function uses arch_match_cpu_phys_id
+ * which can be overridden by architecture specific implementation.
+ *
+ * Returns a node pointer for the logical cpu if found, else NULL.
+ */
+struct device_node *of_get_cpu_node(int cpu, unsigned int *thread)
+{
+	struct device_node *cpun, *cpus;
+
+	cpus = of_find_node_by_path("/cpus");
+	if (!cpus) {
+		pr_warn("Missing cpus node, bailing out\n");
+		return NULL;
+	}
+
+	for_each_child_of_node(cpus, cpun) {
+		if (of_node_cmp(cpun->type, "cpu"))
+			continue;
+		/* Check for non-standard "ibm,ppc-interrupt-server#s" property
+		 * for thread ids on PowerPC. If it doesn't exist fallback to
+		 * standard "reg" property.
+		 */
+		if (IS_ENABLED(CONFIG_PPC) &&
+			__of_find_n_match_cpu_property(cpun,
+				"ibm,ppc-interrupt-server#s", cpu, thread))
+			return cpun;
+		if (__of_find_n_match_cpu_property(cpun, "reg", cpu, thread))
+			return cpun;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(of_get_cpu_node);
+
 /** Checks if the given "compat" string matches one of the strings in
  * the device's "compatible" property
  */
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ab0eade..3dfed2b 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -28,6 +28,7 @@ struct cpu {
 extern int register_cpu(struct cpu *cpu, int num);
 extern struct device *get_cpu_device(unsigned cpu);
 extern bool cpu_is_hotpluggable(unsigned cpu);
+extern bool arch_match_cpu_phys_id(int cpu, u64 phys_id);
 
 extern int cpu_add_dev_attr(struct device_attribute *attr);
 extern void cpu_remove_dev_attr(struct device_attribute *attr);
diff --git a/include/linux/of.h b/include/linux/of.h
index 1fd08ca..c0bb2f1 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -266,6 +266,7 @@ extern int of_device_is_available(const struct device_node *device);
 extern const void *of_get_property(const struct device_node *node,
 				const char *name,
 				int *lenp);
+extern struct device_node *of_get_cpu_node(int cpu, unsigned int *thread);
 #define for_each_property_of_node(dn, pp) \
 	for (pp = dn->properties; pp != NULL; pp = pp->next)
 
@@ -459,6 +460,12 @@ static inline const void *of_get_property(const struct device_node *node,
 	return NULL;
 }
 
+static inline struct device_node *of_get_cpu_node(int cpu,
+					unsigned int *thread)
+{
+	return NULL;
+}
+
 static inline int of_property_read_u64(const struct device_node *np,
 				       const char *propname, u64 *out_value)
 {
-- 
1.8.1.2


