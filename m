Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbbA0Wfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:35:55 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:58502
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932955AbbA0Wde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:33:34 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        vkuznets@redhat.com, tglx@linutronix.de
Cc: Vitaly Kuznetsov 
	<"[mailto:vkuznets@redhat.com]"@linuxonhyperv.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 2/8] Drivers: hv: vmbus: rename channel work queues
Date: Tue, 27 Jan 2015 15:46:42 -0800
Message-Id: <1422402408-5504-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1422402408-5504-1-git-send-email-kys@microsoft.com>
References: <1422402376-5463-1-git-send-email-kys@microsoft.com>
 <1422402408-5504-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Kuznetsov <[mailto:vkuznets@redhat.com]>

All channel work queues are named 'hv_vmbus_ctl', this makes them
indistinguishable in ps output and makes it hard to link to the corresponding
vmbus device. Rename them to hv_vmbus_ctl/N and make vmbus device names match,
e.g. now vmbus_1 device is served by hv_vmbus_ctl/1 work queue.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/channel_mgmt.c |    5 ++++-
 drivers/hv/vmbus_drv.c    |    6 ++----
 include/linux/hyperv.h    |    3 +++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 3736f71..ba4b25f 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -139,19 +139,22 @@ EXPORT_SYMBOL_GPL(vmbus_prep_negotiate_resp);
  */
 static struct vmbus_channel *alloc_channel(void)
 {
+	static atomic_t chan_num = ATOMIC_INIT(0);
 	struct vmbus_channel *channel;
 
 	channel = kzalloc(sizeof(*channel), GFP_ATOMIC);
 	if (!channel)
 		return NULL;
 
+	channel->id = atomic_inc_return(&chan_num);
 	spin_lock_init(&channel->inbound_lock);
 	spin_lock_init(&channel->lock);
 
 	INIT_LIST_HEAD(&channel->sc_list);
 	INIT_LIST_HEAD(&channel->percpu_list);
 
-	channel->controlwq = create_workqueue("hv_vmbus_ctl");
+	channel->controlwq = alloc_workqueue("hv_vmbus_ctl/%d", WQ_MEM_RECLAIM,
+					     1, channel->id);
 	if (!channel->controlwq) {
 		kfree(channel);
 		return NULL;
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 3b18a66..e334ccc 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -875,10 +875,8 @@ int vmbus_device_register(struct hv_device *child_device_obj)
 {
 	int ret = 0;
 
-	static atomic_t device_num = ATOMIC_INIT(0);
-
-	dev_set_name(&child_device_obj->device, "vmbus_0_%d",
-		     atomic_inc_return(&device_num));
+	dev_set_name(&child_device_obj->device, "vmbus_%d",
+		     child_device_obj->channel->id);
 
 	child_device_obj->device.bus = &hv_bus;
 	child_device_obj->device.parent = &hv_acpi_dev->dev;
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 5a2ba67..26a32b7 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -646,6 +646,9 @@ struct hv_input_signal_event_buffer {
 };
 
 struct vmbus_channel {
+	/* Unique channel id */
+	int id;
+
 	struct list_head listentry;
 
 	struct hv_device *device_obj;
-- 
1.7.4.1

