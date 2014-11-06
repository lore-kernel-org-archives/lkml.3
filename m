Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaKFSYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:24:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:34219 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbaKFSXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:23:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,327,1413270000"; 
   d="scan'208";a="603639348"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Cc: Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Noor U Mubeen <noor.u.mubeen@intel.com>,
        Ajay Thomas <ajay.thomas.david.rajamanickam@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 1/3] powercap/rapl: abstract per cpu type functions
Date: Thu,  6 Nov 2014 10:22:35 -0800
Message-Id: <1415298157-7615-2-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415298157-7615-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1415298157-7615-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RAPL implementations may vary slightly between Core and Atom CPUs. There are
also potential differences among generations of CPUs within the family.

This patch adds a per model structure to abstract the differences such that
variations can be handled cleanly.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/powercap/intel_rapl.c | 45 +++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
index 45e05b3..256efed 100644
--- a/drivers/powercap/intel_rapl.c
+++ b/drivers/powercap/intel_rapl.c
@@ -188,6 +188,15 @@ struct rapl_package {
 					*/
 	struct list_head plist;
 };
+
+struct rapl_defaults {
+	int (*check_unit)(struct rapl_package *rp, int cpu);
+	void (*set_floor_freq)(struct rapl_domain *rd, bool mode);
+	u64 (*compute_time_window)(struct rapl_package *rp, u64 val,
+				bool to_raw);
+};
+static struct rapl_defaults *rapl_defaults;
+
 #define PACKAGE_PLN_INT_SAVED   BIT(0)
 #define MAX_PRIM_NAME (32)
 
@@ -946,16 +955,28 @@ static void package_power_limit_irq_restore(int package_id)
 	wrmsr_on_cpu(cpu, MSR_IA32_PACKAGE_THERM_INTERRUPT, l, h);
 }
 
+static const struct rapl_defaults rapl_defaults_core = {
+};
+
+static const struct rapl_defaults rapl_defaults_atom = {
+};
+
+#define RAPL_CPU(_model, _ops) {			\
+		.vendor = X86_VENDOR_INTEL,		\
+		.family = 6,				\
+		.model = _model,			\
+		.driver_data = (kernel_ulong_t)&_ops,	\
+		}
+
 static const struct x86_cpu_id rapl_ids[] = {
-	{ X86_VENDOR_INTEL, 6, 0x2a},/* Sandy Bridge */
-	{ X86_VENDOR_INTEL, 6, 0x2d},/* Sandy Bridge EP */
-	{ X86_VENDOR_INTEL, 6, 0x37},/* Valleyview */
-	{ X86_VENDOR_INTEL, 6, 0x3a},/* Ivy Bridge */
-	{ X86_VENDOR_INTEL, 6, 0x3c},/* Haswell */
-	{ X86_VENDOR_INTEL, 6, 0x3d},/* Broadwell */
-	{ X86_VENDOR_INTEL, 6, 0x3f},/* Haswell */
-	{ X86_VENDOR_INTEL, 6, 0x45},/* Haswell ULT */
-	/* TODO: Add more CPU IDs after testing */
+	RAPL_CPU(0x2a, rapl_defaults_core),/* Sandy Bridge */
+	RAPL_CPU(0x2d, rapl_defaults_core),/* Sandy Bridge EP */
+	RAPL_CPU(0x37, rapl_defaults_atom),/* Valleyview */
+	RAPL_CPU(0x3a, rapl_defaults_core),/* Ivy Bridge */
+	RAPL_CPU(0x3c, rapl_defaults_core),/* Haswell */
+	RAPL_CPU(0x3d, rapl_defaults_core),/* Broadwell */
+	RAPL_CPU(0x3f, rapl_defaults_core),/* Haswell */
+	RAPL_CPU(0x45, rapl_defaults_core),/* Haswell ULT */
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, rapl_ids);
@@ -1358,14 +1379,18 @@ static struct notifier_block rapl_cpu_notifier = {
 static int __init rapl_init(void)
 {
 	int ret = 0;
+	const struct x86_cpu_id *id;
 
-	if (!x86_match_cpu(rapl_ids)) {
+	id = x86_match_cpu(rapl_ids);
+	if (!id) {
 		pr_err("driver does not support CPU family %d model %d\n",
 			boot_cpu_data.x86, boot_cpu_data.x86_model);
 
 		return -ENODEV;
 	}
 
+	rapl_defaults = (struct rapl_defaults *)id->driver_data;
+
 	cpu_notifier_register_begin();
 
 	/* prevent CPU hotplug during detection */
-- 
1.9.1

