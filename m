Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab3FBGjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 02:39:11 -0400
Received: from mail.advaoptical.com ([91.217.199.15]:43167 "EHLO
	mail.advaoptical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3FBGjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 02:39:06 -0400
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Jun 2013 02:39:05 EDT
From: Oded Gabbay <ogabbay@advaoptical.com>
To: <gregkh@linuxfoundation.org>, <cjb@laptop.org>,
        <grant.likely@secretlab.ca>, <rob@landley.net>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <ogabbay@advaoptical.com>
Subject: [PATCH 3/3] MMC: FSL SDHC: Add support for hard-wired (permanent) card. Kernel version 3.4.47
Date: Sun, 2 Jun 2013 09:38:48 +0300
Message-ID: <1370155128-680-1-git-send-email-ogabbay@advaoptical.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.179.55]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-06-02_02:2013-05-31,2013-06-02,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support of recognizing hard-wired (permanent) cards
to Freescale's SDHC host driver. This is done by adding the option
"fsl,card-wired" to the SDHC device-tree entry. Detection of this
option is done in the probe function. Update documentation in file
fsl-esdhc.txt

Signed-off-by: Oded Gabbay <ogabbay@advaoptical.com>
---
 Documentation/devicetree/bindings/mmc/fsl-esdhc.txt | 3 +++
 drivers/mmc/host/sdhci-of-esdhc.c                   | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/fsl-esdhc.txt b/Documentation/devicetree/bindings/mmc/fsl-esdhc.txt
index 64bcb8b..6f0eefa 100644
--- a/Documentation/devicetree/bindings/mmc/fsl-esdhc.txt
+++ b/Documentation/devicetree/bindings/mmc/fsl-esdhc.txt
@@ -16,6 +16,9 @@ Required properties:
     only handle 1-bit data transfers.
   - sdhci,auto-cmd12: (optional) specifies that a controller can
     only handle auto CMD12.
+  - fsl,card-wired : (optional) specifies that the card is
+    a permanent card and should not be detected for insertion or
+    removal
 
 Example:
 
diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index e70f22f..2f79ec2 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -222,6 +222,10 @@ static int __devinit sdhci_esdhc_probe(struct platform_device *pdev)
 		host->quirks2 |= SDHCI_QUIRK2_BROKEN_HOST_CONTROL;
 	}
 
+	/* If card is permanent, add capability of non-removable */
+	if (of_get_property(np, "fsl,card-wired", NULL))
+		host->mmc->caps |= MMC_CAP_NONREMOVABLE;
+
 	ret = sdhci_add_host(host);
 	if (ret)
 		sdhci_pltfm_free(pdev);
-- 
1.7.11.7

