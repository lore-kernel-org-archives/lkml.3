Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab3IMSdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:33:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3IMSdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:33:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: kys@microsoft.com, haiyangz@microsoft.com
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 02/13] hv: move "state" bus attribute to dev_groups
Date: Fri, 13 Sep 2013 11:32:50 -0700
Message-Id: <1379097181-23407-3-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
References: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the "state" bus attribute to the dev_groups structure,
removing the need for it to be in a temporary structure.

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/channel.c   |  1 -
 drivers/hv/vmbus_drv.c | 17 ++++++++++++-----
 include/linux/hyperv.h |  1 -
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index b58a1785..64f19f22 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -69,7 +69,6 @@ void vmbus_get_debug_info(struct vmbus_channel *channel,
 	u8 monitor_group = (u8)channel->offermsg.monitorid / 32;
 	u8 monitor_offset = (u8)channel->offermsg.monitorid % 32;
 
-	debuginfo->state = channel->state;
 	memcpy(&debuginfo->interfacetype,
 	       &channel->offermsg.offer.if_type, sizeof(uuid_le));
 	memcpy(&debuginfo->interface_instance,
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 5c21b228..1e5bc9c4 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -47,7 +47,6 @@ static struct completion probe_event;
 static int irq;
 
 struct hv_device_info {
-	u32 chn_state;
 	uuid_le chn_type;
 	uuid_le chn_instance;
 
@@ -82,7 +81,6 @@ static void get_channel_info(struct hv_device *device,
 
 	vmbus_get_debug_info(device->channel, &debug_info);
 
-	info->chn_state = debug_info.state;
 	memcpy(&info->chn_type, &debug_info.interfacetype,
 	       sizeof(uuid_le));
 	memcpy(&info->chn_instance, &debug_info.interface_instance,
@@ -152,8 +150,6 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 	} else if (!strcmp(dev_attr->attr.name, "modalias")) {
 		print_alias_name(hv_dev, alias_name);
 		ret = sprintf(buf, "vmbus:%s\n", alias_name);
-	} else if (!strcmp(dev_attr->attr.name, "state")) {
-		ret = sprintf(buf, "%d\n", device_info->chn_state);
 	} else if (!strcmp(dev_attr->attr.name, "out_intr_mask")) {
 		ret = sprintf(buf, "%d\n", device_info->outbound.int_mask);
 	} else if (!strcmp(dev_attr->attr.name, "out_read_index")) {
@@ -211,15 +207,26 @@ static ssize_t id_show(struct device *dev, struct device_attribute *dev_attr,
 }
 static DEVICE_ATTR_RO(id);
 
+static ssize_t state_show(struct device *dev, struct device_attribute *dev_attr,
+			  char *buf)
+{
+	struct hv_device *hv_dev = device_to_hv_device(dev);
+
+	if (!hv_dev->channel)
+		return -ENODEV;
+	return sprintf(buf, "%d\n", hv_dev->channel->state);
+}
+static DEVICE_ATTR_RO(state);
+
 static struct attribute *vmbus_attrs[] = {
 	&dev_attr_id.attr,
+	&dev_attr_state.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(vmbus);
 
 /* Set up per device attributes in /sys/bus/vmbus/devices/<bus device> */
 static struct device_attribute vmbus_device_attrs[] = {
-	__ATTR(state, S_IRUGO, vmbus_show_device_attr, NULL),
 	__ATTR(class_id, S_IRUGO, vmbus_show_device_attr, NULL),
 	__ATTR(device_id, S_IRUGO, vmbus_show_device_attr, NULL),
 	__ATTR(monitor_id, S_IRUGO, vmbus_show_device_attr, NULL),
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 45e9b65e..b350a8cf 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -900,7 +900,6 @@ enum vmbus_channel_state {
 };
 
 struct vmbus_channel_debug_info {
-	enum vmbus_channel_state state;
 	uuid_le interfacetype;
 	uuid_le interface_instance;
 	u32 monitorid;
-- 
1.8.4.3.gca3854a

