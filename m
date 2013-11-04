Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3KDDjB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 22:39:01 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:40842 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab3KDDi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 22:38:57 -0500
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>
Cc: linux-kernel@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>
Subject: [PATCH 4/5 v2] tpm: Use the ops structure instead of a copy in tpm_vendor_specific
Date: Sun,  3 Nov 2013 20:38:45 -0700
Message-Id: <1383536326-28772-5-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This builds on the last commit to use the ops structure in the core
and reduce the size of tpm_vendor_specific.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Joel Schopp <jschopp@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm-interface.c    | 34 ++++++++++++----------------------
 drivers/char/tpm/tpm-sysfs.c        |  2 +-
 drivers/char/tpm/tpm.h              |  9 +--------
 drivers/char/tpm/tpm_i2c_stm_st33.c |  4 ++--
 4 files changed, 16 insertions(+), 33 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 0662b70..5a2807c 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -353,7 +353,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 
 	mutex_lock(&chip->tpm_mutex);
 
-	rc = chip->vendor.send(chip, (u8 *) buf, count);
+	rc = chip->ops->send(chip, (u8 *) buf, count);
 	if (rc < 0) {
 		dev_err(chip->dev,
 			"tpm_transmit: tpm_send: error %zd\n", rc);
@@ -365,12 +365,12 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 
 	stop = jiffies + tpm_calc_ordinal_duration(chip, ordinal);
 	do {
-		u8 status = chip->vendor.status(chip);
-		if ((status & chip->vendor.req_complete_mask) ==
-		    chip->vendor.req_complete_val)
+		u8 status = chip->ops->status(chip);
+		if ((status & chip->ops->req_complete_mask) ==
+		    chip->ops->req_complete_val)
 			goto out_recv;
 
-		if (chip->vendor.req_canceled(chip, status)) {
+		if (chip->ops->req_canceled(chip, status)) {
 			dev_err(chip->dev, "Operation Canceled\n");
 			rc = -ECANCELED;
 			goto out;
@@ -380,13 +380,13 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 		rmb();
 	} while (time_before(jiffies, stop));
 
-	chip->vendor.cancel(chip);
+	chip->ops->cancel(chip);
 	dev_err(chip->dev, "Operation Timed out\n");
 	rc = -ETIME;
 	goto out;
 
 out_recv:
-	rc = chip->vendor.recv(chip, (u8 *) buf, bufsiz);
+	rc = chip->ops->recv(chip, (u8 *) buf, bufsiz);
 	if (rc < 0)
 		dev_err(chip->dev,
 			"tpm_transmit: tpm_recv: error %zd\n", rc);
@@ -807,12 +807,12 @@ EXPORT_SYMBOL_GPL(tpm_send);
 static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask,
 				   bool check_cancel, bool *canceled)
 {
-	u8 status = chip->vendor.status(chip);
+	u8 status = chip->ops->status(chip);
 
 	*canceled = false;
 	if ((status & mask) == mask)
 		return true;
-	if (check_cancel && chip->vendor.req_canceled(chip, status)) {
+	if (check_cancel && chip->ops->req_canceled(chip, status)) {
 		*canceled = true;
 		return true;
 	}
@@ -828,7 +828,7 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
 	bool canceled = false;
 
 	/* check current status */
-	status = chip->vendor.status(chip);
+	status = chip->ops->status(chip);
 	if ((status & mask) == mask)
 		return 0;
 
@@ -855,7 +855,7 @@ again:
 	} else {
 		do {
 			msleep(TPM_TIMEOUT);
-			status = chip->vendor.status(chip);
+			status = chip->ops->status(chip);
 			if ((status & mask) == mask)
 				return 0;
 		} while (time_before(jiffies, stop));
@@ -1027,9 +1027,6 @@ void tpm_dev_vendor_release(struct tpm_chip *chip)
 	if (!chip)
 		return;
 
-	if (chip->vendor.release)
-		chip->vendor.release(chip->dev);
-
 	clear_bit(chip->dev_num, dev_mask);
 }
 EXPORT_SYMBOL_GPL(tpm_dev_vendor_release);
@@ -1074,14 +1071,7 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 	mutex_init(&chip->tpm_mutex);
 	INIT_LIST_HEAD(&chip->list);
 
-	chip->vendor.req_complete_mask = ops->req_complete_mask;
-	chip->vendor.req_complete_val = ops->req_complete_val;
-	chip->vendor.req_canceled = ops->req_canceled;
-	chip->vendor.recv = ops->recv;
-	chip->vendor.send = ops->send;
-	chip->vendor.cancel = ops->cancel;
-	chip->vendor.status = ops->status;
-
+	chip->ops = ops;
 	chip->dev_num = find_first_zero_bit(dev_mask, TPM_NUM_DEVICES);
 
 	if (chip->dev_num >= TPM_NUM_DEVICES) {
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 3bcfed0..d2a8bca 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -245,7 +245,7 @@ static ssize_t cancel_store(struct device *dev, struct device_attribute *attr,
 	if (chip == NULL)
 		return 0;
 
-	chip->vendor.cancel(chip);
+	chip->ops->cancel(chip);
 	return count;
 }
 static DEVICE_ATTR_WO(cancel);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index a56af2c..7b0a46e 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -64,9 +64,6 @@ enum tpm_duration {
 struct tpm_chip;
 
 struct tpm_vendor_specific {
-	u8 req_complete_mask;
-	u8 req_complete_val;
-	bool (*req_canceled)(struct tpm_chip *chip, u8 status);
 	void __iomem *iobase;		/* ioremapped address */
 	unsigned long base;		/* TPM base address */
 
@@ -76,11 +73,6 @@ struct tpm_vendor_specific {
 	int region_size;
 	int have_region;
 
-	int (*recv) (struct tpm_chip *, u8 *, size_t);
-	int (*send) (struct tpm_chip *, u8 *, size_t);
-	void (*cancel) (struct tpm_chip *);
-	u8 (*status) (struct tpm_chip *);
-	void (*release) (struct device *);
 	struct miscdevice miscdev;
 	struct list_head list;
 	int locality;
@@ -104,6 +96,7 @@ struct tpm_vendor_specific {
 
 struct tpm_chip {
 	struct device *dev;	/* Device stuff */
+	const struct tpm_class_ops *ops;
 
 	int dev_num;		/* /dev/tpm# */
 	char devname[7];
diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index 874b3be..5b0dd8e 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -564,7 +564,7 @@ static int tpm_stm_i2c_recv(struct tpm_chip *chip, unsigned char *buf,
 	}
 
 out:
-	chip->vendor.cancel(chip);
+	chip->ops->cancel(chip);
 	release_locality(chip);
 	return size;
 }
@@ -807,7 +807,7 @@ static int tpm_st33_i2c_pm_resume(struct device *dev)
 	if (power_mgt) {
 		gpio_set_value(pin_infos->io_lpcpd, 1);
 		ret = wait_for_serirq_timeout(chip,
-					  (chip->vendor.status(chip) &
+					  (chip->ops->status(chip) &
 					  TPM_STS_VALID) == TPM_STS_VALID,
 					  chip->vendor.timeout_b);
 	} else {
-- 
1.8.1.2

