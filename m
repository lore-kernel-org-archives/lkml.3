Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbaIOUYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:24:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41263 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754889AbaIOUYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:24:09 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Huang Shijie <shijie8@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 1/2] mtd: nand: gpmi: add gpmi_move_bits function
Date: Mon, 15 Sep 2014 22:24:02 +0200
Message-Id: <1410812643-14041-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410812643-14041-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1410812643-14041-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function to move bits (not bytes) from a memory region to
another one.
This function is similar to memmove except it acts at bit level.
This function is needed to implement GPMI raw access functions, given the
fact that ECC engine does not pad ECC bits to the next byte boundary.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c  | 86 ++++++++++++++++++++++++++++++++++
 drivers/mtd/nand/gpmi-nand/gpmi-nand.h |  4 ++
 2 files changed, 90 insertions(+)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
index 87e658c..5a83f0f 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
@@ -1353,3 +1353,89 @@ int gpmi_read_page(struct gpmi_nand_data *this,
 	set_dma_type(this, DMA_FOR_READ_ECC_PAGE);
 	return start_dma_with_bch_irq(this, desc);
 }
+
+void gpmi_move_bits(u8 *dst, size_t dst_bit_off,
+		    const u8 *src, size_t src_bit_off,
+		    size_t nbits)
+{
+	size_t i;
+	size_t nbytes;
+	u32 src_byte = 0;
+
+	src += src_bit_off / 8;
+	src_bit_off %= 8;
+
+	dst += dst_bit_off / 8;
+	dst_bit_off %= 8;
+
+	if (src_bit_off) {
+		src_byte = src[0] >> src_bit_off;
+		nbits -= 8 - src_bit_off;
+		src++;
+	}
+
+	nbytes = nbits / 8;
+
+	if (src_bit_off <= dst_bit_off) {
+		dst[0] &= GENMASK(dst_bit_off - 1, 0);
+		dst[0] |= src_byte << dst_bit_off;
+		src_bit_off += (8 - dst_bit_off);
+		src_byte >>= (8 - dst_bit_off);
+		dst_bit_off = 0;
+		dst++;
+	} else if (nbytes) {
+		src_byte |= src[0] << (8 - src_bit_off);
+		dst[0] &= GENMASK(dst_bit_off - 1, 0);
+		dst[0] |= src_byte << dst_bit_off;
+		src_bit_off += dst_bit_off;
+		src_byte >>= (8 - dst_bit_off);
+		dst_bit_off = 0;
+		dst++;
+		nbytes--;
+		src++;
+		if (src_bit_off > 7) {
+			src_bit_off -= 8;
+			dst[0] = src_byte;
+			dst++;
+			src_byte >>= 8;
+		}
+	}
+
+	if (!src_bit_off && !dst_bit_off) {
+		if (nbytes)
+			memcpy(dst, src, nbytes);
+	} else {
+		for (i = 0; i < nbytes; i++) {
+			src_byte |= src[i] << (8 - src_bit_off);
+			dst[i] = src_byte;
+			src_byte >>= 8;
+		}
+	}
+
+	dst += nbytes;
+	src += nbytes;
+	nbits %= 8;
+
+	if (!nbits && !src_bit_off)
+		return;
+
+	if (nbits)
+		src_byte |= (*src & GENMASK(nbits - 1, 0)) <<
+			    ((8 - src_bit_off) % 8);
+	nbits += (8 - src_bit_off) % 8;
+
+	if (dst_bit_off)
+		src_byte = (src_byte << dst_bit_off) |
+			   (*dst & GENMASK(dst_bit_off - 1, 0));
+	nbits += dst_bit_off;
+
+	if (nbits % 8)
+		src_byte |= (dst[nbits / 8] & GENMASK(7, nbits % 8)) <<
+			    (nbits / 8);
+
+	nbytes = DIV_ROUND_UP(nbits, 8);
+	for (i = 0; i < nbytes; i++) {
+		dst[i] = src_byte;
+		src_byte >>= 8;
+	}
+}
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.h b/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
index 32c6ba4..17d0736 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
@@ -290,6 +290,10 @@ extern int gpmi_send_page(struct gpmi_nand_data *,
 extern int gpmi_read_page(struct gpmi_nand_data *,
 			dma_addr_t payload, dma_addr_t auxiliary);
 
+void gpmi_move_bits(u8 *dst, size_t dst_bit_off,
+		    const u8 *src, size_t src_bit_off,
+		    size_t nbits);
+
 /* BCH : Status Block Completion Codes */
 #define STATUS_GOOD		0x00
 #define STATUS_ERASED		0xff
-- 
1.9.1

