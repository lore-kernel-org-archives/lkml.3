Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaBYKk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:40:28 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:39804 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaBYKkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:40:24 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2 2/4] spi: spidev: Add support for Dual/Quad SPI Transfers
Date: Tue, 25 Feb 2014 11:40:17 +0100
Message-Id: <1393324819-3810-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393324819-3810-1-git-send-email-geert@linux-m68k.org>
References: <1393324819-3810-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Add support for Dual/Quad SPI Transfers to the spidev API.
As this uses SPI mode bits that don't fit in a single byte, two new
ioctls (SPI_IOC_RD_MODE32 and SPI_IOC_WR_MODE32) are introduced.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v2:
  - Introduce SPI_IOC_{RD,WR}_MODE32 to avoid breaking backwards
    compatibility,
  - Split off the spidev_test changes in a separate patch
  - Update documentation.

 Documentation/spi/spidev        |    6 ++++++
 drivers/spi/spidev.c            |   19 +++++++++++++++----
 include/uapi/linux/spi/spidev.h |   14 ++++++++++++--
 3 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/Documentation/spi/spidev b/Documentation/spi/spidev
index ed2da5e5b28a..3d14035b1766 100644
--- a/Documentation/spi/spidev
+++ b/Documentation/spi/spidev
@@ -85,6 +85,12 @@ settings for data transfer parameters:
 	SPI_MODE_0..SPI_MODE_3; or if you prefer you can combine SPI_CPOL
 	(clock polarity, idle high iff this is set) or SPI_CPHA (clock phase,
 	sample on trailing edge iff this is set) flags.
+	Note that this request is limited to SPI mode flags that fit in a
+	single byte.
+
+    SPI_IOC_RD_MODE32, SPI_IOC_WR_MODE32 ... pass a pointer to a uin32_t
+	which will return (RD) or assign (WR) the full SPI transfer mode,
+	not limited to the bits that fit in one byte.
 
     SPI_IOC_RD_LSB_FIRST, SPI_IOC_WR_LSB_FIRST ... pass a pointer to a byte
 	which will return (RD) or assign (WR) the bit justification used to
diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 2abc0f5a82be..e3bc23bb5883 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -73,7 +73,8 @@ static DECLARE_BITMAP(minors, N_SPI_MINORS);
  */
 #define SPI_MODE_MASK		(SPI_CPHA | SPI_CPOL | SPI_CS_HIGH \
 				| SPI_LSB_FIRST | SPI_3WIRE | SPI_LOOP \
-				| SPI_NO_CS | SPI_READY)
+				| SPI_NO_CS | SPI_READY | SPI_TX_DUAL \
+				| SPI_TX_QUAD | SPI_RX_DUAL | SPI_RX_QUAD)
 
 struct spidev_data {
 	dev_t			devt;
@@ -265,6 +266,8 @@ static int spidev_message(struct spidev_data *spidev,
 		buf += k_tmp->len;
 
 		k_tmp->cs_change = !!u_tmp->cs_change;
+		k_tmp->tx_nbits = u_tmp->tx_nbits;
+		k_tmp->rx_nbits = u_tmp->rx_nbits;
 		k_tmp->bits_per_word = u_tmp->bits_per_word;
 		k_tmp->delay_usecs = u_tmp->delay_usecs;
 		k_tmp->speed_hz = u_tmp->speed_hz;
@@ -359,6 +362,10 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		retval = __put_user(spi->mode & SPI_MODE_MASK,
 					(__u8 __user *)arg);
 		break;
+	case SPI_IOC_RD_MODE32:
+		retval = __put_user(spi->mode & SPI_MODE_MASK,
+					(__u32 __user *)arg);
+		break;
 	case SPI_IOC_RD_LSB_FIRST:
 		retval = __put_user((spi->mode & SPI_LSB_FIRST) ?  1 : 0,
 					(__u8 __user *)arg);
@@ -372,7 +379,11 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 	/* write requests */
 	case SPI_IOC_WR_MODE:
-		retval = __get_user(tmp, (u8 __user *)arg);
+	case SPI_IOC_WR_MODE32:
+		if (cmd == SPI_IOC_WR_MODE)
+			retval = __get_user(tmp, (u8 __user *)arg);
+		else
+			retval = __get_user(tmp, (u32 __user *)arg);
 		if (retval == 0) {
 			u32	save = spi->mode;
 
@@ -382,12 +393,12 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			}
 
 			tmp |= spi->mode & ~SPI_MODE_MASK;
-			spi->mode = (u8)tmp;
+			spi->mode = (u16)tmp;
 			retval = spi_setup(spi);
 			if (retval < 0)
 				spi->mode = save;
 			else
-				dev_dbg(&spi->dev, "spi mode %02x\n", tmp);
+				dev_dbg(&spi->dev, "spi mode %x\n", tmp);
 		}
 		break;
 	case SPI_IOC_WR_LSB_FIRST:
diff --git a/include/uapi/linux/spi/spidev.h b/include/uapi/linux/spi/spidev.h
index 52d9ed01855f..dd5f21e75805 100644
--- a/include/uapi/linux/spi/spidev.h
+++ b/include/uapi/linux/spi/spidev.h
@@ -42,6 +42,10 @@
 #define SPI_LOOP		0x20
 #define SPI_NO_CS		0x40
 #define SPI_READY		0x80
+#define SPI_TX_DUAL		0x100
+#define SPI_TX_QUAD		0x200
+#define SPI_RX_DUAL		0x400
+#define SPI_RX_QUAD		0x800
 
 /*---------------------------------------------------------------------------*/
 
@@ -92,7 +96,9 @@ struct spi_ioc_transfer {
 	__u16		delay_usecs;
 	__u8		bits_per_word;
 	__u8		cs_change;
-	__u32		pad;
+	__u8		tx_nbits;
+	__u8		rx_nbits;
+	__u16		pad;
 
 	/* If the contents of 'struct spi_ioc_transfer' ever change
 	 * incompatibly, then the ioctl number (currently 0) must change;
@@ -110,7 +116,7 @@ struct spi_ioc_transfer {
 #define SPI_IOC_MESSAGE(N) _IOW(SPI_IOC_MAGIC, 0, char[SPI_MSGSIZE(N)])
 
 
-/* Read / Write of SPI mode (SPI_MODE_0..SPI_MODE_3) */
+/* Read / Write of SPI mode (SPI_MODE_0..SPI_MODE_3) (limited to 8 bits) */
 #define SPI_IOC_RD_MODE			_IOR(SPI_IOC_MAGIC, 1, __u8)
 #define SPI_IOC_WR_MODE			_IOW(SPI_IOC_MAGIC, 1, __u8)
 
@@ -126,6 +132,10 @@ struct spi_ioc_transfer {
 #define SPI_IOC_RD_MAX_SPEED_HZ		_IOR(SPI_IOC_MAGIC, 4, __u32)
 #define SPI_IOC_WR_MAX_SPEED_HZ		_IOW(SPI_IOC_MAGIC, 4, __u32)
 
+/* Read / Write of the SPI mode field */
+#define SPI_IOC_RD_MODE32		_IOR(SPI_IOC_MAGIC, 5, __u32)
+#define SPI_IOC_WR_MODE32		_IOW(SPI_IOC_MAGIC, 5, __u32)
+
 
 
 #endif /* SPIDEV_H */
-- 
1.7.9.5

