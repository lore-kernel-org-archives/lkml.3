Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbaCTJWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:22:34 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33725 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757661AbaCTJWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:22:24 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org, Angus.Clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 31/36] mtd: st_spi_fsm: Supply the MX25xxx chip specific configuration call-back
Date: Thu, 20 Mar 2014 09:21:03 +0000
Message-Id: <1395307268-12721-32-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 82 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 81 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 0eb2c09..89d5e0b 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -326,6 +326,7 @@ struct flash_info {
 };
 
 static int stfsm_n25q_config(struct stfsm *fsm);
+static int stfsm_mx25_config(struct stfsm *fsm);
 
 static struct flash_info flash_types[] = {
 	/*
@@ -357,7 +358,8 @@ static struct flash_info flash_types[] = {
 		   FLASH_FLAG_SE_4K             |	\
 		   FLASH_FLAG_SE_32K)
 	{ "mx25l25635e", 0xc22019, 0, 64*1024, 512,
-	  (MX25_FLAG | FLASH_FLAG_32BIT_ADDR | FLASH_FLAG_RESET), 70, NULL }
+	  (MX25_FLAG | FLASH_FLAG_32BIT_ADDR | FLASH_FLAG_RESET), 70,
+	  stfsm_mx25_config },
 
 #define N25Q_FLAG (FLASH_FLAG_READ_WRITE       |	\
 		   FLASH_FLAG_READ_FAST         |	\
@@ -509,6 +511,31 @@ static struct seq_rw_config n25q_read4_configs[] = {
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
 static struct stfsm_seq stfsm_seq_read;		/* Dynamically populated */
 static struct stfsm_seq stfsm_seq_write;	/* Dynamically populated */
 static struct stfsm_seq stfsm_seq_en_32bit_addr;/* Dynamically populated */
@@ -1048,6 +1075,59 @@ static int stfsm_prepare_rwe_seqs_default(struct stfsm *fsm)
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
-- 
1.8.3.2

