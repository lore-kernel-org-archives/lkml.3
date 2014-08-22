Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbaHVNzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:55:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32877 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbaHVNyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:54:10 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 6/6] ARM: OMAP3+: PRM: register interrupt information from DT
Date: Fri, 22 Aug 2014 08:51:53 -0500
Message-ID: <1408715513-25851-7-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408715513-25851-1-git-send-email-nm@ti.com>
References: <1408715513-25851-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the PRM interrupt information to be picked up from device tree.
OMAP3 may use legacy boot and needs to be compatible with old dtbs
(without interrupt populated), for these, we use the value which is
pre-populated.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/prm3xxx.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/mach-omap2/prm3xxx.c b/arch/arm/mach-omap2/prm3xxx.c
index 2458be6..e0088e0 100644
--- a/arch/arm/mach-omap2/prm3xxx.c
+++ b/arch/arm/mach-omap2/prm3xxx.c
@@ -17,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/of_irq.h>
 
 #include "soc.h"
 #include "common.h"
@@ -649,6 +650,11 @@ int __init omap3xxx_prm_init(void)
 	return prm_register(&omap3xxx_prm_ll_data);
 }
 
+static struct of_device_id omap3_prm_dt_match_table[] = {
+	{ .compatible = "ti,omap3-prm" },
+	{ }
+};
+
 static int omap3xxx_prm_late_init(void)
 {
 	int ret;
@@ -656,6 +662,18 @@ static int omap3xxx_prm_late_init(void)
 	if (!(prm_features & PRM_HAS_IO_WAKEUP))
 		return 0;
 
+	if (of_have_populated_dt()) {
+		struct device_node *np;
+		int irq_num;
+
+		np = of_find_matching_node(NULL, omap3_prm_dt_match_table);
+		if (np) {
+			irq_num = of_irq_get(np, 0);
+			if (irq_num >= 0)
+				omap3_prcm_irq_setup.irq = irq_num;
+		}
+	}
+
 	omap3xxx_prm_enable_io_wakeup();
 	ret = omap_prcm_register_chain_handler(&omap3_prcm_irq_setup);
 	if (!ret)
-- 
1.7.9.5

