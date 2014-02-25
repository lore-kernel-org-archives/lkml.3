Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaBYKkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:40:55 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:35682 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaBYKk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:40:26 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2 3/4] spi: spidev_test: Add support for Dual/Quad SPI Transfers
Date: Tue, 25 Feb 2014 11:40:18 +0100
Message-Id: <1393324819-3810-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393324819-3810-1-git-send-email-geert@linux-m68k.org>
References: <1393324819-3810-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v2:
  - Introduce SPI_IOC_{RD,WR}_MODE32 to avoid breaking backwards
    compatibility,
  - Split off the spidev_test changes in a separate patch

 Documentation/spi/spidev_test.c |   43 +++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/Documentation/spi/spidev_test.c b/Documentation/spi/spidev_test.c
index efd7385e907f..3a2f9d59edab 100644
--- a/Documentation/spi/spidev_test.c
+++ b/Documentation/spi/spidev_test.c
@@ -30,7 +30,7 @@ static void pabort(const char *s)
 }
 
 static const char *device = "/dev/spidev1.1";
-static uint8_t mode;
+static uint32_t mode;
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
@@ -170,11 +201,11 @@ int main(int argc, char *argv[])
 	/*
 	 * spi mode
 	 */
-	ret = ioctl(fd, SPI_IOC_WR_MODE, &mode);
+	ret = ioctl(fd, SPI_IOC_WR_MODE32, &mode);
 	if (ret == -1)
 		pabort("can't set spi mode");
 
-	ret = ioctl(fd, SPI_IOC_RD_MODE, &mode);
+	ret = ioctl(fd, SPI_IOC_RD_MODE32, &mode);
 	if (ret == -1)
 		pabort("can't get spi mode");
 
@@ -200,7 +231,7 @@ int main(int argc, char *argv[])
 	if (ret == -1)
 		pabort("can't get max speed hz");
 
-	printf("spi mode: %d\n", mode);
+	printf("spi mode: 0x%x\n", mode);
 	printf("bits per word: %d\n", bits);
 	printf("max speed: %d Hz (%d KHz)\n", speed, speed/1000);
 
-- 
1.7.9.5

