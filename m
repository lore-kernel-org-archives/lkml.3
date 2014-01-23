Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbaAWKhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:37:23 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:38676 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbaAWKcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:32:45 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, computersforpeace@gmail.com,
        Angus.Clark@st.com, DCG_UPD_stlinux_kernel@list.st.com,
        olivier.clergeaud@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH RESEND v4 25/37] mtd: st_spi_fsm: Prepare default sequences for read/write/erase
Date: Thu, 23 Jan 2014 10:31:13 +0000
Message-Id: <1390473085-24626-26-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
References: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most chips require a predefined set of FSM message sequences for read,
write and erase operations. This patch provides a way to set them up,
which it will do so if a chip specific initialisation routine isn't
been provided.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 28d8ac0..a5b9d67 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -838,6 +838,38 @@ static int stfsm_search_prepare_rw_seq(struct stfsm *fsm,
 	return 0;
 }
 
+/* Prepare a READ/WRITE/ERASE 'default' sequences */
+static int stfsm_prepare_rwe_seqs_default(struct stfsm *fsm)
+{
+	uint32_t flags = fsm->info->flags;
+	int ret;
+
+	/* Configure 'READ' sequence */
+	ret = stfsm_search_prepare_rw_seq(fsm, &stfsm_seq_read,
+					  default_read_configs);
+	if (ret) {
+		dev_err(fsm->dev,
+			"failed to prep READ sequence with flags [0x%08x]\n",
+			flags);
+		return ret;
+	}
+
+	/* Configure 'WRITE' sequence */
+	ret = stfsm_search_prepare_rw_seq(fsm, &stfsm_seq_write,
+					  default_write_configs);
+	if (ret) {
+		dev_err(fsm->dev,
+			"failed to prep WRITE sequence with flags [0x%08x]\n",
+			flags);
+		return ret;
+	}
+
+	/* Configure 'ERASE_SECTOR' sequence */
+	stfsm_prepare_erasesec_seq(fsm, &stfsm_seq_erase_sector);
+
+	return 0;
+}
+
 static int stfsm_n25q_config(struct stfsm *fsm)
 {
 	uint32_t flags = fsm->info->flags;
@@ -1153,6 +1185,10 @@ static int stfsm_probe(struct platform_device *pdev)
 		ret = info->config(fsm);
 		if (ret)
 			return ret;
+	} else {
+		ret = stfsm_prepare_rwe_seqs_default(fsm);
+		if (ret)
+			return ret;
 	}
 
 	platform_set_drvdata(pdev, fsm);
-- 
1.8.3.2

