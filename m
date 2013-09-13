Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab3IMSgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:36:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252Ab3IMSdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:33:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: kys@microsoft.com, haiyangz@microsoft.com
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 04/13] hv: move "modalias" bus attribute to dev_groups
Date: Fri, 13 Sep 2013 11:32:52 -0700
Message-Id: <1379097181-23407-5-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
References: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the "state" bus attribute to the dev_groups structure.

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/vmbus_drv.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 2114ecb8..e3f43700 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -131,7 +131,6 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 {
 	struct hv_device *hv_dev = device_to_hv_device(dev);
 	struct hv_device_info *device_info;
-	char alias_name[VMBUS_ALIAS_LEN + 1];
 	int ret = 0;
 
 	device_info = kzalloc(sizeof(struct hv_device_info), GFP_KERNEL);
@@ -144,9 +143,6 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 		ret = sprintf(buf, "{%pUl}\n", device_info->chn_type.b);
 	} else if (!strcmp(dev_attr->attr.name, "device_id")) {
 		ret = sprintf(buf, "{%pUl}\n", device_info->chn_instance.b);
-	} else if (!strcmp(dev_attr->attr.name, "modalias")) {
-		print_alias_name(hv_dev, alias_name);
-		ret = sprintf(buf, "vmbus:%s\n", alias_name);
 	} else if (!strcmp(dev_attr->attr.name, "out_intr_mask")) {
 		ret = sprintf(buf, "%d\n", device_info->outbound.int_mask);
 	} else if (!strcmp(dev_attr->attr.name, "out_read_index")) {
@@ -224,10 +220,22 @@ static ssize_t monitor_id_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(monitor_id);
 
+static ssize_t modalias_show(struct device *dev,
+			     struct device_attribute *dev_attr, char *buf)
+{
+	struct hv_device *hv_dev = device_to_hv_device(dev);
+	char alias_name[VMBUS_ALIAS_LEN + 1];
+
+	print_alias_name(hv_dev, alias_name);
+	return sprintf(buf, "vmbus:%s\n", alias_name);
+}
+static DEVICE_ATTR_RO(modalias);
+
 static struct attribute *vmbus_attrs[] = {
 	&dev_attr_id.attr,
 	&dev_attr_state.attr,
 	&dev_attr_monitor_id.attr,
+	&dev_attr_modalias.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(vmbus);
@@ -236,7 +244,6 @@ ATTRIBUTE_GROUPS(vmbus);
 static struct device_attribute vmbus_device_attrs[] = {
 	__ATTR(class_id, S_IRUGO, vmbus_show_device_attr, NULL),
 	__ATTR(device_id, S_IRUGO, vmbus_show_device_attr, NULL),
-	__ATTR(modalias, S_IRUGO, vmbus_show_device_attr, NULL),
 
 	__ATTR(server_monitor_pending, S_IRUGO, vmbus_show_device_attr, NULL),
 	__ATTR(server_monitor_latency, S_IRUGO, vmbus_show_device_attr, NULL),
-- 
1.8.4.3.gca3854a

