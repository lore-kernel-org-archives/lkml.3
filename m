Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbaCTJV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:21:56 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:39466 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234AbaCTJVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:21:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org, Angus.Clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 16/36] mtd: st_spi_fsm: Provide the sequence for enabling 32bit addressing mode
Date: Thu, 20 Mar 2014 09:20:48 +0000
Message-Id: <1395307268-12721-17-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FSM Serial Flash Controller is driven by issuing a standard set of
register writes we call a message sequence. This patch supplies a method
to prepare the message sequence responsible for setting 32bit addressing
mode on the Flash chip.

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 06e6a52..9d1edf0 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -411,6 +411,28 @@ static struct stfsm_seq stfsm_seq_erase_sector = {
 		    SEQ_CFG_STARTSEQ),
 };
 
+static int stfsm_n25q_en_32bit_addr_seq(struct stfsm_seq *seq)
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
1.8.3.2

