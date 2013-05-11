Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab3EKBIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 21:08:22 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35554 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab3EKBIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 21:08:20 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] clk: mvebu: introduce per-clock-gate flags
Date: Sat, 11 May 2013 03:08:01 +0200
Message-Id: <1368234490-31416-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clock gates found on MVEBU SoCs get registered by a common function.
To allow specific SoCs to provide tweaks introduce flags to the clock
gate descriptor instead of filling up the common function SoC specific
tweaks.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/mvebu/clk-gating-ctrl.c |  153 +++++++++++++++++------------------
 1 file changed, 72 insertions(+), 81 deletions(-)

diff --git a/drivers/clk/mvebu/clk-gating-ctrl.c b/drivers/clk/mvebu/clk-gating-ctrl.c
index ebf141d..a88e09b 100644
--- a/drivers/clk/mvebu/clk-gating-ctrl.c
+++ b/drivers/clk/mvebu/clk-gating-ctrl.c
@@ -28,6 +28,7 @@ struct mvebu_soc_descr {
 	const char *name;
 	const char *parent;
 	int bit_idx;
+	unsigned long flags;
 };
 
 #define to_clk_gate(_hw) container_of(_hw, struct clk_gate, hw)
@@ -88,21 +89,11 @@ static void __init mvebu_clk_gating_setup(
 	}
 
 	for (n = 0; n < ctrl->num_gates; n++) {
-		u8 flags = 0;
 		const char *parent =
 			(descr[n].parent) ? descr[n].parent : default_parent;
-
-		/*
-		 * On Armada 370, the DDR clock is a special case: it
-		 * isn't taken by any driver, but should anyway be
-		 * kept enabled, so we mark it as IGNORE_UNUSED for
-		 * now.
-		 */
-		if (!strcmp(descr[n].name, "ddr"))
-			flags |= CLK_IGNORE_UNUSED;
-
 		ctrl->gates[n] = clk_register_gate(NULL, descr[n].name, parent,
-				   flags, base, descr[n].bit_idx, 0, &ctrl->lock);
+					descr[n].flags, base, descr[n].bit_idx,
+					0, &ctrl->lock);
 		WARN_ON(IS_ERR(ctrl->gates[n]));
 	}
 	of_clk_add_provider(np, mvebu_clk_gating_get_src, ctrl);
