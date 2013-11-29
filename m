Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab3K2M1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:27:24 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:39334 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab3K2M1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:27:19 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Cc: linus.walleij@linaro.org, linux-mtd@lists.infradead.org,
        angus.clark@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v3 33/36] mtd: st_spi_fsm: Supply the MX25xxx chip specific configuration call-back
Date: Fri, 29 Nov 2013 12:19:22 +0000
Message-Id: <1385727565-25794-34-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 84 ++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/devices/st_spi_fsm.h |  4 +-
 2 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index f1276e5..be66a49 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -98,6 +98,31 @@ static struct seq_rw_config n25q_read4_configs[] = {
 	{0x00,			0,			0, 0, 0, 0x00, 0, 0},
 };
 
+/*
+ * [MX25xxx] Configuration
+ */
+#define MX25_STATUS_QE			(0x1 << 6)
+
+static int stfsm_mx25_en_32bit_addr_seq(struct stfsm_seq *seq)
+{
+	seq->seq_opc[0] = (SEQ_OPC_PADS_1 |
+			   SEQ_OPC_CYCLES(8) |
+			   SEQ_OPC_OPCODE(FLASH_CMD_EN4B_ADDR) |
+			   SEQ_OPC_CSDEASSERT);
+
+	seq->seq[0] = STFSM_INST_CMD1;
+	seq->seq[1] = STFSM_INST_WAIT;
+	seq->seq[2] = STFSM_INST_STOP;
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
 static struct stfsm_seq stfsm_seq_read; 	/* Dynamically populated */
 static struct stfsm_seq stfsm_seq_write;	/* Dynamically populated */
 static struct stfsm_seq stfsm_seq_en_32bit_addr;/* Dynamically populated */
@@ -620,6 +645,65 @@ static int stfsm_prepare_rwe_seqs_default(struct stfsm *fsm)
 	return 0;
 }
 
+static int stfsm_mx25_config(struct stfsm *fsm)
+{
+	uint32_t flags = fsm->info->flags;
+	uint32_t data_pads;
+	uint8_t sta;
+	int ret;
+	bool soc_reset;
+
+	/* Disable support for 'WRITE_1_4_4' (limited to 20MHz which is of
+	 * marginal benefit on our hardware and doesn't justify implementing
+	 * different READ/WRITE frequencies).
+	 */
+	flags &= ~FLASH_FLAG_WRITE_1_4_4;
+
+	/*
+	 * Use default READ/WRITE sequences
+	 */
+	ret = stfsm_prepare_rwe_seqs_default(fsm);
+	if (ret)
+		return ret;
+
+	/*
+	 * Configure 32-bit Address Support
+	 */
+	if (flags & FLASH_FLAG_32BIT_ADDR) {
+		/* Configure 'enter_32bitaddr' FSM sequence */
+		stfsm_mx25_en_32bit_addr_seq(&stfsm_seq_en_32bit_addr);
+
+		soc_reset = stfsm_can_handle_soc_reset(fsm);
+		if (soc_reset || !fsm->booted_from_spi) {
+			/* If we can handle SoC resets, we enable 32-bit address
+			 * mode pervasively */
+			stfsm_enter_32bit_addr(fsm, 1);
+
+		} else {
+			/* Else, enable/disable 32-bit addressing before/after
+			 * each operation */
+			fsm->configuration = (CFG_READ_TOGGLE_32BIT_ADDR |
+					      CFG_WRITE_TOGGLE_32BIT_ADDR |
+					      CFG_ERASESEC_TOGGLE_32BIT_ADDR);
+			/* It seems a small delay is required after exiting
+			 * 32-bit mode following a write operation.  The issue
+			 * is under investigation.
+			 */
+			fsm->configuration |= CFG_WRITE_EX_32BIT_ADDR_DELAY;
+		}
+	}
+
+	/* For QUAD mode, set 'QE' STATUS bit */
+	data_pads = ((stfsm_seq_read.seq_cfg >> 16) & 0x3) + 1;
+	if (data_pads == 4) {
+		stfsm_read_status(fsm, FLASH_CMD_RDSR, &sta);
+		sta |= MX25_STATUS_QE;
+		stfsm_write_status(fsm, sta, 1);
+	}
+
+	return 0;
+}
+
 static int stfsm_n25q_config(struct stfsm *fsm)
 {
 	uint32_t flags = fsm->info->flags;
diff --git a/drivers/mtd/devices/st_spi_fsm.h b/drivers/mtd/devices/st_spi_fsm.h
index 5143843..10c12ba 100644
--- a/drivers/mtd/devices/st_spi_fsm.h
+++ b/drivers/mtd/devices/st_spi_fsm.h
@@ -318,6 +318,7 @@ struct flash_info {
 };
 
 static int stfsm_n25q_config(struct stfsm *fsm);
+static int stfsm_mx25_config(struct stfsm *fsm);
 
 static struct flash_info flash_types[] = {
 	/*
@@ -350,7 +351,8 @@ static struct flash_info flash_types[] = {
 		   FLASH_FLAG_SE_4K		| \
 		   FLASH_FLAG_SE_32K)
 	{ "mx25l25635e", 0xc22019, 0, 64*1024, 512,
-	  (MX25_FLAG | FLASH_FLAG_32BIT_ADDR | FLASH_FLAG_RESET), 70, NULL },
+	  (MX25_FLAG | FLASH_FLAG_32BIT_ADDR | FLASH_FLAG_RESET), 70,
+	  stfsm_mx25_config },
 
 #define N25Q_FLAG (FLASH_FLAG_READ_WRITE	| \
 		   FLASH_FLAG_READ_FAST		| \
-- 
1.8.3.2

