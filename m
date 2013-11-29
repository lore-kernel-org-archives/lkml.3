Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab3K2MVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:21:36 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:58007 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab3K2MUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:20:42 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Cc: linus.walleij@linaro.org, linux-mtd@lists.infradead.org,
        angus.clark@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v3 34/36] mtd: st_spi_fsm: Supply the S25FLxxx chip specific configuration call-back
Date: Fri, 29 Nov 2013 12:19:23 +0000
Message-Id: <1385727565-25794-35-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows us to prepare some of the message sequences which will
be required to talk to the  S25FLxxx family of Serial Flash devices. It
also allows us to do some required extra operations after any busy wait
failures.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 245 +++++++++++++++++++++++++++++++++++++++
 drivers/mtd/devices/st_spi_fsm.h |  26 ++++-
 2 files changed, 265 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index be66a49..d31348a 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -123,6 +123,33 @@ static int stfsm_mx25_en_32bit_addr_seq(struct stfsm_seq *seq)
 	return 0;
 }
 
+/*
+ * [S25FLxxx] Configuration
+ */
+#define STFSM_S25FL_CONFIG_QE		(0x1 << 1)
+
+/*
+ * S25FLxxxS devices provide three ways of supporting 32-bit addressing: Bank
+ * Register, Extended Address Modes, and a 32-bit address command set.  The
+ * 32-bit address command set is used here, since it avoids any problems with
+ * entering a state that is incompatible with the SPIBoot Controller.
+ */
+static struct seq_rw_config stfsm_s25fl_read4_configs[] = {
+	{FLASH_FLAG_READ_1_4_4,  FLASH_CMD_READ4_1_4_4,  0, 4, 4, 0x00, 2, 4},
+	{FLASH_FLAG_READ_1_1_4,  FLASH_CMD_READ4_1_1_4,  0, 1, 4, 0x00, 0, 8},
+	{FLASH_FLAG_READ_1_2_2,  FLASH_CMD_READ4_1_2_2,  0, 2, 2, 0x00, 4, 0},
+	{FLASH_FLAG_READ_1_1_2,  FLASH_CMD_READ4_1_1_2,  0, 1, 2, 0x00, 0, 8},
+	{FLASH_FLAG_READ_FAST,   FLASH_CMD_READ4_FAST,   0, 1, 1, 0x00, 0, 8},
+	{FLASH_FLAG_READ_WRITE,  FLASH_CMD_READ4,        0, 1, 1, 0x00, 0, 0},
+	{0x00,                   0,                      0, 0, 0, 0x00, 0, 0},
+};
+
+static struct seq_rw_config stfsm_s25fl_write4_configs[] = {
+	{FLASH_FLAG_WRITE_1_1_4, S25FL_CMD_WRITE4_1_1_4, 1, 1, 4, 0x00, 0, 0},
+	{FLASH_FLAG_READ_WRITE,  S25FL_CMD_WRITE4,       1, 1, 1, 0x00, 0, 0},
+	{0x00,                   0,                      0, 0, 0, 0x00, 0, 0},
+};
+
 static struct stfsm_seq stfsm_seq_read; 	/* Dynamically populated */
 static struct stfsm_seq stfsm_seq_write;	/* Dynamically populated */
 static struct stfsm_seq stfsm_seq_en_32bit_addr;/* Dynamically populated */
@@ -397,6 +424,11 @@ static uint8_t stfsm_wait_busy(struct stfsm *fsm)
 		if ((status & FLASH_STATUS_BUSY) == 0)
 			return 0;
 
+		if ((fsm->configuration & CFG_S25FL_CHECK_ERROR_FLAGS) &&
+		    ((status & S25FL_STATUS_P_ERR) ||
+		     (status & S25FL_STATUS_E_ERR)))
+			return (uint8_t)(status & 0xff);
+
 		/* Restart */
 		writel(seq->seq_cfg, fsm->base + SPI_FAST_SEQ_CFG);
 
@@ -769,6 +801,215 @@ static int stfsm_n25q_config(struct stfsm *fsm)
 	return 0;
 }
 
