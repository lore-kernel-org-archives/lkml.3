Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbbAUTCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:02:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbbAUTCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:02:21 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 3/3] Drivers: hv: vmbus: teardown hv_vmbus_con workqueue and vmbus_connection pages on shutdown
Date: Wed, 21 Jan 2015 20:02:09 +0100
Message-Id: <1421866929-20167-4-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1421866929-20167-1-git-send-email-vkuznets@redhat.com>
References: <1421866929-20167-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to destroy hv_vmbus_con on module shutdown, otherwise the following
crash is sometimes observed:

[   76.569845] hv_vmbus: Hyper-V Host Build:9600-6.3-17-0.17039; Vmbus version:3.0
[   82.598859] BUG: unable to handle kernel paging request at ffffffffa0003480
[   82.599287] IP: [<ffffffffa0003480>] 0xffffffffa0003480
[   82.599287] PGD 1f34067 PUD 1f35063 PMD 3f72d067 PTE 0
[   82.599287] Oops: 0010 [#1] SMP
[   82.599287] Modules linked in: [last unloaded: hv_vmbus]
[   82.599287] CPU: 0 PID: 26 Comm: kworker/0:1 Not tainted 3.19.0-rc5_bug923184+ #488
[   82.599287] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v1.0 11/26/2012
[   82.599287] Workqueue: hv_vmbus_con 0xffffffffa0003480
[   82.599287] task: ffff88007b6ddfa0 ti: ffff88007f8f8000 task.ti: ffff88007f8f8000
[   82.599287] RIP: 0010:[<ffffffffa0003480>]  [<ffffffffa0003480>] 0xffffffffa0003480
[   82.599287] RSP: 0018:ffff88007f8fbe00  EFLAGS: 00010202
...

To avoid memory leaks we need to free monitor_pages and int_page for
vmbus_connection. Implement vmbus_disconnect() function by separating cleanup
path from vmbus_connect().

As we use hv_vmbus_con to release channels (see free_channel() in channel_mgmt.c)
we need to make sure the work was done before we remove the queue, do that with
drain_workqueue(). We also need to avoid handling messages  which can (potentially)
create new channels, so set vmbus_connection.conn_state = DISCONNECTED at the very
beginning of vmbus_exit() and check for that in vmbus_onmessage_work().

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/connection.c   | 17 ++++++++++++-----
 drivers/hv/hyperv_vmbus.h |  1 +
 drivers/hv/vmbus_drv.c    |  6 ++++++
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index e206619..2fce0c7 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -214,10 +214,21 @@ int vmbus_connect(void)
 
 cleanup:
 	pr_err("Unable to connect to host\n");
+
 	vmbus_connection.conn_state = DISCONNECTED;
+	vmbus_disconnect();
+
+	kfree(msginfo);
+
+	return ret;
+}
 
-	if (vmbus_connection.work_queue)
+void vmbus_disconnect(void)
+{
+	if (vmbus_connection.work_queue) {
+		drain_workqueue(vmbus_connection.work_queue);
 		destroy_workqueue(vmbus_connection.work_queue);
+	}
 
 	if (vmbus_connection.int_page) {
 		free_pages((unsigned long)vmbus_connection.int_page, 0);
@@ -228,10 +239,6 @@ cleanup:
 	free_pages((unsigned long)vmbus_connection.monitor_pages[1], 0);
 	vmbus_connection.monitor_pages[0] = NULL;
 	vmbus_connection.monitor_pages[1] = NULL;
-
-	kfree(msginfo);
-
-	return ret;
 }
 
 /*
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index c386d8d..e01c13e 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -671,6 +671,7 @@ void vmbus_free_channels(void);
 /* Connection interface */
 
 int vmbus_connect(void);
+void vmbus_disconnect(void);
 
 int vmbus_post_msg(void *buffer, size_t buflen);
 
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index b06cb87..e647505 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -572,6 +572,10 @@ static void vmbus_onmessage_work(struct work_struct *work)
 {
 	struct onmessage_work_context *ctx;
 
+	/* Do not process messages if we're in DISCONNECTED state */
+	if (vmbus_connection.conn_state == DISCONNECTED)
+		return;
+
 	ctx = container_of(work, struct onmessage_work_context,
 			   work);
 	vmbus_onmessage(&ctx->msg);
@@ -969,11 +973,13 @@ cleanup:
 
 static void __exit vmbus_exit(void)
 {
+	vmbus_connection.conn_state = DISCONNECTED;
 	hv_remove_vmbus_irq();
 	vmbus_free_channels();
 	bus_unregister(&hv_bus);
 	hv_cleanup();
 	acpi_bus_unregister_driver(&vmbus_acpi_driver);
+	vmbus_disconnect();
 }
 
 
-- 
1.9.3

