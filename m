Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab3HUUZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:25:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab3HUUYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:24:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 2/2] w1: use default attribute groups for w1 slave devices
Date: Wed, 21 Aug 2013 13:24:33 -0700
Message-Id: <1377116673-31216-2-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377116673-31216-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377116673-31216-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we have 2 sysfs files for the w1 slave devices, let the driver core
create / destroy them automatically by setting the default attribute
group for them, saving code and housekeeping logic.

Cc: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/w1.c | 38 +++++++++++---------------------------
 1 file changed, 11 insertions(+), 27 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 3c798db0..52b6c2f0 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -96,14 +96,15 @@ static void w1_slave_release(struct device *dev)
 	complete(&sl->released);
 }
 
-static ssize_t w1_slave_read_name(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t name_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct w1_slave *sl = dev_to_w1_slave(dev);
 
 	return sprintf(buf, "%s\n", sl->name);
 }
+static DEVICE_ATTR_RO(name);
 
-static ssize_t w1_slave_read_id(struct device *dev,
+static ssize_t id_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 	struct w1_slave *sl = dev_to_w1_slave(dev);
@@ -112,11 +113,14 @@ static ssize_t w1_slave_read_id(struct device *dev,
 	memcpy(buf, (u8 *)&sl->reg_num, count);
 	return count;
 }
+static DEVICE_ATTR_RO(id);
 
-static struct device_attribute w1_slave_attr_name =
-	__ATTR(name, S_IRUGO, w1_slave_read_name, NULL);
-static struct device_attribute w1_slave_attr_id =
-	__ATTR(id, S_IRUGO, w1_slave_read_id, NULL);
+static struct attribute *w1_slave_attrs[] = {
+	&dev_attr_name.attr,
+	&dev_attr_id.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(w1_slave);
 
 /* Default family */
 
@@ -610,25 +614,6 @@ static int w1_bus_notify(struct notifier_block *nb, unsigned long action,
 
 	switch (action) {
 	case BUS_NOTIFY_ADD_DEVICE:
-		/* Create our sysfs files before userspace is told about it */
-		/* Create "name" entry */
-		err = device_create_file(&sl->dev, &w1_slave_attr_name);
-		if (err < 0) {
-			dev_err(&sl->dev,
-				"sysfs file creation for [%s] failed. err=%d\n",
-				dev_name(&sl->dev), err);
-			return err;
-		}
-
-		/* Create "id" entry */
-		err = device_create_file(&sl->dev, &w1_slave_attr_id);
-		if (err < 0) {
-			dev_err(&sl->dev,
-				"sysfs file creation for [%s] failed. err=%d\n",
-				dev_name(&sl->dev), err);
-			return err;
-		}
-
 		/* if the family driver needs to initialize something... */
 		if (sl->family->fops && sl->family->fops->add_slave &&
 		    ((err = sl->family->fops->add_slave(sl)) < 0)) {
@@ -643,8 +628,6 @@ static int w1_bus_notify(struct notifier_block *nb, unsigned long action,
 		/* Remove our sysfs files */
 		if (sl->family->fops && sl->family->fops->remove_slave)
 			sl->family->fops->remove_slave(sl);
-		device_remove_file(&sl->dev, &w1_slave_attr_id);
-		device_remove_file(&sl->dev, &w1_slave_attr_name);
 		break;
 	}
 	return 0;
@@ -662,6 +645,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 	sl->dev.driver = &w1_slave_driver;
 	sl->dev.bus = &w1_bus_type;
 	sl->dev.release = &w1_slave_release;
+	sl->dev.groups = w1_slave_groups;
 
 	dev_set_name(&sl->dev, "%02x-%012llx",
 		 (unsigned int) sl->reg_num.family,
-- 
1.8.3.rc0.20.gb99dd2e

