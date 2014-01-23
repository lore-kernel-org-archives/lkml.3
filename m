Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbaAWKjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:39:39 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:53743 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbaAWKcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:32:22 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, computersforpeace@gmail.com,
        Angus.Clark@st.com, DCG_UPD_stlinux_kernel@list.st.com,
        olivier.clergeaud@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH RESEND v4 16/37] mtd: st_spi_fsm: Provide the erase one sector sequence
Date: Thu, 23 Jan 2014 10:31:04 +0000
Message-Id: <1390473085-24626-17-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
References: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FSM Serial Flash Controller is driven by issuing a standard set of
register writes we call a message sequence. This patch supplies a method
to prepare the message sequence responsible for erasing a single sector.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 94840b5..5ee6d08 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -425,6 +425,28 @@ static struct stfsm_seq stfsm_seq_read_jedec = {
 		    SEQ_CFG_STARTSEQ),
 };
 
+static struct stfsm_seq stfsm_seq_erase_sector = {
+	/* 'addr_cfg' configured during initialisation */
+	.seq_opc = {
+		(SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
+		 SEQ_OPC_OPCODE(FLASH_CMD_WREN) | SEQ_OPC_CSDEASSERT),
+
+		(SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
+		 SEQ_OPC_OPCODE(FLASH_CMD_SE)),
+	},
+	.seq = {
+		STFSM_INST_CMD1,
+		STFSM_INST_CMD2,
+		STFSM_INST_ADD1,
+		STFSM_INST_ADD2,
+		STFSM_INST_STOP,
+	},
+	.seq_cfg = (SEQ_CFG_PADS_1 |
+		    SEQ_CFG_READNOTWRITE |
+		    SEQ_CFG_CSDEASSERT |
+		    SEQ_CFG_STARTSEQ),
+};
+
 static inline int stfsm_is_idle(struct stfsm *fsm)
 {
 	return readl(fsm->base + SPI_FAST_SEQ_STA) & 0x10;
@@ -508,6 +530,19 @@ static void stfsm_read_fifo(struct stfsm *fsm, uint32_t *buf,
 	}
 }
 
+/* Configure 'addr_cfg' according to addressing mode */
+static void stfsm_prepare_erasesec_seq(struct stfsm *fsm,
+				       struct stfsm_seq *seq)
+{
+	int addr1_cycles = fsm->info->flags & FLASH_FLAG_32BIT_ADDR ? 16 : 8;
+
+	seq->addr_cfg = (ADR_CFG_CYCLES_ADD1(addr1_cycles) |
+			 ADR_CFG_PADS_1_ADD1 |
+			 ADR_CFG_CYCLES_ADD2(16) |
+			 ADR_CFG_PADS_1_ADD2 |
+			 ADR_CFG_CSDEASSERT_ADD2);
+}
+
 /* Search for preferred configuration based on available flags */
 static struct seq_rw_config *
 stfsm_search_seq_rw_configs(struct stfsm *fsm,
-- 
1.8.3.2

