Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab3K2MWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:22:22 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:49425 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab3K2MUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:20:31 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Cc: linus.walleij@linaro.org, linux-mtd@lists.infradead.org,
        angus.clark@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v3 29/36] mtd: st_spi_fsm: Add the ability to write to a Serial Flash device
Date: Fri, 29 Nov 2013 12:19:18 +0000
Message-Id: <1385727565-25794-30-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a write is requested by userspace the MFD framework calls back
into the driver to conduct the actual command issue and data send.
Here we provide the routines which do exactly that.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 150 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 150 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index d8fc97b..9b35e15 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -665,6 +665,98 @@ static int stfsm_read(struct stfsm *fsm, uint8_t *const buf,
 	return 0;
 }
 
+static int stfsm_write(struct stfsm *fsm, const uint8_t *const buf,
+		       const uint32_t size, const uint32_t offset)
+{
+	struct stfsm_seq *seq = &stfsm_seq_write;
+	uint32_t data_pads;
+	uint32_t write_mask;
+	uint32_t size_ub;
+	uint32_t size_lb;
+	uint32_t size_mop;
+	uint32_t tmp[4];
+	uint32_t page_buf[FLASH_PAGESIZE_32];
+	uint8_t *t = (uint8_t *)&tmp;
+	const uint8_t *p;
+	int ret;
+	int i;
+
+	dev_dbg(fsm->dev, "writing %d bytes to 0x%08x\n", size, offset);
+
+	/* Enter 32-bit address mode, if required */
+	if (fsm->configuration & CFG_WRITE_TOGGLE_32BIT_ADDR)
+		stfsm_enter_32bit_addr(fsm, 1);
+
+	/* Must write in multiples of 32 cycles (or 32*pads/8 bytes) */
+	data_pads = ((seq->seq_cfg >> 16) & 0x3) + 1;
+	write_mask = (data_pads << 2) - 1;
+
+	/* Handle non-aligned buf */
+	if ((uint32_t)buf & 0x3) {
+		memcpy(page_buf, buf, size);
+		p = (uint8_t *)page_buf;
+	} else {
+		p = buf;
+	}
+
+	/* Handle non-aligned size */
+	size_ub = (size + write_mask) & ~write_mask;
+	size_lb = size & ~write_mask;
+	size_mop = size & write_mask;
+
+	seq->data_size = TRANSFER_SIZE(size_ub);
+	seq->addr1 = (offset >> 16) & 0xffff;
+	seq->addr2 = offset & 0xffff;
+
+	/* Need to set FIFO to write mode, before writing data to FIFO (see
+	 * GNBvb79594)
+	 */
+	writel(0x00040000, fsm->base + SPI_FAST_SEQ_CFG);
+
+	/*
+	 * Before writing data to the FIFO, apply a small delay to allow a
+	 * potential change of FIFO direction to complete.
+	 */
+	if (fsm->fifo_dir_delay == 0)
+		readl(fsm->base + SPI_FAST_SEQ_CFG);
+	else
+		udelay(fsm->fifo_dir_delay);
+
+
+	/* Write data to FIFO, before starting sequence (see GNBvd79593) */
+	if (size_lb) {
+		stfsm_write_fifo(fsm, (uint32_t *)p, size_lb);
+		p += size_lb;
+	}
+
+	/* Handle non-aligned size */
+	if (size_mop) {
+		memset(t, 0xff, write_mask + 1);	/* fill with 0xff's */
+		for (i = 0; i < size_mop; i++)
+			t[i] = *p++;
+
+		stfsm_write_fifo(fsm, tmp, write_mask + 1);
+	}
+
+	/* Start sequence */
+	stfsm_load_seq(fsm, seq);
+
+	/* Wait for sequence to finish */
+	stfsm_wait_seq(fsm);
+
+	/* Wait for completion */
+	ret = stfsm_wait_busy(fsm);
+
+	/* Exit 32-bit address mode, if required */
+	if (fsm->configuration & CFG_WRITE_TOGGLE_32BIT_ADDR) {
+		stfsm_enter_32bit_addr(fsm, 0);
+		if (fsm->configuration & CFG_WRITE_EX_32BIT_ADDR_DELAY)
+			udelay(1);
+	}
+
+	return 0;
+}
+
 /*
  * Read an address range from the flash chip. The address range
  * may be any size provided it is within the physical boundaries.
@@ -712,6 +804,63 @@ static int stfsm_mtd_read(struct mtd_info *mtd, loff_t from, size_t len,
 	return 0;
 }
 
+/*
+ * Write an address range to the flash chip.  Data must be written in
+ * FLASH_PAGESIZE chunks.  The address range may be any size provided
+ * it is within the physical boundaries.
+ */
+static int stfsm_mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
+			   size_t *retlen, const u_char *buf)
+{
+	struct stfsm *fsm = dev_get_drvdata(mtd->dev.parent);
+
+	u32 page_offs;
+	u32 bytes;
+	uint8_t *b = (uint8_t *)buf;
+	int ret = 0;
+
+	dev_dbg(fsm->dev, "%s to 0x%08x, len %zd\n", __func__, (u32)to, len);
+
+	if (retlen)
+		*retlen = 0;
+
+	if (!len)
+		return 0;
+
+	if (to + len > mtd->size)
+		return -EINVAL;
+
+	/* Offset within page */
+	page_offs = to % FLASH_PAGESIZE;
+
+	mutex_lock(&fsm->lock);
+
+	while (len) {
+		/* Write up to page boundary */
+		bytes = min(FLASH_PAGESIZE - page_offs, len);
+
+		ret = stfsm_write(fsm, b, bytes, to);
+		if (ret)
+			goto out1;
+
+		b += bytes;
+		len -= bytes;
+		to += bytes;
+
+		/* We are now page-aligned */
+		page_offs = 0;
+
+		if (retlen)
+			*retlen += bytes;
+
+	}
+
+out1:
+	mutex_unlock(&fsm->lock);
+
+	return ret;
+}
+
 static void stfsm_read_jedec(struct stfsm *fsm, uint8_t *const jedec)
 {
 	const struct stfsm_seq *seq = &stfsm_seq_read_jedec;
@@ -981,6 +1130,7 @@ static int stfsm_probe(struct platform_device *pdev)
 	fsm->mtd.erasesize	= info->sector_size;
 
 	fsm->mtd._read  = stfsm_mtd_read;
+	fsm->mtd._write = stfsm_mtd_write;
 
 	dev_err(&pdev->dev,
 		"Found serial flash device: %s\n"
-- 
1.8.3.2

