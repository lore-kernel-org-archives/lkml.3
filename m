Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaDDCUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 22:20:23 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:34143 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaDDCRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 22:17:46 -0400
From: Alex Elder <elder@linaro.org>
To: mporter@linaro.org, bcm@fixthebug.org, devicetree@vger.kernel.org,
        arnd@arndb.de, sboyd@codeaurora.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ARM: introduce CPU_METHOD_OF_DECLARE_SETUP()
Date: Thu,  3 Apr 2014 21:18:07 -0500
Message-Id: <1396577891-2713-2-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396577891-2713-1-git-send-email-elder@linaro.org>
References: <1396577891-2713-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU_METHOD_OF_DECLARE() macro allows methods for assigning
SMP/hotplug operations to CPUS to be defined using device tree,
without the need for machine-dependent code.

And although it allows the *method* to be specified, it does *not*
allow any parameterization of that method.  For example, there is no
efficient way to define a machine-specific address or other
property one might want to define for secondary CPUs.

Define a new of_cpu_method->setup() function, which (if defined) is
called for nodes found having a matching "enable-method" property.
The matching node is supplied as the function's argument, allowing
additional required information to be extracted from that node.
A new macro CPU_METHOD_OF_DECLARE_SETUP() allows a setup method
to be supplied when a method is declared.

Extend the interface for set_smp_ops_by_method() so that it can
return a negative error code to allow DT parsing errors to be
reported by the setup function.

(Note that only the first "cpu" (or "cpus") node having a matching
method is used by set_smp_ops_by_method(); this logic is not
changed.)

Signed-off-by: Alex Elder <elder@linaro.org>
---
 arch/arm/include/asm/smp.h |   10 ++++++++--
 arch/arm/kernel/devtree.c  |   31 +++++++++++++++++++++++++------
 2 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index 2ec765c..ab4a5a9 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -115,15 +115,21 @@ struct smp_operations {
 #endif
 };
 
+struct device_node;
 struct of_cpu_method {
 	const char *method;
+	int (*setup)(struct device_node *node);
 	struct smp_operations *ops;
 };
 
-#define CPU_METHOD_OF_DECLARE(name, _method, _ops)			\
+#define CPU_METHOD_OF_DECLARE_SETUP(name, _method, _setup, _ops)	\
 	static const struct of_cpu_method __cpu_method_of_table_##name	\
 		__used __section(__cpu_method_of_table)			\
-		= { .method = _method, .ops = _ops }
+		= { .method = _method, .setup = _setup, .ops = _ops }
+
+#define CPU_METHOD_OF_DECLARE(name, _method, _ops)			\
+	CPU_METHOD_OF_DECLARE_SETUP(name, _method, NULL, _ops)
+
 /*
  * set platform specific SMP operations
  */
diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index c7419a5..1a0cca3 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -76,11 +76,18 @@ static int __init set_smp_ops_by_method(struct device_node *node)
 	if (of_property_read_string(node, "enable-method", &method))
 		return 0;
 
-	for (; m < __cpu_method_of_table_end; m++)
+	for (; m < __cpu_method_of_table_end; m++) {
 		if (!strcmp(m->method, method)) {
-			smp_set_ops(m->ops);
-			return 1;
+			int ret = 0;
+
+			if (m->setup)
+				ret = m->setup(node);
+			if (!ret)
+				smp_set_ops(m->ops);
+
+			return ret ? ret : 1;
 		}
+	}
 
 	return 0;
 }
@@ -181,16 +188,28 @@ void __init arm_dt_init_cpu_maps(void)
 
 		tmp_map[i] = hwid;
 
-		if (!found_method)
+		if (!found_method) {
 			found_method = set_smp_ops_by_method(cpu);
+			if (WARN(found_method < 0,
+					"error %d getting enable-method for "
+					"DT /cpu %u\n", found_method, cpuidx)) {
+				return;
+			}
+		}
 	}
 
 	/*
 	 * Fallback to an enable-method in the cpus node if nothing found in
 	 * a cpu node.
 	 */
-	if (!found_method)
-		set_smp_ops_by_method(cpus);
+	if (!found_method) {
+		found_method = set_smp_ops_by_method(cpus);
+		if (WARN(found_method < 0,
+				"error %d getting enable-method for "
+				"DT /cpus node\n", found_method)) {
+			return;
+		}
+	}
 
 	if (!bootcpu_valid) {
 		pr_warn("DT missing boot CPU MPIDR[23:0], fall back to default cpu_logical_map\n");
-- 
1.7.9.5

