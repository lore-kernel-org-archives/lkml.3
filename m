Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab3E0Ksc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:48:32 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51118 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab3E0Ksa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:48:30 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v3] ARM: at91: Fix link breakage when !CONFIG_PHYLIB
Date: Mon, 27 May 2013 12:48:22 +0200
Message-Id: <1369651702-9207-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes:
arch/arm/mach-at91/built-in.o: In function `ksz9021rn_phy_fixup':
:(.text+0x1174): undefined reference to `mdiobus_write'
:(.text+0x1188): undefined reference to `mdiobus_write'
:(.text+0x119c): undefined reference to `mdiobus_write'
:(.text+0x11b0): undefined reference to `mdiobus_write'
arch/arm/mach-at91/built-in.o: In function `sama5_dt_device_init':
:(.init.text+0x1e34): undefined reference to `phy_register_fixup_for_uid'

when CONFIG_PHYLIB is not selected.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
---
Changes in v3:
	added SoB
	added Acked-By

Changes in v2:
	use IS_BUILTIN
	use CONFIG_PHYLIB and not CONFIG_PHY

 arch/arm/mach-at91/board-dt-sama5.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index 705305e..e9ce541 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -47,22 +47,24 @@ static int ksz9021rn_phy_fixup(struct phy_device *phy)
 #define GMII_ERCR	11
 #define GMII_ERDWR	12
 
-	/* Set delay values */
-	value = GMII_RCCPSR | 0x8000;
-	phy_write(phy, GMII_ERCR, value);
-	value = 0xF2F4;
-	phy_write(phy, GMII_ERDWR, value);
-	value = GMII_RRDPSR | 0x8000;
-	phy_write(phy, GMII_ERCR, value);
-	value = 0x2222;
-	phy_write(phy, GMII_ERDWR, value);
+	if (IS_BUILTIN(CONFIG_PHYLIB)) {
+		/* Set delay values */
+		value = GMII_RCCPSR | 0x8000;
+		phy_write(phy, GMII_ERCR, value);
+		value = 0xF2F4;
+		phy_write(phy, GMII_ERDWR, value);
+		value = GMII_RRDPSR | 0x8000;
+		phy_write(phy, GMII_ERCR, value);
+		value = 0x2222;
+		phy_write(phy, GMII_ERDWR, value);
+	}
 
 	return 0;
 }
 
 static void __init sama5_dt_device_init(void)
 {
-	if (of_machine_is_compatible("atmel,sama5d3xcm"))
+	if (of_machine_is_compatible("atmel,sama5d3xcm") && IS_BUILTIN(CONFIG_PHYLIB))
 		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
 			ksz9021rn_phy_fixup);
 
-- 
1.8.1.2

