Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbaADCng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 21:43:36 -0500
Received: from mout.gmx.net ([212.227.15.19]:64305 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbaADCnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 21:43:16 -0500
From: Peter Huewe <peterhuewe@gmx.de>
To: James Morris <jmorris@namei.org>
Cc: Ashley Lai <ashley@ashleylai.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 10/15] tpm: Pull all driver sysfs code into tpm-sysfs.c
Date: Sat,  4 Jan 2014 03:44:44 +0100
Message-Id: <1388803489-13258-10-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
References: <201401040335.04980.PeterHuewe@gmx.de>
 <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:Le+l+ZxAoVFkMRzfvjUicVLTracPilqw02RLGeFJVqP486KREXz
 FJO/xs7jkIwGjOs5s/HW0FCb8d3FQXV4jDSW/8Xw1Lb9UGZBaKS9sYxjLLaRTxzn+c7hpAa
 1Br89RT4zvub5GAL9oBOPXQ4yQaJ2V8HjOLn8fzHSCBssLuh0fw7OqCrP7f2kZrPs8YYAk5
 VlnP2FAFdyOxXoVYmz5pg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

The tpm core now sets up and controls all sysfs attributes, instead
of having each driver have a unique take on it.

All drivers now now have a uniform set of attributes, and no sysfs
related entry points are exported from the tpm core module.

This also uses the new method used to declare sysfs attributes
with DEVICE_ATTR_RO and 'struct attribute *'

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
[phuewe: had to apply the tpm_i2c_atmel part manually due to commit
191ffc6bde3fc tpm/tpm_i2c_atmel: fix coccinelle warnings]

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm-interface.c    |  4 +-
 drivers/char/tpm/tpm-sysfs.c        | 99 +++++++++++++++++++++++++------------
 drivers/char/tpm/tpm.h              | 24 +--------
 drivers/char/tpm/tpm_atmel.c        | 16 ------
 drivers/char/tpm/tpm_i2c_atmel.c    | 30 -----------
 drivers/char/tpm/tpm_i2c_infineon.c | 30 -----------
 drivers/char/tpm/tpm_i2c_nuvoton.c  | 30 -----------
 drivers/char/tpm/tpm_i2c_stm_st33.c | 25 ----------
 drivers/char/tpm/tpm_ibmvtpm.c      | 28 -----------
 drivers/char/tpm/tpm_infineon.c     | 16 ------
 drivers/char/tpm/tpm_nsc.c          | 16 ------
 drivers/char/tpm/tpm_tis.c          | 30 -----------
 drivers/char/tpm/xen-tpmfront.c     | 31 ------------
 13 files changed, 72 insertions(+), 307 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 3f8bddf..389d483 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -879,7 +879,7 @@ void tpm_remove_hardware(struct device *dev)
 	synchronize_rcu();
 
 	tpm_dev_del_device(chip);
-	sysfs_remove_group(&dev->kobj, chip->vendor.attr_group);
+	tpm_sysfs_del_device(chip);
 	tpm_remove_ppi(&dev->kobj);
 	tpm_bios_log_teardown(chip->bios_dir);
 
@@ -1095,7 +1095,7 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 	if (tpm_dev_add_device(chip))
 		goto put_device;
 
-	if (sysfs_create_group(&dev->kobj, chip->vendor.attr_group))
+	if (tpm_sysfs_add_device(chip))
 		goto del_misc;
 
 	if (tpm_add_ppi(&dev->kobj))
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 310d960..506a07b 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -6,6 +6,9 @@
  * Reiner Sailer <sailer@watson.ibm.com>
  * Kylene Hall <kjhall@us.ibm.com>
  *
+ * Copyright (C) 2013 Obsidian Research Corp
+ * Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
+ *
  * sysfs filesystem inspection interface to the TPM
  *
  * This program is free software; you can redistribute it and/or
