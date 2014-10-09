Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaJISSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 14:18:46 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:40505 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaJISSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 14:18:37 -0400
X-IronPort-AV: E=Sophos;i="5.04,686,1406617200"; 
   d="scan'208";a="47685820"
From: Ray Jui <rjui@broadcom.com>
To: Mark Brown <broonie@kernel.org>
CC: <linux-spi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        JD Zheng <jdzheng@broadcom.com>, Scott Branden <sbranden@broadcom.com>,
        "Geert Uytterhoeven" <geert.uytterhoeven@gmail.com>,
        Ray Jui <rjui@broadcom.com>
Subject: [PATCH] spi: spidev: Use separate TX and RX bounce buffers
Date: Thu, 9 Oct 2014 11:19:25 -0700
Message-ID: <1412878765-29088-1-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Ray Jui <rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By using separate TX and RX bounce buffers, we avoid potential cache
flush and invalidation sequence issue that may be encountered when a
single bounce buffer is shared between TX and RX

Signed-off-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: JD (Jiandong) Zheng <jdzheng@broadcom.com>
---
 drivers/spi/spidev.c |   79 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 27 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index e3bc23b..e50039f 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -82,10 +82,11 @@ struct spidev_data {
 	struct spi_device	*spi;
 	struct list_head	device_entry;
 
-	/* buffer is NULL unless this device is open (users > 0) */
+	/* TX/RX buffers are NULL unless this device is open (users > 0) */
 	struct mutex		buf_lock;
 	unsigned		users;
-	u8			*buffer;
+	u8			*tx_buffer;
+	u8			*rx_buffer;
 };
 
 static LIST_HEAD(device_list);
