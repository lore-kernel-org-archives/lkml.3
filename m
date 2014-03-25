Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbaCYItW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:49:22 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60983 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaCYIUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:20:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 19/47] mtd: nand: stm_nand_bch: configure BCH read/write/erase programs
Date: Tue, 25 Mar 2014 08:19:36 +0000
Message-Id: <1395735604-26706-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tune BCH programs according to device found and ECC mode.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 121 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 365a73b..351f5e2 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -97,6 +97,124 @@ struct nandi_controller {
 	struct nandi_info	info;		/* NAND device info */
 };
 
+/* BCH 'program' structure */
+struct bch_prog {
+	u32	multi_cs_addr[3];
+	u32	multi_cs_config;
+	u8	seq[16];
+	u32	addr;
+	u32	extra;
+	u8	cmd[4];
+	u32	reserved1;
+	u32	gen_cfg;
+	u32	delay;
+	u32	reserved2;
+	u32	seq_cfg;
+};
+
+/* BCH template programs (modified on-the-fly) */
+static struct bch_prog bch_prog_read_page = {
+	.cmd = {
+		NAND_CMD_READ0,
+		NAND_CMD_READSTART,
+	},
+	.seq = {
+		BCH_ECC_SCORE(0),
+		BCH_CMD_ADDR,
+		BCH_CL_CMD_1,
+		BCH_DATA_2_SECTOR,
+		BCH_STOP,
+	},
+	.gen_cfg = (GEN_CFG_DATA_8_NOT_16 |
+		    GEN_CFG_EXTRA_ADD_CYCLE |
+		    GEN_CFG_LAST_SEQ_NODE),
+	.seq_cfg = SEQ_CFG_GO_STOP,
+};
+
+static struct bch_prog bch_prog_write_page = {
+	.cmd = {
+		NAND_CMD_SEQIN,
+		NAND_CMD_PAGEPROG,
+		NAND_CMD_STATUS,
+	},
+	.seq = {
+		BCH_CMD_ADDR,
+		BCH_DATA_4_SECTOR,
+		BCH_CL_CMD_1,
+		BCH_CL_CMD_2,
+		BCH_OP_ERR,
+		BCH_STOP,
+	},
+	.gen_cfg = (GEN_CFG_DATA_8_NOT_16 |
+		    GEN_CFG_EXTRA_ADD_CYCLE |
+		    GEN_CFG_LAST_SEQ_NODE),
+	.seq_cfg = (SEQ_CFG_GO_STOP |
+		    SEQ_CFG_DATA_WRITE),
+};
+
+static struct bch_prog bch_prog_erase_block = {
+	.seq = {
+		BCH_CL_CMD_1,
+		BCH_AL_EX_0,
+		BCH_AL_EX_1,
+		BCH_AL_EX_2,
+		BCH_CL_CMD_2,
+		BCH_CL_CMD_3,
+		BCH_OP_ERR,
+		BCH_STOP,
+	},
+	.cmd = {
+		NAND_CMD_ERASE1,
+		NAND_CMD_ERASE1,
+		NAND_CMD_ERASE2,
+		NAND_CMD_STATUS,
+	},
+	.gen_cfg = (GEN_CFG_DATA_8_NOT_16 |
+		    GEN_CFG_EXTRA_ADD_CYCLE |
+		    GEN_CFG_LAST_SEQ_NODE),
+	.seq_cfg = (SEQ_CFG_GO_STOP |
+		    SEQ_CFG_ERASE),
+};
+
+/* Configure BCH read/write/erase programs */
+static void bch_configure_progs(struct nandi_controller *nandi)
+{
+	uint8_t data_opa = ffs(nandi->sectors_per_page) - 1;
+	uint8_t data_instr = BCH_INSTR(BCH_OPC_DATA, data_opa);
+	uint32_t gen_cfg_ecc = nandi->bch_ecc_mode << GEN_CFG_ECC_SHIFT;
+
+	/* Set 'DATA' instruction */
+	bch_prog_read_page.seq[3] = data_instr;
+	bch_prog_write_page.seq[1] = data_instr;
+
+	/* Set ECC mode */
+	bch_prog_read_page.gen_cfg |= gen_cfg_ecc;
+	bch_prog_write_page.gen_cfg |= gen_cfg_ecc;
+	bch_prog_erase_block.gen_cfg |= gen_cfg_ecc;
+
+	/*
+	 * Template sequences above are defined for devices that use 5 address
+	 * cycles for page Read/Write operations (and 3 for Erase operations).
+	 * Update sequences for devices that use 4 address cycles.
+	 */
+	if (!nandi->extra_addr) {
+		/* Clear 'GEN_CFG_EXTRA_ADD_CYCLE' flag */
+		bch_prog_read_page.gen_cfg &= ~GEN_CFG_EXTRA_ADD_CYCLE;
+		bch_prog_write_page.gen_cfg &= ~GEN_CFG_EXTRA_ADD_CYCLE;
+		bch_prog_erase_block.gen_cfg &= ~GEN_CFG_EXTRA_ADD_CYCLE;
+
+		/* Configure Erase sequence for 2 address cycles */
+		/* (page address) */
+		bch_prog_erase_block.seq[0] = BCH_CL_CMD_1;
+		bch_prog_erase_block.seq[1] = BCH_AL_EX_0;
+		bch_prog_erase_block.seq[2] = BCH_AL_EX_1;
+		bch_prog_erase_block.seq[3] = BCH_CL_CMD_2;
+		bch_prog_erase_block.seq[4] = BCH_CL_CMD_3;
+		bch_prog_erase_block.seq[5] = BCH_OP_ERR;
+		bch_prog_erase_block.seq[6] = BCH_STOP;
+	}
+}
+
 /*
  * NANDi Interrupts (shared by Hamming and BCH controllers)
  */
@@ -869,6 +987,9 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	/* Tune BCH programs according to device found and ECC mode */
+	bch_configure_progs(nandi);
+
 	return 0;
 }
 
-- 
1.8.3.2

