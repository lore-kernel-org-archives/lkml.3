Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab3K2MUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:20:33 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:47304 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab3K2MU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:20:26 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Cc: linus.walleij@linaro.org, linux-mtd@lists.infradead.org,
        angus.clark@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v3 26/36] mtd: st_spi_fsm: Add the ability to read from a Serial Flash device
Date: Fri, 29 Nov 2013 12:19:15 +0000
Message-Id: <1385727565-25794-27-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a read is issued by userspace the MFD framework calls back into
the driver to conduct the actual command issue and data extraction.
Here we provide the routines which do exactly that.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 110 +++++++++++++++++++++++++++++++++++++++
 drivers/mtd/devices/st_spi_fsm.h |   3 ++
 2 files changed, 113 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index ad277f1..c76510e 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -538,6 +538,114 @@ static int stfsm_n25q_config(struct stfsm *fsm)
 	return 0;
 }
 
+static int stfsm_read(struct stfsm *fsm, uint8_t *const buf,
+		      const uint32_t size, const uint32_t offset)
+{
+	struct stfsm_seq *seq = &stfsm_seq_read;
+	uint32_t data_pads;
+	uint32_t read_mask;
+	uint32_t size_ub;
+	uint32_t size_lb;
+	uint32_t size_mop;
+	uint32_t tmp[4];
+	uint32_t page_buf[FLASH_PAGESIZE_32];
+	uint8_t *p;
+
+	dev_dbg(fsm->dev, "reading %d bytes from 0x%08x\n", size, offset);
+
+	/* Enter 32-bit address mode, if required */
+	if (fsm->configuration & CFG_READ_TOGGLE_32BIT_ADDR)
+		stfsm_enter_32bit_addr(fsm, 1);
+
+	/* Must read in multiples of 32 cycles (or 32*pads/8 Bytes) */
+	data_pads = ((seq->seq_cfg >> 16) & 0x3) + 1;
+	read_mask = (data_pads << 2) - 1;
+
+	/* Handle non-aligned buf */
+	p = ((uint32_t)buf & 0x3) ? (uint8_t *)page_buf : buf;
+
+	/* Handle non-aligned size */
+	size_ub = (size + read_mask) & ~read_mask;
+	size_lb = size & ~read_mask;
+	size_mop = size & read_mask;
+
+	seq->data_size = TRANSFER_SIZE(size_ub);
+	seq->addr1 = (offset >> 16) & 0xffff;
+	seq->addr2 = offset & 0xffff;
+
+	stfsm_load_seq(fsm, seq);
+
+	if (size_lb)
+		stfsm_read_fifo(fsm, (uint32_t *)p, size_lb);
+
+	if (size_mop) {
+		stfsm_read_fifo(fsm, tmp, read_mask + 1);
+		memcpy(p + size_lb, &tmp, size_mop);
+	}
+
+	/* Handle non-aligned buf */
+	if ((uint32_t)buf & 0x3)
+		memcpy(buf, page_buf, size);
+
+	/* Wait for sequence to finish */
+	stfsm_wait_seq(fsm);
+
+	stfsm_clear_fifo(fsm);
+
+	/* Exit 32-bit address mode, if required */
+	if (fsm->configuration & CFG_READ_TOGGLE_32BIT_ADDR)
+		stfsm_enter_32bit_addr(fsm, 0);
+
+	return 0;
+}
+
+/*
+ * Read an address range from the flash chip. The address range
+ * may be any size provided it is within the physical boundaries.
+ */
+static int stfsm_mtd_read(struct mtd_info *mtd, loff_t from, size_t len,
+			  size_t *retlen, u_char *buf)
+{
+	struct stfsm *fsm = dev_get_drvdata(mtd->dev.parent);
+	uint32_t bytes;
+
+	dev_dbg(fsm->dev, "%s from 0x%08x, len %zd\n",
+		__func__, (u32)from, len);
+
+	/* Initialise read length */
+	if (retlen)
+		*retlen = 0;
+
+	if (!len) {
+		dev_warn(fsm->dev, "Zero byte read requested\n");
+		return 0;
+	}
+
+	if (from + len > mtd->size) {
+		dev_err(fsm->dev, "Can't read past end of chip\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&fsm->lock);
+
+	while (len > 0) {
+		bytes = min(len, (size_t)FLASH_PAGESIZE);
+
+		stfsm_read(fsm, buf, bytes, from);
+
+		buf += bytes;
+		from += bytes;
+		len -= bytes;
+
+		if (retlen)
+			*retlen += bytes;
+	}
+
+	mutex_unlock(&fsm->lock);
+
+	return 0;
+}
+
 static void stfsm_read_jedec(struct stfsm *fsm, uint8_t *const jedec)
 {
 	const struct stfsm_seq *seq = &stfsm_seq_read_jedec;
@@ -806,6 +914,8 @@ static int stfsm_probe(struct platform_device *pdev)
 	fsm->mtd.size		= info->sector_size * info->n_sectors;
 	fsm->mtd.erasesize	= info->sector_size;
 
+	fsm->mtd._read  = stfsm_mtd_read;
+
 	dev_err(&pdev->dev,
 		"Found serial flash device: %s\n"
 		" size = %llx (%lldMiB) erasesize = 0x%08x (%uKiB)\n",
diff --git a/drivers/mtd/devices/st_spi_fsm.h b/drivers/mtd/devices/st_spi_fsm.h
index b5ce07d..e168296 100644
--- a/drivers/mtd/devices/st_spi_fsm.h
+++ b/drivers/mtd/devices/st_spi_fsm.h
@@ -229,6 +229,9 @@
 #define FLASH_CMD_READ4_1_1_4	0x6c
 #define FLASH_CMD_READ4_1_4_4	0xec
 
+#define FLASH_PAGESIZE		256			/* In Bytes    */
+#define FLASH_PAGESIZE_32	FLASH_PAGESIZE / 4	/* In uint32_t */
+
 /*
  * Flags to tweak operation of default read/write/erase routines
  */
-- 
1.8.3.2

