Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab3HUWpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:45:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab3HUWpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:45:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 01/11] w1: add attribute groups to struct w1_family_ops
Date: Wed, 21 Aug 2013 15:44:55 -0700
Message-Id: <1377125105-25388-1-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets w1 slave drivers declare an attribute group, and not have to
create/destroy sysfs files directly.  All w1 slave drivers will be fixed
to use this field up in follow-on patches to this one.

Cc: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/w1.c        | 73 ++++++++++++++++++++++++++++----------------------
 drivers/w1/w1_family.h |  1 +
 2 files changed, 42 insertions(+), 32 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 52b6c2f0..22013ca2 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -124,9 +124,9 @@ ATTRIBUTE_GROUPS(w1_slave);
 
 /* Default family */
 
-static ssize_t w1_default_write(struct file *filp, struct kobject *kobj,
-				struct bin_attribute *bin_attr,
-				char *buf, loff_t off, size_t count)
+static ssize_t rw_write(struct file *filp, struct kobject *kobj,
+			struct bin_attribute *bin_attr, char *buf, loff_t off,
+			size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 
@@ -143,9 +143,9 @@ out_up:
 	return count;
 }
 
-static ssize_t w1_default_read(struct file *filp, struct kobject *kobj,
-			       struct bin_attribute *bin_attr,
-			       char *buf, loff_t off, size_t count)
+static ssize_t rw_read(struct file *filp, struct kobject *kobj,
+		       struct bin_attribute *bin_attr, char *buf, loff_t off,
+		       size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 
@@ -155,29 +155,24 @@ static ssize_t w1_default_read(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute w1_default_attr = {
-      .attr = {
-              .name = "rw",
-              .mode = S_IRUGO | S_IWUSR,
-      },
-      .size = PAGE_SIZE,
-      .read = w1_default_read,
-      .write = w1_default_write,
+static BIN_ATTR_RW(rw, PAGE_SIZE);
+
+static struct bin_attribute *w1_slave_bin_attrs[] = {
+	&bin_attr_rw,
+	NULL,
 };
 
-static int w1_default_add_slave(struct w1_slave *sl)
-{
-	return sysfs_create_bin_file(&sl->dev.kobj, &w1_default_attr);
-}
+static const struct attribute_group w1_slave_default_group = {
+	.bin_attrs = w1_slave_bin_attrs,
+};
 
-static void w1_default_remove_slave(struct w1_slave *sl)
-{
-	sysfs_remove_bin_file(&sl->dev.kobj, &w1_default_attr);
-}
+static const struct attribute_group *w1_slave_default_groups[] = {
+	&w1_slave_default_group,
+	NULL,
+};
 
 static struct w1_family_ops w1_default_fops = {
-	.add_slave	= w1_default_add_slave,
-	.remove_slave	= w1_default_remove_slave,
+	.groups		= w1_slave_default_groups,
 };
 
 static struct w1_family w1_default_family = {
@@ -600,6 +595,7 @@ static int w1_bus_notify(struct notifier_block *nb, unsigned long action,
 {
 	struct device *dev = data;
 	struct w1_slave *sl;
+	struct w1_family_ops *fops;
 	int err;
 
 	/*
@@ -611,23 +607,36 @@ static int w1_bus_notify(struct notifier_block *nb, unsigned long action,
 		return 0;
 
 	sl = dev_to_w1_slave(dev);
+	fops = sl->family->fops;
 
 	switch (action) {
 	case BUS_NOTIFY_ADD_DEVICE:
 		/* if the family driver needs to initialize something... */
-		if (sl->family->fops && sl->family->fops->add_slave &&
-		    ((err = sl->family->fops->add_slave(sl)) < 0)) {
-			dev_err(&sl->dev,
-				"sysfs file creation for [%s] failed. err=%d\n",
-				dev_name(&sl->dev), err);
-			return err;
+		if (fops->add_slave) {
+			err = fops->add_slave(sl);
+			if (err < 0) {
+				dev_err(&sl->dev,
+					"add_slave() call failed. err=%d\n",
+					err);
+				return err;
+			}
+		}
+		if (fops->groups) {
+			err = sysfs_create_groups(&sl->dev.kobj, fops->groups);
+			if (err) {
+				dev_err(&sl->dev,
+					"sysfs group creation failed. err=%d\n",
+					err);
+				return err;
+			}
 		}
 
 		break;
 	case BUS_NOTIFY_DEL_DEVICE:
-		/* Remove our sysfs files */
-		if (sl->family->fops && sl->family->fops->remove_slave)
+		if (fops->remove_slave)
 			sl->family->fops->remove_slave(sl);
+		if (fops->groups)
+			sysfs_remove_groups(&sl->dev.kobj, fops->groups);
 		break;
 	}
 	return 0;
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index 625dd08f..4ad0e81b 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -52,6 +52,7 @@ struct w1_family_ops
 {
 	int  (* add_slave)(struct w1_slave *);
 	void (* remove_slave)(struct w1_slave *);
+	const struct attribute_group **groups;
 };
 
 struct w1_family
-- 
1.8.3.rc0.20.gb99dd2e

