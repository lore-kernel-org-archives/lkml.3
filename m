Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab3K2MWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:22:41 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:56403 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab3K2MU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:20:29 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Cc: linus.walleij@linaro.org, linux-mtd@lists.infradead.org,
        angus.clark@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v3 28/36] mtd: st_spi_fsm: Supply a busy wait for post-write status
Date: Fri, 29 Nov 2013 12:19:17 +0000
Message-Id: <1385727565-25794-29-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we write data to the Serial Flash chip we'll wait a predetermined
period of time before giving up. During that period of time we poll the
status register until completion.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 52 ++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/devices/st_spi_fsm.h | 10 ++++++++
 2 files changed, 62 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index c08805f..d8fc97b 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -118,6 +118,22 @@ static struct stfsm_seq stfsm_seq_read_jedec = {
 		    SEQ_CFG_STARTSEQ),
 };
 
+static struct stfsm_seq stfsm_seq_read_status_fifo = {
+	.data_size = TRANSFER_SIZE(4),
+	.seq_opc[0] = (SEQ_OPC_PADS_1 |
+		       SEQ_OPC_CYCLES(8) |
+		       SEQ_OPC_OPCODE(FLASH_CMD_RDSR)),
+	.seq = {
+		STFSM_INST_CMD1,
+		STFSM_INST_DATA_READ,
+		STFSM_INST_STOP,
+	},
+	.seq_cfg = (SEQ_CFG_PADS_1 |
+		    SEQ_CFG_READNOTWRITE |
+		    SEQ_CFG_CSDEASSERT |
+		    SEQ_CFG_STARTSEQ),
+};
+
 static struct stfsm_seq stfsm_seq_erase_sector = {
 	/* 'addr_cfg' configured during initialisation */
 	.seq_opc = {
@@ -292,6 +308,42 @@ static int stfsm_enter_32bit_addr(struct stfsm *fsm, int enter)
 	return 0;
 }
 
+static uint8_t stfsm_wait_busy(struct stfsm *fsm)
+{
+	struct stfsm_seq *seq = &stfsm_seq_read_status_fifo;
+	unsigned long deadline;
+	uint32_t status;
+
+	/* Use RDRS1 */
+	seq->seq_opc[0] = (SEQ_OPC_PADS_1 |
+			   SEQ_OPC_CYCLES(8) |
+			   SEQ_OPC_OPCODE(FLASH_CMD_RDSR));
+
+	/* Load read_status sequence */
+	stfsm_load_seq(fsm, seq);
+
+	/* Repeat until busy bit is deasserted, or timeout */
+	deadline = jiffies + FLASH_MAX_BUSY_WAIT;
+	do {
+		cond_resched();
+
+		stfsm_wait_seq(fsm);
+
+		stfsm_read_fifo(fsm, &status, 4);
+
+		if ((status & FLASH_STATUS_BUSY) == 0)
+			return 0;
+
+		/* Restart */
+		writel(seq->seq_cfg, fsm->base + SPI_FAST_SEQ_CFG);
+
+	} while (!time_after_eq(jiffies, deadline));
+
+	dev_err(fsm->dev, "timeout on wait_busy\n");
+
+	return -EIO;
+}
+
 static int stfsm_wrvcr(struct stfsm *fsm, uint8_t data)
 {
 	struct stfsm_seq *seq = &stfsm_seq_wrvcr;
diff --git a/drivers/mtd/devices/st_spi_fsm.h b/drivers/mtd/devices/st_spi_fsm.h
index e168296..5143843 100644
--- a/drivers/mtd/devices/st_spi_fsm.h
+++ b/drivers/mtd/devices/st_spi_fsm.h
@@ -229,8 +229,18 @@
 #define FLASH_CMD_READ4_1_1_4	0x6c
 #define FLASH_CMD_READ4_1_4_4	0xec
 
+/* Status register */
+#define FLASH_STATUS_BUSY	0x01
+#define FLASH_STATUS_WEL	0x02
+#define FLASH_STATUS_BP0	0x04
+#define FLASH_STATUS_BP1	0x08
+#define FLASH_STATUS_BP2	0x10
+#define FLASH_STATUS_SRWP0	0x80
+#define FLASH_STATUS_TIMEOUT	0xff
+
 #define FLASH_PAGESIZE		256			/* In Bytes    */
 #define FLASH_PAGESIZE_32	FLASH_PAGESIZE / 4	/* In uint32_t */
+#define FLASH_MAX_BUSY_WAIT	(300 * HZ)	/* Maximum 'CHIPERASE' time */
 
 /*
  * Flags to tweak operation of default read/write/erase routines
-- 
1.8.3.2

