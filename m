Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaKHKaW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 05:30:22 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51621 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbaKHKaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 05:30:20 -0500
From: Mark Brown <broonie@kernel.org>
To: Thor Thayer <tthayer@opensource.altera.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Date: Sat,  8 Nov 2014 10:29:49 +0000
Message-Id: <1415442589-29434-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.1.1
X-SA-Exim-Connect-IP: 188.29.164.249
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] spi: spidev: Don't mangle max_speed_hz in underlying spi device
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently spidev allows callers to set the default speed by overriding the
max_speed_hz in the underlying device. This achieves the immediate goal but
is not what devices expect and can easily lead to userspace trying to set
unsupported speeds and succeeding, apart from anything else drivers can't
set a limit on the speed using max_speed_hz as they'd expect and any other
devices on the bus will be affected.

Instead store the default speed in the spidev struct and fill this in on
each transfer.

Signed-off-by: Mark Brown <broonie@kernel.org>
---

I've not tested this at all yet.

 drivers/spi/spidev.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index e50039f..42239fd 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -87,6 +87,7 @@ struct spidev_data {
 	unsigned		users;
 	u8			*tx_buffer;
 	u8			*rx_buffer;
+	u32			speed_hz;
 };
 
 static LIST_HEAD(device_list);
@@ -274,6 +275,8 @@ static int spidev_message(struct spidev_data *spidev,
 		k_tmp->bits_per_word = u_tmp->bits_per_word;
 		k_tmp->delay_usecs = u_tmp->delay_usecs;
 		k_tmp->speed_hz = u_tmp->speed_hz;
+		if (!k_tmp->speed_hz)
+			k_tmp->speed_hz = spidev->speed_hz;
 #ifdef VERBOSE
 		dev_dbg(&spidev->spi->dev,
 			"  xfer len %zd %s%s%s%dbits %u usec %uHz\n",
@@ -377,7 +380,7 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		retval = __put_user(spi->bits_per_word, (__u8 __user *)arg);
 		break;
 	case SPI_IOC_RD_MAX_SPEED_HZ:
-		retval = __put_user(spi->max_speed_hz, (__u32 __user *)arg);
+		retval = __put_user(spidev->speed_hz, (__u32 __user *)arg);
 		break;
 
 	/* write requests */
@@ -442,9 +445,10 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			spi->max_speed_hz = tmp;
 			retval = spi_setup(spi);
 			if (retval < 0)
-				spi->max_speed_hz = save;
+				spidev->speed_hz = tmp;
 			else
 				dev_dbg(&spi->dev, "%d Hz (max)\n", tmp);
+			spi->max_speed_hz = save;
 		}
 		break;
 
@@ -570,6 +574,8 @@ static int spidev_release(struct inode *inode, struct file *filp)
 		kfree(spidev->rx_buffer);
 		spidev->rx_buffer = NULL;
 
+		spidev->speed_hz = spidev->spi->max_speed_hz;
+
 		/* ... after we unbound from the underlying device? */
 		spin_lock_irq(&spidev->spi_lock);
 		dofree = (spidev->spi == NULL);
@@ -650,6 +656,8 @@ static int spidev_probe(struct spi_device *spi)
 	}
 	mutex_unlock(&device_list_lock);
 
+	spidev->speed_hz = spi->max_speed_hz;
+
 	if (status == 0)
 		spi_set_drvdata(spi, spidev);
 	else
-- 
2.1.1