@@ -135,7 +136,7 @@ static inline ssize_t
 spidev_sync_write(struct spidev_data *spidev, size_t len)
 {
 	struct spi_transfer	t = {
-			.tx_buf		= spidev->buffer,
+			.tx_buf		= spidev->tx_buffer,
 			.len		= len,
 		};
 	struct spi_message	m;
@@ -149,7 +150,7 @@ static inline ssize_t
 spidev_sync_read(struct spidev_data *spidev, size_t len)
 {
 	struct spi_transfer	t = {
-			.rx_buf		= spidev->buffer,
+			.rx_buf		= spidev->rx_buffer,
 			.len		= len,
 		};
 	struct spi_message	m;
@@ -179,7 +180,7 @@ spidev_read(struct file *filp, char __user *buf, size_t count, loff_t *f_pos)
 	if (status > 0) {
 		unsigned long	missing;
 
-		missing = copy_to_user(buf, spidev->buffer, status);
+		missing = copy_to_user(buf, spidev->rx_buffer, status);
 		if (missing == status)
 			status = -EFAULT;
 		else
@@ -206,7 +207,7 @@ spidev_write(struct file *filp, const char __user *buf,
 	spidev = filp->private_data;
 
 	mutex_lock(&spidev->buf_lock);
-	missing = copy_from_user(spidev->buffer, buf, count);
+	missing = copy_from_user(spidev->tx_buffer, buf, count);
 	if (missing == 0)
 		status = spidev_sync_write(spidev, count);
 	else
@@ -224,7 +225,7 @@ static int spidev_message(struct spidev_data *spidev,
 	struct spi_transfer	*k_tmp;
 	struct spi_ioc_transfer *u_tmp;
 	unsigned		n, total;
-	u8			*buf;
+	u8			*tx_buf, *rx_buf;
 	int			status = -EFAULT;
 
 	spi_message_init(&msg);
@@ -236,7 +237,8 @@ static int spidev_message(struct spidev_data *spidev,
 	 * We walk the array of user-provided transfers, using each one
 	 * to initialize a kernel version of the same transfer.
 	 */
-	buf = spidev->buffer;
+	tx_buf = spidev->tx_buffer;
+	rx_buf = spidev->rx_buffer;
 	total = 0;
 	for (n = n_xfers, k_tmp = k_xfers, u_tmp = u_xfers;
 			n;
@@ -250,20 +252,21 @@ static int spidev_message(struct spidev_data *spidev,
 		}
 
 		if (u_tmp->rx_buf) {
-			k_tmp->rx_buf = buf;
+			k_tmp->rx_buf = rx_buf;
 			if (!access_ok(VERIFY_WRITE, (u8 __user *)
 						(uintptr_t) u_tmp->rx_buf,
 						u_tmp->len))
 				goto done;
 		}
 		if (u_tmp->tx_buf) {
-			k_tmp->tx_buf = buf;
-			if (copy_from_user(buf, (const u8 __user *)
+			k_tmp->tx_buf = tx_buf;
+			if (copy_from_user(tx_buf, (const u8 __user *)
 						(uintptr_t) u_tmp->tx_buf,
 					u_tmp->len))
 				goto done;
 		}
-		buf += k_tmp->len;
+		tx_buf += k_tmp->len;
+		rx_buf += k_tmp->len;
 
 		k_tmp->cs_change = !!u_tmp->cs_change;
 		k_tmp->tx_nbits = u_tmp->tx_nbits;
@@ -290,17 +293,17 @@ static int spidev_message(struct spidev_data *spidev,
 		goto done;
 
 	/* copy any rx data out of bounce buffer */
-	buf = spidev->buffer;
+	rx_buf = spidev->rx_buffer;
 	for (n = n_xfers, u_tmp = u_xfers; n; n--, u_tmp++) {
 		if (u_tmp->rx_buf) {
 			if (__copy_to_user((u8 __user *)
-					(uintptr_t) u_tmp->rx_buf, buf,
+					(uintptr_t) u_tmp->rx_buf, rx_buf,
 					u_tmp->len)) {
 				status = -EFAULT;
 				goto done;
 			}
 		}
-		buf += u_tmp->len;
+		rx_buf += u_tmp->len;
 	}
 	status = total;
 
@@ -508,22 +511,41 @@ static int spidev_open(struct inode *inode, struct file *filp)
 			break;
 		}
 	}
-	if (status == 0) {
-		if (!spidev->buffer) {
-			spidev->buffer = kmalloc(bufsiz, GFP_KERNEL);
-			if (!spidev->buffer) {
+
+	if (status) {
+		pr_debug("spidev: nothing for minor %d\n", iminor(inode));
+		goto err_find_dev;
+	}
+
+	if (!spidev->tx_buffer) {
+		spidev->tx_buffer = kmalloc(bufsiz, GFP_KERNEL);
+		if (!spidev->tx_buffer) {
 				dev_dbg(&spidev->spi->dev, "open/ENOMEM\n");
 				status = -ENOMEM;
+			goto err_find_dev;
 			}
 		}
-		if (status == 0) {
-			spidev->users++;
-			filp->private_data = spidev;
-			nonseekable_open(inode, filp);
+
+	if (!spidev->rx_buffer) {
+		spidev->rx_buffer = kmalloc(bufsiz, GFP_KERNEL);
+		if (!spidev->rx_buffer) {
+			dev_dbg(&spidev->spi->dev, "open/ENOMEM\n");
+			status = -ENOMEM;
+			goto err_alloc_rx_buf;
 		}
-	} else
-		pr_debug("spidev: nothing for minor %d\n", iminor(inode));
+	}
+
+	spidev->users++;
+	filp->private_data = spidev;
+	nonseekable_open(inode, filp);
+
+	mutex_unlock(&device_list_lock);
+	return 0;
 
+err_alloc_rx_buf:
+	kfree(spidev->tx_buffer);
+	spidev->tx_buffer = NULL;
+err_find_dev:
 	mutex_unlock(&device_list_lock);
 	return status;
 }
@@ -542,8 +564,11 @@ static int spidev_release(struct inode *inode, struct file *filp)
 	if (!spidev->users) {
 		int		dofree;
 
-		kfree(spidev->buffer);
-		spidev->buffer = NULL;
+		kfree(spidev->tx_buffer);
+		spidev->tx_buffer = NULL;
+
+		kfree(spidev->rx_buffer);
+		spidev->rx_buffer = NULL;
 
 		/* ... after we unbound from the underlying device? */
 		spin_lock_irq(&spidev->spi_lock);
-- 
1.7.9.5

