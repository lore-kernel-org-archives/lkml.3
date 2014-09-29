Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaI2Ovg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:51:36 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27186 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbaI2Ove (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:51:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: sgruszka@redhat.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] Revert "xen/acpi-processor: fix enabling interrupts on syscore_resume"
Date: Mon, 29 Sep 2014 10:51:16 -0400
Message-Id: <1412002276-30873-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit cd979883b9ede90643e019f33cb317933eb867b4.

As it actually never gets called on the initial domain when
resuming. That is after we suspend and go in resume, the
do_suspend (from manage.c) is never called (it is if it
was running as a guest)- so the 'resume' functionality of the driver
was never called.

Which means that this whole patch was pointless (well, it did
remove the WARNING splat).

This patch reverts the patch and allows the C and P states to
be uploaded to the hypervisor on ACPI S3 resume of the
initial domain. It sadly brings back the WARNING splat which
will have to be dealt with at some point.

CC: <sgruszka@redhat.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/manage.c             | 16 ----------------
 drivers/xen/xen-acpi-processor.c | 15 +++++++--------
 include/xen/xen-ops.h            |  4 ----
 3 files changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index f8bb36f..05d4126 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -43,20 +43,6 @@ struct suspend_info {
 	int cancelled;
 };
 
-static RAW_NOTIFIER_HEAD(xen_resume_notifier);
-
-void xen_resume_notifier_register(struct notifier_block *nb)
-{
-	raw_notifier_chain_register(&xen_resume_notifier, nb);
-}
-EXPORT_SYMBOL_GPL(xen_resume_notifier_register);
-
-void xen_resume_notifier_unregister(struct notifier_block *nb)
-{
-	raw_notifier_chain_unregister(&xen_resume_notifier, nb);
-}
-EXPORT_SYMBOL_GPL(xen_resume_notifier_unregister);
-
 #ifdef CONFIG_HIBERNATE_CALLBACKS
 static int xen_suspend(void *data)
 {
@@ -133,8 +119,6 @@ static void do_suspend(void)
 	if (!si.cancelled)
 		xen_console_resume();
 
-	raw_notifier_call_chain(&xen_resume_notifier, 0, NULL);
-
 	dpm_resume_start(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
 
 	if (err) {
diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
index 59fc190..2d727ab 100644
--- a/drivers/xen/xen-acpi-processor.c
+++ b/drivers/xen/xen-acpi-processor.c
@@ -27,10 +27,10 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/syscore_ops.h>
 #include <linux/acpi.h>
 #include <acpi/processor.h>
 #include <xen/xen.h>
-#include <xen/xen-ops.h>
 #include <xen/interface/platform.h>
 #include <asm/xen/hypercall.h>
 
@@ -495,15 +495,14 @@ static int xen_upload_processor_pm_data(void)
 	return rc;
 }
 
-static int xen_acpi_processor_resume(struct notifier_block *nb,
-				     unsigned long action, void *data)
+static void xen_acpi_processor_resume(void)
 {
 	bitmap_zero(acpi_ids_done, nr_acpi_bits);
-	return xen_upload_processor_pm_data();
+	xen_upload_processor_pm_data();
 }
 
-struct notifier_block xen_acpi_processor_resume_nb = {
-	.notifier_call = xen_acpi_processor_resume,
+static struct syscore_ops xap_syscore_ops = {
+	.resume	= xen_acpi_processor_resume,
 };
 
 static int __init xen_acpi_processor_init(void)
@@ -556,7 +555,7 @@ static int __init xen_acpi_processor_init(void)
 	if (rc)
 		goto err_unregister;
 
-	xen_resume_notifier_register(&xen_acpi_processor_resume_nb);
+	register_syscore_ops(&xap_syscore_ops);
 
 	return 0;
 err_unregister:
@@ -575,7 +574,7 @@ static void __exit xen_acpi_processor_exit(void)
 {
 	int i;
 
-	xen_resume_notifier_unregister(&xen_acpi_processor_resume_nb);
+	unregister_syscore_ops(&xap_syscore_ops);
 	kfree(acpi_ids_done);
 	kfree(acpi_id_present);
 	kfree(acpi_id_cst_present);
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 7491ee5..b4637b8 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -2,7 +2,6 @@
 #define INCLUDE_XEN_OPS_H
 
 #include <linux/percpu.h>
-#include <linux/notifier.h>
 #include <linux/efi.h>
 #include <asm/xen/interface.h>
 
@@ -14,9 +13,6 @@ void xen_arch_post_suspend(int suspend_cancelled);
 void xen_timer_resume(void);
 void xen_arch_resume(void);
 
-void xen_resume_notifier_register(struct notifier_block *nb);
-void xen_resume_notifier_unregister(struct notifier_block *nb);
-
 int xen_setup_shutdown_event(void);
 
 extern unsigned long *xen_contiguous_bitmap;
-- 
1.9.3

