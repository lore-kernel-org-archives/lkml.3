Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaCYIrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:47:13 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:58575 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbaCYIVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:21:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 24/47] mtd: nand: stm_nand_bch: find IBBT signature
Date: Tue, 25 Mar 2014 08:19:41 +0000
Message-Id: <1395735604-26706-25-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scan block for IBBT signature, either "Bbt0" or "1tbB" from
pre-specified data block.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 91 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 6323590..5bcaabbc 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -43,6 +43,37 @@ static int bch_ecc_sizes[] = {
 	[BCH_NO_ECC] = 0,
 };
 
+/*
+ * Inband Bad Block Table (IBBT)
+ */
+#define NAND_IBBT_NBLOCKS	4
+#define NAND_IBBT_SIGLEN	4
+#define NAND_IBBT_PRIMARY	0
+#define NAND_IBBT_MIRROR	1
+#define NAND_IBBT_SCHEMA	0x10
+#define NAND_IBBT_BCH_SCHEMA	0x10
+
+static uint8_t ibbt_sigs[2][NAND_IBBT_SIGLEN] = {
+	{'B', 'b', 't', '0'},
+	{'1', 't', 'b', 'B'},
+};
+
+/* IBBT header */
+struct nand_ibbt_header {
+	uint8_t	signature[4];		/* "Bbt0" or "1tbB" signature */
+	uint8_t version;		/* BBT version ("age") */
+	uint8_t reserved[3];		/* padding */
+	uint8_t schema[4];		/* "base" schema (x4) */
+} __packed;
+
+/* Extend IBBT header with some stm-nand-bch niceties */
+struct nand_ibbt_bch_header {
+	struct nand_ibbt_header base;
+	uint8_t schema[4];		/* "private" schema (x4) */
+	uint8_t ecc_size[4];		/* ECC bytes (0, 32, 54) (x4) */
+	char	author[64];		/* Arbitrary string for S/W to use */
+} __packed;
+
 /* Bad Block Table (BBT) */
 struct nandi_bbt_info {
 	uint32_t	bbt_size;		/* Size of bad-block table */
@@ -464,6 +495,66 @@ static uint8_t bch_write_page(struct nandi_controller *nandi,
 	return status;
 }
 
+/* Scan block for IBBT signature */
+static int bch_find_ibbt_sig(struct nandi_controller *nandi,
+			     uint32_t block, int *bak, uint8_t *vers,
+			     char *author)
+{
+	struct mtd_info *mtd = &nandi->info.mtd;
+	struct nand_ibbt_bch_header *ibbt_header;
+	loff_t offs;
+	uint8_t *buf = nandi->page_buf;
+	int match_sig;
+	unsigned int b;
+	unsigned int i;
+
+	nandi->cached_page = -1;
+
+	/* Load last page of block */
+	offs = (loff_t)block << nandi->block_shift;
+	offs += mtd->erasesize - mtd->writesize;
+	if (bch_read_page(nandi, offs, buf) < 0) {
+		dev_info(nandi->dev,
+			 "Uncorrectable ECC error while scanning BBT signature at block %u [0x%012llx]\n",
+			 block, offs);
+		return 0;
+	}
+	ibbt_header = (struct nand_ibbt_bch_header *)buf;
+
+	/* Test IBBT signature */
+	match_sig = 0;
+	for (b = 0; b < 2 && !match_sig; b++) {
+		match_sig = 1;
+		for (i = 0; i < NAND_IBBT_SIGLEN; i++) {
+			if (ibbt_header->base.signature[i] != ibbt_sigs[b][i]) {
+				match_sig = 0;
+				break;
+			}
+		}
+
+	}
+
+	if (!match_sig)
+		return 0; /* Failed to match IBBT signature */
+
+	/* Test IBBT schema */
+	for (i = 0; i < 4; i++)
+		if (ibbt_header->base.schema[i] != NAND_IBBT_SCHEMA)
+			return 0;
+
+	/* Test IBBT BCH schema */
+	for (i = 0; i < 4; i++)
+		if (ibbt_header->schema[i] != NAND_IBBT_BCH_SCHEMA)
+			return 0;
+
+	/* We have a match */
+	*vers = ibbt_header->base.version;
+	*bak = b - 1;
+	strncpy(author, ibbt_header->author, 64);
+
+	return 1;
+}
+
 /*
  * Initialisation
  */
-- 
1.8.3.2

