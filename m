Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbaCTJZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:25:59 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44204 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533AbaCTJWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:22:15 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org, Angus.Clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 27/36] mtd: st_spi_fsm: Supply a busy wait for post-write status
Date: Thu, 20 Mar 2014 09:20:59 +0000
Message-Id: <1395307268-12721-28-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we write data to the Serial Flash chip we'll wait a predetermined
period of time before giving up. During that period of time we poll the
status register until completion.

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 221 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 221 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 58b8761..99e08b0 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -238,8 +238,18 @@
 #define FLASH_CMD_READ4_1_1_4  0x6c
 #define FLASH_CMD_READ4_1_4_4  0xec
 
+/* Status register */
+#define FLASH_STATUS_BUSY      0x01
+#define FLASH_STATUS_WEL       0x02
+#define FLASH_STATUS_BP0       0x04
+#define FLASH_STATUS_BP1       0x08
+#define FLASH_STATUS_BP2       0x10
+#define FLASH_STATUS_SRWP0     0x80
+#define FLASH_STATUS_TIMEOUT   0xff
+
 #define FLASH_PAGESIZE         256			/* In Bytes    */
 #define FLASH_PAGESIZE_32      (FLASH_PAGESIZE / 4)	/* In uint32_t */
+#define FLASH_MAX_BUSY_WAIT    (300 * HZ)	/* Maximum 'CHIPERASE' time */
 
 /*
  * Flags to tweak operation of default read/write/erase routines
@@ -519,6 +529,22 @@ static struct stfsm_seq stfsm_seq_read_jedec = {
 		    SEQ_CFG_STARTSEQ),
 };
 
+static struct stfsm_seq stfsm_seq_read_status_fifo = {
+	.data_size = TRANSFER_SIZE(4),
+	.seq_opc[0] = (SEQ_OPC_PADS_1 |
+		       SEQ_OPC_CYCLES(8) |
+		       SEQ_OPC_OPCODE(FLASH_CMD_RDSR)),
+	.seq = {
+		STFSM_INST_CMD1,
+		STFSM_INST_DATA_READ,
+		STFSM_INST_STOP,
+	},
+	.seq_cfg = (SEQ_CFG_PADS_1 |
+		    SEQ_CFG_READNOTWRITE |
+		    SEQ_CFG_CSDEASSERT |
+		    SEQ_CFG_STARTSEQ),
+};
+
 static struct stfsm_seq stfsm_seq_erase_sector = {
 	/* 'addr_cfg' configured during initialisation */
 	.seq_opc = {
@@ -699,6 +725,53 @@ static int stfsm_enter_32bit_addr(struct stfsm *fsm, int enter)
 	return 0;
 }
 
+static uint8_t stfsm_wait_busy(struct stfsm *fsm)
+{
+	struct stfsm_seq *seq = &stfsm_seq_read_status_fifo;
+	unsigned long deadline;
+	uint32_t status;
+	int timeout = 0;
+
+	/* Use RDRS1 */
+	seq->seq_opc[0] = (SEQ_OPC_PADS_1 |
+			   SEQ_OPC_CYCLES(8) |
+			   SEQ_OPC_OPCODE(FLASH_CMD_RDSR));
+
+	/* Load read_status sequence */
+	stfsm_load_seq(fsm, seq);
+
+	/*
+	 * Repeat until busy bit is deasserted, or timeout, or error (S25FLxxxS)
+	 */
+	deadline = jiffies + FLASH_MAX_BUSY_WAIT;
+	while (!timeout) {
+		cond_resched();
+
+		if (time_after_eq(jiffies, deadline))
+			timeout = 1;
+
+		stfsm_wait_seq(fsm);
+
+		stfsm_read_fifo(fsm, &status, 4);
+
+		if ((status & FLASH_STATUS_BUSY) == 0)
+			return 0;
+
+		if ((fsm->configuration & CFG_S25FL_CHECK_ERROR_FLAGS) &&
+		    ((status & S25FL_STATUS_P_ERR) ||
+		     (status & S25FL_STATUS_E_ERR)))
+			return (uint8_t)(status & 0xff);
+
+		if (!timeout)
+			/* Restart */
+			writel(seq->seq_cfg, fsm->base + SPI_FAST_SEQ_CFG);
+	}
+
+	dev_err(fsm->dev, "timeout on wait_busy\n");
+
+	return FLASH_STATUS_TIMEOUT;
+}
+
 static int stfsm_wrvcr(struct stfsm *fsm, uint8_t data)
 {
 	struct stfsm_seq *seq = &stfsm_seq_wrvcr;
@@ -1020,6 +1093,98 @@ static int stfsm_read(struct stfsm *fsm, uint8_t *buf, uint32_t size,
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
@@ -1052,6 +1217,61 @@ static int stfsm_mtd_read(struct mtd_info *mtd, loff_t from, size_t len,
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
+	*retlen = 0;
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
+		*retlen += bytes;
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
@@ -1308,6 +1528,7 @@ static int stfsm_probe(struct platform_device *pdev)
 	fsm->mtd.erasesize	= info->sector_size;
 
 	fsm->mtd._read  = stfsm_mtd_read;
+	fsm->mtd._write = stfsm_mtd_write;
 
 	dev_err(&pdev->dev,
 		"Found serial flash device: %s\n"
-- 
1.8.3.2

