Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3KNOZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:25:18 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:41880 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab3KNOXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:23:07 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, angus.clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/10] mtd: st_spi_fsm: Add support for JEDEC ID extraction
Date: Thu, 14 Nov 2013 14:22:33 +0000
Message-Id: <1384438956-31153-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
References: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once we start supporting devices it will be handy go detect them
dynamically. This will be done using the chip's unique JEDEC ID. This
patch allows us to extract a device's JEDEC ID using the a predefined
FSM register write sequence.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 63 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 6691eaf..2899e0f 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -92,6 +92,22 @@ struct stfsm_seq {
 } __attribute__((__packed__, aligned(4)));
 #define STFSM_SEQ_SIZE sizeof(struct stfsm_seq)
 
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
@@ -158,6 +174,50 @@ static void stfsm_read_fifo(struct stfsm *fsm, uint32_t *buf,
 	}
 }
 
+static int stfsm_read_jedec(struct stfsm *fsm, uint8_t *const jedec)
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
+
+	return 0;
+}
+
+static struct flash_info * stfsm_jedec_probe(struct stfsm *fsm)
+{
+	u16                     ext_jedec;
+	u32			jedec;
+	u8			id[5];
+	int			ret;
+
+	/*
+	 * JEDEC also defines an optional "extended device information"
+	 * string for after vendor-specific data, after the three bytes
+	 * we use here. Supporting some chips might require using it.
+	 */
+
+	ret = stfsm_read_jedec(fsm, id);
+	if (ret) {
+		dev_info(fsm->dev, "Error reading JEDEC ID\n");
+		return NULL;
+	}
+
+	jedec     = id[0] << 16 | id[1] << 8 | id[2];
+	ext_jedec = id[3] << 8  | id[4];
+
+	dev_dbg(fsm->dev, "JEDEC =  0x%08x [%02x %02x %02x %02x %02x]\n",
+		jedec, id[0], id[1], id[2], id[3], id[4]);
+
+	return NULL;
+}
+
 static void stfsm_clear_fifo(struct stfsm *fsm)
 {
 	uint32_t avail;
@@ -310,6 +370,9 @@ static int stfsm_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/* Detect SPI FLASH device */
+	stfsm_jedec_probe(fsm);
+
 	platform_set_drvdata(pdev, fsm);
 
 	fsm->mtd.dev.parent   = &pdev->dev;
-- 
1.8.1.2

