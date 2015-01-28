Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934058AbbA1CLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:11:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539AbbA1B2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.18 29/61] irqchip: omap-intc: Fix legacy DMA regression
Date: Tue, 27 Jan 2015 17:26:41 -0800
Message-Id: <20150128012640.069725892@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 4b149e417463bbb6d1d9b805f729627ca2b54495 upstream.

commit 55601c9f2467 (arm: omap: intc: switch over
to linear irq domain) introduced a regression with
SDMA legacy driver because that driver strictly depends
on INTC's IRQs starting at NR_IRQs. Aparently
irq_domain_add_linear() won't guarantee that, since we see
a 7 IRQs difference when booting with and without the
commit cited above.

Until arch/arm/plat-omap/dma.c is properly fixed, we
must maintain OMAP2/3 using irq_domain_add_legacy().

A FIXME note was added so people know to delete that
code once that legacy DMA driver is fixed up.

Fixes: 55601c9f2467 (arm: omap: intc: switch over to linear irq domain)
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Link: https://lkml.kernel.org/r/1420576688-10604-1-git-send-email-balbi@ti.com
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/irqchip/irq-omap-intc.c b/drivers/irqchip/irq-omap-intc.c
index 28718d3e8281..c03f140acbae 100644
--- a/drivers/irqchip/irq-omap-intc.c
+++ b/drivers/irqchip/irq-omap-intc.c
@@ -263,7 +263,7 @@ static int __init omap_init_irq_of(struct device_node *node)
 	return ret;
 }
 
-static int __init omap_init_irq_legacy(u32 base)
+static int __init omap_init_irq_legacy(u32 base, struct device_node *node)
 {
 	int j, irq_base;
 
@@ -277,7 +277,7 @@ static int __init omap_init_irq_legacy(u32 base)
 		irq_base = 0;
 	}
 
-	domain = irq_domain_add_legacy(NULL, omap_nr_irqs, irq_base, 0,
+	domain = irq_domain_add_legacy(node, omap_nr_irqs, irq_base, 0,
 			&irq_domain_simple_ops, NULL);
 
 	omap_irq_soft_reset();
@@ -301,10 +301,26 @@ static int __init omap_init_irq(u32 base, struct device_node *node)
 {
 	int ret;
 
-	if (node)
+	/*
+	 * FIXME legacy OMAP DMA driver sitting under arch/arm/plat-omap/dma.c
+	 * depends is still not ready for linear IRQ domains; because of that
+	 * we need to temporarily "blacklist" OMAP2 and OMAP3 devices from using
+	 * linear IRQ Domain until that driver is finally fixed.
+	 */
+	if (of_device_is_compatible(node, "ti,omap2-intc") ||
+			of_device_is_compatible(node, "ti,omap3-intc")) {
+		struct resource res;
+
+		if (of_address_to_resource(node, 0, &res))
+			return -ENOMEM;
+
+		base = res.start;
+		ret = omap_init_irq_legacy(base, node);
+	} else if (node) {
 		ret = omap_init_irq_of(node);
-	else
-		ret = omap_init_irq_legacy(base);
+	} else {
+		ret = omap_init_irq_legacy(base, NULL);
+	}
 
 	if (ret == 0)
 		omap_irq_enable_protection();


