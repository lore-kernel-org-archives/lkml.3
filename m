Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab3JGG4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:56:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3JGG4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:56:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        <linux-pcmcia@lists.infradead.org>
Subject: [PATCH 07/11] pcmcia: convert bus code to use dev_groups
Date: Sun,  6 Oct 2013 23:55:46 -0700
Message-Id: <1381128950-28125-8-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
References: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the pcmcia bus code to use the
correct field.

Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: <linux-pcmcia@lists.infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pcmcia/ds.c | 65 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 26 deletions(-)

diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 2deacbb..757119b 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -992,16 +992,17 @@ static ssize_t field##_show (struct device *dev, struct device_attribute *attr,
 {									\
 	struct pcmcia_device *p_dev = to_pcmcia_dev(dev);		\
 	return p_dev->test ? sprintf(buf, format, p_dev->field) : -ENODEV; \
-}
+}									\
+static DEVICE_ATTR_RO(field);
 
 #define pcmcia_device_stringattr(name, field)					\
 static ssize_t name##_show (struct device *dev, struct device_attribute *attr, char *buf)		\
 {									\
 	struct pcmcia_device *p_dev = to_pcmcia_dev(dev);		\
 	return p_dev->field ? sprintf(buf, "%s\n", p_dev->field) : -ENODEV; \
-}
+}									\
+static DEVICE_ATTR_RO(name);
 
-pcmcia_device_attr(func, socket, "0x%02x\n");
 pcmcia_device_attr(func_id, has_func_id, "0x%02x\n");
 pcmcia_device_attr(manf_id, has_manf_id, "0x%04x\n");
 pcmcia_device_attr(card_id, has_card_id, "0x%04x\n");
@@ -1010,8 +1011,16 @@ pcmcia_device_stringattr(prod_id2, prod_id[1]);
 pcmcia_device_stringattr(prod_id3, prod_id[2]);
 pcmcia_device_stringattr(prod_id4, prod_id[3]);
 
-static ssize_t pcmcia_show_resources(struct device *dev,
-				     struct device_attribute *attr, char *buf)
+static ssize_t function_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct pcmcia_device *p_dev = to_pcmcia_dev(dev);
+	return p_dev->socket ? sprintf(buf, "0x%02x\n", p_dev->func) : -ENODEV;
+}
+static DEVICE_ATTR_RO(function);
+
+static ssize_t resources_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
 {
 	struct pcmcia_device *p_dev = to_pcmcia_dev(dev);
 	char *str = buf;
@@ -1022,8 +1031,9 @@ static ssize_t pcmcia_show_resources(struct device *dev,
 
 	return str - buf;
 }
+static DEVICE_ATTR_RO(resources);
 
-static ssize_t pcmcia_show_pm_state(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t pm_state_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct pcmcia_device *p_dev = to_pcmcia_dev(dev);
 
@@ -1033,8 +1043,8 @@ static ssize_t pcmcia_show_pm_state(struct device *dev, struct device_attribute
 		return sprintf(buf, "on\n");
 }
 
-static ssize_t pcmcia_store_pm_state(struct device *dev, struct device_attribute *attr,
-				     const char *buf, size_t count)
+static ssize_t pm_state_store(struct device *dev, struct device_attribute *attr,
+			      const char *buf, size_t count)
 {
 	struct pcmcia_device *p_dev = to_pcmcia_dev(dev);
 	int ret = 0;
@@ -1049,7 +1059,7 @@ static ssize_t pcmcia_store_pm_state(struct device *dev, struct device_attribute
 
 	return ret ? ret : count;
 }
-
+static DEVICE_ATTR_RW(pm_state);
 
 static ssize_t modalias_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -1072,8 +1082,9 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 				p_dev->func, p_dev->device_no,
 				hash[0], hash[1], hash[2], hash[3]);
 }
+static DEVICE_ATTR_RO(modalias);
 
-static ssize_t pcmcia_store_allow_func_id_match(struct device *dev,
+static ssize_t allow_func_id_match_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct pcmcia_device *p_dev = to_pcmcia_dev(dev);
@@ -1088,22 +1099,24 @@ static ssize_t pcmcia_store_allow_func_id_match(struct device *dev,
 
 	return count;
 }
-
-static struct device_attribute pcmcia_dev_attrs[] = {
-	__ATTR(function, 0444, func_show, NULL),
-	__ATTR(pm_state, 0644, pcmcia_show_pm_state, pcmcia_store_pm_state),
-	__ATTR(resources, 0444, pcmcia_show_resources, NULL),
-	__ATTR_RO(func_id),
-	__ATTR_RO(manf_id),
-	__ATTR_RO(card_id),
-	__ATTR_RO(prod_id1),
-	__ATTR_RO(prod_id2),
-	__ATTR_RO(prod_id3),
-	__ATTR_RO(prod_id4),
-	__ATTR_RO(modalias),
-	__ATTR(allow_func_id_match, 0200, NULL, pcmcia_store_allow_func_id_match),
-	__ATTR_NULL,
+static DEVICE_ATTR_WO(allow_func_id_match);
+
+static struct attribute *pcmcia_dev_attrs[] = {
+	&dev_attr_resources.attr,
+	&dev_attr_pm_state.attr,
+	&dev_attr_function.attr,
+	&dev_attr_func_id.attr,
+	&dev_attr_manf_id.attr,
+	&dev_attr_card_id.attr,
+	&dev_attr_prod_id1.attr,
+	&dev_attr_prod_id2.attr,
+	&dev_attr_prod_id3.attr,
+	&dev_attr_prod_id4.attr,
+	&dev_attr_modalias.attr,
+	&dev_attr_allow_func_id_match.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(pcmcia_dev);
 
 /* PM support, also needed for reset */
 
@@ -1389,7 +1402,7 @@ struct bus_type pcmcia_bus_type = {
 	.name = "pcmcia",
 	.uevent = pcmcia_bus_uevent,
 	.match = pcmcia_bus_match,
-	.dev_attrs = pcmcia_dev_attrs,
+	.dev_groups = pcmcia_dev_groups,
 	.probe = pcmcia_device_probe,
 	.remove = pcmcia_device_remove,
 	.suspend = pcmcia_dev_suspend,
-- 
1.8.4.6.g82e253f.dirty

