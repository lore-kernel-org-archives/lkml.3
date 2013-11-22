Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab3KVQYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:24:12 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58268 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab3KVQYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:24:09 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org, angus.clark@st.com
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 17/23] mtd: st_spi_fsm: Provide the sequence for enabling 32bit addressing mode
Date: Fri, 22 Nov 2013 16:22:54 +0000
Message-Id: <1385137380-28968-18-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385137380-28968-1-git-send-email-lee.jones@linaro.org>
References: <1385137380-28968-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FSM Serial Flash Controller is driven by issuing a standard set of
register writes we call a message sequence. This patch supplies a method
to prepare the message sequence responsible for setting 32bit addressing
mode on the Flash chip.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 583a0ab..a56fb98 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -66,6 +66,28 @@ static struct stfsm_seq stfsm_seq_erase_sector = {
 		    SEQ_CFG_STARTSEQ),
 };
 
+static int stfsm_n25q_prepare_en_32bit_addr_seq(struct stfsm_seq *seq)
+{
+	seq->seq_opc[0] = (SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
+			   SEQ_OPC_OPCODE(FLASH_CMD_EN4B_ADDR));
+	seq->seq_opc[1] = (SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
+			   SEQ_OPC_OPCODE(FLASH_CMD_WREN) |
+			   SEQ_OPC_CSDEASSERT);
+
+	seq->seq[0] = STFSM_INST_CMD2;
+	seq->seq[1] = STFSM_INST_CMD1;
+	seq->seq[2] = STFSM_INST_WAIT;
+	seq->seq[3] = STFSM_INST_STOP;
+
+	seq->seq_cfg = (SEQ_CFG_PADS_1 |
+			SEQ_CFG_ERASE |
+			SEQ_CFG_READNOTWRITE |
+			SEQ_CFG_CSDEASSERT |
+			SEQ_CFG_STARTSEQ);
+
+	return 0;
+}
+
 static inline int stfsm_is_idle(struct stfsm *fsm)
 {
 	return readl(fsm->base + SPI_FAST_SEQ_STA) & 0x10;
-- 
1.8.1.2

