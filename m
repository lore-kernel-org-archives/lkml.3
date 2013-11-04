Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab3KDRJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:09:39 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:58408 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab3KDRIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:08:24 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        haver@linux.vnet.ibm.com
Subject: [PATCH 7/9] GenWQE: Start using sysfs attribute groups
Date: Mon,  4 Nov 2013 18:08:07 +0100
Message-Id: <1383584889-21594-8-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
References: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110417-6892-0000-0000-000006CCDA36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the existing sysfs infrastructure to create multiple attributes
instead of doing things manually. Use the is_visible callback now
to determine if an attribute is visible or not.

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/card_base.h  |    6 +-
 drivers/misc/genwqe/card_dev.c   |    6 +-
 drivers/misc/genwqe/card_sysfs.c |  199 ++++++++++++++++++++------------------
 3 files changed, 113 insertions(+), 98 deletions(-)

diff --git a/drivers/misc/genwqe/card_base.h b/drivers/misc/genwqe/card_base.h
index 21cef33..76ebfca 100644
--- a/drivers/misc/genwqe/card_base.h
+++ b/drivers/misc/genwqe/card_base.h
@@ -416,11 +416,11 @@ int  genwqe_device_create(struct genwqe_dev *cd);
 int  genwqe_device_remove(struct genwqe_dev *cd);
 
 /* sysfs */
-int  create_card_sysfs(struct genwqe_dev *cd);
-void remove_card_sysfs(struct genwqe_dev *cd);
+int  genwqe_init_sysfs(struct genwqe_dev *cd);
+void genwqe_exit_sysfs(struct genwqe_dev *cd);
 
 /* debugfs */
-int genwqe_init_debugfs(struct genwqe_dev *cd);
+int  genwqe_init_debugfs(struct genwqe_dev *cd);
 void genqwe_exit_debugfs(struct genwqe_dev *cd);
 
 int  genwqe_read_softreset(struct genwqe_dev *cd);
diff --git a/drivers/misc/genwqe/card_dev.c b/drivers/misc/genwqe/card_dev.c
index 9faab2b..fabf749 100644
--- a/drivers/misc/genwqe/card_dev.c
+++ b/drivers/misc/genwqe/card_dev.c
@@ -1389,7 +1389,7 @@ int genwqe_device_create(struct genwqe_dev *cd)
 	}
 	dev_set_drvdata(cd->dev, cd);
 
-	rc = create_card_sysfs(cd);
+	rc = genwqe_init_sysfs(cd);
 	if (rc != 0)
 		goto err_sysfs;
 
@@ -1400,7 +1400,7 @@ int genwqe_device_create(struct genwqe_dev *cd)
 	return 0;
 
  err_debugfs:
-	remove_card_sysfs(cd);
+	genwqe_exit_sysfs(cd);
  err_sysfs:
 	device_destroy(cd->class_genwqe, cd->devnum_genwqe);
  err_cdev:
@@ -1489,7 +1489,7 @@ int genwqe_device_remove(struct genwqe_dev *cd)
 	}
 
 	genqwe_exit_debugfs(cd);
-	remove_card_sysfs(cd);
+	genwqe_exit_sysfs(cd);
 	device_destroy(cd->class_genwqe, cd->devnum_genwqe);
 	cdev_del(&cd->cdev_genwqe);
 	unregister_chrdev_region(cd->devnum_genwqe, GENWQE_MAX_MINOR);
diff --git a/drivers/misc/genwqe/card_sysfs.c b/drivers/misc/genwqe/card_sysfs.c
index cac2e06..6a51ad7 100644
--- a/drivers/misc/genwqe/card_sysfs.c
+++ b/drivers/misc/genwqe/card_sysfs.c
@@ -20,9 +20,8 @@
 
 /*
  * Sysfs interfaces for the GenWQE card. There are attributes to query
- * the version of the bitstream as well as some for the
- * driver. Additionally there are some attributes which help to debug
- * potential problems.
+ * the version of the bitstream as well as some for the driver. For
+ * debugging, please also see the debugfs interfaces of this driver.
  */
 
 #include <linux/version.h>
