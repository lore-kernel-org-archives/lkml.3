Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab3IMSfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:35:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab3IMSdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:33:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: kys@microsoft.com, haiyangz@microsoft.com
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 05/13] hv: move "class_id" bus attribute to dev_groups
Date: Fri, 13 Sep 2013 11:32:53 -0700
Message-Id: <1379097181-23407-6-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
References: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the "class_id" bus attribute to the dev_groups structure,
removing the need for it to be in a temporary structure.

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/channel.c   |  2 --
 drivers/hv/vmbus_drv.c | 22 +++++++++++++++-------
 include/linux/hyperv.h |  1 -
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index f26a5d25..df9499c1 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -69,8 +69,6 @@ void vmbus_get_debug_info(struct vmbus_channel *channel,
 	u8 monitor_group = (u8)channel->offermsg.monitorid / 32;
 	u8 monitor_offset = (u8)channel->offermsg.monitorid % 32;
 
-	memcpy(&debuginfo->interfacetype,
-	       &channel->offermsg.offer.if_type, sizeof(uuid_le));
 	memcpy(&debuginfo->interface_instance,
 	       &channel->offermsg.offer.if_instance,
 	       sizeof(uuid_le));
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index e3f43700..48258ae3 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -47,7 +47,6 @@ static struct completion probe_event;
 static int irq;
 
 struct hv_device_info {
-	uuid_le chn_type;
 	uuid_le chn_instance;
 
 	u32 server_monitor_pending;
@@ -80,8 +79,6 @@ static void get_channel_info(struct hv_device *device,
 
 	vmbus_get_debug_info(device->channel, &debug_info);
 
-	memcpy(&info->chn_type, &debug_info.interfacetype,
-	       sizeof(uuid_le));
 	memcpy(&info->chn_instance, &debug_info.interface_instance,
 	       sizeof(uuid_le));
 
@@ -139,9 +136,7 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 
 	get_channel_info(hv_dev, device_info);
 
-	if (!strcmp(dev_attr->attr.name, "class_id")) {
-		ret = sprintf(buf, "{%pUl}\n", device_info->chn_type.b);
-	} else if (!strcmp(dev_attr->attr.name, "device_id")) {
+	if (!strcmp(dev_attr->attr.name, "device_id")) {
 		ret = sprintf(buf, "{%pUl}\n", device_info->chn_instance.b);
 	} else if (!strcmp(dev_attr->attr.name, "out_intr_mask")) {
 		ret = sprintf(buf, "%d\n", device_info->outbound.int_mask);
@@ -220,6 +215,18 @@ static ssize_t monitor_id_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(monitor_id);
 
+static ssize_t class_id_show(struct device *dev,
+			       struct device_attribute *dev_attr, char *buf)
+{
+	struct hv_device *hv_dev = device_to_hv_device(dev);
+
+	if (!hv_dev->channel)
+		return -ENODEV;
+	return sprintf(buf, "{%pUl}\n",
+		       hv_dev->channel->offermsg.offer.if_type.b);
+}
+static DEVICE_ATTR_RO(class_id);
+
 static ssize_t modalias_show(struct device *dev,
 			     struct device_attribute *dev_attr, char *buf)
 {
@@ -231,10 +238,12 @@ static ssize_t modalias_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(modalias);
 
+
 static struct attribute *vmbus_attrs[] = {
 	&dev_attr_id.attr,
 	&dev_attr_state.attr,
 	&dev_attr_monitor_id.attr,
+	&dev_attr_class_id.attr,
 	&dev_attr_modalias.attr,
 	NULL,
 };
@@ -242,7 +251,6 @@ ATTRIBUTE_GROUPS(vmbus);
 
 /* Set up per device attributes in /sys/bus/vmbus/devices/<bus device> */
 static struct device_attribute vmbus_device_attrs[] = {
-	__ATTR(class_id, S_IRUGO, vmbus_show_device_attr, NULL),
 	__ATTR(device_id, S_IRUGO, vmbus_show_device_attr, NULL),
 
 	__ATTR(server_monitor_pending, S_IRUGO, vmbus_show_device_attr, NULL),
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 888a8e53..8ccf6f68 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -900,7 +900,6 @@ enum vmbus_channel_state {
 };
 
 struct vmbus_channel_debug_info {
-	uuid_le interfacetype;
 	uuid_le interface_instance;
 	u32 servermonitor_pending;
 	u32 servermonitor_latency;
-- 
1.8.4.3.gca3854a

