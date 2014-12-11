Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbaLKHiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 02:38:24 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:55464 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753061AbaLKHiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 02:38:22 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <wenyou.yang@atmel.com>
Subject: [PATCH] ARM: at91: board-dt-sama5: add phy_fixup to override NAND_Tree which improperly strapp-in during the reset period.
Date: Thu, 11 Dec 2014 15:31:09 +0800
Message-ID: <1418283069-5648-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Appearance: On some SAMA5D4EK boards, after power up, the Eth1 doesn't work.

Reason: The PIOE2 pin is connected to the NAND_Tree# of KSZ8081,
But it outputs LOW during the reset period, which cause the NAND_Tree# enabled.

Add phy_fixup() to disable NAND_Tree by overriding the Operation
Mode Strap Override register(i.e. Register 16h) to clear the NAND_Tree bit.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/mach-at91/board-dt-sama5.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index 8fb9ef5..97f7367 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -17,6 +17,7 @@
 #include <linux/of_platform.h>
 #include <linux/phy.h>
 #include <linux/clk-provider.h>
+#include <linux/phy.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -26,8 +27,25 @@
 
 #include "generic.h"
 
+static int ksz8081_phy_fixup(struct phy_device *phy)
+{
+	int value;
+
+	value = phy_read(phy, 0x16);
+	value &= ~0x20;
+	phy_write(phy, 0x16, value);
+
+	return 0;
+}
+
 static void __init sama5_dt_device_init(void)
 {
+	if (of_machine_is_compatible("atmel,sama5d4ek") &&
+	   IS_ENABLED(CONFIG_PHYLIB)) {
+		phy_register_fixup_for_id("fc028000.etherne:00",
+						ksz8081_phy_fixup);
+	}
+
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-- 
1.7.9.5

