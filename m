Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966267Ab3DQNTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 09:19:04 -0400
Received: from smtp.citrix.com ([66.165.176.89]:54359 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965813Ab3DQNTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 09:19:01 -0400
X-IronPort-AV: E=Sophos;i="4.87,492,1363132800"; 
   d="scan'208";a="19929563"
From: Ben Guthro <benjamin.guthro@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>
CC: Ben Guthro <benjamin.guthro@citrix.com>
Subject: [PATCH] xen: Re-upload processor PM data to hypervisor after S3 resume (v2)
Date: Wed, 17 Apr 2013 09:18:49 -0400
Message-ID: <1366204729-20350-1-git-send-email-benjamin.guthro@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.241.11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upon resume, it was found that ACPI C-states were missing from non-boot CPUs.
This change registers a syscore_ops handler for this case, and re-uploads the
PM information to the hypervisor to properly reset the C-state on these
processors.

v2:
v1 did not go through the check_acpi_ids() code-path, and missed some cases when
xen was running with the dom0_max_vcpus= command line parameter.

Signed-Off-By: Ben Guthro <benjamin.guthro@citrix.com>
---
 drivers/xen/xen-acpi-processor.c |   78 ++++++++++++++++++++++++++------------
 1 file changed, 53 insertions(+), 25 deletions(-)

diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
index 90e34ac..86b6f69 100644
--- a/drivers/xen/xen-acpi-processor.c
+++ b/drivers/xen/xen-acpi-processor.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/syscore_ops.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include <acpi/processor.h>
@@ -51,9 +52,9 @@ static DEFINE_MUTEX(acpi_ids_mutex);
 /* Which ACPI ID we have processed from 'struct acpi_processor'. */
 static unsigned long *acpi_ids_done;
 /* Which ACPI ID exist in the SSDT/DSDT processor definitions. */
-static unsigned long __initdata *acpi_id_present;
+static unsigned long *acpi_id_present;
 /* And if there is an _CST definition (or a PBLK) for the ACPI IDs */
-static unsigned long __initdata *acpi_id_cst_present;
+static unsigned long *acpi_id_cst_present;
 
 static int push_cxx_to_hypervisor(struct acpi_processor *_pr)
 {
@@ -390,6 +391,10 @@ static int __init check_acpi_ids(struct acpi_processor *pr_backup)
 	if (!pr_backup)
 		return -ENODEV;
 
+	if (acpi_id_present && acpi_id_cst_present)
+		/* OK, done this once .. skip to uploading */
+		goto upload;
+
 	/* All online CPUs have been processed at this stage. Now verify
 	 * whether in fact "online CPUs" == physical CPUs.
 	 */
@@ -408,6 +413,7 @@ static int __init check_acpi_ids(struct acpi_processor *pr_backup)
 			    read_acpi_id, NULL, NULL, NULL);
 	acpi_get_devices("ACPI0007", read_acpi_id, NULL, NULL);
 
+upload:
 	if (!bitmap_equal(acpi_id_present, acpi_ids_done, nr_acpi_bits)) {
 		unsigned int i;
 		for_each_set_bit(i, acpi_id_present, nr_acpi_bits) {
@@ -417,10 +423,7 @@ static int __init check_acpi_ids(struct acpi_processor *pr_backup)
 			(void)upload_pm_data(pr_backup);
 		}
 	}
-	kfree(acpi_id_present);
-	acpi_id_present = NULL;
-	kfree(acpi_id_cst_present);
-	acpi_id_cst_present = NULL;
+
 	return 0;
 }
 static int __init check_prereq(void)
@@ -467,10 +470,47 @@ static void free_acpi_perf_data(void)
 	free_percpu(acpi_perf_data);
 }
 
-static int __init xen_acpi_processor_init(void)
+static int xen_upload_processor_pm_data(void)
 {
 	struct acpi_processor *pr_backup = NULL;
 	unsigned int i;
+	int rc = 0;
+
+	printk(KERN_INFO "Uploading Xen processor pm info\n");
+
+	for_each_possible_cpu(i) {
+		struct acpi_processor *_pr;
+		_pr = per_cpu(processors, i /* APIC ID */);
+		if (!_pr)
+			continue;
+
+		if (!pr_backup) {
+			pr_backup = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
+			if (pr_backup)
+				memcpy(pr_backup, _pr, sizeof(struct acpi_processor));
+		}
+		(void)upload_pm_data(_pr);
+	}
+
+	rc = check_acpi_ids(pr_backup);
+	kfree(pr_backup);
+
+	return rc;
+}
+
+static void xen_acpi_processor_resume(void)
+{
+	bitmap_zero(acpi_ids_done, nr_acpi_bits);
+	xen_upload_processor_pm_data();
+}
+
+static struct syscore_ops xap_syscore_ops = {
+	.resume			= xen_acpi_processor_resume,
+};
+
+static int __init xen_acpi_processor_init(void)
+{
+	unsigned int i;
 	int rc = check_prereq();
 
 	if (rc)
@@ -514,27 +554,12 @@ static int __init xen_acpi_processor_init(void)
 			goto err_out;
 	}
 
-	for_each_possible_cpu(i) {
-		struct acpi_processor *_pr;
-		_pr = per_cpu(processors, i /* APIC ID */);
-		if (!_pr)
-			continue;
-
-		if (!pr_backup) {
-			pr_backup = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
-			if (pr_backup)
-				memcpy(pr_backup, _pr, sizeof(struct acpi_processor));
-		}
-		(void)upload_pm_data(_pr);
-	}
-	rc = check_acpi_ids(pr_backup);
-
-	kfree(pr_backup);
-	pr_backup = NULL;
-
+	rc = xen_upload_processor_pm_data();
 	if (rc)
 		goto err_unregister;
 
+	register_syscore_ops(&xap_syscore_ops);
+
 	return 0;
 err_unregister:
 	for_each_possible_cpu(i) {
@@ -552,7 +577,10 @@ static void __exit xen_acpi_processor_exit(void)
 {
 	int i;
 
+	unregister_syscore_ops(&xap_syscore_ops);
 	kfree(acpi_ids_done);
+	kfree(acpi_id_present);
+	kfree(acpi_id_cst_present);
 	for_each_possible_cpu(i) {
 		struct acpi_processor_performance *perf;
 		perf = per_cpu_ptr(acpi_perf_data, i);
-- 
1.7.9.5

