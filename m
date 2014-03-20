Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbaCTJWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:22:14 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49558 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaCTJWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:22:09 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org, Angus.Clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 24/36] mtd: st_spi_fsm: Prepare default sequences for read/write/erase
Date: Thu, 20 Mar 2014 09:20:56 +0000
Message-Id: <1395307268-12721-25-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most chips require a predefined set of FSM message sequences for read,
write and erase operations. This patch provides a way to set them up,
which it will do so if a chip specific initialisation routine isn't
been provided.

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index b4d2a18..b4afee0 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -845,6 +845,38 @@ static int stfsm_search_prepare_rw_seq(struct stfsm *fsm,
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
@@ -1151,6 +1183,10 @@ static int stfsm_probe(struct platform_device *pdev)
 		ret = info->config(fsm);
 		if (ret)
 			return ret;
+	} else {
+		ret = stfsm_prepare_rwe_seqs_default(fsm);
+		if (ret)
+			return ret;
 	}
 
 	fsm->mtd.dev.parent	= &pdev->dev;
-- 
1.8.3.2

