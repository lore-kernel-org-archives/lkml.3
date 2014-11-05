Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbaKERA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:00:58 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35168 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190AbaKERAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:00:54 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: [PATCH v4 11/11] mtd: nand: stm_nand_bch: provide ST's implementation of Bad Block Table
Date: Wed,  5 Nov 2014 16:59:53 +0000
Message-Id: <1415206793-25670-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415206793-25670-1-git-send-email-lee.jones@linaro.org>
References: <1415206793-25670-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the BBT format ST use internally.  It has to be used on boards
which were flashed with or actively use ST's tooling and boards which
are booted using ST's bootloaders.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/Kconfig        |   8 +
 drivers/mtd/nand/Makefile       |   4 +-
 drivers/mtd/nand/stm_nand_bbt.c | 619 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 630 insertions(+), 1 deletion(-)
 create mode 100644 drivers/mtd/nand/stm_nand_bbt.c

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 2738eec..040374d 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -520,4 +520,12 @@ config MTD_NAND_STM_BCH
 	help
 	  Adds support for the STMicroelectronics NANDi BCH Controller.
 
+config MTD_NAND_STM_BCH_BBT
+	bool "STMicroelectronics: NANDi BCH Controller Bad Block Table support"
+	default y if MTD_NAND_STM_BCH=y || MTD_NAND_STM_BCH=m
+	help
+	  Adds support for the STMicroelectronics Bad Block Table support.
+	  If you are using a device which has has already been initialised
+	  by ST or using their tooling/bootloaders, leave this enabled.
+
 endif # MTD_NAND
diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index 6044e0a..e342c91 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -41,7 +41,9 @@ obj-$(CONFIG_MTD_NAND_MLC_LPC32XX)      += lpc32xx_mlc.o
 obj-$(CONFIG_MTD_NAND_SH_FLCTL)		+= sh_flctl.o
 obj-$(CONFIG_MTD_NAND_MXC)		+= mxc_nand.o
 obj-$(CONFIG_MTD_NAND_SOCRATES)		+= socrates_nand.o
-obj-$(CONFIG_MTD_NAND_STM_BCH)		+= stm_nand_bch.o
+obj-$(CONFIG_MTD_NAND_STM_BCH)		+= stm-nand.o
+stm-nand-y				+= stm_nand_bch.o
+stm-nand-$(CONFIG_MTD_NAND_STM_BCH_BBT)	+= stm_nand_bbt.o
 obj-$(CONFIG_MTD_NAND_TXX9NDFMC)	+= txx9ndfmc.o
 obj-$(CONFIG_MTD_NAND_NUC900)		+= nuc900_nand.o
 obj-$(CONFIG_MTD_NAND_MPC5121_NFC)	+= mpc5121_nfc.o
