Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964813Ab3CMXvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:51:40 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:58121 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934457Ab3CMXvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:51:16 -0400
From: Benson Leung <bleung@chromium.org>
To: rydberg@euromail.se, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
Cc: bleung@chromium.org, olofj@chromium.org, djkurtz@chromium.org,
        dudl@cypress.com
Subject: [PATCH 4/4] Input: cyapa - Add sysfs attrs for product_id and fw version
Date: Wed, 13 Mar 2013 16:50:51 -0700
Message-Id: <1363218651-22457-5-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363218651-22457-1-git-send-email-bleung@chromium.org>
References: <1363218651-22457-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add attributes to expose the product_id and firmware_version read
from the device firmware.

Signed-off-by: Dudley Du <dudl@cypress.com>
Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/mouse/cyapa.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 51e9d44..97828f6 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -216,6 +216,8 @@ struct cyapa {
 
 	/* read from query data region. */
 	char product_id[16];
+	u8 fw_maj_ver;  /* firmware major version. */
+	u8 fw_min_ver;  /* firmware minor version. */
 	u8 btn_capability;
 	u8 gen;
 	int max_abs_x;
@@ -714,6 +716,9 @@ static int cyapa_get_query_data(struct cyapa *cyapa)
 	memcpy(&cyapa->product_id[13], &query_data[11], 2);
 	cyapa->product_id[15] = '\0';
 
+	cyapa->fw_maj_ver = query_data[15];
+	cyapa->fw_min_ver = query_data[16];
+
 	cyapa->btn_capability = query_data[19] & CAPABILITY_BTN_MASK;
 
 	cyapa->gen = query_data[20] & 0x0f;
@@ -1175,6 +1180,21 @@ done:
 /*
  * Sysfs Interface.
  */
+static ssize_t cyapa_show_fm_ver(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	return scnprintf(buf, PAGE_SIZE, "%d.%d\n", cyapa->fw_maj_ver,
+			 cyapa->fw_min_ver);
+}
+
+static ssize_t cyapa_show_product_id(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", cyapa->product_id);
+}
+
 static ssize_t cyapa_update_fw_store(struct device *dev,
 				     struct device_attribute *attr,
 				     const char *buf, size_t count)
@@ -1199,9 +1219,13 @@ static ssize_t cyapa_update_fw_store(struct device *dev,
 	return ret ? ret : count;
 }
 
+static DEVICE_ATTR(firmware_version, S_IRUGO, cyapa_show_fm_ver, NULL);
+static DEVICE_ATTR(product_id, S_IRUGO, cyapa_show_product_id, NULL);
 static DEVICE_ATTR(update_fw, S_IWUSR, NULL, cyapa_update_fw_store);
 
 static struct attribute *cyapa_sysfs_entries[] = {
+	&dev_attr_firmware_version.attr,
+	&dev_attr_product_id.attr,
 	&dev_attr_update_fw.attr,
 	NULL,
 };
-- 
1.8.1.3

