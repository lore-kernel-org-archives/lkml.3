Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaCYIZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:25:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57275 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbaCYIVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:21:42 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 43/47] mtd: nand: stm_nand_bch: read and write functions (BCH)
Date: Tue, 25 Mar 2014 08:20:00 +0000
Message-Id: <1395735604-26706-44-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helper function for bch_mtd_read() and bch_mtd_write() to handle
multi-page or non-aligned reads and writes respectively.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 143 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 143 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 389ccee..bcaed32 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -507,6 +507,149 @@ static uint8_t bch_write_page(struct nandi_controller *nandi,
 	return status;
 }
 
+/* Helper function for bch_mtd_read to handle multi-page or non-aligned reads */
+static int bch_read(struct nandi_controller *nandi,
+		    loff_t from, size_t len,
+		    size_t *retlen, u_char *buf)
+{
+	struct mtd_ecc_stats stats;
+	uint32_t page_size = nandi->info.mtd.writesize;
+	uint32_t col_offs;
+	loff_t page_mask;
+	loff_t page_offs;
+	int ecc_errs, max_ecc_errs = 0;
+	int page_num;
+	size_t bytes;
+	uint8_t *p;
+	bool bounce = false;
+
+	dev_dbg(nandi->dev, "%s: %llu @ 0x%012llx\n", __func__,
+		(unsigned long long)len, from);
+
+	stats = nandi->info.mtd.ecc_stats;
+	page_mask = (loff_t)page_size - 1;
+	col_offs  = (uint32_t)(from & page_mask);
+	page_offs = from & ~page_mask;
+	page_num  = (int)(page_offs >> nandi->page_shift);
+
+	while (len > 0) {
+		bytes = min((page_size - col_offs), len);
+
+		if ((bytes != page_size) ||
+		    ((unsigned int)buf & (NANDI_BCH_DMA_ALIGNMENT - 1)) ||
+		    (!virt_addr_valid(buf))) /* vmalloc'd buffer! */
+			bounce = true;
+
+		if (page_num == nandi->cached_page) {
+			memcpy(buf, nandi->page_buf + col_offs, bytes);
+			goto done;
+		}
+
+		p = bounce ? nandi->page_buf : buf;
+
+		ecc_errs = bch_read_page(nandi, page_offs, p);
+		if (bounce)
+			memcpy(buf, p + col_offs, bytes);
+
+		if (ecc_errs < 0) {
+			dev_err(nandi->dev,
+				"%s: uncorrectable error at 0x%012llx\n",
+				__func__, page_offs);
+			nandi->info.mtd.ecc_stats.failed++;
+
+			/* Do not cache uncorrectable pages */
+			if (bounce)
+				nandi->cached_page = -1;
+
+			goto done;
+		}
+
+		if (ecc_errs) {
+			dev_info(nandi->dev,
+				 "%s: corrected %u error(s) at 0x%012llx\n",
+				 __func__, ecc_errs, page_offs);
+
+			nandi->info.mtd.ecc_stats.corrected += ecc_errs;
+
+			if (ecc_errs > max_ecc_errs)
+				max_ecc_errs = ecc_errs;
+		}
+
+		if (bounce)
+			nandi->cached_page = page_num;
+
+done:
+		buf += bytes;
+		len -= bytes;
+
+		if (retlen)
+			*retlen += bytes;
+
+		/* We are now page-aligned */
+		page_offs += page_size;
+		page_num++;
+		col_offs = 0;
+	}
+
+	/* Return '-EBADMSG' on uncorrectable errors */
+	if (nandi->info.mtd.ecc_stats.failed - stats.failed)
+		return -EBADMSG;
+
+	return max_ecc_errs;
+}
+
+/* Helper function for mtd_write, to handle multi-page and non-aligned writes */
+static int bch_write(struct nandi_controller *nandi,
+		     loff_t to, size_t len,
+		     size_t *retlen, const uint8_t *buf)
+{
+	uint32_t page_size = nandi->info.mtd.writesize;
+	int page_num;
+	bool bounce = false;
+	const uint8_t *p = NULL;
+	uint8_t ret;
+
+	dev_dbg(nandi->dev, "%s: %llu @ 0x%012llx\n", __func__,
+		(unsigned long long)len, to);
+
+	BUG_ON(len & (page_size - 1));
+	BUG_ON(to & (page_size - 1));
+
+	if (((unsigned long)buf & (NANDI_BCH_DMA_ALIGNMENT - 1)) ||
+	    !virt_addr_valid(buf)) { /* vmalloc'd buffer! */
+		bounce = true;
+	}
+
+	page_num = (int)(to >> nandi->page_shift);
+
+	while (len > 0) {
+		if (bounce) {
+			memcpy(nandi->page_buf, buf, page_size);
+			p = nandi->page_buf;
+			nandi->cached_page = -1;
+		} else {
+			p = buf;
+		}
+
+		if (nandi->cached_page == page_num)
+			nandi->cached_page = -1;
+
+		ret = bch_write_page(nandi, to, p);
+		if (ret & NAND_STATUS_FAIL)
+			return -EIO;
+
+		to += page_size;
+		page_num++;
+		buf += page_size;
+		len -= page_size;
+
+		if (retlen)
+			*retlen += page_size;
+	}
+
+	return 0;
+}
+
 /*
  * Hamming-FLEX operations
  */
-- 
1.8.3.2

