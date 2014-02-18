Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbaBRO65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:58:57 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37694 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbaBRO5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:57:55 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, DCG_UPD_stlinux_kernel@list.st.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        computersforpeace@gmail.com, Angus.Clark@st.com
Subject: [PATCH 33/35] mtd: st_spi_fsm: Supply the W25Qxxx chip specific configuration call-back
Date: Tue, 18 Feb 2014 14:56:00 +0000
Message-Id: <1392735362-1245-34-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
References: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 47 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index b6f395c..211adf1 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -341,6 +341,7 @@ struct flash_info {
 static int stfsm_n25q_config(struct stfsm *fsm);
 static int stfsm_mx25_config(struct stfsm *fsm);
 static int stfsm_s25fl_config(struct stfsm *fsm);
+static int stfsm_w25q_config(struct stfsm *fsm);
 
 static struct flash_info flash_types[] = {
 	/*
@@ -446,10 +447,14 @@ static struct flash_info flash_types[] = {
 		   FLASH_FLAG_READ_1_1_4        |	\
 		   FLASH_FLAG_READ_1_4_4        |	\
 		   FLASH_FLAG_WRITE_1_1_4)
-	{ "w25q80",  0xef4014, 0,  64 * 1024,  16, W25Q_FLAG, 80, NULL },
-	{ "w25q16",  0xef4015, 0,  64 * 1024,  32, W25Q_FLAG, 80, NULL },
-	{ "w25q32",  0xef4016, 0,  64 * 1024,  64, W25Q_FLAG, 80, NULL },
-	{ "w25q64",  0xef4017, 0,  64 * 1024, 128, W25Q_FLAG, 80, NULL },
+	{ "w25q80",  0xef4014, 0,  64 * 1024,  16, W25Q_FLAG, 80,
+	  stfsm_w25q_config },
+	{ "w25q16",  0xef4015, 0,  64 * 1024,  32, W25Q_FLAG, 80,
+	  stfsm_w25q_config },
+	{ "w25q32",  0xef4016, 0,  64 * 1024,  64, W25Q_FLAG, 80,
+	  stfsm_w25q_config },
+	{ "w25q64",  0xef4017, 0,  64 * 1024, 128, W25Q_FLAG, 80,
+	  stfsm_w25q_config },
 
 	/* Sentinel */
 	{ NULL, 0x000000, 0, 0, 0, 0, 0, NULL },
@@ -577,6 +582,11 @@ static struct seq_rw_config stfsm_s25fl_write4_configs[] = {
 	{0x00,                   0,                      0, 0, 0, 0x00, 0, 0},
 };
 
+/*
+ * [W25Qxxx] Configuration
+ */
+#define W25Q_STATUS_QE			(0x1 << 9)
+
 static struct stfsm_seq stfsm_seq_read;		/* Dynamically populated */
 static struct stfsm_seq stfsm_seq_write;	/* Dynamically populated */
 static struct stfsm_seq stfsm_seq_en_32bit_addr;/* Dynamically populated */
@@ -1443,6 +1453,35 @@ static int stfsm_s25fl_config(struct stfsm *fsm)
 	return 0;
 }
 
+static int stfsm_w25q_config(struct stfsm *fsm)
+{
+	uint32_t data_pads;
+	uint16_t sta_wr;
+	uint8_t sta1, sta2;
+	int ret;
+
+	ret = stfsm_prepare_rwe_seqs_default(fsm);
+	if (ret)
+		return ret;
+
+	/* If using QUAD mode, set QE STATUS bit */
+	data_pads = ((stfsm_seq_read.seq_cfg >> 16) & 0x3) + 1;
+	if (data_pads == 4) {
+		stfsm_read_status(fsm, FLASH_CMD_RDSR, &sta1);
+		stfsm_read_status(fsm, FLASH_CMD_RDSR2, &sta2);
+
+		sta_wr = ((uint16_t)sta2 << 8) | sta1;
+
+		sta_wr |= W25Q_STATUS_QE;
+
+		stfsm_write_status(fsm, sta_wr, 2);
+
+		stfsm_wait_busy(fsm);
+	}
+
+	return 0;
+}
+
 static int stfsm_read(struct stfsm *fsm, uint8_t *buf, uint32_t size,
 		      uint32_t offset)
 {
-- 
1.8.3.2

