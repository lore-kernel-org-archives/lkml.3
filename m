Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaBCKga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:36:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbaBCKg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:36:27 -0500
Date: Mon, 3 Feb 2014 11:12:16 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Rientjes <rientjes@google.com>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, Ben Guthro <benjamin.guthro@citrix.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        xen-devel@lists.xensource.com
Subject: Re: [BUG?] Interrupts enabled after
 xen_acpi_processor_resume+0x0/0x34 [xen_acpi_processor]
Message-ID: <20140203101215.GA1725@redhat.com>
References: <20140128150848.GA1428@redhat.com>
 <20140128160404.GA5732@phenom.dumpdata.com>
 <alpine.DEB.2.02.1401282120180.20167@chino.kir.corp.google.com>
 <20140129082521.GA1362@redhat.com>
 <20140131160140.GC23648@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140131160140.GC23648@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 11:01:40AM -0500, Konrad Rzeszutek Wilk wrote:
> Perhaps by using 'subsys_system_register' and stick it there?

This will not call ->resume callback as it is only called for
devices, so additional dummy device is needed, for example:

struct device xap_dev = {
        .init_name = "xen-acpi-processor-dev",
        .bus = &xap_bus,
};
...
subsys_system_register(&xap_bus, NULL);
device_register(&xap_dev);

But I'm not sure if that is good solution. It crate some not necessery
sysfs directories and files. Additionaly it can restore CPU C-states
after some other drivers resume, which prehaps require proper C-states.

Hence maybe adding direct notify from xen core resume will be better
idea (proposed patch below). Plese let me know what you think, I'll
provide solution which you choose to bug reporters for testing.

Thanks
Stanislaw

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 624e8dc..96e4173 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -13,6 +13,7 @@
 #include <linux/freezer.h>
 #include <linux/syscore_ops.h>
 #include <linux/export.h>
+#include <linux/notifier.h>
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
@@ -46,6 +47,20 @@ struct suspend_info {
 	void (*post)(int cancelled);
 };
 
+static RAW_NOTIFIER_HEAD(xen_resume_notifier);
+
+void xen_resume_notifier_register(struct notifier_block *nb)
+{
+	raw_notifier_chain_register(&xen_resume_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(xen_resume_notifier_register);
+
+void xen_resume_notifier_unregister(struct notifier_block *nb)
+{
+	raw_notifier_chain_unregister(&xen_resume_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(xen_resume_notifier_unregister);
+
 #ifdef CONFIG_HIBERNATE_CALLBACKS
 static void xen_hvm_post_suspend(int cancelled)
 {
@@ -152,6 +167,8 @@ static void do_suspend(void)
 
 	err = stop_machine(xen_suspend, &si, cpumask_of(0));
 
+	raw_notifier_call_chain(&xen_resume_notifier, 0, NULL);
+
 	dpm_resume_start(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
 
 	if (err) {
diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
index 7231859..82358d1 100644
--- a/drivers/xen/xen-acpi-processor.c
+++ b/drivers/xen/xen-acpi-processor.c
@@ -27,10 +27,10 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/syscore_ops.h>
 #include <linux/acpi.h>
 #include <acpi/processor.h>
 #include <xen/xen.h>
+#include <xen/xen-ops.h>
 #include <xen/interface/platform.h>
 #include <asm/xen/hypercall.h>
 
@@ -495,14 +495,15 @@ static int xen_upload_processor_pm_data(void)
 	return rc;
 }
 
-static void xen_acpi_processor_resume(void)
+static int xen_acpi_processor_resume(struct notifier_block *nb,
+				     unsigned long action, void *data)
 {
 	bitmap_zero(acpi_ids_done, nr_acpi_bits);
-	xen_upload_processor_pm_data();
+	return xen_upload_processor_pm_data();
 }
 
-static struct syscore_ops xap_syscore_ops = {
-	.resume	= xen_acpi_processor_resume,
+struct notifier_block xen_acpi_processor_resume_nb = {
+	.notifier_call = xen_acpi_processor_resume,
 };
 
 static int __init xen_acpi_processor_init(void)
@@ -555,7 +556,7 @@ static int __init xen_acpi_processor_init(void)
 	if (rc)
 		goto err_unregister;
 
-	register_syscore_ops(&xap_syscore_ops);
+	xen_resume_notifier_register(&xen_acpi_processor_resume_nb);
 
 	return 0;
 err_unregister:
@@ -574,7 +575,7 @@ static void __exit xen_acpi_processor_exit(void)
 {
 	int i;
 
-	unregister_syscore_ops(&xap_syscore_ops);
+	xen_resume_notifier_unregister(&xen_acpi_processor_resume_nb);
 	kfree(acpi_ids_done);
 	kfree(acpi_id_present);
 	kfree(acpi_id_cst_present);
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index fb2ea8f..6412358 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -16,6 +16,9 @@ void xen_mm_unpin_all(void);
 void xen_timer_resume(void);
 void xen_arch_resume(void);
 
+void xen_resume_notifier_register(struct notifier_block *nb);
+void xen_resume_notifier_unregister(struct notifier_block *nb);
+
 int xen_setup_shutdown_event(void);
 
 extern unsigned long *xen_contiguous_bitmap;
