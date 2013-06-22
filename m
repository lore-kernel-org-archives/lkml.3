Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423672Ab3FVDcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 23:32:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37078 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423471Ab3FVDcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 23:32:19 -0400
From: Joel A Fernandes <joelagnel@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>
CC: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Joel A Fernandes <joelagnel@ti.com>
Subject: [PATCH v2] ARM: common: edma: Fix dangling pointer dereference
Date: Fri, 21 Jun 2013 22:31:17 -0500
Message-ID: <1371871877-15269-1-git-send-email-joelagnel@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixup for linux-davinci/soc-v2 branch. Please ignore v1 and use this.
Returning a pointer to a variable in the setup_from_dt function is
causing dangling pointer dereferences. This causes boot to fail
on AM33XX.

Add ninfo to the caller's stack and just return the kzalloc'ed ptr
from the calling function.

v2: Fixed last issue in davinci branch:
    ninfo 2D array is used for DT platforms.
    info is shared between DT and non-DT cases. So point info to ninfo.

With this MMC is working (rootfs mount) on AM33XX.

Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
---
 arch/arm/common/edma.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 2b591b1..3567ba1 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1514,10 +1514,9 @@ static struct of_dma_filter_info edma_filter_info = {
 	.filter_fn = edma_filter_fn,
 };
 
-static struct edma_soc_info **edma_setup_info_from_dt(struct device *dev,
+static struct edma_soc_info *edma_setup_info_from_dt(struct device *dev,
 						      struct device_node *node)
 {
-	static struct edma_soc_info **info;
 	struct edma_soc_info *ninfo;
 	int ret;
 
@@ -1539,9 +1538,7 @@ static struct edma_soc_info **edma_setup_info_from_dt(struct device *dev,
 	of_dma_controller_register(dev->of_node, of_dma_simple_xlate,
 				   &edma_filter_info);
 
-	info = &ninfo;
-
-	return info;
+	return ninfo;
 }
 #else
 static struct edma_soc_info **edma_setup_info_from_dt(struct device *dev,
@@ -1554,6 +1551,7 @@ static struct edma_soc_info **edma_setup_info_from_dt(struct device *dev,
 static int edma_probe(struct platform_device *pdev)
 {
 	struct edma_soc_info	**info = pdev->dev.platform_data;
+	struct edma_soc_info    *ninfo[EDMA_MAX_CC] = {NULL};
 	s8		(*queue_priority_mapping)[2];
 	s8		(*queue_tc_mapping)[2];
 	int			i, j, off, ln, found = 0;
@@ -1572,7 +1570,9 @@ static int edma_probe(struct platform_device *pdev)
 	int			ret;
 
 	if (node) {
-		info = edma_setup_info_from_dt(dev, node);
+		/* For now, for DT we populate only first ninfo element */
+		ninfo[0] = edma_setup_info_from_dt(dev, node);
+		info = ninfo;
 		if (IS_ERR(info)) {
 			dev_err(dev, "failed to get DT data\n");
 			return PTR_ERR(info);
-- 
1.7.9.5