@@ -34,6 +33,7 @@
 #include <linux/fs.h>
 #include <linux/sysfs.h>
 #include <linux/ctype.h>
+#include <linux/device.h>
 
 #include "card_base.h"
 #include "card_ddcb.h"
@@ -45,9 +45,8 @@ static const char * const genwqe_types[] = {
 	[GENWQE_TYPE_ALTERA_A7]  = "GenWQE5-A7",
 };
 
-static ssize_t show_card_status(struct device *dev,
-				struct device_attribute *attr,
-				char *buf)
+static ssize_t status_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
 {
 	ssize_t len = 0;
 	struct genwqe_dev *cd = dev_get_drvdata(dev);
@@ -57,10 +56,10 @@ static ssize_t show_card_status(struct device *dev,
 			 "%s\n", cs[cd->card_state]);
 	return len;
 }
+static DEVICE_ATTR_RO(status);
 
-static ssize_t show_card_appid(struct device *dev,
-			       struct device_attribute *attr,
-			       char *buf)
+static ssize_t appid_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
 {
 	ssize_t len = 0;
 	char app_name[5];
@@ -71,10 +70,10 @@ static ssize_t show_card_appid(struct device *dev,
 			 "%s\n", app_name);
 	return len;
 }
+static DEVICE_ATTR_RO(appid);
 
-static ssize_t show_card_version(struct device *dev,
-				 struct device_attribute *attr,
-				 char *buf)
+static ssize_t version_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
 {
 	ssize_t len = 0;
 	u64 slu_id, app_id;
@@ -87,23 +86,10 @@ static ssize_t show_card_version(struct device *dev,
 			 "%016llx.%016llx\n", slu_id, app_id);
 	return len;
 }
+static DEVICE_ATTR_RO(version);
 
-/**
- * FIXME Implement me!
- */
-static ssize_t show_cpld_version(struct device *dev,
-				 struct device_attribute *attr,
-				 char *buf)
-{
-	ssize_t len = 0;
-	len += scnprintf(&buf[len], PAGE_SIZE - len,
-			 "unknown (FIXME)\n");
-	return len;
-}
-
-static ssize_t show_card_type(struct device *dev,
-			      struct device_attribute *attr,
-			      char *buf)
+static ssize_t type_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
 {
 	ssize_t len = 0;
 	u8 card_type;
@@ -115,20 +101,20 @@ static ssize_t show_card_type(struct device *dev,
 			 "invalid" : genwqe_types[card_type]);
 	return len;
 }
+static DEVICE_ATTR_RO(type);
 
-static ssize_t show_card_driver(struct device *dev,
-				struct device_attribute *attr,
-				char *buf)
+static ssize_t driver_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
 {
 	ssize_t len = 0;
 	len += scnprintf(&buf[len], PAGE_SIZE - len,
 			 "%s\n", DRV_VERS_STRING);
 	return len;
 }
+static DEVICE_ATTR_RO(driver);
 
-static ssize_t show_card_tempsens(struct device *dev,
-				  struct device_attribute *attr,
-				  char *buf)
+static ssize_t tempsens_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
 {
 	ssize_t len = 0;
 	u64 tempsens;
@@ -139,10 +125,11 @@ static ssize_t show_card_tempsens(struct device *dev,
 			 "%016llx\n", tempsens);
 	return len;
 }
+static DEVICE_ATTR_RO(tempsens);
 
-static ssize_t show_card_base_clock(struct device *dev,
-				    struct device_attribute *attr,
-				    char *buf)
+static ssize_t base_clock_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
 {
 	ssize_t len = 0;
 	u64 base_clock;
@@ -153,9 +140,10 @@ static ssize_t show_card_base_clock(struct device *dev,
 			 "%lld\n", base_clock);
 	return len;
 }
