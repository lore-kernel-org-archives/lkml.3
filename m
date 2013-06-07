Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3FGR2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 13:28:46 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:45928 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3FGR2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 13:28:44 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Olof Johansson <olof@lixom.net>, Andrew Bresticker <abrestic@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Will Newton <will.newton@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [PATCH v2 1/2] mmc: dw_mmc: Handle late vmmc regulators with EPROBE_DEFER
Date: Fri,  7 Jun 2013 10:28:29 -0700
Message-Id: <1370626110-1731-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1370580406-10254-1-git-send-email-dianders@chromium.org>
References: <1370580406-10254-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to specify a regulator that should be turned on when
dw_mmc is probed.  At the moment dw_mmc will fail to use the regulator
properly if the regulator probes after dw_mmc.  Fix this problem by
honoring EPROBE_DEFER.

At the same time move the regulator code out of the slot init code.
We only specify one regulator for the whole device and other parts of
the code (like suspend/resume) assume that the regulator has only been
enabled once.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Avoid hackery to detect regulators that will never show up.
- Move regulator out of slot init--it doesn't belong there.

 .../devicetree/bindings/mmc/synopsis-dw-mshc.txt   |  4 +++
 drivers/mmc/host/dw_mmc.c                          | 40 ++++++++++++----------
 2 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt b/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt
index 726fd21..d5cc94e 100644
--- a/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt
+++ b/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt
@@ -55,6 +55,9 @@ Optional properties:
 
 * broken-cd: as documented in mmc core bindings.
 
+* vmmc-supply: The phandle to the regulator to use for vmmc.  If this is
+  specified we'll defer probe until we can find this regulator.
+
 Aliases:
 
 - All the MSHC controller nodes should be represented in the aliases node using
@@ -79,6 +82,7 @@ board specific portions as listed below.
 		broken-cd;
 		fifo-depth = <0x80>;
 		card-detect-delay = <200>;
+		vmmc-supply = <&buck8>;
 
 		slot@0 {
 			reg = <0>;
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index bc3a1bc..ab5642d 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1895,7 +1895,7 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
 	struct mmc_host *mmc;
 	struct dw_mci_slot *slot;
 	const struct dw_mci_drv_data *drv_data = host->drv_data;
-	int ctrl_id, ret;
+	int ctrl_id;
 	u8 bus_width;
 
 	mmc = mmc_alloc_host(sizeof(struct dw_mci_slot), host->dev);
@@ -1985,19 +1985,6 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
 #endif /* CONFIG_MMC_DW_IDMAC */
 	}
 
-	host->vmmc = devm_regulator_get(mmc_dev(mmc), "vmmc");
-	if (IS_ERR(host->vmmc)) {
-		pr_info("%s: no vmmc regulator found\n", mmc_hostname(mmc));
-		host->vmmc = NULL;
-	} else {
-		ret = regulator_enable(host->vmmc);
-		if (ret) {
-			dev_err(host->dev,
-				"failed to enable regulator: %d\n", ret);
-			goto err_setup_bus;
-		}
-	}
-
 	if (dw_mci_get_cd(mmc))
 		set_bit(DW_MMC_CARD_PRESENT, &slot->flags);
 	else
@@ -2023,10 +2010,6 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
 	queue_work(host->card_workqueue, &host->card_work);
 
 	return 0;
-
-err_setup_bus:
-	mmc_free_host(mmc);
-	return -EINVAL;
 }
 
 static void dw_mci_cleanup_slot(struct dw_mci_slot *slot, unsigned int id)
@@ -2229,11 +2212,29 @@ int dw_mci_probe(struct dw_mci *host)
 		}
 	}
 
+	host->vmmc = devm_regulator_get(host->dev, "vmmc");
+	if (IS_ERR(host->vmmc)) {
+		ret = PTR_ERR(host->vmmc);
+		if (ret == -EPROBE_DEFER)
+			goto err_clk_ciu;
+
+		dev_info(host->dev, "no vmmc regulator found: %d\n", ret);
+		host->vmmc = NULL;
+	} else {
+		ret = regulator_enable(host->vmmc);
+		if (ret) {
+			if (ret != -EPROBE_DEFER)
+				dev_err(host->dev,
+					"regulator_enable fail: %d\n", ret);
+			goto err_clk_ciu;
+		}
+	}
+
 	if (!host->bus_hz) {
 		dev_err(host->dev,
 			"Platform data must supply bus speed\n");
 		ret = -ENODEV;
-		goto err_clk_ciu;
+		goto err_regulator;
 	}
 
 	host->quirks = host->pdata->quirks;
@@ -2378,6 +2379,7 @@ err_dmaunmap:
 	if (host->use_dma && host->dma_ops->exit)
 		host->dma_ops->exit(host);
 
+err_regulator:
 	if (host->vmmc)
 		regulator_disable(host->vmmc);
 
-- 
1.8.3

