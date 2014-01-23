Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaAWKcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:32:46 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:58176 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbaAWKcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:32:43 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, computersforpeace@gmail.com,
        Angus.Clark@st.com, DCG_UPD_stlinux_kernel@list.st.com,
        olivier.clergeaud@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH RESEND v4 24/37] mtd: st_spi_fsm: Supply the N25Qxxx chip specific configuration call-back
Date: Thu, 23 Jan 2014 10:31:12 +0000
Message-Id: <1390473085-24626-25-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
References: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the FSM driver we handle chip differences by providing the possibility
of calling back into a chip specific initialisation routine. In this patch
we provide one for the N25Qxxx series, which endeavours to setup things
like the read, write and erase sequences, as they differ from the
default. We also configure 32bit support and the amount of dummy cycles to
use.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 84 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 3b56b6e..28d8ac0 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -310,6 +310,8 @@ struct flash_info {
 	int             (*config)(struct stfsm *);
 };
 
+static int stfsm_n25q_config(struct stfsm *fsm);
+
 static struct flash_info flash_types[] = {
 	/*
 	 * ST Microelectronics/Numonyx --
@@ -352,9 +354,10 @@ static struct flash_info flash_types[] = {
 		   FLASH_FLAG_WRITE_1_2_2       |	\
 		   FLASH_FLAG_WRITE_1_1_4       |	\
 		   FLASH_FLAG_WRITE_1_4_4)
-	{ "n25q128", 0x20ba18, 0, 64 * 1024,  256, N25Q_FLAG, 108, NULL },
+	{ "n25q128", 0x20ba18, 0, 64 * 1024,  256, N25Q_FLAG, 108,
+	  stfsm_n25q_config },
 	{ "n25q256", 0x20ba19, 0, 64 * 1024,  512,
-	  N25Q_FLAG | FLASH_FLAG_32BIT_ADDR, 108, NULL },
+	  N25Q_FLAG | FLASH_FLAG_32BIT_ADDR, 108, stfsm_n25q_config },
 
 	/*
 	 * Spansion S25FLxxxP
@@ -491,6 +494,8 @@ static struct seq_rw_config n25q_read4_configs[] = {
 	{0x00,			0,			0, 0, 0, 0x00, 0, 0},
 };
 
+static struct stfsm_seq stfsm_seq_read;		/* Dynamically populated */
+static struct stfsm_seq stfsm_seq_write;	/* Dynamically populated */
 static struct stfsm_seq stfsm_seq_en_32bit_addr;/* Dynamically populated */
 
 static struct stfsm_seq stfsm_seq_read_jedec = {
@@ -833,6 +838,71 @@ static int stfsm_search_prepare_rw_seq(struct stfsm *fsm,
 	return 0;
 }
 
+static int stfsm_n25q_config(struct stfsm *fsm)
+{
+	uint32_t flags = fsm->info->flags;
+	uint8_t vcr;
+	int ret = 0;
+	bool soc_reset;
+
+	/* Configure 'READ' sequence */
+	if (flags & FLASH_FLAG_32BIT_ADDR)
+		ret = stfsm_search_prepare_rw_seq(fsm, &stfsm_seq_read,
+						  n25q_read4_configs);
+	else
+		ret = stfsm_search_prepare_rw_seq(fsm, &stfsm_seq_read,
+						  n25q_read3_configs);
+	if (ret) {
+		dev_err(fsm->dev,
+			"failed to prepare READ sequence with flags [0x%08x]\n",
+			flags);
+		return ret;
+	}
+
+	/* Configure 'WRITE' sequence (default configs) */
+	ret = stfsm_search_prepare_rw_seq(fsm, &stfsm_seq_write,
+					  default_write_configs);
+	if (ret) {
+		dev_err(fsm->dev,
+			"preparing WRITE sequence using flags [0x%08x] failed\n",
+			flags);
+		return ret;
+	}
+
+	/* * Configure 'ERASE_SECTOR' sequence */
+	stfsm_prepare_erasesec_seq(fsm, &stfsm_seq_erase_sector);
+
+	/* Configure 32-bit address support */
+	if (flags & FLASH_FLAG_32BIT_ADDR) {
+		stfsm_n25q_en_32bit_addr_seq(&stfsm_seq_en_32bit_addr);
+
+		soc_reset = stfsm_can_handle_soc_reset(fsm);
+		if (soc_reset || !fsm->booted_from_spi) {
+			/*
+			 * If we can handle SoC resets, we enable 32-bit
+			 * address mode pervasively
+			 */
+			stfsm_enter_32bit_addr(fsm, 1);
+		} else {
+			/*
+			 * If not, enable/disable for WRITE and ERASE
+			 * operations (READ uses special commands)
+			 */
+			fsm->configuration = (CFG_WRITE_TOGGLE_32BIT_ADDR |
+					      CFG_ERASESEC_TOGGLE_32BIT_ADDR);
+		}
+	}
+
+	/*
+	 * Configure device to use 8 dummy cycles
+	 */
+	vcr = (N25Q_VCR_DUMMY_CYCLES(8) | N25Q_VCR_XIP_DISABLED |
+	       N25Q_VCR_WRAP_CONT);
+	stfsm_wrvcr(fsm, vcr);
+
+	return 0;
+}
+
 static void stfsm_read_jedec(struct stfsm *fsm, uint8_t *const jedec)
 {
 	const struct stfsm_seq *seq = &stfsm_seq_read_jedec;
@@ -1075,6 +1145,16 @@ static int stfsm_probe(struct platform_device *pdev)
 
 	fsm->info = info;
 
+	/*
+	 * Configure READ/WRITE/ERASE sequences according to platform and
+	 * device flags.
+	 */
+	if (info->config) {
+		ret = info->config(fsm);
+		if (ret)
+			return ret;
+	}
+
 	platform_set_drvdata(pdev, fsm);
 
 	stfsm_fetch_platform_configs(pdev);
-- 
1.8.3.2

