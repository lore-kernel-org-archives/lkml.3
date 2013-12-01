Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab3LAG3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 01:29:12 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:58736 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab3LAG3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 01:29:03 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH 10/11] misc: support for I-8042 in LP-8x4x
Date: Sun,  1 Dec 2013 10:26:23 +0400
Message-Id: <1385879185-22455-11-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Status of I-8042 16 digital output channels can be managed via
sysfs.

Status of I-8042 16 digital input channels can be read via sysfs.

http://www.icpdas.com/products/Remote_IO/i-8ke/i-8042w.htm

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
 Documentation/misc-devices/lp8x4x_bus.txt |  4 ++
 drivers/misc/lp8x4x_bus.c                 | 76 ++++++++++++++++++++++++++++++-
 2 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/Documentation/misc-devices/lp8x4x_bus.txt b/Documentation/misc-devices/lp8x4x_bus.txt
index 74df10b..e3a8bcf 100644
--- a/Documentation/misc-devices/lp8x4x_bus.txt
+++ b/Documentation/misc-devices/lp8x4x_bus.txt
@@ -50,6 +50,10 @@ active_slot
 model
 	RO - shows expansion module model number
 
+input_status
+	RO - get status of digital input channels on the module in
+	     the expansion slot.
+
 output_status
 	RW - set status of digital output channels on the module in
 	     the expansion slot. Value can be read back.
diff --git a/drivers/misc/lp8x4x_bus.c b/drivers/misc/lp8x4x_bus.c
index d177735..fce11c4 100644
--- a/drivers/misc/lp8x4x_bus.c
+++ b/drivers/misc/lp8x4x_bus.c
@@ -30,6 +30,8 @@ struct lp8x4x_slot {
 	struct mutex		lock;
 	unsigned int		DO_len;
 	u32			DO;
+	unsigned int		DI_len;
+	u32			DI;
 	struct device		dev;
 };
 
@@ -92,6 +94,21 @@ static void lp8x4x_slot_release(struct device *dev)
 {
 }
 
+static void lp8x4x_slot_get_DI(struct lp8x4x_slot *s)
+{
+	int i;
+	u32 b;
+
+	mutex_lock(&s->lock);
+	s->DI = 0;
+	for (i = 0; i < s->DI_len; i++) {
+		b = ioread8(s->data_addr + 2 * (i + 1));
+		b ^= 0xff;
+		s->DI += b << (i * 8);
+	}
+	mutex_unlock(&s->lock);
+}
+
 static void lp8x4x_slot_set_DO(struct lp8x4x_slot *s)
 {
 	int i;
@@ -101,29 +118,70 @@ static void lp8x4x_slot_set_DO(struct lp8x4x_slot *s)
 	mutex_unlock(&s->lock);
 }
 
+static ssize_t input_status_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct lp8x4x_slot *s = container_of(dev, struct lp8x4x_slot, dev);
+
+	lp8x4x_slot_get_DI(s);
+	switch (s->DI_len) {
+	case 4:
+		return sprintf(buf, "0x%08x\n", s->DI);
+	case 2:
+		return sprintf(buf, "0x%04x\n", s->DI);
+	case 1:
+		return sprintf(buf, "0x%02x\n", s->DI);
+	default:
+		break;
+	}
+	return sprintf(buf, "0x%x\n", s->DI);
+}
+
+static DEVICE_ATTR_RO(input_status);
+
 static ssize_t output_status_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct lp8x4x_slot *s = container_of(dev, struct lp8x4x_slot, dev);
 
-	return sprintf(buf, "0x%08x\n", s->DO);
+	switch (s->DO_len) {
+	case 4:
+		return sprintf(buf, "0x%08x\n", s->DO);
+	case 2:
+		return sprintf(buf, "0x%04x\n", s->DO);
+	case 1:
+		return sprintf(buf, "0x%02x\n", s->DO);
+	default:
+		break;
+	}
+	return sprintf(buf, "0x%x\n", s->DO);
 }
 
 static ssize_t output_status_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct lp8x4x_slot *s = container_of(dev, struct lp8x4x_slot, dev);
+	u32 DO;
+	u8 *b = (void *) &DO;
+	int i;
 
 	if (!buf)
 		return count;
 	if (0 == count)
 		return count;
 
-	if (kstrtouint(buf, 16, &s->DO) != 0) {
+	if (kstrtouint(buf, 16, &DO) != 0) {
 		dev_err(dev, "bad input\n");
 		return count;
 	}
 
+	for (i = 4; i > s->DO_len; i--)
+		if (b[i - 1] != 0) {
+			dev_err(dev, "bad input\n");
+			return count;
+		}
+
+	s->DO = DO;
 	lp8x4x_slot_set_DO(s);
 
 	return count;
@@ -154,6 +212,14 @@ static struct attribute *do_slot_dev_attrs[] = {
 };
 ATTRIBUTE_GROUPS(do_slot_dev);
 
+static struct attribute *dio_slot_dev_attrs[] = {
+	&dev_attr_model.attr,
+	&dev_attr_output_status.attr,
+	&dev_attr_input_status.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(dio_slot_dev);
+
 static void lp8x4x_master_release(struct device *dev)
 {
 	struct lp8x4x_master *m = container_of(dev, struct lp8x4x_master, dev);
@@ -263,6 +329,12 @@ static void __init lp8x4x_bus_probe_slot(struct lp8x4x_master *m, int i,
 		lp8x4x_slot_set_DO(s);
 		s->dev.groups = do_slot_dev_groups;
 		break;
+	case 42:
+		s->DI_len = 2;
+		s->DO_len = 2;
+		lp8x4x_slot_set_DO(s);
+		s->dev.groups = dio_slot_dev_groups;
+		break;
 	default:
 		s->dev.groups = slot_dev_groups;
 		break;
-- 
1.8.4.2

