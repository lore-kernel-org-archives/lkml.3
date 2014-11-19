Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbaKSTh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:37:29 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:52207 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaKSTh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:37:27 -0500
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, chris@printf.net,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] mmc: dw_mmc: Turn the card clock off at suspend time
Date: Wed, 19 Nov 2014 11:37:21 -0800
Message-Id: <1416425841-12681-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the dw_mmc driver was first added to Linux it's had a TODO in it
that we should turn off the card clock during suspend.  I have no idea
for sure why it wasn't done originally, but if I had to guess I'd
guess it was related to the lack of a common clock framework.  Let's
do it now.

There is no reason for the card clock to be left on during suspend and
most systems will eventually turn it off anyway (when whole clock
trees are disabled).  However, it's good to be explicit that it's
disabled at the time that the MMC subsystem is disabled.

This actually fixes a bug on Rockchip rk3288 where an SDIO card wakes
the system back up during suspend.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Handle fact that ciu_clk is optional (abrestic)
- Check for errors enabling ciu_clk (abrestic)

 drivers/mmc/host/dw_mmc.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 5a37c33..49f4013 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2825,11 +2825,11 @@ EXPORT_SYMBOL(dw_mci_remove);
 
 
 #ifdef CONFIG_PM_SLEEP
-/*
- * TODO: we should probably disable the clock to the card in the suspend path.
- */
 int dw_mci_suspend(struct dw_mci *host)
 {
+	if (!IS_ERR(host->ciu_clk))
+		clk_disable(host->ciu_clk);
+
 	return 0;
 }
 EXPORT_SYMBOL(dw_mci_suspend);
@@ -2838,9 +2838,15 @@ int dw_mci_resume(struct dw_mci *host)
 {
 	int i, ret;
 
+	if (!IS_ERR(host->ciu_clk)) {
+		ret = clk_enable(host->ciu_clk);
+		if (ret)
+			return ret;
+	}
+
 	if (!dw_mci_ctrl_reset(host, SDMMC_CTRL_ALL_RESET_FLAGS)) {
 		ret = -ENODEV;
-		return ret;
+		goto exit_ciu_enabled;
 	}
 
 	if (host->use_dma && host->dma_ops->init)
@@ -2871,7 +2877,14 @@ int dw_mci_resume(struct dw_mci *host)
 			dw_mci_setup_bus(slot, true);
 		}
 	}
+
 	return 0;
+
+exit_ciu_enabled:
+	if (!IS_ERR(host->ciu_clk))
+		clk_disable(host->ciu_clk);
+
+	return ret;
 }
 EXPORT_SYMBOL(dw_mci_resume);
 #endif /* CONFIG_PM_SLEEP */
-- 
2.1.0.rc2.206.gedb03e5

