Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbaCZQkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:40:06 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:50842 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbaCZQj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:39:58 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, angus.clark@st.com
Subject: [PATCH 04/15] mtd: st_spi_fsm: Refactor status register operations
Date: Wed, 26 Mar 2014 16:39:18 +0000
Message-Id: <1395851969-13520-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395851969-13520-1-git-send-email-lee.jones@linaro.org>
References: <1395851969-13520-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Angus Clark <angus.clark@st.com>

This patch refactors the fsm_read_status() and fsm_write_status() code to
support 1 or 2 byte operations, with a specified command.  This allows us to
remove device/register specific code, such as the N25Q fsm_wrvcr() function.

The 'QE' configuration code is updated accordingly, with minor tweaks to ensure
the register values are only written if actually required.  One notable change
in this area is that the 'W25Q_STATUS_QE' bit-field is now defined with respect
to the 'SR2' register, rather than the combined 'SR1+SR2' register which is only
used for write operations.

Signed-off-by: Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 152 ++++++++++++++++++---------------------
 1 file changed, 68 insertions(+), 84 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index fabba2c..d6b352e 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -212,8 +212,6 @@
 #define FLASH_CMD_SE_32K       0x52
 #define FLASH_CMD_SE           0xd8
 #define FLASH_CMD_CHIPERASE    0xc7
-#define FLASH_CMD_WRVCR                0x81
-#define FLASH_CMD_RDVCR                0x85
 
 #define FLASH_CMD_READ         0x03    /* READ */
 #define FLASH_CMD_READ_FAST    0x0b    /* FAST READ */
@@ -261,6 +259,12 @@
 #define S25FL_STATUS_E_ERR     0x20
 #define S25FL_STATUS_P_ERR     0x40
 
+#define N25Q_CMD_WRVCR         0x81
+#define N25Q_CMD_RDVCR         0x85
+#define N25Q_CMD_RDVECR        0x65
+#define N25Q_CMD_RDNVCR        0xb5
+#define N25Q_CMD_WRNVCR        0xb1
+
 #define FLASH_PAGESIZE         256			/* In Bytes    */
 #define FLASH_PAGESIZE_32      (FLASH_PAGESIZE / 4)	/* In uint32_t */
 #define FLASH_MAX_BUSY_WAIT    (300 * HZ)	/* Maximum 'CHIPERASE' time */
