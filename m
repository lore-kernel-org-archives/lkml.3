Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaILNQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:16:08 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:58625 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbaILNP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:15:26 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/4] irqchip: renesas-intc-irqpin: Add minimal runtime PM support
Date: Fri, 12 Sep 2014 15:15:18 +0200
Message-Id: <1410527720-18061-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410527720-18061-1-git-send-email-geert+renesas@glider.be>
References: <1410527720-18061-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just enough to let pm_clk_*() enable the functional clock, and
manage it for suspend/resume, if present.
Before, it was assumed enabled by the bootloader or reset state.

To prevent the clock from being disabled while the module is needed for
wake-up, implement irq_chip.irq_set_wake(), which increments/decrements
the clock's enable_count when needed.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/irqchip/irq-renesas-intc-irqpin.c | 38 +++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-intc-irqpin.c b/drivers/irqchip/irq-renesas-intc-irqpin.c
index a6b205b72c9b..542e850f4946 100644
--- a/drivers/irqchip/irq-renesas-intc-irqpin.c
+++ b/drivers/irqchip/irq-renesas-intc-irqpin.c
@@ -17,6 +17,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/clk.h>
 #include <linux/init.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -30,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/platform_data/irq-renesas-intc-irqpin.h>
+#include <linux/pm_runtime.h>
 
 #define INTC_IRQPIN_MAX 8 /* maximum 8 interrupts per driver instance */
 
@@ -75,6 +77,7 @@ struct intc_irqpin_priv {
 	struct platform_device *pdev;
 	struct irq_chip irq_chip;
 	struct irq_domain *irq_domain;
+	struct clk *clk;
 	bool shared_irqs;
 	u8 shared_irq_mask;
 };
@@ -270,6 +273,21 @@ static int intc_irqpin_irq_set_type(struct irq_data *d, unsigned int type)
 				     value ^ INTC_IRQ_SENSE_VALID);
 }
 
+static int intc_irqpin_irq_set_wake(struct irq_data *d, unsigned int on)
+{
+	struct intc_irqpin_priv *p = irq_data_get_irq_chip_data(d);
+
+	if (!p->clk)
+		return 0;
+
+	if (on)
+		clk_enable(p->clk);
+	else
+		clk_disable(p->clk);
+
+	return 0;
+}
+
 static irqreturn_t intc_irqpin_irq_handler(int irq, void *dev_id)
 {
 	struct intc_irqpin_irq *i = dev_id;
@@ -346,8 +364,7 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 	p = devm_kzalloc(dev, sizeof(*p), GFP_KERNEL);
 	if (!p) {
 		dev_err(dev, "failed to allocate driver data\n");
-		ret = -ENOMEM;
-		goto err0;
+		return -ENOMEM;
 	}
 
 	/* deal with driver instance configuration */
@@ -365,6 +382,15 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 	p->pdev = pdev;
 	platform_set_drvdata(pdev, p);
 
+	p->clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(p->clk)) {
+		dev_warn(dev, "unable to get clock\n");
+		p->clk = NULL;
+	}
+
+	pm_runtime_enable(dev);
+	pm_runtime_get_sync(dev);
+
 	/* get hold of manadatory IOMEM */
 	for (k = 0; k < INTC_IRQPIN_REG_NR; k++) {
 		io[k] = platform_get_resource(pdev, IORESOURCE_MEM, k);
@@ -456,7 +482,8 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 	irq_chip->irq_mask = disable_fn;
 	irq_chip->irq_unmask = enable_fn;
 	irq_chip->irq_set_type = intc_irqpin_irq_set_type;
-	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE | IRQCHIP_MASK_ON_SUSPEND;
+	irq_chip->irq_set_wake = intc_irqpin_irq_set_wake;
+	irq_chip->flags	= IRQCHIP_MASK_ON_SUSPEND;
 
 	p->irq_domain = irq_domain_add_simple(dev->of_node,
 					      p->number_of_irqs,
@@ -508,6 +535,8 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 err1:
 	irq_domain_remove(p->irq_domain);
 err0:
+	pm_runtime_put(dev);
+	pm_runtime_disable(dev);
 	return ret;
 }
 
@@ -516,7 +545,8 @@ static int intc_irqpin_remove(struct platform_device *pdev)
 	struct intc_irqpin_priv *p = platform_get_drvdata(pdev);
 
 	irq_domain_remove(p->irq_domain);
-
+	pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	return 0;
 }
 
-- 
1.9.1