diff --git a/drivers/mtd/nand/stm_nand_bbt.c b/drivers/mtd/nand/stm_nand_bbt.c
new file mode 100644
index 0000000..aacf9fd
--- /dev/null
+++ b/drivers/mtd/nand/stm_nand_bbt.c
@@ -0,0 +1,619 @@
+/*
+ * Support for STMicroelectronics Bad Block Table (BBT)
+ *
+ * Copyright (c) 2014 STMicroelectronics Limited
+ *
+ * Authors: Angus Clark <Angus.Clark@st.com>
+ *	    Lee Jones <lee.jones@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/stm_nand.h>
+#include <linux/mtd/stm_nand_bbt.h>
+#include <generated/utsrelease.h>
+
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
+static char *bbt_strs[] = {
+	"primary",
+	"mirror",
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
+/*
+ * Bad Block Tables/Bad Block Markers
+ */
+#define BBT_MARK_BAD_FACTORY	0x0
+#define BBT_MARK_BAD_WEAR	0x1
+#define BBT_MARK_GOOD		0x3
+
+static void bbt_set_block_mark(uint8_t *bbt, uint32_t block, uint8_t mark)
+{
+	unsigned int byte = block >> 2;
+	unsigned int shift = (block & 0x3) << 1;
+
+	bbt[byte] &= ~(0x3 << shift);
+	bbt[byte] |= ((mark & 0x3) << shift);
+}
+
+static uint8_t bbt_get_block_mark(uint8_t *bbt, uint32_t block)
+{
+	unsigned int byte = block >> 2;
+	unsigned int shift = (block & 0x3) << 1;
+
+	return (bbt[byte] >> shift) & 0x3;
+}
+
+static int bbt_is_block_bad(uint8_t *bbt, uint32_t block)
+{
+	return bbt_get_block_mark(bbt, block) == BBT_MARK_GOOD ? 0 : 1;
+}
+
+/* Scan page for BBM(s), according to specified BBT options */
+static int nandi_scan_bad_block_markers_page(struct nandi_controller *nandi,
+					     uint32_t page)
+{
+	struct mtd_info *mtd = &nandi->info.mtd;
+	struct nand_chip *chip = mtd->priv;
+	uint8_t *oob_buf = nandi->oob_buf;
+	struct mtd_oob_ops ops;
+	loff_t from;
+	int ret;
+	int i, e;
+
+	from = page << chip->page_shift;
+	ops.mode = MTD_OPS_PLACE_OOB;
+	ops.oobbuf = oob_buf;
+	ops.ooblen = mtd->oobsize;
+	ops.ooboffs = 0;
+	ops.datbuf = NULL;
+	ops.len = 0;
+
+	ret = mtd_read_oob(mtd, from, &ops);
+	/* Ignore ECC errors when checking for BBMs */
+	if (ret && !mtd_is_bitflip_or_eccerr(ret))
+		return ret;
+
+	if (oob_buf[chip->badblockpos] == 0xff)
+		return 0;
+
+	/* Tolerate 'alien' Hamming Boot Mode ECC */
+	e = 0;
+	for (i = 0; i < mtd->oobsize; i += 16)
+		e += hweight8(oob_buf[i + 3] ^ 'B');
+	if (e <= 1)
+		return 0;
+
+	/* Tolerate 'alien' Hamming AFM ECC */
+	e = 0;
+	for (i = 0; i < mtd->oobsize; i += 16) {
+		e += hweight8(oob_buf[i + 3] ^ 'A');
+		e += hweight8(oob_buf[i + 4] ^ 'F');
+		e += hweight8(oob_buf[i + 5] ^ 'M');
+		if (e <= 1)
+			return 0;
+	}
+
+	return 1;
+}
+
+/* Scan block for BBM(s), according to specified BBT options */
+static int nandi_scan_bad_block_markers_block(struct nandi_controller *nandi,
+					      uint32_t block)
+
+{
+	struct mtd_info *mtd = &nandi->info.mtd;
+	struct nand_chip *chip = mtd->priv;
+	uint32_t pages_per_block = mtd->erasesize >> chip->page_shift;
+	uint32_t page = block << (chip->phys_erase_shift - chip->page_shift);
+
+	if (nandi_scan_bad_block_markers_page(nandi, page))
+		return 1;
+
+	if ((chip->bbt_options & NAND_BBT_SCAN2NDPAGE) &&
+	    nandi_scan_bad_block_markers_page(nandi, page + 1))
+		return 1;
+
+	if ((chip->bbt_options & NAND_BBT_SCANLASTPAGE) &&
+	    nandi_scan_bad_block_markers_page(nandi,
+					      page + pages_per_block - 1))
+		return 1;
+
+	return 0;
+}
+
+/* Scan for BBMs and build memory-resident BBT */
+static int nandi_scan_build_bbt(struct nandi_controller *nandi,
+				struct nandi_bbt_info *bbt_info)
+{
+	struct mtd_info *mtd = &nandi->info.mtd;
+	struct nand_chip *chip = mtd->priv;
+	uint32_t page_size = mtd->writesize;
+	uint8_t *bbt = bbt_info->bbt;
+	uint32_t block;
+
+	dev_dbg(nandi->dev,
+		"scan device for bad-block markers [bbt options = 0x%02x]\n",
+		chip->bbt_options);
+
+	memset(bbt, 0xff, page_size);
+	bbt_info->bbt_vers[0] = 0;
+	bbt_info->bbt_vers[1] = 0;
+	bbt_info->bbt_block[0] = nandi->blocks_per_device - 1;
+	bbt_info->bbt_block[1] = nandi->blocks_per_device - 2;
+
+	for (block = 0; block < nandi->blocks_per_device; block++)
+		if (nandi_scan_bad_block_markers_block(nandi, block))
+			bbt_set_block_mark(bbt, block, BBT_MARK_BAD_FACTORY);
+
+	return 0;
+}
+
+/* Populate IBBT BCH Header */
+static void bch_fill_ibbt_header(struct nandi_controller *nandi,
+				 struct nand_ibbt_bch_header *ibbt_header,
+				 int bak, uint8_t vers)
+{
+	const char author[] = "STLinux " UTS_RELEASE " (stm-nand-bch)";
+
+	memcpy(ibbt_header->base.signature, ibbt_sigs[bak], NAND_IBBT_SIGLEN);
+	ibbt_header->base.version = vers;
+	memset(ibbt_header->base.schema, NAND_IBBT_SCHEMA, 4);
+
+	memset(ibbt_header->schema, NAND_IBBT_SCHEMA, 4);
+	memset(ibbt_header->ecc_size, bch_ecc_sizes[nandi->bch_ecc_mode], 4);
+	memcpy(ibbt_header->author, author, sizeof(author));
+}
+
+/* Write IBBT to Flash */
+static int bch_write_bbt_data(struct nandi_controller *nandi,
+			      struct nandi_bbt_info *bbt_info,
+			      uint32_t block, int bak, uint8_t vers)
+{
+	struct nand_ibbt_bch_header *ibbt_header =
+		(struct nand_ibbt_bch_header *)nandi->page_buf;
+	struct nand_chip *chip = &nandi->info.chip;
+	struct mtd_info *mtd = &nandi->info.mtd;
+	uint32_t page_size = mtd->writesize;
+	uint32_t block_size = mtd->erasesize;
+	loff_t offs;
+	size_t retlen;
+	int ret;
+
+	/* Write BBT contents to first page of block */
+	offs = (loff_t)block << chip->phys_erase_shift;
+	ret = mtd_write(mtd, offs, page_size, &retlen, bbt_info->bbt);
+	if (ret)
+		return ret;
+
+	/* Update IBBT header and write to last page of block */
+	memset(ibbt_header, 0xff, mtd->writesize);
+	bch_fill_ibbt_header(nandi, ibbt_header, bak, vers);
+	offs += block_size - page_size;
+	ret = mtd_write(mtd, offs, sizeof(*ibbt_header), &retlen,
+			     (uint8_t *)ibbt_header);
+	return ret;
+}
+
+/*
+ * Update Flash-resident BBT:
+ *   erase/search suitable block, and write table data to Flash
+ */
+static int bch_update_bbt(struct nandi_controller *nandi,
+			 struct nandi_bbt_info *bbt_info,
+			 int bak, uint8_t vers)
+{
+	struct nand_chip *chip = &nandi->info.chip;
+	struct mtd_info *mtd = &nandi->info.mtd;
+	struct erase_info einfo;
+	loff_t offs;
+	uint32_t block;
+	uint32_t block_lower;
+	uint32_t block_other;
+	int ret;
+
+	block_other = bbt_info->bbt_block[(bak+1)%2];
+	block_lower = nandi->blocks_per_device - NAND_IBBT_NBLOCKS;
+
+	for (block = bbt_info->bbt_block[bak]; block >= block_lower;  block--) {
+		offs = (loff_t)block << chip->phys_erase_shift;
+
+		/* Skip if block used by other table */
+		if (block == block_other)
+			continue;
+
+		/* Skip if block is marked bad */
+		if (bbt_is_block_bad(bbt_info->bbt, block))
+			continue;
+
+		/* Erase block, mark bad and skip on failure */
+		memset(&einfo, 0, sizeof(einfo));
+		einfo.mtd = mtd;
+		einfo.addr = offs;
+		einfo.len = 1 << chip->phys_erase_shift;
+		ret = mtd_erase(mtd, &einfo);
+		if (ret < 0) {
+			dev_info(nandi->dev,
+				 "failed to erase block [%u:0x%012llx] while updating BBT\n",
+				 block, offs);
+			vers++;
+			bbt_set_block_mark(bbt_info->bbt, block,
+					   BBT_MARK_BAD_WEAR);
+			continue;
+		}
+
+		/* Write BBT, mark bad and skip on failure */
+		if (bch_write_bbt_data(nandi, bbt_info, block, bak, vers)) {
+			dev_info(nandi->dev,
+				 "failed to write BBT to block [%u:0x%012llx]\n",
+				 block, offs);
+			vers++;
+			bbt_set_block_mark(bbt_info->bbt, block,
+					   BBT_MARK_BAD_WEAR);
+			continue;
+		}
+
+		/* Success */
+		bbt_info->bbt_block[bak] = block;
+		bbt_info->bbt_vers[bak] = vers;
+		break;
+	}
+
+	/* No space in BBT area */
+	if (block < block_lower) {
+		dev_err(nandi->dev, "no space left in BBT area\n");
+		dev_err(nandi->dev, "failed to update %s BBT\n", bbt_strs[bak]);
+		return -ENOSPC;
+	}
+
+	dev_info(nandi->dev, "wrote BBT [%s:%u] at 0x%012llx [%u]\n",
+		 bbt_strs[bak], vers, offs, block);
+
+	return 0;
+}
+
+#define NAND_IBBT_UPDATE_PRIMARY	0x1
+#define NAND_IBBT_UPDATE_MIRROR		0x2
+#define NAND_IBBT_UPDATE_BOTH		(NAND_IBBT_UPDATE_PRIMARY | \
+					 NAND_IBBT_UPDATE_MIRROR)
+static char *bbt_update_strs[] = {
+	"",
+	"primary",
+	"mirror",
+	"both",
+};
+
+/*
+ * Update Flash-resident BBT(s):
+ *   incrementing 'vers' number if required, and ensuring Primary
+ *   and Mirror are kept in sync
+ */
+static int bch_update_bbts(struct nandi_controller *nandi,
+			   struct nandi_bbt_info *bbt_info,
+			   unsigned int update, uint8_t vers)
+{
+	int err;
+
+	dev_info(nandi->dev, "updating %s BBT(s)\n", bbt_update_strs[update]);
+
+	do {
+		/* Update Primary if specified */
+		if (update & NAND_IBBT_UPDATE_PRIMARY) {
+			err = bch_update_bbt(nandi, bbt_info, NAND_IBBT_PRIMARY,
+					     vers);
+			/* Bail out on error (e.g. no space left in BBT area) */
+			if (err)
+				return err;
+
+			/*
+			 * If update resulted in a new BBT version
+			 * (e.g. Erase/Write fail on BBT block) update version
+			 * here, and force update of other table.
+			 */
+			if (bbt_info->bbt_vers[NAND_IBBT_PRIMARY] != vers) {
+				vers = bbt_info->bbt_vers[NAND_IBBT_PRIMARY];
+				update = NAND_IBBT_UPDATE_MIRROR;
+			}
+		}
+
+		/* Update Mirror if specified */
+		if (update & NAND_IBBT_UPDATE_MIRROR) {
+			err = bch_update_bbt(nandi, bbt_info, NAND_IBBT_MIRROR,
+					     vers);
+			/* Bail out on error (e.g. no space left in BBT area) */
+			if (err)
+				return err;
+
+			/*
+			 * If update resulted in a new BBT version
+			 * (e.g. Erase/Write fail on BBT block) update version
+			 * here, and force update of other table.
+			 */
+			if (bbt_info->bbt_vers[NAND_IBBT_MIRROR] != vers) {
+				vers = bbt_info->bbt_vers[NAND_IBBT_MIRROR];
+				update = NAND_IBBT_UPDATE_PRIMARY;
+			}
+		}
+
+		/* Continue, until Primary and Mirror versions are in sync */
+	} while (bbt_info->bbt_vers[NAND_IBBT_PRIMARY] !=
+		 bbt_info->bbt_vers[NAND_IBBT_MIRROR]);
+
+	return 0;
+}
+
+/* Scan block for IBBT signature */
+static int bch_find_ibbt_sig(struct nandi_controller *nandi,
+			     uint32_t block, int *bak, uint8_t *vers,
+			     char *author)
+{
+	struct nand_chip *chip = &nandi->info.chip;
+	struct mtd_info *mtd = &nandi->info.mtd;
+	struct nand_ibbt_bch_header *ibbt_header;
+	loff_t offs;
+	uint8_t *buf = nandi->page_buf;
+	int match_sig;
+	unsigned int b;
+	unsigned int i;
+	size_t retlen;
+	int ret;
+
+	/* Load last page of block */
+	offs = (loff_t)block << chip->phys_erase_shift;
+	offs += mtd->erasesize - mtd->writesize;
+	ret = mtd_read(mtd, offs, sizeof(*ibbt_header), &retlen, buf);
+	if (ret < 0) {
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
+/* Search for and load Flash-resident BBT, updating Primary/Mirror if req'd */
+static int bch_load_bbt(struct nandi_controller *nandi,
+			struct nandi_bbt_info *bbt_info)
+{
+	struct nand_chip *chip = &nandi->info.chip;
+	struct mtd_info *mtd = &nandi->info.mtd;
+	uint32_t page_size = mtd->writesize;
+	unsigned int update = 0;
+	uint32_t block;
+	loff_t offs;
+	uint8_t vers;
+	char author[64];
+	size_t retlen;
+	int ret;
+	int bak;
+
+	dev_dbg(nandi->dev, "looking for Flash-resident BBTs\n");
+
+	bbt_info->bbt_block[0] = 0;
+	bbt_info->bbt_block[1] = 0;
+	bbt_info->bbt_vers[0] = 0;
+	bbt_info->bbt_vers[1] = 0;
+
+	/* Look for IBBT signatures */
+	for (block = nandi->blocks_per_device - NAND_IBBT_NBLOCKS;
+	     block < nandi->blocks_per_device;
+	     block++) {
+		offs = (loff_t)block << chip->phys_erase_shift;
+
+		if (bch_find_ibbt_sig(nandi, block, &bak, &vers, author)) {
+			dev_dbg(nandi->dev,
+				"found BBT [%s:%u] at 0x%012llx [%u] (%s)\n",
+				bbt_strs[bak], vers, offs, block,
+				author);
+
+			if (bbt_info->bbt_block[bak] == 0 ||
+			    ((int8_t)(bbt_info->bbt_vers[bak] - vers)) < 0) {
+				bbt_info->bbt_block[bak] = block;
+				bbt_info->bbt_vers[bak] = vers;
+			}
+		}
+	}
+
+	/* What have we found? */
+	if (bbt_info->bbt_block[0] == 0 && bbt_info->bbt_block[1] == 0) {
+		/* no primary, no mirror: return error */
+		return 1;
+	} else if (bbt_info->bbt_block[0] == 0) {
+		/* no primary: use mirror, update primary */
+		bak = 1;
+		update = NAND_IBBT_UPDATE_PRIMARY;
+		bbt_info->bbt_block[0] = nandi->blocks_per_device - 1;
+	} else if (bbt_info->bbt_block[1] == 0) {
+		/* no mirror: use primary, update mirror */
+		bak = 0;
+		update = NAND_IBBT_UPDATE_MIRROR;
+		bbt_info->bbt_block[1] = nandi->blocks_per_device - 1;
+	} else if (bbt_info->bbt_vers[0] == bbt_info->bbt_vers[1]) {
+		/* primary == mirror: use primary, no update required */
+		bak = 0;
+	} else if ((int8_t)(bbt_info->bbt_vers[1] -
+			    bbt_info->bbt_vers[0]) < 0) {
+		/* primary > mirror: use primary, update mirror */
+		bak = 0;
+		update = NAND_IBBT_UPDATE_MIRROR;
+	} else {
+		/* mirror > primary: use mirror, update primary */
+		bak = 1;
+		update = NAND_IBBT_UPDATE_PRIMARY;
+	}
+
+	vers = bbt_info->bbt_vers[bak];
+	block = bbt_info->bbt_block[bak];
+	offs = (loff_t)block << chip->phys_erase_shift;
+	dev_info(nandi->dev, "using BBT [%s:%u] at 0x%012llx [%u]\n",
+		 bbt_strs[bak], vers, offs, block);
+
+	/* Read BBT data */
+	ret = mtd_read(mtd, offs, page_size, &retlen, bbt_info->bbt);
+	if (ret < 0) {
+		dev_err(nandi->dev,
+			"error while reading BBT %s:%u] at 0x%012llx [%u]\n",
+			bbt_strs[bak], vers, offs, block);
+		return 1;
+	}
+
+	/* Update other BBT if required */
+	if (update)
+		bch_update_bbts(nandi, bbt_info, update, vers);
+
+	return 0;
+}
+
+int bch_scan_bbt(struct mtd_info *mtd)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+	struct nandi_bbt_info *bbt_info = &nandi->info.bbt_info;
+	int err;
+
+	/* Load Flash-resident BBT */
+	err = bch_load_bbt(nandi, bbt_info);
+	if (err) {
+		dev_warn(nandi->dev,
+			"failed to find BBTs:\n"
+			"  scanning device for bad-block markers\n");
+
+		/* Scan, build, and write BBT */
+		nandi_scan_build_bbt(nandi, bbt_info);
+		err = bch_update_bbts(nandi, bbt_info, NAND_IBBT_UPDATE_BOTH,
+				      bbt_info->bbt_vers[0] + 1);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+int bch_block_isbad(struct mtd_info *mtd, loff_t offs, int getchip)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+
+	uint32_t block;
+
+	/* Check for invalid offset */
+	if (offs >= mtd->size)
+		return -EINVAL;
+
+	block = offs >> chip->phys_erase_shift;
+
+	/* Protect blocks reserved for BBTs */
+	if (block >= (nandi->blocks_per_device - NAND_IBBT_NBLOCKS))
+		return 1;
+
+	return bbt_is_block_bad(nandi->info.bbt_info.bbt, block);
+}
+
+int bch_block_markbad(struct mtd_info *mtd, loff_t offs)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+
+	uint32_t block;
+	int ret;
+
+	/* Mark bad */
+	block = offs >> chip->phys_erase_shift;
+	bbt_set_block_mark(nandi->info.bbt_info.bbt, block, BBT_MARK_BAD_WEAR);
+
+	/* Update BBTs, incrementing bbt_vers */
+	ret = bch_update_bbts(nandi, &nandi->info.bbt_info,
+			      NAND_IBBT_UPDATE_BOTH,
+			      nandi->info.bbt_info.bbt_vers[0] + 1);
+
+	return ret;
+}
+
+void nandi_dump_bad_blocks(struct nandi_controller *nandi)
+{
+	struct nand_chip *chip = &nandi->info.chip;
+	int bad_count = 0;
+	uint32_t block;
+	uint8_t *bbt = nandi->info.bbt_info.bbt;
+	uint8_t mark;
+
+	pr_info("BBT:\n");
+	for (block = 0; block < nandi->blocks_per_device; block++) {
+		mark = bbt_get_block_mark(bbt, block);
+		if (mark != BBT_MARK_GOOD) {
+			pr_info("\t\tBlock 0x%08x [%05u] marked bad [%s]\n",
+				block << chip->phys_erase_shift, block,
+				(mark == BBT_MARK_BAD_FACTORY) ?
+				"Factory" : "Wear");
+			bad_count++;
+		}
+	}
+	if (bad_count == 0)
+		pr_info("\t\tNo bad blocks listed in BBT\n");
+}
+EXPORT_SYMBOL(nandi_dump_bad_blocks);
-- 
1.9.1

