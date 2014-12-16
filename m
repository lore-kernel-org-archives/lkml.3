Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaLPAWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:22:52 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:48068 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaLPAWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:22:30 -0500
From: Doug Anderson <dianders@chromium.org>
To: Ulf Hansson <ulf.hansson@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>
Cc: Mark Brown <broonie@kernel.org>, Alexandru Stan <amstan@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, chris@printf.net,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] mmc: dw_mmc: Use mmc_regulator_set_vqmmc in start_signal_voltage_switch
Date: Mon, 15 Dec 2014 16:22:19 -0800
Message-Id: <1418689340-29517-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1418689340-29517-1-git-send-email-dianders@chromium.org>
References: <1418689340-29517-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've introduced a new helper in the MMC core:
mmc_regulator_set_vqmmc().  Let's use this in dw_mmc.  Using this new
helper has some advantages:

1. We get the mmc_regulator_set_vqmmc() behavior of trying to match
   VQMMC and VMMC when the signal voltage is 3.3V.  This ensures max
   compatibility.

2. We get rid of a few more warnings when probing unsupported
   voltages.

3. We get rid of some non-dw_mmc specific code in dw_mmc.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v3:
- Continue to check for errors if VQMMC is not an error as per Andrew.

Changes in v2: None

 drivers/mmc/host/dw_mmc.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 67c0451..b3993d4 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1160,7 +1160,6 @@ static int dw_mci_switch_voltage(struct mmc_host *mmc, struct mmc_ios *ios)
 	struct dw_mci *host = slot->host;
 	u32 uhs;
 	u32 v18 = SDMMC_UHS_18V << slot->id;
-	int min_uv, max_uv;
 	int ret;
 
 	/*
@@ -1169,22 +1168,18 @@ static int dw_mci_switch_voltage(struct mmc_host *mmc, struct mmc_ios *ios)
 	 * does no harm but you need to set the regulator directly.  Try both.
 	 */
 	uhs = mci_readl(host, UHS_REG);
-	if (ios->signal_voltage == MMC_SIGNAL_VOLTAGE_330) {
-		min_uv = 2700000;
-		max_uv = 3600000;
+	if (ios->signal_voltage == MMC_SIGNAL_VOLTAGE_330)
 		uhs &= ~v18;
-	} else {
-		min_uv = 1700000;
-		max_uv = 1950000;
+	else
 		uhs |= v18;
-	}
+
 	if (!IS_ERR(mmc->supply.vqmmc)) {
-		ret = regulator_set_voltage(mmc->supply.vqmmc, min_uv, max_uv);
+		ret = mmc_regulator_set_vqmmc(mmc, ios);
 
 		if (ret) {
 			dev_dbg(&mmc->class_dev,
-					 "Regulator set error %d: %d - %d\n",
-					 ret, min_uv, max_uv);
+					 "Regulator set error %d - %s V\n",
+					 ret, uhs & v18 ? "1.8" : "3.3");
 			return ret;
 		}
 	}
-- 
2.2.0.rc0.207.ga3a616c

