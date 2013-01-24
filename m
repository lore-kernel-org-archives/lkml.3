Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3AXQ7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 11:59:45 -0500
Received: from smtp.citrix.com ([66.165.176.89]:45154 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab3AXQ7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 11:59:44 -0500
X-SBRS: None
X-MesageID: 4957388
X-Ironport-Server: ftlpip01.citrite.net
X-Remote-IP: 75.150.106.249
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.84,530,1355097600"; 
   d="scan'208";a="4957388"
From: Ben Guthro <benjamin.guthro@citrix.com>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Cc: Ben Guthro <benjamin.guthro@citrix.com>
Subject: [PATCH] xen: Re-upload processor PM data to hypervisor after S3 resume
Date: Thu, 24 Jan 2013 11:59:19 -0500
Message-Id: <1359046759-11376-1-git-send-email-benjamin.guthro@citrix.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upon resume, it was found that ACPI C-states were missing from non-boot CPUs.
This change registers a syscore_ops handler for this case, and performs a
subset of the xen_acpi_processor_init() functionality to achieve this case.

Signed-Off-By: Ben Guthro <benjamin.guthro@citrix.com>
---
 drivers/xen/xen-acpi-processor.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
index 316df65..1510c64 100644
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
@@ -467,6 +468,26 @@ static void free_acpi_perf_data(void)
 	free_percpu(acpi_perf_data);
 }
 
+static void xen_acpi_processor_resume(void)
+{
+	int i;
+	printk(KERN_INFO "Resuming Xen processor info\n");
+
+	for_each_possible_cpu(i) {
+		struct acpi_processor *_pr;
+		_pr = per_cpu(processors, i /* APIC ID */);
+		if (!_pr)
+			continue;
+
+		__clear_bit(_pr->acpi_id, acpi_ids_done);
+		(void)upload_pm_data(_pr);
+	}
+}
+
+static struct syscore_ops xap_syscore_ops = {
+	.resume			= xen_acpi_processor_resume,
+};
+
 static int __init xen_acpi_processor_init(void)
 {
 	struct acpi_processor *pr_backup = NULL;
@@ -532,6 +553,8 @@ static int __init xen_acpi_processor_init(void)
 	if (rc)
 		goto err_unregister;
 
+	register_syscore_ops(&xap_syscore_ops);
+
 	return 0;
 err_unregister:
 	for_each_possible_cpu(i) {
@@ -550,6 +573,7 @@ static void __exit xen_acpi_processor_exit(void)
 	int i;
 
 	kfree(acpi_ids_done);
+	unregister_syscore_ops(&xap_syscore_ops);
 	for_each_possible_cpu(i) {
 		struct acpi_processor_performance *perf;
 		perf = per_cpu_ptr(acpi_perf_data, i);
-- 
1.7.9.5