@@ -114,93 +105,93 @@ static void __init mvebu_clk_gating_setup(
 
 #ifdef CONFIG_MACH_ARMADA_370
 static const struct mvebu_soc_descr __initconst armada_370_gating_descr[] = {
-	{ "audio", NULL, 0 },
-	{ "pex0_en", NULL, 1 },
-	{ "pex1_en", NULL,  2 },
-	{ "ge1", NULL, 3 },
-	{ "ge0", NULL, 4 },
-	{ "pex0", NULL, 5 },
-	{ "pex1", NULL, 9 },
-	{ "sata0", NULL, 15 },
-	{ "sdio", NULL, 17 },
-	{ "tdm", NULL, 25 },
-	{ "ddr", NULL, 28 },
-	{ "sata1", NULL, 30 },
+	{ "audio", NULL, 0, 0 },
+	{ "pex0_en", NULL, 1, 0 },
+	{ "pex1_en", NULL,  2, 0 },
+	{ "ge1", NULL, 3, 0 },
+	{ "ge0", NULL, 4, 0 },
+	{ "pex0", NULL, 5, 0 },
+	{ "pex1", NULL, 9, 0 },
+	{ "sata0", NULL, 15, 0 },
+	{ "sdio", NULL, 17, 0 },
+	{ "tdm", NULL, 25, 0 },
+	{ "ddr", NULL, 28, CLK_IGNORE_UNUSED },
+	{ "sata1", NULL, 30, 0 },
 	{ }
 };
 #endif
 
 #ifdef CONFIG_MACH_ARMADA_XP
 static const struct mvebu_soc_descr __initconst armada_xp_gating_descr[] = {
-	{ "audio", NULL, 0 },
-	{ "ge3", NULL, 1 },
-	{ "ge2", NULL,  2 },
-	{ "ge1", NULL, 3 },
-	{ "ge0", NULL, 4 },
-	{ "pex0", NULL, 5 },
-	{ "pex1", NULL, 6 },
-	{ "pex2", NULL, 7 },
-	{ "pex3", NULL, 8 },
-	{ "bp", NULL, 13 },
-	{ "sata0lnk", NULL, 14 },
-	{ "sata0", "sata0lnk", 15 },
-	{ "lcd", NULL, 16 },
-	{ "sdio", NULL, 17 },
-	{ "usb0", NULL, 18 },
-	{ "usb1", NULL, 19 },
-	{ "usb2", NULL, 20 },
-	{ "xor0", NULL, 22 },
-	{ "crypto", NULL, 23 },
-	{ "tdm", NULL, 25 },
-	{ "xor1", NULL, 28 },
-	{ "sata1lnk", NULL, 29 },
-	{ "sata1", "sata1lnk", 30 },
+	{ "audio", NULL, 0, 0 },
+	{ "ge3", NULL, 1, 0 },
+	{ "ge2", NULL,  2, 0 },
+	{ "ge1", NULL, 3, 0 },
+	{ "ge0", NULL, 4, 0 },
+	{ "pex0", NULL, 5, 0 },
+	{ "pex1", NULL, 6, 0 },
+	{ "pex2", NULL, 7, 0 },
+	{ "pex3", NULL, 8, 0 },
+	{ "bp", NULL, 13, 0 },
+	{ "sata0lnk", NULL, 14, 0 },
+	{ "sata0", "sata0lnk", 15, 0 },
+	{ "lcd", NULL, 16, 0 },
+	{ "sdio", NULL, 17, 0 },
+	{ "usb0", NULL, 18, 0 },
+	{ "usb1", NULL, 19, 0 },
+	{ "usb2", NULL, 20, 0 },
+	{ "xor0", NULL, 22, 0 },
+	{ "crypto", NULL, 23, 0 },
+	{ "tdm", NULL, 25, 0 },
+	{ "xor1", NULL, 28, 0 },
+	{ "sata1lnk", NULL, 29, 0 },
+	{ "sata1", "sata1lnk", 30, 0 },
 	{ }
 };
 #endif
 
 #ifdef CONFIG_ARCH_DOVE
 static const struct mvebu_soc_descr __initconst dove_gating_descr[] = {
-	{ "usb0", NULL, 0 },
-	{ "usb1", NULL, 1 },
-	{ "ge", "gephy", 2 },
-	{ "sata", NULL, 3 },
-	{ "pex0", NULL, 4 },
-	{ "pex1", NULL, 5 },
-	{ "sdio0", NULL, 8 },
-	{ "sdio1", NULL, 9 },
-	{ "nand", NULL, 10 },
-	{ "camera", NULL, 11 },
-	{ "i2s0", NULL, 12 },
-	{ "i2s1", NULL, 13 },
-	{ "crypto", NULL, 15 },
-	{ "ac97", NULL, 21 },
-	{ "pdma", NULL, 22 },
-	{ "xor0", NULL, 23 },
-	{ "xor1", NULL, 24 },
-	{ "gephy", NULL, 30 },
+	{ "usb0", NULL, 0, 0 },
+	{ "usb1", NULL, 1, 0 },
+	{ "ge", "gephy", 2, 0 },
+	{ "sata", NULL, 3, 0 },
+	{ "pex0", NULL, 4, 0 },
+	{ "pex1", NULL, 5, 0 },
+	{ "sdio0", NULL, 8, 0 },
+	{ "sdio1", NULL, 9, 0 },
+	{ "nand", NULL, 10, 0 },
+	{ "camera", NULL, 11, 0 },
+	{ "i2s0", NULL, 12, 0 },
+	{ "i2s1", NULL, 13, 0 },
+	{ "crypto", NULL, 15, 0 },
+	{ "ac97", NULL, 21, 0 },
+	{ "pdma", NULL, 22, 0 },
+	{ "xor0", NULL, 23, 0 },
+	{ "xor1", NULL, 24, 0 },
+	{ "gephy", NULL, 30, 0 },
 	{ }
 };
 #endif
 
 #ifdef CONFIG_ARCH_KIRKWOOD
 static const struct mvebu_soc_descr __initconst kirkwood_gating_descr[] = {
-	{ "ge0", NULL, 0 },
-	{ "pex0", NULL, 2 },
-	{ "usb0", NULL, 3 },
-	{ "sdio", NULL, 4 },
-	{ "tsu", NULL, 5 },
-	{ "runit", NULL, 7 },
-	{ "xor0", NULL, 8 },
-	{ "audio", NULL, 9 },
-	{ "powersave", "cpuclk", 11 },
-	{ "sata0", NULL, 14 },
-	{ "sata1", NULL, 15 },
-	{ "xor1", NULL, 16 },
-	{ "crypto", NULL, 17 },
-	{ "pex1", NULL, 18 },
-	{ "ge1", NULL, 19 },
-	{ "tdm", NULL, 20 },
+	{ "ge0", NULL, 0, 0 },
+	{ "pex0", NULL, 2, 0 },
+	{ "usb0", NULL, 3, 0 },
+	{ "sdio", NULL, 4, 0 },
+	{ "tsu", NULL, 5, 0 },
+	{ "runit", NULL, 7, 0 },
+	{ "xor0", NULL, 8, 0 },
+	{ "audio", NULL, 9, 0 },
+	{ "powersave", "cpuclk", 11, 0 },
+	{ "sata0", NULL, 14, 0 },
+	{ "sata1", NULL, 15, 0 },
+	{ "xor1", NULL, 16, 0 },
+	{ "crypto", NULL, 17, 0 },
+	{ "pex1", NULL, 18, 0 },
+	{ "ge1", NULL, 19, 0 },
+	{ "tdm", NULL, 20, 0 },
 	{ }
 };
 #endif
-- 
1.7.10.4

