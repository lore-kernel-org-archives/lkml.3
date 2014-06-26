Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaFZUuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:50:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38192 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaFZUuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:50:16 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>
Cc: Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        devicetree@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 10/10] mmc: sdhci-tegra: Add IOMMU support
Date: Thu, 26 Jun 2014 22:49:50 +0200
Message-Id: <1403815790-8548-11-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Attach to the device's master interface of the IOMMU at .probe() time.
IOMMU support becomes available via the DMA mapping API interoperation
code, but this explicit attachment is necessary to ensure proper probe
order.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/mmc/host/sdhci-tegra.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 33100d10d176..b884614fa4e6 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/iommu.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/io.h>
@@ -237,6 +238,11 @@ static int sdhci_tegra_probe(struct platform_device *pdev)
 	match = of_match_device(sdhci_tegra_dt_match, &pdev->dev);
 	if (!match)
 		return -EINVAL;
+
+	rc = iommu_attach(&pdev->dev);
+	if (rc < 0)
+		return rc;
+
 	soc_data = match->data;
 
 	host = sdhci_pltfm_init(pdev, soc_data->pdata, 0);
@@ -310,6 +316,8 @@ static int sdhci_tegra_remove(struct platform_device *pdev)
 	clk_disable_unprepare(pltfm_host->clk);
 	clk_put(pltfm_host->clk);
 
+	iommu_detach(&pdev->dev);
+
 	sdhci_pltfm_free(pdev);
 
 	return 0;
-- 
2.0.0

