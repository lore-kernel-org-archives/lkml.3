Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaAWKdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:33:08 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:39924 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbaAWKdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:33:03 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, computersforpeace@gmail.com,
        Angus.Clark@st.com, DCG_UPD_stlinux_kernel@list.st.com,
        olivier.clergeaud@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH RESEND v4 31/37] mtd: st_spi_fsm: Add the ability to read the FSM's status
Date: Thu, 23 Jan 2014 10:31:19 +0000
Message-Id: <1390473085-24626-32-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
References: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index eac23df..5f291dc 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -778,6 +778,30 @@ static uint8_t stfsm_wait_busy(struct stfsm *fsm)
 	return -EIO;
 }
 
+static int stfsm_read_status(struct stfsm *fsm, uint8_t cmd,
+			   uint8_t *status)
+{
+	struct stfsm_seq *seq = &stfsm_seq_read_status_fifo;
+	uint32_t tmp;
+
+	dev_dbg(fsm->dev, "reading STA[%s]\n",
+		(cmd == FLASH_CMD_RDSR) ? "1" : "2");
+
+	seq->seq_opc[0] = (SEQ_OPC_PADS_1 |
+			   SEQ_OPC_CYCLES(8) |
+			   SEQ_OPC_OPCODE(cmd)),
+
+	stfsm_load_seq(fsm, seq);
+
+	stfsm_read_fifo(fsm, &tmp, 4);
+
+	*status = (uint8_t)(tmp >> 24);
+
+	stfsm_wait_seq(fsm);
+
+	return 0;
+}
+
 static int stfsm_wrvcr(struct stfsm *fsm, uint8_t data)
 {
 	struct stfsm_seq *seq = &stfsm_seq_wrvcr;
-- 
1.8.3.2

