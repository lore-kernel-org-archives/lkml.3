Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab3K2MUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:20:43 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:47598 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab3K2MUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:20:38 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Cc: linus.walleij@linaro.org, linux-mtd@lists.infradead.org,
        angus.clark@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v3 32/36] mtd: st_spi_fsm: Add the ability to write to FSM's status register
Date: Fri, 29 Nov 2013 12:19:21 +0000
Message-Id: <1385727565-25794-33-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 1d6bd94..f1276e5 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -177,6 +177,23 @@ static struct stfsm_seq stfsm_seq_erase_chip = {
 		    SEQ_CFG_STARTSEQ),
 };
 
+static struct stfsm_seq stfsm_seq_write_status = {
+	.seq_opc[0] = (SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
+		       SEQ_OPC_OPCODE(FLASH_CMD_WREN) | SEQ_OPC_CSDEASSERT),
+	.seq_opc[1] = (SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
+		       SEQ_OPC_OPCODE(FLASH_CMD_WRSR)),
+	.seq = {
+		STFSM_INST_CMD1,
+		STFSM_INST_CMD2,
+		STFSM_INST_STA_WR1,
+		STFSM_INST_STOP,
+	},
+	.seq_cfg = (SEQ_CFG_PADS_1 |
+		    SEQ_CFG_READNOTWRITE |
+		    SEQ_CFG_CSDEASSERT |
+		    SEQ_CFG_STARTSEQ),
+};
+
 static struct stfsm_seq stfsm_seq_wrvcr = {
 	.seq_opc[0] = (SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
 		       SEQ_OPC_OPCODE(FLASH_CMD_WREN) | SEQ_OPC_CSDEASSERT),
@@ -389,6 +406,25 @@ static int stfsm_read_status(struct stfsm *fsm, uint8_t cmd,
 	return 0;
 }
 
+static int stfsm_write_status(struct stfsm *fsm, uint16_t status,
+			       int sta_bytes)
+{
+	struct stfsm_seq *seq = &stfsm_seq_write_status;
+
+	dev_dbg(fsm->dev, "writing STA[%s] 0x%04x\n",
+		(sta_bytes == 1) ? "1" : "1+2", status);
+
+	seq->status = (uint32_t)status | STA_PADS_1 | STA_CSDEASSERT;
+	seq->seq[2] = (sta_bytes == 1) ?
+		STFSM_INST_STA_WR1 : STFSM_INST_STA_WR1_2;
+
+	stfsm_load_seq(fsm, seq);
+
+	stfsm_wait_seq(fsm);
+
+	return 0;
+};
+
 static int stfsm_wrvcr(struct stfsm *fsm, uint8_t data)
 {
 	struct stfsm_seq *seq = &stfsm_seq_wrvcr;
-- 
1.8.3.2

