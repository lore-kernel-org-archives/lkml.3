Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaHLKiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 06:38:18 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:53773 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751479AbaHLKiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 06:38:17 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>, Anton Vorontsov <anton@enomsg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH 3/5 v2] mmc: sdhci-pltfm: Do not use parent as the host's device
Date: Tue, 12 Aug 2014 11:37:52 +0100
Message-Id: <1407839872-12864-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <CAPDyKFrb9OSbhHtn=wgbs9Yky1t453rdNBJVgGA62vER-65dYw@mail.gmail.com>
References: <CAPDyKFrb9OSbhHtn=wgbs9Yky1t453rdNBJVgGA62vER-65dYw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code selecting a device for the sdhci host has been
continuously tweaked (4b711cb13843f5082e82970dd1e8031383134a65
"mmc: sdhci-pltfm: Add structure for host-specific data" and
a4d2177f00a5252d825236c5124bc1e9918bdb41 "mmc: sdhci-pltfm: dt
device does not pass parent to sdhci_alloc_host" while there
does not seem to be any reason to use platform device's parent
in the first place.

The comment saying "Some PCI-based MFD need the parent here"
seem to refer to Timberdale FPGA driver (the only MFD driver
registering SDHCI cell, drivers/mfd/timberdale.c) but again,
the only situation when parent device matter is runtime PM,
which is not implemented for Timberdale.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/mmc/host/sdhci-pltfm.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index 7e834fb..c5b01d6 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -123,7 +123,6 @@ struct sdhci_host *sdhci_pltfm_init(struct platform_device *pdev,
 				    size_t priv_size)
 {
 	struct sdhci_host *host;
-	struct device_node *np = pdev->dev.of_node;
 	struct resource *iomem;
 	int ret;
 
@@ -136,13 +135,8 @@ struct sdhci_host *sdhci_pltfm_init(struct platform_device *pdev,
 	if (resource_size(iomem) < 0x100)
 		dev_err(&pdev->dev, "Invalid iomem size!\n");
 
-	/* Some PCI-based MFD need the parent here */
-	if (pdev->dev.parent != &platform_bus && !np)
-		host = sdhci_alloc_host(pdev->dev.parent,
-			sizeof(struct sdhci_pltfm_host) + priv_size);
-	else
-		host = sdhci_alloc_host(&pdev->dev,
-			sizeof(struct sdhci_pltfm_host) + priv_size);
+	host = sdhci_alloc_host(&pdev->dev,
+		sizeof(struct sdhci_pltfm_host) + priv_size);
 
 	if (IS_ERR(host)) {
 		ret = PTR_ERR(host);
-- 
1.9.1

