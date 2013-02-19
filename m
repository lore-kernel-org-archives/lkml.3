Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab3BSEOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 23:14:24 -0500
Received: from mout.gmx.net ([212.227.17.20]:58701 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311Ab3BSEOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 23:14:22 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+QW+Jlq/eQzw26j+/A0ZJX8ymxQfJD4jukemmbrT
	KQb+KAHl5tc/qG
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Devendra Naga <devendra.aaru@gmail.com>, Peter Huewe <peterhuewe@gmx.de>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Cruz Julian Bishop <cruzjbishop@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] staging/slicoss: Use ether_crc for mac hash calculation
Date: Tue, 19 Feb 2013 05:18:52 +0100
Message-Id: <1361247532-1874-5-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1361247234-1754-1-git-send-email-peterhuewe@gmx.de>
References: <1361247234-1754-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of performing the hash calculation for the mac address by ourself, we
can simply reuse ether_crc and shift only the result according to our
needs.
The code was tested against the previous implementation by verifying both
implementations against each other in userspace for 16200000000 different
mac addresses, changing the vendor bits of the mac address first.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/slicoss/slicoss.c |   69 ++----------------------------------
 1 files changed, 4 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 48056bf..58a00c2 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -76,6 +76,7 @@
 #include <linux/bitops.h>
 #include <linux/io.h>
 #include <linux/netdevice.h>
+#include <linux/crc32.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/delay.h>
@@ -189,76 +190,14 @@ static inline void slic_reg64_write(struct adapter *adapter, void __iomem *reg,
 				adapter->bit64reglock.flags);
 }
 
-/*
- * Functions to obtain the CRC corresponding to the destination mac address.
- * This is a standard ethernet CRC in that it is a 32-bit, reflected CRC using
- * the polynomial:
- *   x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 +
- *   x^4 + x^2 + x^1.
- *
- * After the CRC for the 6 bytes is generated (but before the value is
- * complemented),
- * we must then transpose the value and return bits 30-23.
- *
- */
-static u32 slic_crc_table[256];	/* Table of CRCs for all possible byte values */
-static u32 slic_crc_init;	/* Is table initialized */
-
-/*
- *  Contruct the CRC32 table
- */
-static void slic_mcast_init_crc32(void)
-{
-	u32 c;			/*  CRC reg                      */
-	u32 e = 0;		/*  Poly X-or pattern            */
-	int i;			/*  counter                      */
-	int k;			/*  byte being shifted into crc  */
-
-	static int p[] = { 0, 1, 2, 4, 5, 7, 8, 10, 11, 12, 16, 22, 23, 26 };
-
-	for (i = 0; i < ARRAY_SIZE(p); i++)
-		e |= 1L << (31 - p[i]);
-
-	for (i = 1; i < 256; i++) {
-		c = i;
-		for (k = 8; k; k--)
-			c = c & 1 ? (c >> 1) ^ e : c >> 1;
-		slic_crc_table[i] = c;
-	}
-}
-
-/*
- *  Return the MAC hast as described above.
- */
-static unsigned char slic_mcast_get_mac_hash(char *macaddr)
-{
-	u32 crc;
-	char *p;
-	int i;
-	unsigned char machash = 0;
-
-	if (!slic_crc_init) {
-		slic_mcast_init_crc32();
-		slic_crc_init = 1;
-	}
-
-	crc = 0xFFFFFFFF;	/* Preload shift register, per crc-32 spec */
-	for (i = 0, p = macaddr; i < 6; ++p, ++i)
-		crc = (crc >> 8) ^ slic_crc_table[(crc ^ *p) & 0xFF];
-
-	/* Return bits 1-8, transposed */
-	for (i = 1; i < 9; i++)
-		machash |= (((crc >> i) & 1) << (8 - i));
-
-	return machash;
-}
-
 static void slic_mcast_set_bit(struct adapter *adapter, char *address)
 {
 	unsigned char crcpoly;
 
 	/* Get the CRC polynomial for the mac address */
-	crcpoly = slic_mcast_get_mac_hash(address);
+	/* we use bits 1-8 (lsb), bitwise reversed,
+	 * msb (= lsb bit 0 before bitrev) is automatically discarded */
+	crcpoly = (ether_crc(ETH_ALEN, address)>>23);
 
 	/* We only have space on the SLIC for 64 entries.  Lop
 	 * off the top two bits. (2^6 = 64)
-- 
1.7.8.6

