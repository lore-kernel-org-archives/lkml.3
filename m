Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3LQTl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:41:29 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:37900 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab3LQTk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:40:27 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH v3 19/21] misc: support for I-8041 in LP-8x4x
Date: Tue, 17 Dec 2013 23:37:49 +0400
Message-Id: <1387309071-22382-20-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387309071-22382-1-git-send-email-ynvich@gmail.com>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
 <1387309071-22382-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Status of I-8041 32 digital output channels can be managed via
sysfs now.

http://www.icpdas.com/products/Remote_IO/i-8ke/i-8041w.htm

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
   v2..v3
   v0..v2
   * no changes (except number 14/16 -> 19/21)

 Documentation/misc-devices/lp8x4x_bus.txt |  4 ++
 drivers/misc/lp8x4x_bus.c                 | 67 ++++++++++++++++++++++++++++++-
 2 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/Documentation/misc-devices/lp8x4x_bus.txt b/Documentation/misc-devices/lp8x4x_bus.txt
index 09380fd..68fefde 100644
--- a/Documentation/misc-devices/lp8x4x_bus.txt
+++ b/Documentation/misc-devices/lp8x4x_bus.txt
@@ -58,3 +58,7 @@ slot_count
 
 model
 	RO - shows expansion module model number
+
+output_status
+	RW - set status of digital output channels on the module in
+	     the expansion slot. Value can be read back.
diff --git a/drivers/misc/lp8x4x_bus.c b/drivers/misc/lp8x4x_bus.c
index 59dc767..5af788d 100644
--- a/drivers/misc/lp8x4x_bus.c
+++ b/drivers/misc/lp8x4x_bus.c
@@ -26,6 +26,9 @@ MODULE_DESCRIPTION("ICP DAS LP-8x4x parallel bus driver");
 struct lp8x4x_slot {
 	void			*data_addr;
 	unsigned int		model;
+	struct mutex		lock;
+	unsigned int		DO_len;
+	u32			DO;
 	struct device		dev;
 };
 
@@ -91,6 +94,45 @@ static void lp8x4x_slot_release(struct device *dev)
 {
 }
 
+static void lp8x4x_slot_set_DO(struct lp8x4x_slot *s)
+{
+	int i;
+	mutex_lock(&s->lock);
+	for (i = 0; i < s->DO_len; i++)
+		iowrite8((s->DO >> (i * 8)) & 0xff, s->data_addr + 2 * i);
+	mutex_unlock(&s->lock);
+}
+
+static ssize_t output_status_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct lp8x4x_slot *s = container_of(dev, struct lp8x4x_slot, dev);
+
+	return sprintf(buf, "0x%08x\n", s->DO);
+}
+
+static ssize_t output_status_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct lp8x4x_slot *s = container_of(dev, struct lp8x4x_slot, dev);
+
+	if (!buf)
+		return count;
+	if (0 == count)
+		return count;
+
+	if (kstrtouint(buf, 16, &s->DO) != 0) {
+		dev_err(dev, "bad input\n");
+		return count;
+	}
+
+	lp8x4x_slot_set_DO(s);
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(output_status);
+
 static ssize_t model_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -107,6 +149,13 @@ static struct attribute *slot_dev_attrs[] = {
 };
 ATTRIBUTE_GROUPS(slot_dev);
 
+static struct attribute *do_slot_dev_attrs[] = {
+	&dev_attr_model.attr,
+	&dev_attr_output_status.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(do_slot_dev);
+
 static void lp8x4x_master_release(struct device *dev)
 {
 	struct lp8x4x_master *m = container_of(dev, struct lp8x4x_master, dev);
@@ -242,8 +291,10 @@ static void devm_lp8x4x_bus_release(struct device *dev, void *res)
 	dev_dbg(dev, "releasing devices\n");
 	for (i = 0; i < LP8X4X_MAX_SLOT_COUNT; i++) {
 		s = &m->slot[i];
-		if (s->model)
+		if (s->model) {
 			device_unregister(&s->dev);
+			mutex_destroy(&s->lock);
+		}
 	}
 	device_unregister(&m->dev);
 	bus_unregister(&lp8x4x_bus_type);
@@ -261,13 +312,25 @@ static void __init lp8x4x_bus_probe_slot(struct lp8x4x_master *m, int i,
 	dev_set_name(&s->dev, "slot%02i", i + 1);
 	s->dev.parent = &m->dev;
 	s->dev.release = lp8x4x_slot_release;
-	s->dev.groups = slot_dev_groups;
 	s->model = model;
+	mutex_init(&s->lock);
+
+	switch (model) {
+	case 41:
+		s->DO_len = 4;
+		lp8x4x_slot_set_DO(s);
+		s->dev.groups = do_slot_dev_groups;
+		break;
+	default:
+		s->dev.groups = slot_dev_groups;
+		break;
+	};
 
 	err = device_register(&s->dev);
 	if (err < 0) {
 		dev_err(&s->dev, "failed to register device\n");
 		s->model = 0;
+		mutex_destroy(&s->lock);
 		return;
 	}
 }
-- 
1.8.4.2

