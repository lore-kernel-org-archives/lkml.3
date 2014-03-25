Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaCYIkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:40:55 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:47706 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaCYIVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:21:33 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 39/47] mtd: nand: stm_nand_bch: read and write ops (FLEX)
Date: Tue, 25 Mar 2014 08:19:56 +0000
Message-Id: <1395735604-26706-40-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helper functions for mtd_write_oob() and mtd_write_oob().
Handles multi-page transfers and mapping between BCH sectors
and MTD page+OOB data.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 136 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 136 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 18601e5..75c5c9b 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -1082,6 +1082,142 @@ static int bch_load_bbt(struct nandi_controller *nandi,
 	return 0;
 }
 
+/*
+ * Helper function for mtd_read_oob(): handles multi-page transfers
+ * and mapping between BCH sectors and MTD page+OOB data.
+ */
+static int flex_do_read_ops(struct nandi_controller *nandi,
+			    loff_t from,
+			    struct mtd_oob_ops *ops)
+{
+	struct mtd_info *mtd = &nandi->info.mtd;
+	uint32_t page_addr = from >> nandi->page_shift;
+	uint32_t oob_remainder;
+	uint8_t *oobbuf = ops->oobbuf;
+	uint8_t *datbuf = ops->datbuf;
+	uint8_t *page_buf;
+	int ecc_size;
+	int pages;
+	int s;
+
+	ecc_size = bch_ecc_sizes[nandi->bch_ecc_mode];
+	nandi->cached_page = -1;
+
+	pages = ops->datbuf ?
+		(ops->len >> nandi->page_shift) :
+		(ops->ooblen / mtd->oobsize);
+
+	oob_remainder = mtd->oobsize - (nandi->sectors_per_page * ecc_size);
+
+	while (pages) {
+		page_buf = nandi->page_buf;
+
+		flex_read_raw(nandi, page_addr, 0, page_buf,
+			      mtd->writesize + mtd->oobsize);
+
+		for (s = 0; s < nandi->sectors_per_page; s++) {
+			if (datbuf) {
+				memcpy(datbuf, page_buf, NANDI_BCH_SECTOR_SIZE);
+				datbuf += NANDI_BCH_SECTOR_SIZE;
+				ops->retlen += NANDI_BCH_SECTOR_SIZE;
+			}
+			page_buf += NANDI_BCH_SECTOR_SIZE;
+
+			if (oobbuf) {
+				memcpy(oobbuf, page_buf, ecc_size);
+				ops->oobretlen += ecc_size;
+				oobbuf += ecc_size;
+			}
+			page_buf += ecc_size;
+		}
+
+		if (oob_remainder && oobbuf) {
+			memcpy(oobbuf, page_buf, oob_remainder);
+			oobbuf += oob_remainder;
+			ops->oobretlen += oob_remainder;
+		}
+
+		page_addr++;
+		pages--;
+	}
+
+	return 0;
+}
+
+/*
+ * Helper function for mtd_write_oob(): handles multi-page transfers
+ * and mapping between BCH sectors and MTD page+OOB data.
+*/
+static int flex_do_write_ops(struct nandi_controller *nandi,
+			     loff_t to,
+			     struct mtd_oob_ops *ops)
+{
+	struct mtd_info *mtd = &nandi->info.mtd;
+	uint32_t page_addr = to >> nandi->page_shift;
+	uint32_t oob_remainder;
+	uint8_t *oobbuf = ops->oobbuf;
+	uint8_t *datbuf = ops->datbuf;
+	uint8_t *page_buf;
+	uint8_t status;
+	int ecc_size;
+	int pages;
+	int s;
+
+	ecc_size = bch_ecc_sizes[nandi->bch_ecc_mode];
+	nandi->cached_page = -1;
+
+	pages = ops->datbuf ?
+		(ops->len >> nandi->page_shift) :
+		(ops->ooblen / mtd->oobsize);
+
+	oob_remainder = mtd->oobsize - (nandi->sectors_per_page * ecc_size);
+
+	while (pages) {
+		page_buf = nandi->page_buf;
+
+		for (s = 0; s < nandi->sectors_per_page; s++) {
+			if (datbuf) {
+				memcpy(page_buf, datbuf, NANDI_BCH_SECTOR_SIZE);
+				datbuf += NANDI_BCH_SECTOR_SIZE;
+				ops->retlen += NANDI_BCH_SECTOR_SIZE;
+			} else {
+				memset(page_buf, 0xff, NANDI_BCH_SECTOR_SIZE);
+			}
+			page_buf += NANDI_BCH_SECTOR_SIZE;
+
+			if (oobbuf) {
+				memcpy(page_buf, oobbuf, ecc_size);
+				oobbuf += ecc_size;
+				ops->oobretlen += ecc_size;
+			} else {
+				memset(page_buf, 0xff, ecc_size);
+			}
+			page_buf += ecc_size;
+		}
+
+		if (oob_remainder) {
+			if (oobbuf) {
+				memcpy(page_buf, oobbuf, oob_remainder);
+				oobbuf += oob_remainder;
+				ops->oobretlen += oob_remainder;
+			} else {
+				memset(page_buf, 0xff, oob_remainder);
+			}
+		}
+
+		status = flex_write_raw(nandi, page_addr, 0, nandi->page_buf,
+					mtd->writesize + mtd->oobsize);
+
+		if (status & NAND_STATUS_FAIL)
+			return -EIO;
+
+		page_addr++;
+		pages--;
+	}
+
+	return 0;
+}
+
 static void nandi_dump_bad_blocks(struct nandi_controller *nandi)
 {
 	int bad_count = 0;
-- 
1.8.3.2