+static void stfsm_s25fl_prepare_erasesec_seq_32(struct stfsm_seq *seq)
+{
+	seq->seq_opc[1] = (SEQ_OPC_PADS_1 |
+			   SEQ_OPC_CYCLES(8) |
+			   SEQ_OPC_OPCODE(S25FL_CMD_SE4));
+
+	seq->addr_cfg = (ADR_CFG_CYCLES_ADD1(16) |
+			 ADR_CFG_PADS_1_ADD1 |
+			 ADR_CFG_CYCLES_ADD2(16) |
+			 ADR_CFG_PADS_1_ADD2 |
+			 ADR_CFG_CSDEASSERT_ADD2);
+}
+
+static void stfsm_s25fl_read_dyb(struct stfsm *fsm, uint32_t offs, uint8_t *dby)
+{
+	uint32_t tmp;
+	struct stfsm_seq seq = {
+		.data_size = TRANSFER_SIZE(4),
+		.seq_opc[0] = (SEQ_OPC_PADS_1 |
+			       SEQ_OPC_CYCLES(8) |
+			       SEQ_OPC_OPCODE(S25FL_CMD_DYBRD)),
+		.addr_cfg = (ADR_CFG_CYCLES_ADD1(16) |
+			     ADR_CFG_PADS_1_ADD1 |
+			     ADR_CFG_CYCLES_ADD2(16) |
+			     ADR_CFG_PADS_1_ADD2),
+		.addr1 = (offs >> 16) & 0xffff,
+		.addr2 = offs & 0xffff,
+		.seq = {
+			STFSM_INST_CMD1,
+			STFSM_INST_ADD1,
+			STFSM_INST_ADD2,
+			STFSM_INST_DATA_READ,
+			STFSM_INST_STOP,
+		},
+		.seq_cfg = (SEQ_CFG_PADS_1 |
+			    SEQ_CFG_READNOTWRITE |
+			    SEQ_CFG_CSDEASSERT |
+			    SEQ_CFG_STARTSEQ),
+	};
+
+	stfsm_load_seq(fsm, &seq);
+
+	stfsm_read_fifo(fsm, &tmp, 4);
+
+	*dby = (uint8_t)(tmp >> 24);
+
+	stfsm_wait_seq(fsm);
+}
+
+static void stfsm_s25fl_write_dyb(struct stfsm *fsm, uint32_t offs, uint8_t dby)
+{
+	struct stfsm_seq seq = {
+		.seq_opc[0] = (SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
+			       SEQ_OPC_OPCODE(FLASH_CMD_WREN) |
+			       SEQ_OPC_CSDEASSERT),
+		.seq_opc[1] = (SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
+			       SEQ_OPC_OPCODE(S25FL_CMD_DYBWR)),
+		.addr_cfg = (ADR_CFG_CYCLES_ADD1(16) |
+			     ADR_CFG_PADS_1_ADD1 |
+			     ADR_CFG_CYCLES_ADD2(16) |
+			     ADR_CFG_PADS_1_ADD2),
+		.status = (uint32_t)dby | STA_PADS_1 | STA_CSDEASSERT,
+		.addr1 = (offs >> 16) & 0xffff,
+		.addr2 = offs & 0xffff,
+		.seq = {
+			STFSM_INST_CMD1,
+			STFSM_INST_CMD2,
+			STFSM_INST_ADD1,
+			STFSM_INST_ADD2,
+			STFSM_INST_STA_WR1,
+			STFSM_INST_STOP,
+		},
+		.seq_cfg = (SEQ_CFG_PADS_1 |
+			    SEQ_CFG_READNOTWRITE |
+			    SEQ_CFG_CSDEASSERT |
+			    SEQ_CFG_STARTSEQ),
+	};
+
+	stfsm_load_seq(fsm, &seq);
+	stfsm_wait_seq(fsm);
+
+	stfsm_wait_busy(fsm);
+}
+
+static int stfsm_s25fl_clear_status_reg(struct stfsm *fsm)
+{
+	struct stfsm_seq seq = {
+		.seq_opc[0] = (SEQ_OPC_PADS_1 |
+			       SEQ_OPC_CYCLES(8) |
+			       SEQ_OPC_OPCODE(S25FL_CMD_CLSR) |
+			       SEQ_OPC_CSDEASSERT),
+		.seq_opc[1] = (SEQ_OPC_PADS_1 |
+			       SEQ_OPC_CYCLES(8) |
+			       SEQ_OPC_OPCODE(FLASH_CMD_WRDI) |
+			       SEQ_OPC_CSDEASSERT),
+		.seq = {
+			STFSM_INST_CMD1,
+			STFSM_INST_CMD2,
+			STFSM_INST_WAIT,
+			STFSM_INST_STOP,
+		},
+		.seq_cfg = (SEQ_CFG_PADS_1 |
+			    SEQ_CFG_ERASE |
+			    SEQ_CFG_READNOTWRITE |
+			    SEQ_CFG_CSDEASSERT |
+			    SEQ_CFG_STARTSEQ),
+	};
+
+	stfsm_load_seq(fsm, &seq);
+
+	stfsm_wait_seq(fsm);
+
+	return 0;
+}
+
+static int stfsm_s25fl_config(struct stfsm *fsm)
+{
+	struct flash_info *info = fsm->info;
+	uint32_t flags = info->flags;
+	uint32_t data_pads;
+	uint32_t offs;
+	uint16_t sta_wr;
+	uint8_t sr1, cr1, dyb;
+	int ret;
+
+	if (flags & FLASH_FLAG_32BIT_ADDR) {
+		/*
+		 * Prepare Read/Write/Erase sequences according to S25FLxxx
+		 * 32-bit address command set
+		 */
+		ret = stfsm_search_prepare_rw_seq(fsm, &stfsm_seq_read,
+						  stfsm_s25fl_read4_configs);
+		if (ret)
+			return ret;
+
+		ret = stfsm_search_prepare_rw_seq(fsm, &stfsm_seq_write,
+						  stfsm_s25fl_write4_configs);
+		if (ret)
+			return ret;
+
+		stfsm_s25fl_prepare_erasesec_seq_32(&stfsm_seq_erase_sector);
+
+	} else {
+		/* Use default configurations for 24-bit addressing */
+		ret = stfsm_prepare_rwe_seqs_default(fsm);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * For devices that support 'DYB' sector locking, check lock status and
+	 * unlock sectors if necessary (some variants power-on with sectors
+	 * locked by default)
+	 */
+	if (flags & FLASH_FLAG_DYB_LOCKING) {
+		offs = 0;
+		for (offs = 0; offs < info->sector_size * info->n_sectors;) {
+			stfsm_s25fl_read_dyb(fsm, offs, &dyb);
+			if (dyb == 0x00)
+				stfsm_s25fl_write_dyb(fsm, offs, 0xff);
+
+			/* Handle bottom/top 4KiB parameter sectors */
+			if ((offs < info->sector_size * 2) ||
+			    (offs >= (info->sector_size - info->n_sectors * 4)))
+				offs += 0x1000;
+			else
+				offs += 0x10000;
+		}
+	}
+
+	/* Check status of 'QE' bit */
+	data_pads = ((stfsm_seq_read.seq_cfg >> 16) & 0x3) + 1;
+	stfsm_read_status(fsm, FLASH_CMD_RDSR2, &cr1);
+	if (data_pads == 4) {
+		if (!(cr1 & STFSM_S25FL_CONFIG_QE)) {
+			/* Set 'QE' */
+			cr1 |= STFSM_S25FL_CONFIG_QE;
+
+			stfsm_read_status(fsm, FLASH_CMD_RDSR, &sr1);
+			sta_wr = ((uint16_t)cr1  << 8) | sr1;
+
+			stfsm_write_status(fsm, sta_wr, 2);
+
+			stfsm_wait_busy(fsm);
+		}
+	} else {
+		if ((cr1 & STFSM_S25FL_CONFIG_QE)) {
+			/* Clear 'QE' */
+			cr1 &= ~STFSM_S25FL_CONFIG_QE;
+
+			stfsm_read_status(fsm, FLASH_CMD_RDSR, &sr1);
+			sta_wr = ((uint16_t)cr1  << 8) | sr1;
+
+			stfsm_write_status(fsm, sta_wr, 2);
+
+			stfsm_wait_busy(fsm);
+		}
+
+	}
+
+	/*
+	 * S25FLxxx devices support Program and Error error flags.
+	 * Configure driver to check flags and clear if necessary.
+	 */
+	fsm->configuration |= CFG_S25FL_CHECK_ERROR_FLAGS;
+
+	return 0;
+}
+
 static int stfsm_read(struct stfsm *fsm, uint8_t *const buf,
 		      const uint32_t size, const uint32_t offset)
 {
@@ -911,6 +1152,8 @@ static int stfsm_write(struct stfsm *fsm, const uint8_t *const buf,
 
 	/* Wait for completion */
 	ret = stfsm_wait_busy(fsm);
+	if (ret && fsm->configuration & CFG_S25FL_CHECK_ERROR_FLAGS)
+		stfsm_s25fl_clear_status_reg(fsm);
 
 	/* Exit 32-bit address mode, if required */
 	if (fsm->configuration & CFG_WRITE_TOGGLE_32BIT_ADDR) {
@@ -989,6 +1232,8 @@ static int stfsm_erase_sector(struct stfsm *fsm, const uint32_t offset)
 
 	/* Wait for completion */
 	ret = stfsm_wait_busy(fsm);
+	if (ret && fsm->configuration & CFG_S25FL_CHECK_ERROR_FLAGS)
+		stfsm_s25fl_clear_status_reg(fsm);
 
 	/* Exit 32-bit address mode, if required */
 	if (fsm->configuration & CFG_ERASESEC_TOGGLE_32BIT_ADDR)
diff --git a/drivers/mtd/devices/st_spi_fsm.h b/drivers/mtd/devices/st_spi_fsm.h
index 10c12ba..83b30f9 100644
--- a/drivers/mtd/devices/st_spi_fsm.h
+++ b/drivers/mtd/devices/st_spi_fsm.h
@@ -229,6 +229,16 @@
 #define FLASH_CMD_READ4_1_1_4	0x6c
 #define FLASH_CMD_READ4_1_4_4	0xec
 
+/* S25FLxxxS commands */
+#define S25FL_CMD_WRITE4_1_1_4	0x34
+#define S25FL_CMD_SE4		0xdc
+#define S25FL_CMD_CLSR		0x30
+#define S25FL_CMD_DYBWR		0xe1
+#define S25FL_CMD_DYBRD		0xe0
+#define S25FL_CMD_WRITE4	0x12	/* Note, opcode clashes with
+					 * 'FLASH_CMD_WRITE_1_4_4'
+					 * as found on N25Qxxx devices! */
+
 /* Status register */
 #define FLASH_STATUS_BUSY	0x01
 #define FLASH_STATUS_WEL	0x02
@@ -237,6 +247,9 @@
 #define FLASH_STATUS_BP2	0x10
 #define FLASH_STATUS_SRWP0	0x80
 #define FLASH_STATUS_TIMEOUT	0xff
+/* S25FL Error Flags */
+#define S25FL_STATUS_E_ERR	0x20
+#define S25FL_STATUS_P_ERR	0x40
 
 #define FLASH_PAGESIZE		256			/* In Bytes    */
 #define FLASH_PAGESIZE_32	FLASH_PAGESIZE / 4	/* In uint32_t */
@@ -319,6 +332,7 @@ struct flash_info {
 
 static int stfsm_n25q_config(struct stfsm *fsm);
 static int stfsm_mx25_config(struct stfsm *fsm);
+static int stfsm_s25fl_config(struct stfsm *fsm);
 
 static struct flash_info flash_types[] = {
 	/*
@@ -381,9 +395,9 @@ static struct flash_info flash_types[] = {
 			FLASH_FLAG_WRITE_1_1_4	| \
 			FLASH_FLAG_READ_FAST)
 	{ "s25fl129p0", 0x012018, 0x4d00, 256 * 1024,  64, S25FLXXXP_FLAG, 80,
-	  NULL },
+	  stfsm_s25fl_config },
 	{ "s25fl129p1", 0x012018, 0x4d01,  64 * 1024, 256, S25FLXXXP_FLAG, 80,
-	  NULL },
+	  stfsm_s25fl_config },
 
 	/*
 	 * Spansion S25FLxxxS
@@ -398,13 +412,13 @@ static struct flash_info flash_types[] = {
 			FLASH_FLAG_RESET	| \
 			FLASH_FLAG_DYB_LOCKING)
 	{ "s25fl128s0", 0x012018, 0x0300,  256 * 1024, 64, S25FLXXXS_FLAG, 80,
-	  NULL },
+	  stfsm_s25fl_config },
 	{ "s25fl128s1", 0x012018, 0x0301,  64 * 1024, 256, S25FLXXXS_FLAG, 80,
-	  NULL },
+	  stfsm_s25fl_config },
 	{ "s25fl256s0", 0x010219, 0x4d00, 256 * 1024, 128,
-	  S25FLXXXS_FLAG | FLASH_FLAG_32BIT_ADDR, 80, NULL },
+	  S25FLXXXS_FLAG | FLASH_FLAG_32BIT_ADDR, 80, stfsm_s25fl_config },
 	{ "s25fl256s1", 0x010219, 0x4d01,  64 * 1024, 512,
-	  S25FLXXXS_FLAG | FLASH_FLAG_32BIT_ADDR, 80, NULL },
+	  S25FLXXXS_FLAG | FLASH_FLAG_32BIT_ADDR, 80, stfsm_s25fl_config },
 
 	/* Winbond -- w25x "blocks" are 64K, "sectors" are 4KiB */
 #define W25X_FLAG (FLASH_FLAG_READ_WRITE	| \
-- 
1.8.3.2

