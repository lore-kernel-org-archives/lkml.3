Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbaCTJVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:21:36 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:39710 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989AbaCTJVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:21:30 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org, Angus.Clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 06/36] mtd: st_spi_fsm: Add support for JEDEC ID extraction
Date: Thu, 20 Mar 2014 09:20:38 +0000
Message-Id: <1395307268-12721-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once we start supporting devices it will be handy go detect them
dynamically. This will be done using the chip's unique JEDEC ID. This
patch allows us to extract a device's JEDEC ID using the a predefined
FSM register write sequence.

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 55 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 73e0f27..9fc0b19 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -219,6 +219,22 @@ struct stfsm_seq {
 	uint32_t seq_cfg;
 } __packed __aligned(4);
 
+static struct stfsm_seq stfsm_seq_read_jedec = {
+	.data_size = TRANSFER_SIZE(8),
+	.seq_opc[0] = (SEQ_OPC_PADS_1 |
+		       SEQ_OPC_CYCLES(8) |
+		       SEQ_OPC_OPCODE(FLASH_CMD_RDID)),
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
 static inline int stfsm_is_idle(struct stfsm *fsm)
 {
 	return readl(fsm->base + SPI_FAST_SEQ_STA) & 0x10;
@@ -307,6 +323,42 @@ static void stfsm_read_fifo(struct stfsm *fsm, uint32_t *buf,
 	}
 }
 
+static void stfsm_read_jedec(struct stfsm *fsm, uint8_t *const jedec)
+{
+	const struct stfsm_seq *seq = &stfsm_seq_read_jedec;
+	uint32_t tmp[2];
+
+	stfsm_load_seq(fsm, seq);
+
+	stfsm_read_fifo(fsm, tmp, 8);
+
+	memcpy(jedec, tmp, 5);
+
+	stfsm_wait_seq(fsm);
+}
+
+static struct flash_info *stfsm_jedec_probe(struct stfsm *fsm)
+{
+	u16                     ext_jedec;
+	u32			jedec;
+	u8			id[5];
+
+	stfsm_read_jedec(fsm, id);
+
+	jedec     = id[0] << 16 | id[1] << 8 | id[2];
+	/*
+	 * JEDEC also defines an optional "extended device information"
+	 * string for after vendor-specific data, after the three bytes
+	 * we use here. Supporting some chips might require using it.
+	 */
+	ext_jedec = id[3] << 8  | id[4];
+
+	dev_dbg(fsm->dev, "JEDEC =  0x%08x [%02x %02x %02x %02x %02x]\n",
+		jedec, id[0], id[1], id[2], id[3], id[4]);
+
+	return NULL;
+}
+
 static int stfsm_set_mode(struct stfsm *fsm, uint32_t mode)
 {
 	int ret, timeout = 10;
@@ -436,6 +488,9 @@ static int stfsm_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/* Detect SPI FLASH device */
+	stfsm_jedec_probe(fsm);
+
 	fsm->mtd.dev.parent	= &pdev->dev;
 	fsm->mtd.type		= MTD_NORFLASH;
 	fsm->mtd.writesize	= 4;
-- 
1.8.3.2

