Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbaHVNyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:54:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33538 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338AbaHVNyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:54:09 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 3/6] ARM: OMAP4+: PRM: register interrupt information from DT
Date: Fri, 22 Aug 2014 08:51:50 -0500
Message-ID: <1408715513-25851-4-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408715513-25851-1-git-send-email-nm@ti.com>
References: <1408715513-25851-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the PRM interrupt information to be picked up from device tree.
the only exception is for OMAP4 which uses values pre-populated and allows
compatibility with older dtb.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/prm44xx.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm/mach-omap2/prm44xx.c b/arch/arm/mach-omap2/prm44xx.c
index d4d745e..5a70c91 100644
--- a/arch/arm/mach-omap2/prm44xx.c
+++ b/arch/arm/mach-omap2/prm44xx.c
@@ -17,6 +17,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/of_irq.h>
 
 
 #include "soc.h"
@@ -699,11 +700,50 @@ int __init omap44xx_prm_init(void)
 	return prm_register(&omap44xx_prm_ll_data);
 }
 
+static struct of_device_id omap_prm_dt_match_table[] = {
+	{ .compatible = "ti,omap4-prm" },
+	{ .compatible = "ti,omap5-prm" },
+	{ .compatible = "ti,dra7-prm" },
+	{ }
+};
+
 static int omap44xx_prm_late_init(void)
 {
+	struct device_node *np;
+	int irq_num;
+
 	if (!(prm_features & PRM_HAS_IO_WAKEUP))
 		return 0;
 
+	/* OMAP4+ is DT only now */
+	if (!of_have_populated_dt())
+		return 0;
+
+	np = of_find_matching_node(NULL, omap_prm_dt_match_table);
+
+	if (!np) {
+		/* Default loaded up with OMAP4 values */
+		if (!cpu_is_omap44xx())
+			return 0;
+	} else {
+		irq_num = of_irq_get(np, 0);
+		/*
+		 * Already have OMAP4 IRQ num. For all other platforms, we need
+		 * IRQ numbers from DT
+		 */
+		if (irq_num < 0 && !cpu_is_omap44xx()) {
+			if (irq_num == -EPROBE_DEFER)
+				return irq_num;
+
+			/* Have nothing to do */
+			return 0;
+		}
+
+		/* Once OMAP4 DT is filled as well */
+		if (irq_num >= 0)
+			omap4_prcm_irq_setup.irq = irq_num;
+	}
+
 	omap44xx_prm_enable_io_wakeup();
 
 	return omap_prcm_register_chain_handler(&omap4_prcm_irq_setup);
-- 
1.7.9.5

