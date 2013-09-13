Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab3IMSeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:34:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab3IMSdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:33:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: kys@microsoft.com, haiyangz@microsoft.com
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 12/13] hv: delete struct hv_dev_port_info
Date: Fri, 13 Sep 2013 11:33:00 -0700
Message-Id: <1379097181-23407-13-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
References: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's no longer needed, and the struct hv_ring_buffer_debug_info
structure shouldn't be "global" so move it to the local .h file instead.


Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/hyperv_vmbus.h |  7 +++++++
 drivers/hv/vmbus_drv.c    | 35 ++++++++++-------------------------
 include/linux/hyperv.h    | 17 -----------------
 3 files changed, 17 insertions(+), 42 deletions(-)

diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index d58c22ff..e0551761 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -514,6 +514,13 @@ struct hv_context {
 
 extern struct hv_context hv_context;
 
+struct hv_ring_buffer_debug_info {
+	u32 current_interrupt_mask;
+	u32 current_read_index;
+	u32 current_write_index;
+	u32 bytes_avail_toread;
+	u32 bytes_avail_towrite;
+};
 
 /* Hv Interface */
 
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 62d9311b..cf3220e8 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -47,8 +47,8 @@ static struct completion probe_event;
 static int irq;
 
 struct hv_device_info {
-	struct hv_dev_port_info inbound;
-	struct hv_dev_port_info outbound;
+	struct hv_ring_buffer_debug_info inbound;
+	struct hv_ring_buffer_debug_info outbound;
 };
 
 static int vmbus_exists(void)
@@ -63,26 +63,11 @@ static int vmbus_exists(void)
 static void get_channel_info(struct hv_device *device,
 			     struct hv_device_info *info)
 {
-	struct hv_ring_buffer_debug_info inbound;
-	struct hv_ring_buffer_debug_info outbound;
-
 	if (!device->channel)
 		return;
 
-	hv_ringbuffer_get_debuginfo(&device->channel->inbound, &inbound);
-	hv_ringbuffer_get_debuginfo(&device->channel->outbound, &outbound);
-
-	info->inbound.int_mask = inbound.current_interrupt_mask;
-	info->inbound.read_idx = inbound.current_read_index;
-	info->inbound.write_idx = inbound.current_write_index;
-	info->inbound.bytes_avail_toread = inbound.bytes_avail_toread;
-	info->inbound.bytes_avail_towrite = inbound.bytes_avail_towrite;
-
-	info->outbound.int_mask = outbound.current_interrupt_mask;
-	info->outbound.read_idx = outbound.current_read_index;
-	info->outbound.write_idx = outbound.current_write_index;
-	info->outbound.bytes_avail_toread = outbound.bytes_avail_toread;
-	info->outbound.bytes_avail_towrite = outbound.bytes_avail_towrite;
+	hv_ringbuffer_get_debuginfo(&device->channel->inbound, &info->inbound);
+	hv_ringbuffer_get_debuginfo(&device->channel->outbound, &info->outbound);
 }
 
 #define VMBUS_ALIAS_LEN ((sizeof((struct hv_vmbus_device_id *)0)->guid) * 2)
@@ -114,11 +99,11 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 	get_channel_info(hv_dev, device_info);
 
 	if (!strcmp(dev_attr->attr.name, "out_intr_mask")) {
-		ret = sprintf(buf, "%d\n", device_info->outbound.int_mask);
+		ret = sprintf(buf, "%d\n", device_info->outbound.current_interrupt_mask);
 	} else if (!strcmp(dev_attr->attr.name, "out_read_index")) {
-		ret = sprintf(buf, "%d\n", device_info->outbound.read_idx);
+		ret = sprintf(buf, "%d\n", device_info->outbound.current_read_index);
 	} else if (!strcmp(dev_attr->attr.name, "out_write_index")) {
-		ret = sprintf(buf, "%d\n", device_info->outbound.write_idx);
+		ret = sprintf(buf, "%d\n", device_info->outbound.current_write_index);
 	} else if (!strcmp(dev_attr->attr.name, "out_read_bytes_avail")) {
 		ret = sprintf(buf, "%d\n",
 			       device_info->outbound.bytes_avail_toread);
@@ -126,11 +111,11 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 		ret = sprintf(buf, "%d\n",
 			       device_info->outbound.bytes_avail_towrite);
 	} else if (!strcmp(dev_attr->attr.name, "in_intr_mask")) {
-		ret = sprintf(buf, "%d\n", device_info->inbound.int_mask);
+		ret = sprintf(buf, "%d\n", device_info->inbound.current_interrupt_mask);
 	} else if (!strcmp(dev_attr->attr.name, "in_read_index")) {
-		ret = sprintf(buf, "%d\n", device_info->inbound.read_idx);
+		ret = sprintf(buf, "%d\n", device_info->inbound.current_read_index);
 	} else if (!strcmp(dev_attr->attr.name, "in_write_index")) {
-		ret = sprintf(buf, "%d\n", device_info->inbound.write_idx);
+		ret = sprintf(buf, "%d\n", device_info->inbound.current_write_index);
 	} else if (!strcmp(dev_attr->attr.name, "in_read_bytes_avail")) {
 		ret = sprintf(buf, "%d\n",
 			       device_info->inbound.bytes_avail_toread);
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index c0e8faf4..c68ecfe2 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -429,15 +429,6 @@ struct hv_ring_buffer_info {
 	u32 ring_data_startoffset;
 };
 
-struct hv_ring_buffer_debug_info {
-	u32 current_interrupt_mask;
-	u32 current_read_index;
-	u32 current_write_index;
-	u32 bytes_avail_toread;
-	u32 bytes_avail_towrite;
-};
-
-
 /*
  *
  * hv_get_ringbuffer_availbytes()
@@ -1166,14 +1157,6 @@ extern int vmbus_recvpacket_raw(struct vmbus_channel *channel,
 
 extern void vmbus_ontimer(unsigned long data);
 
-struct hv_dev_port_info {
-	u32 int_mask;
-	u32 read_idx;
-	u32 write_idx;
-	u32 bytes_avail_toread;
-	u32 bytes_avail_towrite;
-};
-
 /* Base driver object */
 struct hv_driver {
 	const char *name;
-- 
1.8.4.3.gca3854a

