Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaG1VSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:18:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55568 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbaG1VRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:41 -0400
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 24/35] arm: omap: irq: drop omap2_intc_handle_irq()
Date: Mon, 28 Jul 2014 16:16:12 -0500
Message-ID: <1406582183-696-25-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

that was just a no-op wrapper around omap_intc_handle_irq
anyway.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/common.h |  1 -
 arch/arm/mach-omap2/irq.c    | 16 ++++++----------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index bc3208b..1dd0021 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -219,7 +219,6 @@ void omap_intc_restore_context(void);
 void omap3_intc_suspend(void);
 void omap3_intc_prepare_idle(void);
 void omap3_intc_resume_idle(void);
-void omap2_intc_handle_irq(struct pt_regs *regs);
 void omap_gic_of_init(void);
 
 #ifdef CONFIG_CACHE_L2X0
diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 4dfeac6..14716a8 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -234,7 +234,8 @@ static void __init omap_init_irq(u32 base, int nr_irqs,
 		omap_alloc_gc(omap_irq_base + j, j + irq_base, 32);
 }
 
-static inline void omap_intc_handle_irq(struct pt_regs *regs)
+static asmlinkage void __exception_irq_entry
+omap_intc_handle_irq(struct pt_regs *regs)
 {
 	u32 irqnr;
 	int handled_irq = 0;
@@ -276,27 +277,22 @@ out:
 		omap_ack_irq(NULL);
 }
 
-asmlinkage void __exception_irq_entry omap2_intc_handle_irq(struct pt_regs *regs)
-{
-	omap_intc_handle_irq(regs);
-}
-
 void __init omap2_init_irq(void)
 {
 	omap_init_irq(OMAP24XX_IC_BASE, 96, NULL);
-	set_handle_irq(omap2_intc_handle_irq);
+	set_handle_irq(omap_intc_handle_irq);
 }
 
 void __init omap3_init_irq(void)
 {
 	omap_init_irq(OMAP34XX_IC_BASE, 96, NULL);
-	set_handle_irq(omap2_intc_handle_irq);
+	set_handle_irq(omap_intc_handle_irq);
 }
 
 void __init ti81xx_init_irq(void)
 {
 	omap_init_irq(OMAP34XX_IC_BASE, 128, NULL);
-	set_handle_irq(omap2_intc_handle_irq);
+	set_handle_irq(omap_intc_handle_irq);
 }
 
 static int __init intc_of_init(struct device_node *node,
@@ -318,7 +314,7 @@ static int __init intc_of_init(struct device_node *node,
 
 	omap_init_irq(res.start, nr_irq, of_node_get(node));
 
-	set_handle_irq(omap2_intc_handle_irq);
+	set_handle_irq(omap_intc_handle_irq);
 
 	return 0;
 }
-- 
2.0.1.563.g66f467c

