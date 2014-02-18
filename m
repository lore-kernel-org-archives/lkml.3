Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbaBRO5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:57:30 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:49217 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258AbaBRO5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:57:21 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, DCG_UPD_stlinux_kernel@list.st.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        computersforpeace@gmail.com, Angus.Clark@st.com
Subject: [PATCH 20/35] mtd: st_spi_fsm: Update the flash Volatile Configuration Register
Date: Tue, 18 Feb 2014 14:55:47 +0000
Message-Id: <1392735362-1245-21-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
References: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FSM Serial Flash Controller is driven by issuing a standard set of
register writes we call a message sequence. This patch supplies a method
to prepare the message sequence responsible for updating a chip's VCR.

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index e20f4cb..208b6c3 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -415,6 +415,23 @@ static struct stfsm_seq stfsm_seq_erase_sector = {
 		    SEQ_CFG_STARTSEQ),
 };
 
+static struct stfsm_seq stfsm_seq_wrvcr = {
+	.seq_opc[0] = (SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
+		       SEQ_OPC_OPCODE(FLASH_CMD_WREN) | SEQ_OPC_CSDEASSERT),
+	.seq_opc[1] = (SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
+		       SEQ_OPC_OPCODE(FLASH_CMD_WRVCR)),
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
 static int stfsm_n25q_en_32bit_addr_seq(struct stfsm_seq *seq)
 {
 	seq->seq_opc[0] = (SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
@@ -542,6 +559,21 @@ static int stfsm_enter_32bit_addr(struct stfsm *fsm, int enter)
 	return 0;
 }
 
+static int stfsm_wrvcr(struct stfsm *fsm, uint8_t data)
+{
+	struct stfsm_seq *seq = &stfsm_seq_wrvcr;
+
+	dev_dbg(fsm->dev, "writing VCR 0x%02x\n", data);
+
+	seq->status = (STA_DATA_BYTE1(data) | STA_PADS_1 | STA_CSDEASSERT);
+
+	stfsm_load_seq(fsm, seq);
+
+	stfsm_wait_seq(fsm);
+
+	return 0;
+}
+
 /*
  * SoC reset on 'boot-from-spi' systems
  *
-- 
1.8.3.2

