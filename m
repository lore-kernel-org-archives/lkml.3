Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbaCTJXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:23:45 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:48085 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672AbaCTJWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:22:31 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org, Angus.Clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 34/36] mtd: st_spi_fsm: Move runtime configurable msg sequences into device's struct
Date: Thu, 20 Mar 2014 09:21:06 +0000
Message-Id: <1395307268-12721-35-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now the dynamically configurable message sequences for read, write
and enable 32bit addressing have been global. Brian makes a good point
why this should not be the case. If there are ever two FSM's located on
the same platform, we could be potentially introducing a race condition
on "needlessly shared data".

Suggested-by: Brian Norris <computersforpeace@gmail.com>
Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 64 ++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index dc9412a..dccbac0 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -273,6 +273,19 @@
 #define CFG_ERASESEC_TOGGLE_32BIT_ADDR 0x00000008
 #define CFG_S25FL_CHECK_ERROR_FLAGS    0x00000010
 
+struct stfsm_seq {
+	uint32_t data_size;
+	uint32_t addr1;
+	uint32_t addr2;
+	uint32_t addr_cfg;
+	uint32_t seq_opc[5];
+	uint32_t mode;
+	uint32_t dummy;
+	uint32_t status;
+	uint8_t  seq[16];
+	uint32_t seq_cfg;
+} __packed __aligned(4);
+
 struct stfsm {
 	struct device		*dev;
 	void __iomem		*base;
@@ -286,20 +299,11 @@ struct stfsm {
 	bool                    booted_from_spi;
 	bool                    reset_signal;
 	bool                    reset_por;
-};
 
-struct stfsm_seq {
-	uint32_t data_size;
-	uint32_t addr1;
-	uint32_t addr2;
-	uint32_t addr_cfg;
-	uint32_t seq_opc[5];
-	uint32_t mode;
-	uint32_t dummy;
-	uint32_t status;
-	uint8_t  seq[16];
-	uint32_t seq_cfg;
-} __packed __aligned(4);
+	struct stfsm_seq stfsm_seq_read;
+	struct stfsm_seq stfsm_seq_write;
+	struct stfsm_seq stfsm_seq_en_32bit_addr;
+};
 
 /* Parameters to configure a READ or WRITE FSM sequence */
 struct seq_rw_config {
@@ -587,10 +591,6 @@ static struct seq_rw_config stfsm_s25fl_write4_configs[] = {
  */
 #define W25Q_STATUS_QE			(0x1 << 9)
 
-static struct stfsm_seq stfsm_seq_read;		/* Dynamically populated */
-static struct stfsm_seq stfsm_seq_write;	/* Dynamically populated */
-static struct stfsm_seq stfsm_seq_en_32bit_addr;/* Dynamically populated */
-
 static struct stfsm_seq stfsm_seq_read_jedec = {
 	.data_size = TRANSFER_SIZE(8),
 	.seq_opc[0] = (SEQ_OPC_PADS_1 |
@@ -826,7 +826,7 @@ static int stfsm_write_fifo(struct stfsm *fsm,
 
 static int stfsm_enter_32bit_addr(struct stfsm *fsm, int enter)
 {
-	struct stfsm_seq *seq = &stfsm_seq_en_32bit_addr;
+	struct stfsm_seq *seq = &fsm->stfsm_seq_en_32bit_addr;
 	uint32_t cmd = enter ? FLASH_CMD_EN4B_ADDR : FLASH_CMD_EX4B_ADDR;
 
 	seq->seq_opc[0] = (SEQ_OPC_PADS_1 |
@@ -1101,7 +1101,7 @@ static int stfsm_prepare_rwe_seqs_default(struct stfsm *fsm)
 	int ret;
 
 	/* Configure 'READ' sequence */
-	ret = stfsm_search_prepare_rw_seq(fsm, &stfsm_seq_read,
+	ret = stfsm_search_prepare_rw_seq(fsm, &fsm->stfsm_seq_read,
 					  default_read_configs);
 	if (ret) {
 		dev_err(fsm->dev,
@@ -1111,7 +1111,7 @@ static int stfsm_prepare_rwe_seqs_default(struct stfsm *fsm)
 	}
 
 	/* Configure 'WRITE' sequence */
-	ret = stfsm_search_prepare_rw_seq(fsm, &stfsm_seq_write,
+	ret = stfsm_search_prepare_rw_seq(fsm, &fsm->stfsm_seq_write,
 					  default_write_configs);
 	if (ret) {
 		dev_err(fsm->dev,
@@ -1146,7 +1146,7 @@ static int stfsm_mx25_config(struct stfsm *fsm)
 	 */
 	if (flags & FLASH_FLAG_32BIT_ADDR) {
 		/* Configure 'enter_32bitaddr' FSM sequence */
-		stfsm_mx25_en_32bit_addr_seq(&stfsm_seq_en_32bit_addr);
+		stfsm_mx25_en_32bit_addr_seq(&fsm->stfsm_seq_en_32bit_addr);
 
 		soc_reset = stfsm_can_handle_soc_reset(fsm);
 		if (soc_reset || !fsm->booted_from_spi) {
@@ -1169,7 +1169,7 @@ static int stfsm_mx25_config(struct stfsm *fsm)
 	}
 
 	/* For QUAD mode, set 'QE' STATUS bit */
-	data_pads = ((stfsm_seq_read.seq_cfg >> 16) & 0x3) + 1;
+	data_pads = ((fsm->stfsm_seq_read.seq_cfg >> 16) & 0x3) + 1;
 	if (data_pads == 4) {
 		stfsm_read_status(fsm, FLASH_CMD_RDSR, &sta);
 		sta |= MX25_STATUS_QE;
@@ -1188,10 +1188,10 @@ static int stfsm_n25q_config(struct stfsm *fsm)
 
 	/* Configure 'READ' sequence */
 	if (flags & FLASH_FLAG_32BIT_ADDR)
-		ret = stfsm_search_prepare_rw_seq(fsm, &stfsm_seq_read,
+		ret = stfsm_search_prepare_rw_seq(fsm, &fsm->stfsm_seq_read,
 						  n25q_read4_configs);
 	else
-		ret = stfsm_search_prepare_rw_seq(fsm, &stfsm_seq_read,
+		ret = stfsm_search_prepare_rw_seq(fsm, &fsm->stfsm_seq_read,
 						  n25q_read3_configs);
 	if (ret) {
 		dev_err(fsm->dev,
@@ -1201,7 +1201,7 @@ static int stfsm_n25q_config(struct stfsm *fsm)
 	}
 
 	/* Configure 'WRITE' sequence (default configs) */
-	ret = stfsm_search_prepare_rw_seq(fsm, &stfsm_seq_write,
+	ret = stfsm_search_prepare_rw_seq(fsm, &fsm->stfsm_seq_write,
 					  default_write_configs);
 	if (ret) {
 		dev_err(fsm->dev,
@@ -1215,7 +1215,7 @@ static int stfsm_n25q_config(struct stfsm *fsm)
 
 	/* Configure 32-bit address support */
 	if (flags & FLASH_FLAG_32BIT_ADDR) {
-		stfsm_n25q_en_32bit_addr_seq(&stfsm_seq_en_32bit_addr);
+		stfsm_n25q_en_32bit_addr_seq(&fsm->stfsm_seq_en_32bit_addr);
 
 		soc_reset = stfsm_can_handle_soc_reset(fsm);
 		if (soc_reset || !fsm->booted_from_spi) {
@@ -1374,12 +1374,12 @@ static int stfsm_s25fl_config(struct stfsm *fsm)
 		 * Prepare Read/Write/Erase sequences according to S25FLxxx
 		 * 32-bit address command set
 		 */
-		ret = stfsm_search_prepare_rw_seq(fsm, &stfsm_seq_read,
+		ret = stfsm_search_prepare_rw_seq(fsm, &fsm->stfsm_seq_read,
 						  stfsm_s25fl_read4_configs);
 		if (ret)
 			return ret;
 
-		ret = stfsm_search_prepare_rw_seq(fsm, &stfsm_seq_write,
+		ret = stfsm_search_prepare_rw_seq(fsm, &fsm->stfsm_seq_write,
 						  stfsm_s25fl_write4_configs);
 		if (ret)
 			return ret;
@@ -1415,7 +1415,7 @@ static int stfsm_s25fl_config(struct stfsm *fsm)
 	}
 
 	/* Check status of 'QE' bit */
-	data_pads = ((stfsm_seq_read.seq_cfg >> 16) & 0x3) + 1;
+	data_pads = ((fsm->stfsm_seq_read.seq_cfg >> 16) & 0x3) + 1;
 	stfsm_read_status(fsm, FLASH_CMD_RDSR2, &cr1);
 	if (data_pads == 4) {
 		if (!(cr1 & STFSM_S25FL_CONFIG_QE)) {
@@ -1465,7 +1465,7 @@ static int stfsm_w25q_config(struct stfsm *fsm)
 		return ret;
 
 	/* If using QUAD mode, set QE STATUS bit */
-	data_pads = ((stfsm_seq_read.seq_cfg >> 16) & 0x3) + 1;
+	data_pads = ((fsm->stfsm_seq_read.seq_cfg >> 16) & 0x3) + 1;
 	if (data_pads == 4) {
 		stfsm_read_status(fsm, FLASH_CMD_RDSR, &sta1);
 		stfsm_read_status(fsm, FLASH_CMD_RDSR2, &sta2);
@@ -1485,7 +1485,7 @@ static int stfsm_w25q_config(struct stfsm *fsm)
 static int stfsm_read(struct stfsm *fsm, uint8_t *buf, uint32_t size,
 		      uint32_t offset)
 {
-	struct stfsm_seq *seq = &stfsm_seq_read;
+	struct stfsm_seq *seq = &fsm->stfsm_seq_read;
 	uint32_t data_pads;
 	uint32_t read_mask;
 	uint32_t size_ub;
@@ -1546,7 +1546,7 @@ static int stfsm_read(struct stfsm *fsm, uint8_t *buf, uint32_t size,
 static int stfsm_write(struct stfsm *fsm, const uint8_t *const buf,
 		       const uint32_t size, const uint32_t offset)
 {
-	struct stfsm_seq *seq = &stfsm_seq_write;
+	struct stfsm_seq *seq = &fsm->stfsm_seq_write;
 	uint32_t data_pads;
 	uint32_t write_mask;
 	uint32_t size_ub;
-- 
1.8.3.2

