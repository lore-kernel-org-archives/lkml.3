Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaLQNkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 08:40:52 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:32860 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaLQNku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 08:40:50 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] ARM: shmobile: r8a7740: Instantiate GIC from C board code in legacy builds
Date: Wed, 17 Dec 2014 14:40:42 +0100
Message-Id: <1418823642-28154-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit 9a1091ef0017c40a ("irqchip: gic: Support hierarchy irq
domain."), armadillo-legacy hangs during boot with:

     sh-tmu.0: ch0: used for clock events
     sh-tmu.0: ch0: used for periodic clock events
     sh-tmu.0: ch0: failed to request irq 230
     sh-tmu.0: ch1: used as clock source
     sh-cmt-48.1: ch0: failed to request irq 90
     sh-cmt-48.1: ch0: registration failed
    earlytimer: unable to probe sh-cmt-48 early.
    Calibrating delay loop...

This happens because the IRQ numbers of the GIC are now virtual, and no
longer match the hardcoded hardware IRQ numbers in the platform board
code.
To fix this, instantiate the GIC from platform board code when compiling
a legacy kernel, like is done on sh73a0 for kzm9g-legacy.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/mach-shmobile/setup-r8a7740.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/mach-shmobile/setup-r8a7740.c b/arch/arm/mach-shmobile/setup-r8a7740.c
index 79ad93dfdae4ee70..d191cf4197313482 100644
--- a/arch/arm/mach-shmobile/setup-r8a7740.c
+++ b/arch/arm/mach-shmobile/setup-r8a7740.c
@@ -800,7 +800,14 @@ void __init r8a7740_init_irq_of(void)
 	void __iomem *intc_msk_base = ioremap_nocache(0xe6900040, 0x10);
 	void __iomem *pfc_inta_ctrl = ioremap_nocache(0xe605807c, 0x4);
 
+#ifdef CONFIG_ARCH_SHMOBILE_LEGACY
+	void __iomem *gic_dist_base = ioremap_nocache(0xc2800000, 0x1000);
+	void __iomem *gic_cpu_base = ioremap_nocache(0xc2000000, 0x1000);
+
+	gic_init(0, 29, gic_dist_base, gic_cpu_base);
+#else
 	irqchip_init();
+#endif
 
 	/* route signals to GIC */
 	iowrite32(0x0, pfc_inta_ctrl);
-- 
1.9.1

