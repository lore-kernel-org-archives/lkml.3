Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbaCTJWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:22:23 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:59597 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaCTJWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:22:20 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org, Angus.Clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 29/36] mtd: st_spi_fsm: Add the ability to read the FSM's status
Date: Thu, 20 Mar 2014 09:21:01 +0000
Message-Id: <1395307268-12721-30-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 34aac3f..5e315e3 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -793,6 +793,30 @@ static uint8_t stfsm_wait_busy(struct stfsm *fsm)
 	return FLASH_STATUS_TIMEOUT;
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

