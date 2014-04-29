Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbaD2IUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:20:52 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:56741 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640AbaD2IUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:20:46 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, agross@quicinc.com,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v1 08/11] mmc: mmci: Qcom fix MCICLK register settings.
Date: Tue, 29 Apr 2014 09:20:37 +0100
Message-Id: <1398759638-13299-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

MCICLK register layout is bit different to the standard pl180 register layout.
Qcom SDCC controller some setup in MCICLK register to get it going. So this
patch adds new setup and makes it specific to Qcom hw designer.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c |   36 ++++++++++++++++++++++++++++++------
 drivers/mmc/host/mmci.h |   21 +++++++++++++++++++++
 2 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 306e0c8..35aed38 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -326,13 +326,37 @@ static void mmci_set_clkreg(struct mmci_host *host, unsigned int desired)
 	/* Set actual clock for debug */
 	host->mmc->actual_clock = host->cclk;
 
-	if (host->mmc->ios.bus_width == MMC_BUS_WIDTH_4)
-		clk |= MCI_4BIT_BUS;
-	if (host->mmc->ios.bus_width == MMC_BUS_WIDTH_8)
-		clk |= MCI_ST_8BIT_BUS;
+	if (host->hw_designer == AMBA_VENDOR_QCOM) {
+		clk |= MCI_CLK_QCOM_FLOWENA;
+		clk |= (MCI_CLK_QCOM_SEL_FEEDBACK_CLK <<
+				MCI_CLK_QCOM_SEL_IN_SHIFT); /* feedback clk */
+		if (host->mmc->ios.bus_width == MMC_BUS_WIDTH_8)
+			clk |= MCI_CLK_QCOM_WIDEBUS_8;
+		else if (host->mmc->ios.bus_width == MMC_BUS_WIDTH_4)
+			clk |= MCI_CLK_QCOM_WIDEBUS_4;
+		else
+			clk |= MCI_CLK_QCOM_WIDEBUS_1;
+
+		if (host->mmc->ios.timing == MMC_TIMING_UHS_DDR50) {
+			/* clear SELECT_IN field */
+			clk &= ~(MCI_CLK_QCOM_SEL_MASK <<
+					MCI_CLK_QCOM_SEL_IN_SHIFT);
+			/* set DDR timing mode */
+			clk |= (MCI_CLK_QCOM_SEL_DDR_MODE <<
+					MCI_CLK_QCOM_SEL_IN_SHIFT);
+		}
+		clk |= (MCI_CLK_SDC4_MCLK_SEL_MCLK <<
+				MCI_CLK_SDC4_MCLK_SEL_SHIFT);
 
-	if (host->mmc->ios.timing == MMC_TIMING_UHS_DDR50)
-		clk |= MCI_ST_UX500_NEG_EDGE;
+	} else {
+		if (host->mmc->ios.bus_width == MMC_BUS_WIDTH_4)
+			clk |= MCI_4BIT_BUS;
+		if (host->mmc->ios.bus_width == MMC_BUS_WIDTH_8)
+			clk |= MCI_ST_8BIT_BUS;
+
+		if (host->mmc->ios.timing == MMC_TIMING_UHS_DDR50)
+			clk |= MCI_ST_UX500_NEG_EDGE;
+	}
 
 	mmci_write_clkreg(host, clk);
 }
diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index 58b1b88..0a6de1c 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -31,6 +31,27 @@
 /* Modified PL180 on Versatile Express platform */
 #define MCI_ARM_HWFCEN		(1 << 12)
 
+/* Modified on Qualcomm Integrations */
+#define MCI_CLK_QCOM_WIDEBUS_1	(0 << 10)
+#define MCI_CLK_QCOM_WIDEBUS_4	(2 << 10)
+#define MCI_CLK_QCOM_WIDEBUS_8	(3 << 10)
+#define MCI_CLK_QCOM_FLOWENA	(1 << 12)
+#define MCI_CLK_QCOM_INVERTOUT	(1 << 13)
+
+/* select in latch data and command */
+#define MCI_CLK_QCOM_SEL_IN_SHIFT	(14)
+#define MCI_CLK_QCOM_SEL_MASK		(0x3)
+#define MCI_CLK_QCOM_SEL_RISING_EDGE	(1)
+#define MCI_CLK_QCOM_SEL_FEEDBACK_CLK	(2)
+#define MCI_CLK_QCOM_SEL_DDR_MODE	(3)
+
+/* mclk selection */
+#define MCI_CLK_SDC4_MCLK_SEL_SHIFT	(23)
+#define MCI_CLK_SDC4_MCLK_SEL_MASK	(0x3)
+#define MCI_CLK_SDC4_MCLK_SEL_FB_CLK	(1)
+#define MCI_CLK_SDC4_MCLK_SEL_MCLK	(2)
+
+
 #define MMCIARGUMENT		0x008
 #define MMCICOMMAND		0x00c
 #define MCI_CPSM_RESPONSE	(1 << 6)
-- 
1.7.9.5

