Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaAWKcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:32:36 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59811 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbaAWKcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:32:32 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, computersforpeace@gmail.com,
        Angus.Clark@st.com, DCG_UPD_stlinux_kernel@list.st.com,
        olivier.clergeaud@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH RESEND v4 20/37] mtd: st_spi_fsm: Provide a method to put the chip into 32bit addressing mode
Date: Thu, 23 Jan 2014 10:31:08 +0000
Message-Id: <1390473085-24626-21-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
References: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most Serial Flash chips support 24bit addressing as a default but more
recent incarnations can support 32bit. Based on information provided
though platform specific data and capabilities we can determine whether
or not our current chip can. This patch provides a means to setup the
FSM message sequence to put the chip into 32bit mode.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index b21929b..e74513d 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -411,6 +411,8 @@ static struct flash_info flash_types[] = {
 	{ NULL, 0x000000, 0, 0, 0, 0, 0, NULL },
 };
 
+static struct stfsm_seq stfsm_seq_en_32bit_addr;/* Dynamically populated */
+
 static struct stfsm_seq stfsm_seq_read_jedec = {
 	.data_size = TRANSFER_SIZE(8),
 	.seq_opc[0] = (SEQ_OPC_PADS_1 |
@@ -554,6 +556,23 @@ static void stfsm_read_fifo(struct stfsm *fsm, uint32_t *buf,
 	}
 }
 
+static int stfsm_enter_32bit_addr(struct stfsm *fsm, int enter)
+{
+	struct stfsm_seq *seq = &stfsm_seq_en_32bit_addr;
+	uint32_t cmd = enter ? FLASH_CMD_EN4B_ADDR : FLASH_CMD_EX4B_ADDR;
+
+	seq->seq_opc[0] = (SEQ_OPC_PADS_1 |
+			   SEQ_OPC_CYCLES(8) |
+			   SEQ_OPC_OPCODE(cmd) |
+			   SEQ_OPC_CSDEASSERT);
+
+	stfsm_load_seq(fsm, seq);
+
+	stfsm_wait_seq(fsm);
+
+	return 0;
+}
+
 /*
  * SoC reset on 'boot-from-spi' systems
  *
-- 
1.8.3.2

