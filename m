Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200AbaHEKMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:12:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51608 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933163AbaHEKMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:12:42 -0400
From: Roger Quadros <rogerq@ti.com>
To: <computersforpeace@gmail.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <ezequiel.garcia@free-electrons.com>,
        <pekon.gupta@gmail.com>, <artem.bityutskiy@linux.intel.com>,
        <dwmw2@infradead.org>, <jg1.han@samsung.com>,
        <linux-mtd@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 2/3] ARM: OMAP2+: GPMC: Support Software ECC scheme via DT
Date: Tue, 5 Aug 2014 13:11:21 +0300
Message-ID: <1407233482-11642-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1407233482-11642-1-git-send-email-rogerq@ti.com>
References: <1407233482-11642-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For v3.14 and prior, 1-bit Hamming code ECC via software was the
default choice for some boards e.g. 3430sdp.
Commit ac65caf514ec in v3.15 changed the behaviour
to use 1-bit Hamming code via Hardware using a different ECC layout
i.e. (ROM code layout) than what is used by software ECC.

This ECC layout change causes NAND filesystems created in v3.14
and prior to be unusable in v3.15 and later. So don't mark "sw" scheme
as deperecated and support it.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/mtd/gpmc-nand.txt | 2 +-
 arch/arm/mach-omap2/gpmc.c                          | 7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
index 65f4f7c..ee654e9 100644
--- a/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/gpmc-nand.txt
@@ -22,7 +22,7 @@ Optional properties:
 				width of 8 is assumed.
 
  - ti,nand-ecc-opt:		A string setting the ECC layout to use. One of:
-		"sw"		<deprecated> use "ham1" instead
+		"sw"		1-bit Hamming ecc code via software
 		"hw"		<deprecated> use "ham1" instead
 		"hw-romcode"	<deprecated> use "ham1" instead
 		"ham1"		1-bit Hamming ecc code
diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 8bc1338..9f42d54 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1403,8 +1403,11 @@ static int gpmc_probe_nand_child(struct platform_device *pdev,
 		pr_err("%s: ti,nand-ecc-opt not found\n", __func__);
 		return -ENODEV;
 	}
-	if (!strcmp(s, "ham1") || !strcmp(s, "sw") ||
-		!strcmp(s, "hw") || !strcmp(s, "hw-romcode"))
+
+	if (!strcmp(s, "sw"))
+		gpmc_nand_data->ecc_opt = OMAP_ECC_HAM1_CODE_SW;
+	else if (!strcmp(s, "ham1") ||
+		 !strcmp(s, "hw") || !strcmp(s, "hw-romcode"))
 		gpmc_nand_data->ecc_opt =
 				OMAP_ECC_HAM1_CODE_HW;
 	else if (!strcmp(s, "bch4"))
-- 
1.8.3.2

