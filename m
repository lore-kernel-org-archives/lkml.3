Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbaBRO5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:57:06 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:47966 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbaBRO5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:57:00 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, DCG_UPD_stlinux_kernel@list.st.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        computersforpeace@gmail.com, Angus.Clark@st.com
Subject: [PATCH 12/35] mtd: st_spi_fsm: Prepare the read/write FSM message sequence(s)
Date: Tue, 18 Feb 2014 14:55:39 +0000
Message-Id: <1392735362-1245-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
References: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FSM Serial Flash Controller is driven by issuing a standard set of
register writes we call a message sequence. This patch supplies a method
to prepare read/write FSM message sequence(s) based on chip capability
and configuration.

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 69 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 1d7a13a0..2cbed4b 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -489,6 +489,75 @@ stfsm_search_seq_rw_configs(struct stfsm *fsm,
 	return NULL;
 }
 
+/* Prepare a READ/WRITE sequence according to configuration parameters */
+static void stfsm_prepare_rw_seq(struct stfsm *fsm,
+				 struct stfsm_seq *seq,
+				 struct seq_rw_config *cfg)
+{
+	int addr1_cycles, addr2_cycles;
+	int i = 0;
+
+	memset(seq, 0, sizeof(*seq));
+
+	/* Add READ/WRITE OPC  */
+	seq->seq_opc[i++] = (SEQ_OPC_PADS_1 |
+			     SEQ_OPC_CYCLES(8) |
+			     SEQ_OPC_OPCODE(cfg->cmd));
+
+	/* Add WREN OPC for a WRITE sequence */
+	if (cfg->write)
+		seq->seq_opc[i++] = (SEQ_OPC_PADS_1 |
+				     SEQ_OPC_CYCLES(8) |
+				     SEQ_OPC_OPCODE(FLASH_CMD_WREN) |
+				     SEQ_OPC_CSDEASSERT);
+
+	/* Address configuration (24 or 32-bit addresses) */
+	addr1_cycles  = (fsm->info->flags & FLASH_FLAG_32BIT_ADDR) ? 16 : 8;
+	addr1_cycles /= cfg->addr_pads;
+	addr2_cycles  = 16 / cfg->addr_pads;
+	seq->addr_cfg = ((addr1_cycles & 0x3f) << 0 |	/* ADD1 cycles */
+			 (cfg->addr_pads - 1) << 6 |	/* ADD1 pads */
+			 (addr2_cycles & 0x3f) << 16 |	/* ADD2 cycles */
+			 ((cfg->addr_pads - 1) << 22));	/* ADD2 pads */
+
+	/* Data/Sequence configuration */
+	seq->seq_cfg = ((cfg->data_pads - 1) << 16 |
+			SEQ_CFG_STARTSEQ |
+			SEQ_CFG_CSDEASSERT);
+	if (!cfg->write)
+		seq->seq_cfg |= SEQ_CFG_READNOTWRITE;
+
+	/* Mode configuration (no. of pads taken from addr cfg) */
+	seq->mode = ((cfg->mode_data & 0xff) << 0 |	/* data */
+		     (cfg->mode_cycles & 0x3f) << 16 |	/* cycles */
+		     (cfg->addr_pads - 1) << 22);	/* pads */
+
+	/* Dummy configuration (no. of pads taken from addr cfg) */
+	seq->dummy = ((cfg->dummy_cycles & 0x3f) << 16 |	/* cycles */
+		      (cfg->addr_pads - 1) << 22);		/* pads */
+
+
+	/* Instruction sequence */
+	i = 0;
+	if (cfg->write)
+		seq->seq[i++] = STFSM_INST_CMD2;
+
+	seq->seq[i++] = STFSM_INST_CMD1;
+
+	seq->seq[i++] = STFSM_INST_ADD1;
+	seq->seq[i++] = STFSM_INST_ADD2;
+
+	if (cfg->mode_cycles)
+		seq->seq[i++] = STFSM_INST_MODE;
+
+	if (cfg->dummy_cycles)
+		seq->seq[i++] = STFSM_INST_DUMMY;
+
+	seq->seq[i++] =
+		cfg->write ? STFSM_INST_DATA_WRITE : STFSM_INST_DATA_READ;
+	seq->seq[i++] = STFSM_INST_STOP;
+}
+
 static void stfsm_read_jedec(struct stfsm *fsm, uint8_t *const jedec)
 {
 	const struct stfsm_seq *seq = &stfsm_seq_read_jedec;
-- 
1.8.3.2

