Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbaBRPA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:00:26 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:43323 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345AbaBRO5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:57:42 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, DCG_UPD_stlinux_kernel@list.st.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        computersforpeace@gmail.com, Angus.Clark@st.com
Subject: [PATCH 28/35] mtd: st_spi_fsm: Erase partly or as a whole a Serial Flash device
Date: Tue, 18 Feb 2014 14:55:55 +0000
Message-Id: <1392735362-1245-29-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
References: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an erase is requested by userspace the MTD framework calls back
into the driver to conduct the actual command issue. Here we provide the
routines which do exactly that. We can choose to either do an entire chip
erase or by sector.

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 113 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 112 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 0eacfbf..a5e2c5a 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -567,6 +567,27 @@ static struct stfsm_seq stfsm_seq_erase_sector = {
 		    SEQ_CFG_STARTSEQ),
 };
 
+static struct stfsm_seq stfsm_seq_erase_chip = {
+	.seq_opc = {
+		(SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
+		 SEQ_OPC_OPCODE(FLASH_CMD_WREN) | SEQ_OPC_CSDEASSERT),
+
+		(SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
+		 SEQ_OPC_OPCODE(FLASH_CMD_CHIPERASE) | SEQ_OPC_CSDEASSERT),
+	},
+	.seq = {
+		STFSM_INST_CMD1,
+		STFSM_INST_CMD2,
+		STFSM_INST_WAIT,
+		STFSM_INST_STOP,
+	},
+	.seq_cfg = (SEQ_CFG_PADS_1 |
+		    SEQ_CFG_ERASE |
+		    SEQ_CFG_READNOTWRITE |
+		    SEQ_CFG_CSDEASSERT |
+		    SEQ_CFG_STARTSEQ),
+};
+
 static struct stfsm_seq stfsm_seq_wrvcr = {
 	.seq_opc[0] = (SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
 		       SEQ_OPC_OPCODE(FLASH_CMD_WREN) | SEQ_OPC_CSDEASSERT),
@@ -1218,6 +1239,47 @@ static int stfsm_mtd_read(struct mtd_info *mtd, loff_t from, size_t len,
 	return 0;
 }
 
+static int stfsm_erase_sector(struct stfsm *fsm, const uint32_t offset)
+{
+	struct stfsm_seq *seq = &stfsm_seq_erase_sector;
+	int ret;
+
+	dev_dbg(fsm->dev, "erasing sector at 0x%08x\n", offset);
+
+	/* Enter 32-bit address mode, if required */
+	if (fsm->configuration & CFG_ERASESEC_TOGGLE_32BIT_ADDR)
+		stfsm_enter_32bit_addr(fsm, 1);
+
+	seq->addr1 = (offset >> 16) & 0xffff;
+	seq->addr2 = offset & 0xffff;
+
+	stfsm_load_seq(fsm, seq);
+
+	stfsm_wait_seq(fsm);
+
+	/* Wait for completion */
+	ret = stfsm_wait_busy(fsm);
+
+	/* Exit 32-bit address mode, if required */
+	if (fsm->configuration & CFG_ERASESEC_TOGGLE_32BIT_ADDR)
+		stfsm_enter_32bit_addr(fsm, 0);
+
+	return ret;
+}
+
+static int stfsm_erase_chip(struct stfsm *fsm)
+{
+	const struct stfsm_seq *seq = &stfsm_seq_erase_chip;
+
+	dev_dbg(fsm->dev, "erasing chip\n");
+
+	stfsm_load_seq(fsm, seq);
+
+	stfsm_wait_seq(fsm);
+
+	return stfsm_wait_busy(fsm);
+}
+
 /*
  * Write an address range to the flash chip.  Data must be written in
  * FLASH_PAGESIZE chunks.  The address range may be any size provided
@@ -1275,6 +1337,54 @@ out1:
 	return ret;
 }
 
+/*
+ * Erase an address range on the flash chip. The address range may extend
+ * one or more erase sectors.  Return an error is there is a problem erasing.
+ */
+static int stfsm_mtd_erase(struct mtd_info *mtd, struct erase_info *instr)
+{
+	struct stfsm *fsm = dev_get_drvdata(mtd->dev.parent);
+	u32 addr, len;
+	int ret;
+
+	dev_dbg(fsm->dev, "%s at 0x%llx, len %lld\n", __func__,
+		(long long)instr->addr, (long long)instr->len);
+
+	addr = instr->addr;
+	len = instr->len;
+
+	mutex_lock(&fsm->lock);
+
+	/* Whole-chip erase? */
+	if (len == mtd->size) {
+		ret = stfsm_erase_chip(fsm);
+		if (ret)
+			goto out1;
+	} else {
+		while (len) {
+			ret = stfsm_erase_sector(fsm, addr);
+			if (ret)
+				goto out1;
+
+			addr += mtd->erasesize;
+			len -= mtd->erasesize;
+		}
+	}
+
+	mutex_unlock(&fsm->lock);
+
+	instr->state = MTD_ERASE_DONE;
+	mtd_erase_callback(instr);
+
+	return 0;
+
+out1:
+	instr->state = MTD_ERASE_FAILED;
+	mutex_unlock(&fsm->lock);
+
+	return ret;
+}
+
 static void stfsm_read_jedec(struct stfsm *fsm, uint8_t *const jedec)
 {
 	const struct stfsm_seq *seq = &stfsm_seq_read_jedec;
@@ -1533,8 +1643,9 @@ static int stfsm_probe(struct platform_device *pdev)
 
 	fsm->mtd._read  = stfsm_mtd_read;
 	fsm->mtd._write = stfsm_mtd_write;
+	fsm->mtd._erase = stfsm_mtd_erase;
 
-	dev_err(&pdev->dev,
+	dev_info(&pdev->dev,
 		"Found serial flash device: %s\n"
 		" size = %llx (%lldMiB) erasesize = 0x%08x (%uKiB)\n",
 		info->name,
-- 
1.8.3.2

