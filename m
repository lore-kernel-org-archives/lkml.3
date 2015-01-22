Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbbAVSBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:01:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbbAVSBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:01:44 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH] Drivers: hv: vmbus: rename channel work queues
Date: Thu, 22 Jan 2015 19:01:34 +0100
Message-Id: <1421949694-2487-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All channel work queues are named 'hv_vmbus_ctl', this makes them
indistinguishable in ps output and makes it hard to link to the corresponding
vmbus device. Rename them to hv_vmbus_ctl/N and make vmbus device names match,
e.g. now vmbus_1 device is served by hv_vmbus_ctl/1 work queue.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/channel_mgmt.c | 5 ++++-
 drivers/hv/vmbus_drv.c    | 6 ++----
 include/linux/hyperv.h    | 3 +++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 0141a3d..b7be96f 100644
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
index e647505..544b1f2 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -811,10 +811,8 @@ int vmbus_device_register(struct hv_device *child_device_obj)
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
index 02dd978..af73b85 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -634,6 +634,9 @@ struct hv_input_signal_event_buffer {
 };
 
 struct vmbus_channel {
+	/* Unique channel id */
+	int id;
+
 	struct list_head listentry;
 
 	struct hv_device *device_obj;
-- 
1.9.3