@@ -43,9 +46,8 @@ static struct tpm_input_header tpm_readpubek_header = {
 	.length = cpu_to_be32(30),
 	.ordinal = TPM_ORD_READPUBEK
 };
-
-ssize_t tpm_show_pubek(struct device *dev, struct device_attribute *attr,
-		       char *buf)
+static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
 {
 	u8 *data;
 	struct tpm_cmd_t tpm_cmd;
@@ -99,10 +101,10 @@ out:
 	rc = str - buf;
 	return rc;
 }
-EXPORT_SYMBOL_GPL(tpm_show_pubek);
+static DEVICE_ATTR_RO(pubek);
 
-ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
-		      char *buf)
+static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
 {
 	cap_t cap;
 	u8 digest[TPM_DIGEST_SIZE];
@@ -128,10 +130,10 @@ ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
 	}
 	return str - buf;
 }
-EXPORT_SYMBOL_GPL(tpm_show_pcrs);
+static DEVICE_ATTR_RO(pcrs);
 
-ssize_t tpm_show_enabled(struct device *dev, struct device_attribute *attr,
-			char *buf)
+static ssize_t enabled_show(struct device *dev, struct device_attribute *attr,
+		     char *buf)
 {
 	cap_t cap;
 	ssize_t rc;
@@ -144,10 +146,10 @@ ssize_t tpm_show_enabled(struct device *dev, struct device_attribute *attr,
 	rc = sprintf(buf, "%d\n", !cap.perm_flags.disable);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(tpm_show_enabled);
+static DEVICE_ATTR_RO(enabled);
 
-ssize_t tpm_show_active(struct device *dev, struct device_attribute *attr,
-			char *buf)
+ssize_t active_show(struct device *dev, struct device_attribute *attr,
+		    char *buf)
 {
 	cap_t cap;
 	ssize_t rc;
@@ -160,10 +162,10 @@ ssize_t tpm_show_active(struct device *dev, struct device_attribute *attr,
 	rc = sprintf(buf, "%d\n", !cap.perm_flags.deactivated);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(tpm_show_active);
+static DEVICE_ATTR_RO(active);
 
-ssize_t tpm_show_owned(struct device *dev, struct device_attribute *attr,
-			char *buf)
+static ssize_t owned_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
 {
 	cap_t cap;
 	ssize_t rc;
@@ -176,10 +178,10 @@ ssize_t tpm_show_owned(struct device *dev, struct device_attribute *attr,
 	rc = sprintf(buf, "%d\n", cap.owned);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(tpm_show_owned);
+static DEVICE_ATTR_RO(owned);
 
-ssize_t tpm_show_temp_deactivated(struct device *dev,
-				struct device_attribute *attr, char *buf)
+static ssize_t temp_deactivated_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
 {
 	cap_t cap;
 	ssize_t rc;
@@ -192,10 +194,10 @@ ssize_t tpm_show_temp_deactivated(struct device *dev,
 	rc = sprintf(buf, "%d\n", cap.stclear_flags.deactivated);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(tpm_show_temp_deactivated);
+static DEVICE_ATTR_RO(temp_deactivated);
 
-ssize_t tpm_show_caps(struct device *dev, struct device_attribute *attr,
-		      char *buf)
+static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
 {
 	cap_t cap;
 	ssize_t rc;
@@ -234,10 +236,10 @@ ssize_t tpm_show_caps(struct device *dev, struct device_attribute *attr,
 
 	return str - buf;
 }
-EXPORT_SYMBOL_GPL(tpm_show_caps);
+static DEVICE_ATTR_RO(caps);
 
-ssize_t tpm_store_cancel(struct device *dev, struct device_attribute *attr,
-			const char *buf, size_t count)
+static ssize_t cancel_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	if (chip == NULL)
@@ -246,10 +248,10 @@ ssize_t tpm_store_cancel(struct device *dev, struct device_attribute *attr,
 	chip->vendor.cancel(chip);
 	return count;
 }
-EXPORT_SYMBOL_GPL(tpm_store_cancel);
+static DEVICE_ATTR_WO(cancel);
 
-ssize_t tpm_show_durations(struct device *dev, struct device_attribute *attr,
-			  char *buf)
+static ssize_t durations_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
@@ -263,10 +265,10 @@ ssize_t tpm_show_durations(struct device *dev, struct device_attribute *attr,
 		       chip->vendor.duration_adjusted
 		       ? "adjusted" : "original");
 }
-EXPORT_SYMBOL_GPL(tpm_show_durations);
+static DEVICE_ATTR_RO(durations);
 
-ssize_t tpm_show_timeouts(struct device *dev, struct device_attribute *attr,
-			  char *buf)
+static ssize_t timeouts_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 
@@ -278,4 +280,39 @@ ssize_t tpm_show_timeouts(struct device *dev, struct device_attribute *attr,
 		       chip->vendor.timeout_adjusted
 		       ? "adjusted" : "original");
 }
-EXPORT_SYMBOL_GPL(tpm_show_timeouts);
+static DEVICE_ATTR_RO(timeouts);
+
+static struct attribute *tpm_dev_attrs[] = {
+	&dev_attr_pubek.attr,
+	&dev_attr_pcrs.attr,
+	&dev_attr_enabled.attr,
+	&dev_attr_active.attr,
+	&dev_attr_owned.attr,
+	&dev_attr_temp_deactivated.attr,
+	&dev_attr_caps.attr,
+	&dev_attr_cancel.attr,
+	&dev_attr_durations.attr,
+	&dev_attr_timeouts.attr,
+	NULL,
+};
+
+static const struct attribute_group tpm_dev_group = {
+	.attrs = tpm_dev_attrs,
+};
+
+int tpm_sysfs_add_device(struct tpm_chip *chip)
+{
+	int err;
+	err = sysfs_create_group(&chip->dev->kobj,
+				 &tpm_dev_group);
+
+	if (err)
+		dev_err(chip->dev,
+			"failed to create sysfs attributes, %d\n", err);
+	return err;
+}
+
+void tpm_sysfs_del_device(struct tpm_chip *chip)
+{
+	sysfs_remove_group(&chip->dev->kobj, &tpm_dev_group);
+}
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 41b1480..14ba162 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -61,27 +61,6 @@ enum tpm_duration {
 #define TPM_ERR_INVALID_POSTINIT 38
 
 #define TPM_HEADER_SIZE		10
-extern ssize_t tpm_show_pubek(struct device *, struct device_attribute *attr,
-				char *);
-extern ssize_t tpm_show_pcrs(struct device *, struct device_attribute *attr,
-				char *);
-extern ssize_t tpm_show_caps(struct device *, struct device_attribute *attr,
-				char *);
-extern ssize_t tpm_store_cancel(struct device *, struct device_attribute *attr,
-				const char *, size_t);
-extern ssize_t tpm_show_enabled(struct device *, struct device_attribute *attr,
-				char *);
-extern ssize_t tpm_show_active(struct device *, struct device_attribute *attr,
-				char *);
-extern ssize_t tpm_show_owned(struct device *, struct device_attribute *attr,
-				char *);
-extern ssize_t tpm_show_temp_deactivated(struct device *,
-					 struct device_attribute *attr, char *);
-extern ssize_t tpm_show_durations(struct device *,
-				  struct device_attribute *attr, char *);
-extern ssize_t tpm_show_timeouts(struct device *,
-				 struct device_attribute *attr, char *);
-
 struct tpm_chip;
 
 struct tpm_vendor_specific {
@@ -103,7 +82,6 @@ struct tpm_vendor_specific {
 	u8 (*status) (struct tpm_chip *);
 	void (*release) (struct device *);
 	struct miscdevice miscdev;
-	struct attribute_group *attr_group;
 	struct list_head list;
 	int locality;
 	unsigned long timeout_a, timeout_b, timeout_c, timeout_d; /* jiffies */
@@ -368,6 +346,8 @@ extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
 
 int tpm_dev_add_device(struct tpm_chip *chip);
 void tpm_dev_del_device(struct tpm_chip *chip);
+int tpm_sysfs_add_device(struct tpm_chip *chip);
+void tpm_sysfs_del_device(struct tpm_chip *chip);
 
 int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
 
diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
index 9692e2f..7e665d0 100644
--- a/drivers/char/tpm/tpm_atmel.c
+++ b/drivers/char/tpm/tpm_atmel.c
@@ -121,21 +121,6 @@ static bool tpm_atml_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == ATML_STATUS_READY);
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR |S_IWGRP, NULL, tpm_store_cancel);
-
-static struct attribute* atmel_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	NULL,
-};
-
-static struct attribute_group atmel_attr_grp = { .attrs = atmel_attrs };
-
 static const struct tpm_vendor_specific tpm_atmel = {
 	.recv = tpm_atml_recv,
 	.send = tpm_atml_send,
@@ -144,7 +129,6 @@ static const struct tpm_vendor_specific tpm_atmel = {
 	.req_complete_mask = ATML_STATUS_BUSY | ATML_STATUS_DATA_AVAIL,
 	.req_complete_val = ATML_STATUS_DATA_AVAIL,
 	.req_canceled = tpm_atml_req_canceled,
-	.attr_group = &atmel_attr_grp,
 };
 
 static struct platform_device *pdev;
diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
index 079c19d..fe8bdce 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -135,35 +135,6 @@ static u8 i2c_atmel_read_status(struct tpm_chip *chip)
 	return ATMEL_STS_OK;
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
-static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
-static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
-static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
-static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
-static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
-
-static struct attribute *i2c_atmel_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_enabled.attr,
-	&dev_attr_active.attr,
-	&dev_attr_owned.attr,
-	&dev_attr_temp_deactivated.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	&dev_attr_durations.attr,
-	&dev_attr_timeouts.attr,
-	NULL,
-};
-
-static struct attribute_group i2c_atmel_attr_grp = {
-	.attrs = i2c_atmel_attrs
-};
-
 static bool i2c_atmel_req_canceled(struct tpm_chip *chip, u8 status)
 {
 	return false;
@@ -177,7 +148,6 @@ static const struct tpm_vendor_specific i2c_atmel = {
 	.req_complete_mask = ATMEL_STS_OK,
 	.req_complete_val = ATMEL_STS_OK,
 	.req_canceled = i2c_atmel_req_canceled,
-	.attr_group = &i2c_atmel_attr_grp,
 };
 
 static int i2c_atmel_probe(struct i2c_client *client,
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index c1ba7fa..ac1218f 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -566,35 +566,6 @@ static bool tpm_tis_i2c_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == TPM_STS_COMMAND_READY);
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
-static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
-static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
-static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
-static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
-static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
-
-static struct attribute *tis_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_enabled.attr,
-	&dev_attr_active.attr,
-	&dev_attr_owned.attr,
-	&dev_attr_temp_deactivated.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	&dev_attr_durations.attr,
-	&dev_attr_timeouts.attr,
-	NULL,
-};
-
-static struct attribute_group tis_attr_grp = {
-	.attrs = tis_attrs
-};
-
 static struct tpm_vendor_specific tpm_tis_i2c = {
 	.status = tpm_tis_i2c_status,
 	.recv = tpm_tis_i2c_recv,
@@ -603,7 +574,6 @@ static struct tpm_vendor_specific tpm_tis_i2c = {
 	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_canceled = tpm_tis_i2c_req_canceled,
-	.attr_group = &tis_attr_grp,
 };
 
 static int tpm_tis_i2c_init(struct device *dev)
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index c9bb60e..1e6905b 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -455,35 +455,6 @@ static bool i2c_nuvoton_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == TPM_STS_COMMAND_READY);
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
-static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
-static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
-static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
-static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
-static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
-
-static struct attribute *i2c_nuvoton_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_enabled.attr,
-	&dev_attr_active.attr,
-	&dev_attr_owned.attr,
-	&dev_attr_temp_deactivated.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	&dev_attr_durations.attr,
-	&dev_attr_timeouts.attr,
-	NULL,
-};
-
-static struct attribute_group i2c_nuvoton_attr_grp = {
-	.attrs = i2c_nuvoton_attrs
-};
-
 static const struct tpm_vendor_specific tpm_i2c = {
 	.status = i2c_nuvoton_read_status,
 	.recv = i2c_nuvoton_recv,
@@ -492,7 +463,6 @@ static const struct tpm_vendor_specific tpm_i2c = {
 	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_canceled = i2c_nuvoton_req_canceled,
-	.attr_group = &i2c_nuvoton_attr_grp,
 };
 
 /* The only purpose for the handler is to signal to any waiting threads that
diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index e519e68..6902f7b 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -574,30 +574,6 @@ static bool tpm_st33_i2c_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == TPM_STS_COMMAND_READY);
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
-static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
-static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
-static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
-
-static struct attribute *stm_tpm_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_enabled.attr,
-	&dev_attr_active.attr,
-	&dev_attr_owned.attr,
-	&dev_attr_temp_deactivated.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr, NULL,
-};
-
-static struct attribute_group stm_tpm_attr_grp = {
-	.attrs = stm_tpm_attrs
-};
-
 static struct tpm_vendor_specific st_i2c_tpm = {
 	.send = tpm_stm_i2c_send,
 	.recv = tpm_stm_i2c_recv,
@@ -606,7 +582,6 @@ static struct tpm_vendor_specific st_i2c_tpm = {
 	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_canceled = tpm_st33_i2c_req_canceled,
-	.attr_group = &stm_tpm_attr_grp,
 };
 
 static int interrupts;
diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 2ee4309..ff064f0 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -403,33 +403,6 @@ static bool tpm_ibmvtpm_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == 0);
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
-static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
-static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
-static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated,
-		   NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
-static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
-static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
-
-static struct attribute *ibmvtpm_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_enabled.attr,
-	&dev_attr_active.attr,
-	&dev_attr_owned.attr,
-	&dev_attr_temp_deactivated.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	&dev_attr_durations.attr,
-	&dev_attr_timeouts.attr, NULL,
-};
-
-static struct attribute_group ibmvtpm_attr_grp = { .attrs = ibmvtpm_attrs };
-
 static const struct tpm_vendor_specific tpm_ibmvtpm = {
 	.recv = tpm_ibmvtpm_recv,
 	.send = tpm_ibmvtpm_send,
@@ -438,7 +411,6 @@ static const struct tpm_vendor_specific tpm_ibmvtpm = {
 	.req_complete_mask = 0,
 	.req_complete_val = 0,
 	.req_canceled = tpm_ibmvtpm_req_canceled,
-	.attr_group = &ibmvtpm_attr_grp,
 };
 
 static const struct dev_pm_ops tpm_ibmvtpm_pm_ops = {
diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infineon.c
index c75c10c..9525be5 100644
--- a/drivers/char/tpm/tpm_infineon.c
+++ b/drivers/char/tpm/tpm_infineon.c
@@ -371,21 +371,6 @@ static u8 tpm_inf_status(struct tpm_chip *chip)
 	return tpm_data_in(STAT);
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
-
-static struct attribute *inf_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	NULL,
-};
-
-static struct attribute_group inf_attr_grp = {.attrs = inf_attrs };
-
 static const struct tpm_vendor_specific tpm_inf = {
 	.recv = tpm_inf_recv,
 	.send = tpm_inf_send,
@@ -393,7 +378,6 @@ static const struct tpm_vendor_specific tpm_inf = {
 	.status = tpm_inf_status,
 	.req_complete_mask = 0,
 	.req_complete_val = 0,
-	.attr_group = &inf_attr_grp,
 };
 
 static const struct pnp_device_id tpm_inf_pnp_tbl[] = {
diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index a4acac9..ad980be 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -232,21 +232,6 @@ static bool tpm_nsc_req_canceled(struct tpm_chip *chip, u8 status)
 	return (status == NSC_STATUS_RDY);
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR|S_IWGRP, NULL, tpm_store_cancel);
-
-static struct attribute * nsc_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	NULL,
-};
-
-static struct attribute_group nsc_attr_grp = { .attrs = nsc_attrs };
-
 static const struct tpm_vendor_specific tpm_nsc = {
 	.recv = tpm_nsc_recv,
 	.send = tpm_nsc_send,
@@ -255,7 +240,6 @@ static const struct tpm_vendor_specific tpm_nsc = {
 	.req_complete_mask = NSC_STATUS_OBF,
 	.req_complete_val = NSC_STATUS_OBF,
 	.req_canceled = tpm_nsc_req_canceled,
-	.attr_group = &nsc_attr_grp,
 };
 
 static struct platform_device *pdev = NULL;
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 46f57f5..a362ede 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -432,35 +432,6 @@ static bool tpm_tis_req_canceled(struct tpm_chip *chip, u8 status)
 	}
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
-static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
-static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
-static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated,
-		   NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
-static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
-static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
-
-static struct attribute *tis_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_enabled.attr,
-	&dev_attr_active.attr,
-	&dev_attr_owned.attr,
-	&dev_attr_temp_deactivated.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	&dev_attr_durations.attr,
-	&dev_attr_timeouts.attr, NULL,
-};
-
-static struct attribute_group tis_attr_grp = {
-	.attrs = tis_attrs
-};
-
 static struct tpm_vendor_specific tpm_tis = {
 	.status = tpm_tis_status,
 	.recv = tpm_tis_recv,
@@ -469,7 +440,6 @@ static struct tpm_vendor_specific tpm_tis = {
 	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_canceled = tpm_tis_req_canceled,
-	.attr_group = &tis_attr_grp,
 };
 
 static irqreturn_t tis_int_probe(int irq, void *dev_id)
diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
index e3c7c01..d4f6b521 100644
--- a/drivers/char/tpm/xen-tpmfront.c
+++ b/drivers/char/tpm/xen-tpmfront.c
@@ -143,36 +143,6 @@ static int vtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	return length;
 }
 
-static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
-static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
-static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
-static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
-static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
-static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated,
-		NULL);
-static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
-static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
-static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
-static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
-
-static struct attribute *vtpm_attrs[] = {
-	&dev_attr_pubek.attr,
-	&dev_attr_pcrs.attr,
-	&dev_attr_enabled.attr,
-	&dev_attr_active.attr,
-	&dev_attr_owned.attr,
-	&dev_attr_temp_deactivated.attr,
-	&dev_attr_caps.attr,
-	&dev_attr_cancel.attr,
-	&dev_attr_durations.attr,
-	&dev_attr_timeouts.attr,
-	NULL,
-};
-
-static struct attribute_group vtpm_attr_grp = {
-	.attrs = vtpm_attrs,
-};
-
 static const struct tpm_vendor_specific tpm_vtpm = {
 	.status = vtpm_status,
 	.recv = vtpm_recv,
@@ -181,7 +151,6 @@ static const struct tpm_vendor_specific tpm_vtpm = {
 	.req_complete_mask = VTPM_STATUS_IDLE | VTPM_STATUS_RESULT,
 	.req_complete_val  = VTPM_STATUS_IDLE | VTPM_STATUS_RESULT,
 	.req_canceled      = vtpm_req_canceled,
-	.attr_group = &vtpm_attr_grp,
 };
 
 static irqreturn_t tpmif_interrupt(int dummy, void *dev_id)
-- 
1.8.1.5

