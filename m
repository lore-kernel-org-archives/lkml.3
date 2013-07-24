Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3GXWOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:14:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3GXWGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:06:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 26/36] SCSI: st: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:29 -0700
Message-Id: <1374703539-9705-27-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the scsi tape class code to use
the correct field.

Cc: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

James, feel free to take this through your tree, or ACK it and I can
take it through mine.

 drivers/scsi/st.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 2a32036a..ff44b3c2 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -82,7 +82,7 @@ static int try_rdio = 1;
 static int try_wdio = 1;
 
 static struct class st_sysfs_class;
-static struct device_attribute st_dev_attrs[];
+static const struct attribute_group *st_dev_groups[];
 
 MODULE_AUTHOR("Kai Makisara");
 MODULE_DESCRIPTION("SCSI tape (st) driver");
@@ -4274,7 +4274,7 @@ static void scsi_tape_release(struct kref *kref)
 
 static struct class st_sysfs_class = {
 	.name = "scsi_tape",
-	.dev_attrs = st_dev_attrs,
+	.dev_groups = st_dev_groups,
 };
 
 static int __init init_st(void)
@@ -4408,6 +4408,7 @@ defined_show(struct device *dev, struct device_attribute *attr, char *buf)
 	l = snprintf(buf, PAGE_SIZE, "%d\n", STm->defined);
 	return l;
 }
+static DEVICE_ATTR_RO(defined);
 
 static ssize_t
 default_blksize_show(struct device *dev, struct device_attribute *attr,
@@ -4419,7 +4420,7 @@ default_blksize_show(struct device *dev, struct device_attribute *attr,
 	l = snprintf(buf, PAGE_SIZE, "%d\n", STm->default_blksize);
 	return l;
 }
-
+static DEVICE_ATTR_RO(default_blksize);
 
 static ssize_t
 default_density_show(struct device *dev, struct device_attribute *attr,
@@ -4433,6 +4434,7 @@ default_density_show(struct device *dev, struct device_attribute *attr,
 	l = snprintf(buf, PAGE_SIZE, fmt, STm->default_density);
 	return l;
 }
+static DEVICE_ATTR_RO(default_density);
 
 static ssize_t
 default_compression_show(struct device *dev, struct device_attribute *attr,
@@ -4444,6 +4446,7 @@ default_compression_show(struct device *dev, struct device_attribute *attr,
 	l = snprintf(buf, PAGE_SIZE, "%d\n", STm->default_compression - 1);
 	return l;
 }
+static DEVICE_ATTR_RO(default_compression);
 
 static ssize_t
 options_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -4472,15 +4475,17 @@ options_show(struct device *dev, struct device_attribute *attr, char *buf)
 	l = snprintf(buf, PAGE_SIZE, "0x%08x\n", options);
 	return l;
 }
-
-static struct device_attribute st_dev_attrs[] = {
-	__ATTR_RO(defined),
-	__ATTR_RO(default_blksize),
-	__ATTR_RO(default_density),
-	__ATTR_RO(default_compression),
-	__ATTR_RO(options),
-	__ATTR_NULL,
+static DEVICE_ATTR_RO(options);
+
+static struct attribute *st_dev_attrs[] = {
+	&dev_attr_defined.attr,
+	&dev_attr_default_blksize.attr,
+	&dev_attr_default_density.attr,
+	&dev_attr_default_compression.attr,
+	&dev_attr_options.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(st_dev);
 
 /* The following functions may be useful for a larger audience. */
 static int sgl_map_user_pages(struct st_buffer *STbp,
-- 
1.8.3.rc0.20.gb99dd2e