@@ -592,7 +596,7 @@ static struct seq_rw_config stfsm_s25fl_write4_configs[] = {
 /*
  * [W25Qxxx] Configuration
  */
-#define W25Q_STATUS_QE			(0x1 << 9)
+#define W25Q_STATUS_QE			(0x1 << 1)
 
 static struct stfsm_seq stfsm_seq_read_jedec = {
 	.data_size = TRANSFER_SIZE(8),
@@ -686,23 +690,6 @@ static struct stfsm_seq stfsm_seq_write_status = {
 		    SEQ_CFG_STARTSEQ),
 };
 
-static struct stfsm_seq stfsm_seq_wrvcr = {
-	.seq_opc[0] = (SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
-		       SEQ_OPC_OPCODE(FLASH_CMD_WREN) | SEQ_OPC_CSDEASSERT),
-	.seq_opc[1] = (SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
-		       SEQ_OPC_OPCODE(FLASH_CMD_WRVCR)),
-	.seq = {
-		STFSM_INST_CMD1,
-		STFSM_INST_CMD2,
-		STFSM_INST_STA_WR1,
-		STFSM_INST_STOP,
-	},
-	.seq_cfg = (SEQ_CFG_PADS_1 |
-		    SEQ_CFG_READNOTWRITE |
-		    SEQ_CFG_CSDEASSERT |
-		    SEQ_CFG_STARTSEQ),
-};
-
 static int stfsm_n25q_en_32bit_addr_seq(struct stfsm_seq *seq)
 {
 	seq->seq_opc[0] = (SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
@@ -890,60 +877,57 @@ static uint8_t stfsm_wait_busy(struct stfsm *fsm)
 }
 
 static int stfsm_read_status(struct stfsm *fsm, uint8_t cmd,
-			   uint8_t *status)
+			     uint8_t *data, int bytes)
 {
 	struct stfsm_seq *seq = &stfsm_seq_read_status_fifo;
 	uint32_t tmp;
+	uint8_t *t = (uint8_t *)&tmp;
+	int i;
 
-	dev_dbg(fsm->dev, "reading STA[%s]\n",
-		(cmd == FLASH_CMD_RDSR) ? "1" : "2");
+	dev_dbg(fsm->dev, "read 'status' register [0x%02x], %d byte(s)\n",
+		cmd, bytes);
 
-	seq->seq_opc[0] = (SEQ_OPC_PADS_1 |
-			   SEQ_OPC_CYCLES(8) |
+	BUG_ON(bytes != 1 && bytes != 2);
+
+	seq->seq_opc[0] = (SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
 			   SEQ_OPC_OPCODE(cmd)),
 
 	stfsm_load_seq(fsm, seq);
 
 	stfsm_read_fifo(fsm, &tmp, 4);
 
-	*status = (uint8_t)(tmp >> 24);
+	for (i = 0; i < bytes; i++)
+		data[i] = t[i];
 
 	stfsm_wait_seq(fsm);
 
 	return 0;
 }
 
-static int stfsm_write_status(struct stfsm *fsm, uint16_t status,
-			       int sta_bytes)
+static int stfsm_write_status(struct stfsm *fsm, uint8_t cmd,
+			    uint16_t data, int bytes, int wait_busy)
 {
 	struct stfsm_seq *seq = &stfsm_seq_write_status;
 
-	dev_dbg(fsm->dev, "writing STA[%s] 0x%04x\n",
-		(sta_bytes == 1) ? "1" : "1+2", status);
-
-	seq->status = (uint32_t)status | STA_PADS_1 | STA_CSDEASSERT;
-	seq->seq[2] = (sta_bytes == 1) ?
-		STFSM_INST_STA_WR1 : STFSM_INST_STA_WR1_2;
-
-	stfsm_load_seq(fsm, seq);
-
-	stfsm_wait_seq(fsm);
-
-	return 0;
-};
+	dev_dbg(fsm->dev,
+		"write 'status' register [0x%02x], %d byte(s), 0x%04x\n"
+		" %s wait-busy\n", cmd, bytes, data, wait_busy ? "with" : "no");
 
-static int stfsm_wrvcr(struct stfsm *fsm, uint8_t data)
-{
-	struct stfsm_seq *seq = &stfsm_seq_wrvcr;
+	BUG_ON(bytes != 1 && bytes != 2);
 
-	dev_dbg(fsm->dev, "writing VCR 0x%02x\n", data);
+	seq->seq_opc[1] = (SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
+			   SEQ_OPC_OPCODE(cmd));
 
-	seq->status = (STA_DATA_BYTE1(data) | STA_PADS_1 | STA_CSDEASSERT);
+	seq->status = (uint32_t)data | STA_PADS_1 | STA_CSDEASSERT;
+	seq->seq[2] = (bytes == 1) ? STFSM_INST_STA_WR1 : STFSM_INST_STA_WR1_2;
 
 	stfsm_load_seq(fsm, seq);
 
 	stfsm_wait_seq(fsm);
 
+	if (wait_busy)
+		stfsm_wait_busy(fsm);
+
 	return 0;
 }
 
@@ -1163,26 +1147,22 @@ static int stfsm_mx25_config(struct stfsm *fsm)
 					      CFG_ERASESEC_TOGGLE_32BIT_ADDR);
 	}
 
-	/* Check status of 'QE' bit */
-	stfsm_read_status(fsm, FLASH_CMD_RDSR, &sta);
+	/* Check status of 'QE' bit, update if required. */
+	stfsm_read_status(fsm, FLASH_CMD_RDSR, &sta, 1);
 	data_pads = ((fsm->stfsm_seq_read.seq_cfg >> 16) & 0x3) + 1;
 	if (data_pads == 4) {
 		if (!(sta & MX25_STATUS_QE)) {
 			/* Set 'QE' */
 			sta |= MX25_STATUS_QE;
 
-			stfsm_write_status(fsm, sta, 1);
-
-			stfsm_wait_busy(fsm);
+			stfsm_write_status(fsm, FLASH_CMD_WRSR, sta, 1, 1);
 		}
 	} else {
 		if (sta & MX25_STATUS_QE) {
 			/* Clear 'QE' */
 			sta &= ~MX25_STATUS_QE;
 
-			stfsm_write_status(fsm, sta, 1);
-
-			stfsm_wait_busy(fsm);
+			stfsm_write_status(fsm, FLASH_CMD_WRSR, sta, 1, 1);
 		}
 	}
 
@@ -1249,7 +1229,7 @@ static int stfsm_n25q_config(struct stfsm *fsm)
 	 */
 	vcr = (N25Q_VCR_DUMMY_CYCLES(8) | N25Q_VCR_XIP_DISABLED |
 	       N25Q_VCR_WRAP_CONT);
-	stfsm_wrvcr(fsm, vcr);
+	stfsm_write_status(fsm, N25Q_CMD_WRVCR, vcr, 1, 0);
 
 	return 0;
 }
