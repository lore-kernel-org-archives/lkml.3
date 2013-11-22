Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab3KVQXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:23:43 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38346 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab3KVQXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:23:39 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org, angus.clark@st.com
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/23] mtd: st_spi_fsm: Add support for JEDEC ID extraction
Date: Fri, 22 Nov 2013 16:22:44 +0000
Message-Id: <1385137380-28968-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385137380-28968-1-git-send-email-lee.jones@linaro.org>
References: <1385137380-28968-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once we start supporting devices it will be handy go detect them
dynamically. This will be done using the chip's unique JEDEC ID. This
patch allows us to extract a device's JEDEC ID using the a predefined
FSM register write sequence.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 55 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 73c55b4..f937329 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -25,6 +25,22 @@
 
 #include "st_spi_fsm.h"
 
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
@@ -91,6 +107,42 @@ static void stfsm_read_fifo(struct stfsm *fsm, uint32_t *buf,
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
+static struct flash_info * stfsm_jedec_probe(struct stfsm *fsm)
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
 static void stfsm_clear_fifo(struct stfsm *fsm)
 {
 	uint32_t avail;
@@ -243,6 +295,9 @@ static int stfsm_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/* Detect SPI FLASH device */
+	stfsm_jedec_probe(fsm);
+
 	platform_set_drvdata(pdev, fsm);
 
 	fsm->mtd.dev.parent	= &pdev->dev;
-- 
1.8.1.2