+static DEVICE_ATTR_RO(base_clock);
 
 /**
- * show_card_curr_bitstream() - Show the current bitstream id
+ * curr_bitstream_show() - Show the current bitstream id
  *
  * There is a bug in some old versions of the CPLD which selects the
  * bitstream, which causes the IO_SLU_BITSTREAM register to report
@@ -171,9 +159,9 @@ static ssize_t show_card_base_clock(struct device *dev,
  * on the backup partition (0) to identify problems while loading the
  * image.
  */
-static ssize_t show_card_curr_bitstream(struct device *dev,
-					struct device_attribute *attr,
-					char *buf)
+static ssize_t curr_bitstream_show(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
 {
 	ssize_t len = 0;
 	int curr_bitstream;
@@ -184,21 +172,22 @@ static ssize_t show_card_curr_bitstream(struct device *dev,
 			 "%d\n", curr_bitstream);
 	return len;
 }
+static DEVICE_ATTR_RO(curr_bitstream);
 
 /**
- * show_card_next_bitstream() - Show the next activated bitstream
+ * next_bitstream_show() - Show the next activated bitstream
  *
  * IO_SLC_CFGREG_SOFTRESET: This register can only be accessed by the PF.
  */
-static ssize_t show_card_next_bitstream(struct device *dev,
-					struct device_attribute *attr,
-					char *buf)
+static ssize_t next_bitstream_show(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
 {
 	ssize_t len = 0;
 	int next_bitstream;
 	struct genwqe_dev *cd = dev_get_drvdata(dev);
 
-	switch ((cd->softreset & 0xCull) >> 2) {
+	switch ((cd->softreset & 0xcull) >> 2) {
 	case 0x2:
 		next_bitstream =  0;
 		break;
@@ -214,9 +203,9 @@ static ssize_t show_card_next_bitstream(struct device *dev,
 	return len;
 }
 
-static ssize_t store_card_next_bitstream(struct device *dev,
-					 struct device_attribute *attr,
-					 const char *buf, size_t count)
+static ssize_t next_bitstream_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
 {
 	u64 partition;
 	struct genwqe_dev *cd = dev_get_drvdata(dev);
@@ -238,69 +227,95 @@ static ssize_t store_card_next_bitstream(struct device *dev,
 	__genwqe_writeq(cd, IO_SLC_CFGREG_SOFTRESET, cd->softreset);
 	return count;
 }
+static DEVICE_ATTR_RW(next_bitstream);
+
+/**
+ * FIXME Implement me!
+ */
+static ssize_t cpld_version_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	ssize_t len = 0;
+	len += scnprintf(&buf[len], PAGE_SIZE - len, "unknown (FIXME)\n");
+	return len;
+}
+static DEVICE_ATTR_RO(cpld_version);
 
 /*
  * Create device_attribute structures / params: name, mode, show, store
  * additional flag if valid in VF
  */
-struct genwqe_dev_attrib {
-	struct device_attribute att;	/* sysfs entry attributes */
-	int vf;				/* may exist in VF or not */
+static struct attribute *genwqe_attributes[] = {
+	&dev_attr_tempsens.attr,
+	&dev_attr_next_bitstream.attr,
+	&dev_attr_curr_bitstream.attr,
+	&dev_attr_base_clock.attr,
+	&dev_attr_driver.attr,
+	&dev_attr_type.attr,
+	&dev_attr_version.attr,
+	&dev_attr_appid.attr,
+	&dev_attr_status.attr,
+	&dev_attr_cpld_version.attr,
+	NULL,
 };
 
-static struct genwqe_dev_attrib dev_attr_tab[] = {
-	{__ATTR(tempsens,       S_IRUGO, show_card_tempsens, NULL), 0},
-	{__ATTR(next_bitstream, (S_IRUGO | S_IWUSR),
-		show_card_next_bitstream, store_card_next_bitstream), 0},
-	{__ATTR(curr_bitstream, S_IRUGO, show_card_curr_bitstream, NULL), 0},
-	{__ATTR(cpld_version,   S_IRUGO, show_cpld_version, NULL), 0},
-	{__ATTR(base_clock,	S_IRUGO, show_card_base_clock, NULL), 0},
-
-	{__ATTR(driver,		S_IRUGO, show_card_driver, NULL), 1},
-	{__ATTR(type,		S_IRUGO, show_card_type, NULL), 1},
-	{__ATTR(version,	S_IRUGO, show_card_version, NULL), 1},
-	{__ATTR(appid,		S_IRUGO, show_card_appid, NULL), 1},
-	{__ATTR(status,		S_IRUGO, show_card_status, NULL), 1},
+static struct attribute *genwqe_normal_attributes[] = {
+	&dev_attr_driver.attr,
+	&dev_attr_type.attr,
+	&dev_attr_version.attr,
+	&dev_attr_appid.attr,
+	&dev_attr_status.attr,
+	NULL,
 };
 
 /**
- * create_card_sysfs() - Setup sysfs entries of the card device
+ * genwqe_is_visible() - Determine if sysfs attribute should be visible or not
  *
  * VFs have restricted mmio capabilities, so not all sysfs entries
  * are allowed in VFs.
  */
-int create_card_sysfs(struct genwqe_dev *cd)
+static umode_t genwqe_is_visible(struct kobject *kobj,
+				 struct attribute *attr, int n)
 {
-	int rc, priv;
-	unsigned int i;
-
-	priv = genwqe_is_privileged(cd);
-	for (i = 0; i < ARRAY_SIZE(dev_attr_tab); i++) {
-		struct genwqe_dev_attrib *dev_attr = &dev_attr_tab[i];
-		if (dev_attr->vf || priv) {
-			rc = device_create_file(cd->dev, &dev_attr->att);
-			if (rc != 0)
-				goto err_exit;
-		}
-	}
+	unsigned int j;
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct genwqe_dev *cd = dev_get_drvdata(dev);
+	umode_t mode = attr->mode;
+
+	if (genwqe_is_privileged(cd))
+		return mode;
+
+	for (j = 0; genwqe_normal_attributes[j] != NULL;  j++)
+		if (genwqe_normal_attributes[j] == attr)
+			return mode;
+
 	return 0;
+}
+
+static struct attribute_group genwqe_attribute_group = {
+	.is_visible = genwqe_is_visible,
+	.attrs      = genwqe_attributes,
+};
 
- err_exit:
-	return -ENXIO;
+/**
+ * genwqe_init_sysfs() - Setup sysfs entries of the card device
+ */
+int genwqe_init_sysfs(struct genwqe_dev *cd)
+{
+	int rc;
+
+	rc = sysfs_create_group(&cd->dev->kobj, &genwqe_attribute_group);
+	if (rc)
+		return -ENXIO;
+
+	return 0;
 }
 
 /**
- * remove_card_sysfs() - Remove sysfs entries
+ * genwqe_exit_sysfs() - Remove sysfs entries
  */
-void remove_card_sysfs(struct genwqe_dev *cd)
+void genwqe_exit_sysfs(struct genwqe_dev *cd)
 {
-	int priv;
-	unsigned int i;
-
-	priv = genwqe_is_privileged(cd);
-	for (i = 0; i < ARRAY_SIZE(dev_attr_tab); i++) {
-		struct genwqe_dev_attrib *dev_attr = &dev_attr_tab[i];
-		if (dev_attr->vf || priv)
-			device_remove_file(cd->dev, &dev_attr->att);
-	}
+	sysfs_remove_group(&cd->dev->kobj, &genwqe_attribute_group);
 }
-- 
1.7.1

