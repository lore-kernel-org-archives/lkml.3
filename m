Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3LETby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:31:54 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:43285 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3LETav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:30:51 -0500
X-IronPort-AV: E=Sophos;i="4.93,835,1378882800"; 
   d="scan'208";a="365454"
From: Tim Kryger <tim.kryger@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        Axel Lin <axel.lin@ingics.com>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Subject: [PATCH v4 5/8] mmc: sdhci-bcm-kona: Add basic use of clocks
Date: Thu, 5 Dec 2013 11:20:41 -0800
Message-ID: <1386271244-3927-6-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
References: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the external clock needed by the host controller during the
probe and disable it during the remove.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 drivers/mmc/host/sdhci-bcm-kona.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-bcm-kona.c b/drivers/mmc/host/sdhci-bcm-kona.c
index 7a190fe..923eefa 100644
--- a/drivers/mmc/host/sdhci-bcm-kona.c
+++ b/drivers/mmc/host/sdhci-bcm-kona.c
@@ -54,6 +54,7 @@
 
 struct sdhci_bcm_kona_dev {
 	struct mutex	write_lock; /* protect back to back writes */
+	struct clk	*external_clk;
 };
 
 
@@ -257,6 +258,24 @@ static int sdhci_bcm_kona_probe(struct platform_device *pdev)
 		goto err_pltfm_free;
 	}
 
+	/* Get and enable the external clock */
+	kona_dev->external_clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(kona_dev->external_clk)) {
+		dev_err(dev, "Failed to get external clock\n");
+		ret = PTR_ERR(kona_dev->external_clk);
+		goto err_pltfm_free;
+	}
+
+	if (clk_set_rate(kona_dev->external_clk, host->mmc->f_max) != 0) {
+		dev_err(dev, "Failed to set rate external clock\n");
+		goto err_pltfm_free;
+	}
+
+	if (clk_prepare_enable(kona_dev->external_clk) != 0) {
+		dev_err(dev, "Failed to enable external clock\n");
+		goto err_pltfm_free;
+	}
+
 	dev_dbg(dev, "non-removable=%c\n",
 		(host->mmc->caps & MMC_CAP_NONREMOVABLE) ? 'Y' : 'N');
 	dev_dbg(dev, "cd_gpio %c, wp_gpio %c\n",
@@ -271,7 +290,7 @@ static int sdhci_bcm_kona_probe(struct platform_device *pdev)
 
 	ret = sdhci_bcm_kona_sd_reset(host);
 	if (ret)
-		goto err_pltfm_free;
+		goto err_clk_disable;
 
 	sdhci_bcm_kona_sd_init(host);
 
@@ -307,6 +326,9 @@ err_remove_host:
 err_reset:
 	sdhci_bcm_kona_sd_reset(host);
 
+err_clk_disable:
+	clk_disable_unprepare(kona_dev->external_clk);
+
 err_pltfm_free:
 	sdhci_pltfm_free(pdev);
 
@@ -316,7 +338,18 @@ err_pltfm_free:
 
 static int __exit sdhci_bcm_kona_remove(struct platform_device *pdev)
 {
-	return sdhci_pltfm_unregister(pdev);
+	struct sdhci_host *host = platform_get_drvdata(pdev);
+	struct sdhci_pltfm_host *pltfm_priv = sdhci_priv(host);
+	struct sdhci_bcm_kona_dev *kona_dev = sdhci_pltfm_priv(pltfm_priv);
+	int dead = (readl(host->ioaddr + SDHCI_INT_STATUS) == 0xffffffff);
+
+	sdhci_remove_host(host, dead);
+
+	clk_disable_unprepare(kona_dev->external_clk);
+
+	sdhci_pltfm_free(pdev);
+
+	return 0;
 }
 
 static struct platform_driver sdhci_bcm_kona_driver = {
-- 
1.8.0.1

