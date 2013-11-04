Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3KDDje (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 22:39:34 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:48359 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3KDDi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 22:38:57 -0500
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>
Cc: linux-kernel@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>
Subject: [PATCH 5/5 v2] tpm: Make tpm-dev allocate a per-file structure
Date: Sun,  3 Nov 2013 20:38:46 -0700
Message-Id: <1383536326-28772-6-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This consolidates everything that is only used within tpm-dev.c
into tpm-dev.c and out of the publicly visible struct tpm_chip.

The per-file allocation lays the ground work for someday fixing the
strange forced O_EXCL behaviour of the current code.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Joel Schopp <jschopp@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm-dev.c | 100 ++++++++++++++++++++++++++-------------------
 drivers/char/tpm/tpm.h     |   7 ----
 2 files changed, 57 insertions(+), 50 deletions(-)

diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index 8d94e97..f492eb6 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -22,21 +22,34 @@
 #include <linux/uaccess.h>
 #include "tpm.h"
 
+struct file_priv {
+	struct tpm_chip *chip;
+
+	/* Data passed to and from the tpm via the read/write calls */
+	atomic_t data_pending;
+	struct mutex buffer_mutex;
+
+	struct timer_list user_read_timer;      /* user needs to claim result */
+	struct work_struct work;
+
+	u8 data_buffer[TPM_BUFSIZE];
+};
+
 static void user_reader_timeout(unsigned long ptr)
 {
-	struct tpm_chip *chip = (struct tpm_chip *) ptr;
+	struct file_priv *priv = (struct file_priv *)ptr;
 
-	schedule_work(&chip->work);
+	schedule_work(&priv->work);
 }
 
 static void timeout_work(struct work_struct *work)
 {
-	struct tpm_chip *chip = container_of(work, struct tpm_chip, work);
+	struct file_priv *priv = container_of(work, struct file_priv, work);
 
-	mutex_lock(&chip->buffer_mutex);
-	atomic_set(&chip->data_pending, 0);
-	memset(chip->data_buffer, 0, TPM_BUFSIZE);
-	mutex_unlock(&chip->buffer_mutex);
+	mutex_lock(&priv->buffer_mutex);
+	atomic_set(&priv->data_pending, 0);
+	memset(priv->data_buffer, 0, sizeof(priv->data_buffer));
+	mutex_unlock(&priv->buffer_mutex);
 }
 
 static int tpm_open(struct inode *inode, struct file *file)
@@ -44,6 +57,7 @@ static int tpm_open(struct inode *inode, struct file *file)
 	struct miscdevice *misc = file->private_data;
 	struct tpm_chip *chip = container_of(misc, struct tpm_chip,
 					     vendor.miscdev);
+	struct file_priv *priv;
 
 	/* It's assured that the chip will be opened just once,
 	 * by the check of is_open variable, which is protected
@@ -53,15 +67,20 @@ static int tpm_open(struct inode *inode, struct file *file)
 		return -EBUSY;
 	}
 
-	chip->data_buffer = kzalloc(TPM_BUFSIZE, GFP_KERNEL);
-	if (chip->data_buffer == NULL) {
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv == NULL) {
 		clear_bit(0, &chip->is_open);
 		return -ENOMEM;
 	}
 
-	atomic_set(&chip->data_pending, 0);
+	priv->chip = chip;
+	atomic_set(&priv->data_pending, 0);
+	mutex_init(&priv->buffer_mutex);
+	setup_timer(&priv->user_read_timer, user_reader_timeout,
+			(unsigned long)priv);
+	INIT_WORK(&priv->work, timeout_work);
 
-	file->private_data = chip;
+	file->private_data = priv;
 	get_device(chip->dev);
 	return 0;
 }
@@ -69,28 +88,28 @@ static int tpm_open(struct inode *inode, struct file *file)
 static ssize_t tpm_read(struct file *file, char __user *buf,
 			size_t size, loff_t *off)
 {
-	struct tpm_chip *chip = file->private_data;
+	struct file_priv *priv = file->private_data;
 	ssize_t ret_size;
 	int rc;
 
-	del_singleshot_timer_sync(&chip->user_read_timer);
-	flush_work(&chip->work);
-	ret_size = atomic_read(&chip->data_pending);
+	del_singleshot_timer_sync(&priv->user_read_timer);
+	flush_work(&priv->work);
+	ret_size = atomic_read(&priv->data_pending);
 	if (ret_size > 0) {	/* relay data */
 		ssize_t orig_ret_size = ret_size;
 		if (size < ret_size)
 			ret_size = size;
 
-		mutex_lock(&chip->buffer_mutex);
-		rc = copy_to_user(buf, chip->data_buffer, ret_size);
-		memset(chip->data_buffer, 0, orig_ret_size);
+		mutex_lock(&priv->buffer_mutex);
+		rc = copy_to_user(buf, priv->data_buffer, ret_size);
+		memset(priv->data_buffer, 0, orig_ret_size);
 		if (rc)
 			ret_size = -EFAULT;
 
-		mutex_unlock(&chip->buffer_mutex);
+		mutex_unlock(&priv->buffer_mutex);
 	}
 
