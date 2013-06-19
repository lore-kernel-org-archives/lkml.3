Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206Ab3FSDix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 23:38:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933861Ab3FSDiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 23:38:51 -0400
From: Jason Wang <jasowang@redhat.com>
To: kys@microsoft.com, haiyangz@microsoft.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH] drivers: hv: allocate synic structures before hv_synic_init()
Date: Wed, 19 Jun 2013 11:28:10 +0800
Message-Id: <1371612490-28748-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently allocate synic structures in hv_sync_init(), but there's no way for
the driver to know about the allocation failure and it may continue to use the
uninitialized pointers. Solve this by introducing helpers for allocating and
freeing and doing the allocation before the on_each_cpu() call in
vmbus_bus_init().

Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/hv/hv.c           |   85 ++++++++++++++++++++++++++++-----------------
 drivers/hv/hyperv_vmbus.h |    4 ++
 drivers/hv/vmbus_drv.c    |    8 +++-
 3 files changed, 63 insertions(+), 34 deletions(-)

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 3f88681..0039373 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -265,6 +265,59 @@ u16 hv_signal_event(void *con_id)
 	return status;
 }
 
+
+int hv_synic_alloc(void)
+{
+	size_t size = sizeof(struct tasklet_struct);
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		hv_context.event_dpc[cpu] = kmalloc(size, GFP_ATOMIC);
+		if (hv_context.event_dpc[cpu] == NULL) {
+			pr_err("Unable to allocate event dpc\n");
+			goto err;
+		}
+		tasklet_init(hv_context.event_dpc[cpu], vmbus_on_event, cpu);
+
+		hv_context.synic_message_page[cpu] =
+			(void *)get_zeroed_page(GFP_ATOMIC);
+
+		if (hv_context.synic_message_page[cpu] == NULL) {
+			pr_err("Unable to allocate SYNIC message page\n");
+			goto err;
+		}
+
+		hv_context.synic_event_page[cpu] =
+			(void *)get_zeroed_page(GFP_ATOMIC);
+
+		if (hv_context.synic_event_page[cpu] == NULL) {
+			pr_err("Unable to allocate SYNIC event page\n");
+			goto err;
+		}
+	}
+
+	return 0;
+err:
+	return -ENOMEM;
+}
+
+void hv_synic_free_cpu(int cpu)
+{
+	kfree(hv_context.event_dpc[cpu]);
+	if (hv_context.synic_message_page[cpu])
+		free_page((unsigned long)hv_context.synic_event_page[cpu]);
+	if (hv_context.synic_message_page[cpu])
+		free_page((unsigned long)hv_context.synic_message_page[cpu]);
+}
+
+void hv_synic_free(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		hv_synic_free_cpu(cpu);
+}
+
 /*
  * hv_synic_init - Initialize the Synthethic Interrupt Controller.
  *
@@ -289,30 +342,6 @@ void hv_synic_init(void *arg)
 	/* Check the version */
 	rdmsrl(HV_X64_MSR_SVERSION, version);
 
-	hv_context.event_dpc[cpu] = kmalloc(sizeof(struct tasklet_struct),
-					    GFP_ATOMIC);
-	if (hv_context.event_dpc[cpu] == NULL) {
-		pr_err("Unable to allocate event dpc\n");
-		goto cleanup;
-	}
-	tasklet_init(hv_context.event_dpc[cpu], vmbus_on_event, cpu);
-
-	hv_context.synic_message_page[cpu] =
-		(void *)get_zeroed_page(GFP_ATOMIC);
-
-	if (hv_context.synic_message_page[cpu] == NULL) {
-		pr_err("Unable to allocate SYNIC message page\n");
-		goto cleanup;
-	}
-
-	hv_context.synic_event_page[cpu] =
-		(void *)get_zeroed_page(GFP_ATOMIC);
-
-	if (hv_context.synic_event_page[cpu] == NULL) {
-		pr_err("Unable to allocate SYNIC event page\n");
-		goto cleanup;
-	}
-
 	/* Setup the Synic's message page */
 	rdmsrl(HV_X64_MSR_SIMP, simp.as_uint64);
 	simp.simp_enabled = 1;
@@ -355,14 +384,6 @@ void hv_synic_init(void *arg)
 	rdmsrl(HV_X64_MSR_VP_INDEX, vp_index);
 	hv_context.vp_index[cpu] = (u32)vp_index;
 	return;
-
-cleanup:
-	if (hv_context.synic_event_page[cpu])
-		free_page((unsigned long)hv_context.synic_event_page[cpu]);
-
-	if (hv_context.synic_message_page[cpu])
-		free_page((unsigned long)hv_context.synic_message_page[cpu]);
-	return;
 }
 
 /*
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 12f2f9e..d84918f 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -527,6 +527,10 @@ extern int hv_post_message(union hv_connection_id connection_id,
 
 extern u16 hv_signal_event(void *con_id);
 
+extern int hv_synic_alloc(void);
+
+extern void hv_synic_free(void);
+
 extern void hv_synic_init(void *irqarg);
 
 extern void hv_synic_cleanup(void *arg);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 4004e54..a2464bf 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -563,6 +563,9 @@ static int vmbus_bus_init(int irq)
 	 */
 	hv_register_vmbus_handler(irq, vmbus_isr);
 
+	ret = hv_synic_alloc();
+	if (ret)
+		goto err_alloc;
 	/*
 	 * Initialize the per-cpu interrupt state and
 	 * connect to the host.
@@ -570,13 +573,14 @@ static int vmbus_bus_init(int irq)
 	on_each_cpu(hv_synic_init, NULL, 1);
 	ret = vmbus_connect();
 	if (ret)
-		goto err_irq;
+		goto err_alloc;
 
 	vmbus_request_offers();
 
 	return 0;
 
-err_irq:
+err_alloc:
+	hv_synic_free();
 	free_irq(irq, hv_acpi_dev);
 
 err_unregister:
-- 
1.7.1

