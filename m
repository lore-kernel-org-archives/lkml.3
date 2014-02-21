Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbaBUQPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:15:04 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:35022 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800AbaBUQPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:15:01 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH] [RFC] spi: spidev: Add support for Dual/Quad SPI Transfers
Date: Fri, 21 Feb 2014 17:14:53 +0100
Message-Id: <1392999293-5015-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Add support for Dual/Quad SPI Transfers to the spidev API, and the
spidev_test test program.

This requires enlarging the mode from 8 to 16 bits.
Note that this does break binary compatibility with userspace.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
The Kconfig entry for SPI_SPIDEV states:

    Note that this application programming interface is EXPERIMENTAL
    and hence SUBJECT TO CHANGE WITHOUT NOTICE while it stabilizes.

So it's OK to break binary compatibility?
Or should we introduce PI_IOC_RD_MODE16 and SPI_IOC_WR_MODE16 instead?
---
 Documentation/spi/spidev_test.c |   39 +++++++++++++++++++++++++++++++++++----
 drivers/spi/spidev.c            |   17 ++++++++++-------
 include/uapi/linux/spi/spidev.h |   12 +++++++++---
 3 files changed, 54 insertions(+), 14 deletions(-)

diff --git a/Documentation/spi/spidev_test.c b/Documentation/spi/spidev_test.c
index efd7385e907f..68c705b1326c 100644
--- a/Documentation/spi/spidev_test.c
+++ b/Documentation/spi/spidev_test.c
@@ -30,7 +30,7 @@ static void pabort(const char *s)
 }
 
 static const char *device = "/dev/spidev1.1";
-static uint8_t mode;
+static uint16_t mode;
 static uint8_t bits = 8;
 static uint32_t speed = 500000;
 static uint16_t delay;
@@ -57,6 +57,21 @@ static void transfer(int fd)
 		.bits_per_word = bits,
 	};
 
+	if (mode & SPI_TX_QUAD)
+		tr.tx_nbits = 4;
+	else if (mode & SPI_TX_DUAL)
+		tr.tx_nbits = 2;
+	if (mode & SPI_RX_QUAD)
+		tr.rx_nbits = 4;
+	else if (mode & SPI_RX_DUAL)
+		tr.rx_nbits = 2;
+	if (!(mode & SPI_LOOP)) {
+		if (mode & (SPI_TX_QUAD | SPI_TX_DUAL))
+			tr.rx_buf = 0;
+		else if (mode & (SPI_RX_QUAD | SPI_RX_DUAL))
+			tr.tx_buf = 0;
+	}
+
 	ret = ioctl(fd, SPI_IOC_MESSAGE(1), &tr);
 	if (ret < 1)
 		pabort("can't send spi message");
@@ -83,7 +98,9 @@ static void print_usage(const char *prog)
 	     "  -C --cs-high  chip select active high\n"
 	     "  -3 --3wire    SI/SO signals shared\n"
 	     "  -N --no-cs    no chip select\n"
-	     "  -R --ready    slave pulls low to pause\n");
+	     "  -R --ready    slave pulls low to pause\n"
+	     "  -2 --dual     dual transfer\n"
+	     "  -4 --quad     quad transfer\n");
 	exit(1);
 }
 
@@ -103,11 +120,13 @@ static void parse_opts(int argc, char *argv[])
 			{ "3wire",   0, 0, '3' },
 			{ "no-cs",   0, 0, 'N' },
 			{ "ready",   0, 0, 'R' },
+			{ "dual",    0, 0, '2' },
+			{ "quad",    0, 0, '4' },
 			{ NULL, 0, 0, 0 },
 		};
 		int c;
 
-		c = getopt_long(argc, argv, "D:s:d:b:lHOLC3NR", lopts, NULL);
+		c = getopt_long(argc, argv, "D:s:d:b:lHOLC3NR24", lopts, NULL);
 
 		if (c == -1)
 			break;
@@ -149,11 +168,23 @@ static void parse_opts(int argc, char *argv[])
 		case 'R':
 			mode |= SPI_READY;
 			break;
+		case '2':
+			mode |= SPI_TX_DUAL;
+			break;
+		case '4':
+			mode |= SPI_TX_QUAD;
+			break;
 		default:
 			print_usage(argv[0]);
 			break;
 		}
 	}
+	if (mode & SPI_LOOP) {
+		if (mode & SPI_TX_DUAL)
+			mode |= SPI_RX_DUAL;
+		if (mode & SPI_TX_QUAD)
+			mode |= SPI_RX_QUAD;
+	}
 }
 
 int main(int argc, char *argv[])
@@ -200,7 +231,7 @@ int main(int argc, char *argv[])
 	if (ret == -1)
 		pabort("can't get max speed hz");
 
-	printf("spi mode: %d\n", mode);
+	printf("spi mode: %x\n", mode);
 	printf("bits per word: %d\n", bits);
 	printf("max speed: %d Hz (%d KHz)\n", speed, speed/1000);
 
diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index d7c6e36021e8..e490e01db192 100644
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
@@ -357,7 +360,7 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	/* read requests */
 	case SPI_IOC_RD_MODE:
 		retval = __put_user(spi->mode & SPI_MODE_MASK,
-					(__u8 __user *)arg);
+					(__u16 __user *)arg);
 		break;
 	case SPI_IOC_RD_LSB_FIRST:
 		retval = __put_user((spi->mode & SPI_LSB_FIRST) ?  1 : 0,
@@ -372,9 +375,9 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 	/* write requests */
 	case SPI_IOC_WR_MODE:
-		retval = __get_user(tmp, (u8 __user *)arg);
+		retval = __get_user(tmp, (u16 __user *)arg);
 		if (retval == 0) {
-			u8	save = spi->mode;
+			u16	save = spi->mode;
 
 			if (tmp & ~SPI_MODE_MASK) {
 				retval = -EINVAL;
@@ -382,18 +385,18 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			}
 
 			tmp |= spi->mode & ~SPI_MODE_MASK;
-			spi->mode = (u8)tmp;
+			spi->mode = (u16)tmp;
 			retval = spi_setup(spi);
 			if (retval < 0)
 				spi->mode = save;
 			else
-				dev_dbg(&spi->dev, "spi mode %02x\n", tmp);
+				dev_dbg(&spi->dev, "spi mode %04x\n", tmp);
 		}
 		break;
 	case SPI_IOC_WR_LSB_FIRST:
 		retval = __get_user(tmp, (__u8 __user *)arg);
 		if (retval == 0) {
-			u8	save = spi->mode;
+			u16	save = spi->mode;
 
 			if (tmp)
 				spi->mode |= SPI_LSB_FIRST;
diff --git a/include/uapi/linux/spi/spidev.h b/include/uapi/linux/spi/spidev.h
index 52d9ed01855f..50e8aef0e7ca 100644
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
@@ -111,8 +117,8 @@ struct spi_ioc_transfer {
 
 
 /* Read / Write of SPI mode (SPI_MODE_0..SPI_MODE_3) */
-#define SPI_IOC_RD_MODE			_IOR(SPI_IOC_MAGIC, 1, __u8)
-#define SPI_IOC_WR_MODE			_IOW(SPI_IOC_MAGIC, 1, __u8)
+#define SPI_IOC_RD_MODE			_IOR(SPI_IOC_MAGIC, 1, __u16)
+#define SPI_IOC_WR_MODE			_IOW(SPI_IOC_MAGIC, 1, __u16)
 
 /* Read / Write SPI bit justification */
 #define SPI_IOC_RD_LSB_FIRST		_IOR(SPI_IOC_MAGIC, 2, __u8)
-- 
1.7.9.5