-	atomic_set(&chip->data_pending, 0);
+	atomic_set(&priv->data_pending, 0);
 
 	return ret_size;
 }
@@ -98,7 +117,7 @@ static ssize_t tpm_read(struct file *file, char __user *buf,
 static ssize_t tpm_write(struct file *file, const char __user *buf,
 			 size_t size, loff_t *off)
 {
-	struct tpm_chip *chip = file->private_data;
+	struct file_priv *priv = file->private_data;
 	size_t in_size = size;
 	ssize_t out_size;
 
@@ -106,32 +125,33 @@ static ssize_t tpm_write(struct file *file, const char __user *buf,
 	   either via tpm_read or a user_read_timer timeout.
 	   This also prevents splitted buffered writes from blocking here.
 	*/
-	if (atomic_read(&chip->data_pending) != 0)
+	if (atomic_read(&priv->data_pending) != 0)
 		return -EBUSY;
 
 	if (in_size > TPM_BUFSIZE)
 		return -E2BIG;
 
-	mutex_lock(&chip->buffer_mutex);
+	mutex_lock(&priv->buffer_mutex);
 
 	if (copy_from_user
-	    (chip->data_buffer, (void __user *) buf, in_size)) {
-		mutex_unlock(&chip->buffer_mutex);
+	    (priv->data_buffer, (void __user *) buf, in_size)) {
+		mutex_unlock(&priv->buffer_mutex);
 		return -EFAULT;
 	}
 
 	/* atomic tpm command send and result receive */
-	out_size = tpm_transmit(chip, chip->data_buffer, TPM_BUFSIZE);
+	out_size = tpm_transmit(priv->chip, priv->data_buffer,
+				sizeof(priv->data_buffer));
 	if (out_size < 0) {
-		mutex_unlock(&chip->buffer_mutex);
+		mutex_unlock(&priv->buffer_mutex);
 		return out_size;
 	}
 
-	atomic_set(&chip->data_pending, out_size);
-	mutex_unlock(&chip->buffer_mutex);
+	atomic_set(&priv->data_pending, out_size);
+	mutex_unlock(&priv->buffer_mutex);
 
 	/* Set a timeout by which the reader must come claim the result */
-	mod_timer(&chip->user_read_timer, jiffies + (60 * HZ));
+	mod_timer(&priv->user_read_timer, jiffies + (60 * HZ));
 
 	return in_size;
 }
@@ -141,15 +161,15 @@ static ssize_t tpm_write(struct file *file, const char __user *buf,
  */
 static int tpm_release(struct inode *inode, struct file *file)
 {
-	struct tpm_chip *chip = file->private_data;
+	struct file_priv *priv = file->private_data;
 
-	del_singleshot_timer_sync(&chip->user_read_timer);
-	flush_work(&chip->work);
+	del_singleshot_timer_sync(&priv->user_read_timer);
+	flush_work(&priv->work);
 	file->private_data = NULL;
-	atomic_set(&chip->data_pending, 0);
-	kzfree(chip->data_buffer);
-	clear_bit(0, &chip->is_open);
-	put_device(chip->dev);
+	atomic_set(&priv->data_pending, 0);
+	clear_bit(0, &priv->chip->is_open);
+	put_device(priv->chip->dev);
+	kfree(priv);
 	return 0;
 }
 
@@ -166,12 +186,6 @@ int tpm_dev_add_device(struct tpm_chip *chip)
 {
 	int rc;
 
-	mutex_init(&chip->buffer_mutex);
-	INIT_WORK(&chip->work, timeout_work);
-
-	setup_timer(&chip->user_read_timer, user_reader_timeout,
-			(unsigned long)chip);
-
 	chip->vendor.miscdev.fops = &tpm_fops;
 	if (chip->dev_num == 0)
 		chip->vendor.miscdev.minor = TPM_MINOR;
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 7b0a46e..e4d0888 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -103,13 +103,6 @@ struct tpm_chip {
 	unsigned long is_open;	/* only one allowed */
 	int time_expired;
 
-	/* Data passed to and from the tpm via the read/write calls */
-	u8 *data_buffer;
-	atomic_t data_pending;
-	struct mutex buffer_mutex;
-
-	struct timer_list user_read_timer;	/* user needs to claim result */
-	struct work_struct work;
 	struct mutex tpm_mutex;	/* tpm is processing */
 
 	struct tpm_vendor_specific vendor;
-- 
1.8.1.2

