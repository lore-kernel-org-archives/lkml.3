Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbaFKJKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:10:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57601 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640AbaFKI6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:58:06 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 13/36] ARM: OMAP2+: gpmc.c: sanity check bank-width DT property
Date: Wed, 11 Jun 2014 11:56:18 +0300
Message-ID: <1402477001-31132-14-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure bank-width property provided via DT is sane.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index c713616..70cb6b0 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1219,6 +1219,7 @@ static int gpmc_probe_generic_child(struct platform_device *pdev,
 	struct resource res;
 	unsigned long base;
 	int ret, cs;
+	struct device *dev = &pdev->dev;
 
 	if (of_property_read_u32(child, "reg", &cs) < 0) {
 		dev_err(&pdev->dev, "%s has no 'reg' property\n",
@@ -1284,7 +1285,7 @@ static int gpmc_probe_generic_child(struct platform_device *pdev,
 			gpmc_s.device_width = GPMC_DEVWIDTH_16BIT;
 			break;
 		default:
-			dev_err(&pdev->dev, "%s: invalid 'nand-bus-width'\n",
+			dev_err(dev, "%s: invalid 'nand-bus-width'\n",
 				child->name);
 			ret = -EINVAL;
 			goto err;
@@ -1292,10 +1293,18 @@ static int gpmc_probe_generic_child(struct platform_device *pdev,
 
 		gpmc_s.device_nand = true;
 	} else {
-		ret = of_property_read_u32(child, "bank-width",
-					   &gpmc_s.device_width);
-		if (ret < 0)
+		if (of_property_read_u32(child, "bank-width",
+					 &gpmc_s.device_width)) {
+			dev_err(dev, "%s: no 'bank-width' property\n",
+				child->name);
+			goto err;
+		}
+
+		if (gpmc_s.device_width < 1 || gpmc_s.device_width > 2) {
+			dev_err(dev, "%s: invalid 'bank-width'\n",
+				child->name);
 			goto err;
+		}
 	}
 
 	ret = gpmc_cs_program_settings(cs, &gpmc_s);
-- 
1.8.3.2

