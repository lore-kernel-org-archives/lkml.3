Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbaDNQup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:50:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35197 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbaDNQZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:25:52 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/15] bus: omap_l3_noc: introduce concept of submodule
Date: Mon, 14 Apr 2014 11:25:24 -0500
Message-ID: <1397492726-17203-15-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397492726-17203-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While OMAP4 and OMAP5 had 3 separate clock domains, DRA7 has only 2
and the first one then is internally divided into 2 sub clock domains.

To better represent this in the driver, we use the concept of submodule.

The address defintions in the devicetree is as per the high level
clock domain(module) base, the sub clockdomain/subdomain which shares
the same register space of a clockdomain is marked in the SoC data as
L3_BASE_IS_SUBMODULE.

L3_BASE_IS_SUBMODULE is used as an indication that it's base address is
the same as the parent module and offsets are considered from the same
base address as they are usually intermingled.

Other than the base address, the submodule is same as a module as it is
functionally so.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/bus/omap_l3_noc.c |   17 ++++++++++++-----
 drivers/bus/omap_l3_noc.h |    6 +++++-
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 49b19d5..5e2a89d 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -184,7 +184,7 @@ static int omap_l3_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id;
 	static struct omap_l3 *l3;
-	int ret, i;
+	int ret, i, res_idx;
 
 	of_id = of_match_device(l3_noc_match, &pdev->dev);
 	if (!of_id) {
@@ -201,15 +201,22 @@ static int omap_l3_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, l3);
 
 	/* Get mem resources */
-	for (i = 0; i < l3->num_modules; i++) {
-		struct resource	*res = platform_get_resource(pdev,
-							     IORESOURCE_MEM, i);
-
+	for (i = 0, res_idx = 0; i < l3->num_modules; i++) {
+		struct resource	*res;
+
+		if (l3->l3_base[i] == L3_BASE_IS_SUBMODULE) {
+			/* First entry cannot be submodule */
+			BUG_ON(i == 0);
+			l3->l3_base[i] = l3->l3_base[i - 1];
+			continue;
+		}
+		res = platform_get_resource(pdev, IORESOURCE_MEM, res_idx);
 		l3->l3_base[i] = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR(l3->l3_base[i])) {
 			dev_err(l3->dev, "ioremap %d failed\n", i);
 			return PTR_ERR(l3->l3_base[i]);
 		}
+		res_idx++;
 	}
 
 	/*
diff --git a/drivers/bus/omap_l3_noc.h b/drivers/bus/omap_l3_noc.h
index af33b6e..592821f 100644
--- a/drivers/bus/omap_l3_noc.h
+++ b/drivers/bus/omap_l3_noc.h
@@ -36,6 +36,8 @@
 
 #define L3_TARGET_NOT_SUPPORTED		NULL
 
+#define L3_BASE_IS_SUBMODULE		((void __iomem *)(1 << 0))
+
 /**
  * struct l3_masters_data - L3 Master information
  * @id:		ID of the L3 Master
@@ -76,7 +78,9 @@ struct l3_flagmux_data {
 /**
  * struct omap_l3 - Description of data relevant for L3 bus.
  * @dev:	device representing the bus (populated runtime)
- * @l3_base:	base addresses of modules (populated runtime)
+ * @l3_base:	base addresses of modules (populated runtime if 0)
+ *		if set to L3_BASE_IS_SUBMODULE, then uses previous
+ *		module index as the base address
  * @l3_flag_mux: array containing flag mux data per module
  *		 offset from corresponding module base indexed per
  *		 module.
-- 
1.7.9.5

