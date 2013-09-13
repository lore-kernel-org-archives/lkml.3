Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab3IMSdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:33:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab3IMSdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:33:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: kys@microsoft.com, haiyangz@microsoft.com
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 08/13] hv: move "client/server_monitor_pending" bus attributes to dev_groups
Date: Fri, 13 Sep 2013 11:32:56 -0700
Message-Id: <1379097181-23407-9-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
References: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the "client_monitor_pending" and "server_monitor_pending" bus
attributes to the dev_groups structure, removing the need for it to be
in a temporary structure.

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/channel.c   |  4 ----
 drivers/hv/vmbus_drv.c | 56 +++++++++++++++++++++++++++++++++++++++++---------
 include/linux/hyperv.h |  2 --
 3 files changed, 46 insertions(+), 16 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 04bf0656..d600360e 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -70,8 +70,6 @@ void vmbus_get_debug_info(struct vmbus_channel *channel,
 	u8 monitor_offset = (u8)channel->offermsg.monitorid % 32;
 
 	monitorpage = vmbus_connection.monitor_pages[0];
-	debuginfo->servermonitor_pending =
-			monitorpage->trigger_group[monitor_group].pending;
 	debuginfo->servermonitor_latency =
 			monitorpage->latency[monitor_group][monitor_offset];
 	debuginfo->servermonitor_connectionid =
@@ -79,8 +77,6 @@ void vmbus_get_debug_info(struct vmbus_channel *channel,
 					[monitor_offset].connectionid.u.id;
 
 	monitorpage = vmbus_connection.monitor_pages[1];
-	debuginfo->clientmonitor_pending =
-			monitorpage->trigger_group[monitor_group].pending;
 	debuginfo->clientmonitor_latency =
 			monitorpage->latency[monitor_group][monitor_offset];
 	debuginfo->clientmonitor_connectionid =
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 944dc4b0..5a44957b 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -47,10 +47,8 @@ static struct completion probe_event;
 static int irq;
 
 struct hv_device_info {
-	u32 server_monitor_pending;
 	u32 server_monitor_latency;
 	u32 server_monitor_conn_id;
-	u32 client_monitor_pending;
 	u32 client_monitor_latency;
 	u32 client_monitor_conn_id;
 
@@ -77,11 +75,9 @@ static void get_channel_info(struct hv_device *device,
 
 	vmbus_get_debug_info(device->channel, &debug_info);
 
-	info->server_monitor_pending = debug_info.servermonitor_pending;
 	info->server_monitor_latency = debug_info.servermonitor_latency;
 	info->server_monitor_conn_id = debug_info.servermonitor_connectionid;
 
-	info->client_monitor_pending = debug_info.clientmonitor_pending;
 	info->client_monitor_latency = debug_info.clientmonitor_latency;
 	info->client_monitor_conn_id = debug_info.clientmonitor_connectionid;
 
@@ -155,15 +151,11 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 	} else if (!strcmp(dev_attr->attr.name, "in_write_bytes_avail")) {
 		ret = sprintf(buf, "%d\n",
 			       device_info->inbound.bytes_avail_towrite);
-	} else if (!strcmp(dev_attr->attr.name, "server_monitor_pending")) {
-		ret = sprintf(buf, "%d\n", device_info->server_monitor_pending);
 	} else if (!strcmp(dev_attr->attr.name, "server_monitor_latency")) {
 		ret = sprintf(buf, "%d\n", device_info->server_monitor_latency);
 	} else if (!strcmp(dev_attr->attr.name, "server_monitor_conn_id")) {
 		ret = sprintf(buf, "%d\n",
 			       device_info->server_monitor_conn_id);
-	} else if (!strcmp(dev_attr->attr.name, "client_monitor_pending")) {
-		ret = sprintf(buf, "%d\n", device_info->client_monitor_pending);
 	} else if (!strcmp(dev_attr->attr.name, "client_monitor_latency")) {
 		ret = sprintf(buf, "%d\n", device_info->client_monitor_latency);
 	} else if (!strcmp(dev_attr->attr.name, "client_monitor_conn_id")) {
@@ -175,6 +167,23 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 	return ret;
 }
 
+static u8 channel_monitor_group(struct vmbus_channel *channel)
+{
+	return (u8)channel->offermsg.monitorid / 32;
+}
+
+static u8 channel_monitor_offset(struct vmbus_channel *channel)
+{
+	return (u8)channel->offermsg.monitorid % 32;
+}
+
+static u32 channel_pending(struct vmbus_channel *channel,
+			   struct hv_monitor_page *monitor_page)
+{
+	u8 monitor_group = channel_monitor_group(channel);
+	return monitor_page->trigger_group[monitor_group].pending;
+}
+
 static ssize_t id_show(struct device *dev, struct device_attribute *dev_attr,
 		       char *buf)
 {
@@ -243,6 +252,33 @@ static ssize_t modalias_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(modalias);
 
+static ssize_t server_monitor_pending_show(struct device *dev,
+					   struct device_attribute *dev_attr,
+					   char *buf)
+{
+	struct hv_device *hv_dev = device_to_hv_device(dev);
+
+	if (!hv_dev->channel)
+		return -ENODEV;
+	return sprintf(buf, "%d\n",
+		       channel_pending(hv_dev->channel,
+				       vmbus_connection.monitor_pages[1]));
+}
+static DEVICE_ATTR_RO(server_monitor_pending);
+
+static ssize_t client_monitor_pending_show(struct device *dev,
+					   struct device_attribute *dev_attr,
+					   char *buf)
+{
+	struct hv_device *hv_dev = device_to_hv_device(dev);
+
+	if (!hv_dev->channel)
+		return -ENODEV;
+	return sprintf(buf, "%d\n",
+		       channel_pending(hv_dev->channel,
+				       vmbus_connection.monitor_pages[1]));
+}
+static DEVICE_ATTR_RO(client_monitor_pending);
 
 static struct attribute *vmbus_attrs[] = {
 	&dev_attr_id.attr,
@@ -251,17 +287,17 @@ static struct attribute *vmbus_attrs[] = {
 	&dev_attr_class_id.attr,
 	&dev_attr_device_id.attr,
 	&dev_attr_modalias.attr,
+	&dev_attr_server_monitor_pending.attr,
+	&dev_attr_client_monitor_pending.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(vmbus);
 
 /* Set up per device attributes in /sys/bus/vmbus/devices/<bus device> */
 static struct device_attribute vmbus_device_attrs[] = {
-	__ATTR(server_monitor_pending, S_IRUGO, vmbus_show_device_attr, NULL),
 	__ATTR(server_monitor_latency, S_IRUGO, vmbus_show_device_attr, NULL),
 	__ATTR(server_monitor_conn_id, S_IRUGO, vmbus_show_device_attr, NULL),
 
-	__ATTR(client_monitor_pending, S_IRUGO, vmbus_show_device_attr, NULL),
 	__ATTR(client_monitor_latency, S_IRUGO, vmbus_show_device_attr, NULL),
 	__ATTR(client_monitor_conn_id, S_IRUGO, vmbus_show_device_attr, NULL),
 
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 687c01b8..f0a7d27f 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -900,10 +900,8 @@ enum vmbus_channel_state {
 };
 
 struct vmbus_channel_debug_info {
-	u32 servermonitor_pending;
 	u32 servermonitor_latency;
 	u32 servermonitor_connectionid;
-	u32 clientmonitor_pending;
 	u32 clientmonitor_latency;
 	u32 clientmonitor_connectionid;
 
-- 
1.8.4.3.gca3854a

