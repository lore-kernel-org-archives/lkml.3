Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaK3SKs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 13:10:48 -0500
Received: from down.free-electrons.com ([37.187.137.238]:47368 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752487AbaK3SKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 13:10:45 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Cc: Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v6 1/3] mtd: nand: gpmi: add gpmi_copy_bits function
Date: Sun, 30 Nov 2014 19:10:28 +0100
Message-Id: <1417371030-24015-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417371030-24015-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417371030-24015-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function to copy bits (not bytes) from a memory region to
another one.
This function is similar to memcpy except it acts at bit level.
It is needed to implement GPMI raw access functions and adapt to the
hardware ECC engine which does not pad ECC bits to the next byte boundary.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Tested-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c  | 153 +++++++++++++++++++++++++++++++++
 drivers/mtd/nand/gpmi-nand/gpmi-nand.h |   4 +
 2 files changed, 157 insertions(+)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
index 87e658c..27f272e 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
@@ -1353,3 +1353,156 @@ int gpmi_read_page(struct gpmi_nand_data *this,
 	set_dma_type(this, DMA_FOR_READ_ECC_PAGE);
 	return start_dma_with_bch_irq(this, desc);
 }
+
+/**
+ * gpmi_copy_bits - copy bits from one memory region to another
+ * @dst: destination buffer
+ * @dst_bit_off: bit offset we're starting to write at
+ * @src: source buffer
+ * @src_bit_off: bit offset we're starting to read from
+ * @nbits: number of bits to copy
+ *
+ * This functions copies bits from one memory region to another, and is used by
+ * the GPMI driver to copy ECC sections which are not guaranteed to be byte
+ * aligned.
+ *
+ * src and dst should not overlap.
+ *
+ */
+void gpmi_copy_bits(u8 *dst, size_t dst_bit_off,
+		    const u8 *src, size_t src_bit_off,
+		    size_t nbits)
+{
+	size_t i;
+	size_t nbytes;
+	u32 src_buffer = 0;
+	size_t bits_in_src_buffer = 0;
+
+	if (!nbits)
+		return;
+
+	/*
+	 * Move src and dst pointers to the closest byte pointer and store bit
+	 * offsets within a byte.
+	 */
+	src += src_bit_off / 8;
+	src_bit_off %= 8;
+
+	dst += dst_bit_off / 8;
+	dst_bit_off %= 8;
+
+	/*
+	 * Initialize the src_buffer value with bits available in the first
+	 * byte of data so that we end up with a byte aligned src pointer.
+	 */
+	if (src_bit_off) {
+		src_buffer = src[0] >> src_bit_off;
+		if (nbits >= (8 - src_bit_off)) {
+			bits_in_src_buffer += 8 - src_bit_off;
+		} else {
+			src_buffer &= GENMASK(nbits - 1, 0);
+			bits_in_src_buffer += nbits;
+		}
+		nbits -= bits_in_src_buffer;
+		src++;
+	}
+
+	/* Calculate the number of bytes that can be copied from src to dst. */
+	nbytes = nbits / 8;
+
+	/* Try to align dst to a byte boundary. */
+	if (dst_bit_off) {
+		if (bits_in_src_buffer < (8 - dst_bit_off) && nbytes) {
+			src_buffer |= src[0] << bits_in_src_buffer;
+			bits_in_src_buffer += 8;
+			src++;
+			nbytes--;
+		}
+
+		if (bits_in_src_buffer >= (8 - dst_bit_off)) {
+			dst[0] &= GENMASK(dst_bit_off - 1, 0);
+			dst[0] |= src_buffer << dst_bit_off;
+			src_buffer >>= (8 - dst_bit_off);
+			bits_in_src_buffer -= (8 - dst_bit_off);
+			dst_bit_off = 0;
+			dst++;
+			if (bits_in_src_buffer > 7) {
+				bits_in_src_buffer -= 8;
+				dst[0] = src_buffer;
+				dst++;
+				src_buffer >>= 8;
+			}
+		}
+	}
+
+	if (!bits_in_src_buffer && !dst_bit_off) {
+		/*
+		 * Both src and dst pointers are byte aligned, thus we can
+		 * just use the optimized memcpy function.
+		 */
+		if (nbytes)
+			memcpy(dst, src, nbytes);
+	} else {
+		/*
+		 * src buffer is not byte aligned, hence we have to copy each
+		 * src byte to the src_buffer variable before extracting a byte
+		 * to store in dst.
+		 */
+		for (i = 0; i < nbytes; i++) {
+			src_buffer |= src[i] << bits_in_src_buffer;
+			dst[i] = src_buffer;
+			src_buffer >>= 8;
+		}
+	}
+	/* Update dst and src pointers */
+	dst += nbytes;
+	src += nbytes;
+
+	/*
+	 * nbits is the number of remaining bits. It should not exceed 8 as
+	 * we've already copied as much bytes as possible.
+	 */
+	nbits %= 8;
+
+	/*
+	 * If there's no more bits to copy to the destination and src buffer
+	 * was already byte aligned, then we're done.
+	 */
+	if (!nbits && !bits_in_src_buffer)
+		return;
+
+	/* Copy the remaining bits to src_buffer */
+	if (nbits)
+		src_buffer |= (*src & GENMASK(nbits - 1, 0)) <<
+			      bits_in_src_buffer;
+	bits_in_src_buffer += nbits;
+
+	/*
+	 * In case there were not enough bits to get a byte aligned dst buffer
+	 * prepare the src_buffer variable to match the dst organization (shift
+	 * src_buffer by dst_bit_off and retrieve the least significant bits
+	 * from dst).
+	 */
+	if (dst_bit_off)
+		src_buffer = (src_buffer << dst_bit_off) |
+			     (*dst & GENMASK(dst_bit_off - 1, 0));
+	bits_in_src_buffer += dst_bit_off;
+
+	/*
+	 * Keep most significant bits from dst if we end up with an unaligned
+	 * number of bits.
+	 */
+	nbytes = bits_in_src_buffer / 8;
+	if (bits_in_src_buffer % 8) {
+		src_buffer |= (dst[nbytes] &
+			       GENMASK(7, bits_in_src_buffer % 8)) <<
+			      (nbytes * 8);
+		nbytes++;
+	}
+
+	/* Copy the remaining bytes to dst */
+	for (i = 0; i < nbytes; i++) {
+		dst[i] = src_buffer;
+		src_buffer >>= 8;
+	}
+}
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.h b/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
index 32c6ba4..20da1f1 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
@@ -290,6 +290,10 @@ extern int gpmi_send_page(struct gpmi_nand_data *,
 extern int gpmi_read_page(struct gpmi_nand_data *,
 			dma_addr_t payload, dma_addr_t auxiliary);
 
+void gpmi_copy_bits(u8 *dst, size_t dst_bit_off,
+		    const u8 *src, size_t src_bit_off,
+		    size_t nbits);
+
 /* BCH : Status Block Completion Codes */
 #define STATUS_GOOD		0x00
 #define STATUS_ERASED		0xff
-- 
1.9.1

