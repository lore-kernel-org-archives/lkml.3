Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbaIBPuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:50:01 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63824 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaIBPt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:49:59 -0400
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: rmk+kernel@arm.linux.org.uk, shawn.guo@linaro.org, b29396@freescale.com,
        peter.griffin@linaro.org, tgih.jun@samsung.com, h80.chung@samsung.com,
        ulf.hansson@linaro.org, chris@printf.net, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH] mmc: sdhci-esdhc-imx: Enable boot partition access from DT
Date: Tue,  2 Sep 2014 17:49:37 +0200
Message-Id: <1409672977-26972-1-git-send-email-jean-michel.hautbois@vodalys.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This property is useful when we don't want to access boot partitions on eMMC

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 Documentation/devicetree/bindings/mmc/mmc.txt | 1 +
 drivers/mmc/host/sdhci-esdhc-imx.c            | 8 ++++++++
 include/linux/platform_data/mmc-esdhc-imx.h   | 1 +
 3 files changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/mmc.txt b/Documentation/devicetree/bindings/mmc/mmc.txt
index 431716e..59cc854 100644
--- a/Documentation/devicetree/bindings/mmc/mmc.txt
+++ b/Documentation/devicetree/bindings/mmc/mmc.txt
@@ -40,6 +40,7 @@ Optional properties:
 - mmc-hs200-1_2v: eMMC HS200 mode(1.2V I/O) is supported
 - mmc-hs400-1_8v: eMMC HS400 mode(1.8V I/O) is supported
 - mmc-hs400-1_2v: eMMC HS400 mode(1.2V I/O) is supported
+- no-boot-part : when preset, tells to access boot partitions

 *NOTE* on CD and WP polarity. To use common for all SD/MMC host controllers line
 polarity properties, we have to fix the meaning of the "normal" and "inverted"
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index ccec0e3..439e663 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -942,6 +942,11 @@ sdhci_esdhc_imx_probe_dt(struct platform_device *pdev,
	if (of_property_read_u32(np, "fsl,delay-line", &boarddata->delay_line))
		boarddata->delay_line = 0;

+	if (of_find_property(np, "no-boot-part", NULL))
+		boarddata->access_boot_part = false;
+	else
+		boarddata->access_boot_part = true;
+
	return 0;
 }
 #else
@@ -1119,6 +1124,9 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
		host->quirks2 |= SDHCI_QUIRK2_NO_1_8_V;
	}

+	if (!boarddata->access_boot_part)
+		host->mmc->caps2 |= MMC_CAP2_BOOTPART_NOACC;
+
	err = sdhci_add_host(host);
	if (err)
		goto disable_clk;
diff --git a/include/linux/platform_data/mmc-esdhc-imx.h b/include/linux/platform_data/mmc-esdhc-imx.h
index 75f70f6..a34ee9e 100644
--- a/include/linux/platform_data/mmc-esdhc-imx.h
+++ b/include/linux/platform_data/mmc-esdhc-imx.h
@@ -46,5 +46,6 @@ struct esdhc_platform_data {
	unsigned int f_max;
	bool support_vsel;
	unsigned int delay_line;
+	bool access_boot_part;
 };
 #endif /* __ASM_ARCH_IMX_ESDHC_H */

2.0.4

