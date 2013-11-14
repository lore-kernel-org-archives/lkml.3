Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab3KNTLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 14:11:16 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:2787 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135Ab3KNTLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 14:11:08 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Christian Daudt" <bcm@fixthebug.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Chris Ball" <cjb@laptop.org>
cc: "Tim Kryger" <tim.kryger@linaro.org>,
        "Device Tree List" <devicetree@vger.kernel.org>,
        "Linux ARM Kernel List" <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        "Linaro Patches List" <patches@linaro.org>
Subject: [PATCH v3 5/8] mmc: sdhci-bcm-kona: Add basic use of clocks
Date: Thu, 14 Nov 2013 11:10:40 -0800
Message-ID: <1384456243-27053-6-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1384456243-27053-1-git-send-email-tim.kryger@linaro.org>
References: <1384456243-27053-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
X-WSS-ID: 7E9BFF981SC8091018-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the external clock needed by the host controller during the
probe and disable it during the remove.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 drivers/mmc/host/sdhci-bcm-kona.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-bcm-kona.c b/drivers/mmc/host/sdhci-bcm-kona.c
index 85472d3..bffbb40 100644
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
 
@@ -317,6 +339,8 @@ err_pltfm_free:
 static int __exit sdhci_bcm_kona_remove(struct platform_device *pdev)
 {
 	struct sdhci_host *host = platform_get_drvdata(pdev);
+	struct sdhci_pltfm_host *pltfm_priv = sdhci_priv(host);
+	struct sdhci_bcm_kona_dev *kona_dev = sdhci_pltfm_priv(pltfm_priv);
 	int dead;
 	u32 scratch;
 
@@ -326,6 +350,8 @@ static int __exit sdhci_bcm_kona_remove(struct platform_device *pdev)
 		dead = 1;
 	sdhci_remove_host(host, dead);
 
+	clk_disable_unprepare(kona_dev->external_clk);
+
 	sdhci_free_host(host);
 
 	return 0;
-- 
1.8.0.1