@@ -1377,6 +1357,7 @@ static int stfsm_s25fl_config(struct stfsm *fsm)
 	uint32_t offs;
 	uint16_t sta_wr;
 	uint8_t sr1, cr1, dyb;
+	int update_sr = 0;
 	int ret;
 
 	if (flags & FLASH_FLAG_32BIT_ADDR) {
@@ -1424,34 +1405,28 @@ static int stfsm_s25fl_config(struct stfsm *fsm)
 		}
 	}
 
-	/* Check status of 'QE' bit */
+	/* Check status of 'QE' bit, update if required. */
+	stfsm_read_status(fsm, FLASH_CMD_RDSR2, &cr1, 1);
 	data_pads = ((fsm->stfsm_seq_read.seq_cfg >> 16) & 0x3) + 1;
-	stfsm_read_status(fsm, FLASH_CMD_RDSR2, &cr1);
 	if (data_pads == 4) {
 		if (!(cr1 & STFSM_S25FL_CONFIG_QE)) {
 			/* Set 'QE' */
 			cr1 |= STFSM_S25FL_CONFIG_QE;
 
-			stfsm_read_status(fsm, FLASH_CMD_RDSR, &sr1);
-			sta_wr = ((uint16_t)cr1  << 8) | sr1;
-
-			stfsm_write_status(fsm, sta_wr, 2);
-
-			stfsm_wait_busy(fsm);
+			update_sr = 1;
 		}
 	} else {
-		if ((cr1 & STFSM_S25FL_CONFIG_QE)) {
+		if (cr1 & STFSM_S25FL_CONFIG_QE) {
 			/* Clear 'QE' */
 			cr1 &= ~STFSM_S25FL_CONFIG_QE;
 
-			stfsm_read_status(fsm, FLASH_CMD_RDSR, &sr1);
-			sta_wr = ((uint16_t)cr1  << 8) | sr1;
-
-			stfsm_write_status(fsm, sta_wr, 2);
-
-			stfsm_wait_busy(fsm);
+			update_sr = 1;
 		}
-
+	}
+	if (update_sr) {
+		stfsm_read_status(fsm, FLASH_CMD_RDSR, &sr1, 1);
+		sta_wr = ((uint16_t)cr1  << 8) | sr1;
+		stfsm_write_status(fsm, FLASH_CMD_WRSR, sta_wr, 2, 1);
 	}
 
 	/*
@@ -1466,27 +1441,36 @@ static int stfsm_s25fl_config(struct stfsm *fsm)
 static int stfsm_w25q_config(struct stfsm *fsm)
 {
 	uint32_t data_pads;
-	uint16_t sta_wr;
-	uint8_t sta1, sta2;
+	uint8_t sr1, sr2;
+	uint16_t sr_wr;
+	int update_sr = 0;
 	int ret;
 
 	ret = stfsm_prepare_rwe_seqs_default(fsm);
 	if (ret)
 		return ret;
 
-	/* If using QUAD mode, set QE STATUS bit */
+	/* Check status of 'QE' bit, update if required. */
+	stfsm_read_status(fsm, FLASH_CMD_RDSR2, &sr2, 1);
 	data_pads = ((fsm->stfsm_seq_read.seq_cfg >> 16) & 0x3) + 1;
 	if (data_pads == 4) {
-		stfsm_read_status(fsm, FLASH_CMD_RDSR, &sta1);
-		stfsm_read_status(fsm, FLASH_CMD_RDSR2, &sta2);
-
-		sta_wr = ((uint16_t)sta2 << 8) | sta1;
-
-		sta_wr |= W25Q_STATUS_QE;
-
-		stfsm_write_status(fsm, sta_wr, 2);
-
-		stfsm_wait_busy(fsm);
+		if (!(sr2 & W25Q_STATUS_QE)) {
+			/* Set 'QE' */
+			sr2 |= W25Q_STATUS_QE;
+			update_sr = 1;
+		}
+	} else {
+		if (sr2 & W25Q_STATUS_QE) {
+			/* Clear 'QE' */
+			sr2 &= ~W25Q_STATUS_QE;
+			update_sr = 1;
+		}
+	}
+	if (update_sr) {
+		/* Write status register */
+		stfsm_read_status(fsm, FLASH_CMD_RDSR, &sr1, 1);
+		sr_wr = ((uint16_t)sr2 << 8) | sr1;
+		stfsm_write_status(fsm, FLASH_CMD_WRSR, sr_wr, 2, 1);
 	}
 
 	return 0;
-- 
1.8.3.2

