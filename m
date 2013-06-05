Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3FEJvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:51:03 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:34379 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3FEJvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:51:01 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv4] ARM: at91: Fix link breakage when !CONFIG_PHYLIB
Date: Wed,  5 Jun 2013 11:50:43 +0200
Message-Id: <1370425843-6802-1-git-send-email-alexandre.belloni@free-electrons.com>
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
---
 arch/arm/mach-at91/Kconfig          | 1 +
 arch/arm/mach-at91/board-dt-sama5.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 0280238..699b71e 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -163,6 +163,7 @@ config MACH_SAMA5_DT
 	bool "Atmel SAMA5 Evaluation Kits with device-tree support"
 	depends on SOC_SAMA5
 	select USE_OF
+	select PHYLIB if NETDEVICES
 	help
 	  Select this if you want to experiment device-tree with
 	  an Atmel Evaluation Kit.
diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index 705305e..ad95f6a 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -62,7 +62,8 @@ static int ksz9021rn_phy_fixup(struct phy_device *phy)
 
 static void __init sama5_dt_device_init(void)
 {
-	if (of_machine_is_compatible("atmel,sama5d3xcm"))
+	if (of_machine_is_compatible("atmel,sama5d3xcm") &&
+	    IS_ENABLED(CONFIG_PHYLIB))
 		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
 			ksz9021rn_phy_fixup);
 
-- 
1.8.1.2

