Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab3JCFmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 01:42:32 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:18970 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755728Ab3JCFm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 01:42:29 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18HuRaaSNs2oRzhg3tVTYH2
Subject: [PATCH 5/6] pinctrl: single: Add support for auxdata
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>, linux-omap@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>
Date: Wed, 02 Oct 2013 22:42:26 -0700
Message-ID: <20131003054226.8941.80570.stgit@localhost>
In-Reply-To: <20131003054104.8941.88857.stgit@localhost>
References: <20131003054104.8941.88857.stgit@localhost>
User-Agent: StGit/0.16-1-ga54b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For omaps, we still have dependencies to the legacy code
for handling the PRM (Power Reset Management) interrupts,
and also for reconfiguring the io wake-up chain after
changes.

Let's pass the PRM interrupt and the rearm functions via
auxdata. Then when at some point we have a proper PRM
driver, we can get the interrupt via device tree and
set up the rearm function as exported function in the
PRM driver.

By using auxdata we can remove a dependency to the
wake-up events for converting omap3 to be device
tree only.

Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Prakash Manjunathappa <prakash.pm@ti.com>
Cc: Roger Quadros <rogerq@ti.com>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/pinctrl/pinctrl-single.c             |   23 +++++++++++++++++++++++
 include/linux/platform_data/pinctrl-single.h |   12 ++++++++++++
 2 files changed, 35 insertions(+)
 create mode 100644 include/linux/platform_data/pinctrl-single.h

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index b4ff055..e7092e8 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -28,6 +28,8 @@
 #include <linux/pinctrl/pinmux.h>
 #include <linux/pinctrl/pinconf-generic.h>
 
+#include <linux/platform_data/pinctrl-single.h>
+
 #include "core.h"
 #include "pinconf.h"
 
@@ -159,12 +161,14 @@ struct pcs_name {
  * @irq:	optional interrupt for the controller
  * @irq_enable_mask:	optional SoC specific interrupt enable mask
  * @irq_status_mask:	optional SoC specific interrupt status mask
+ * @rearm:	optional SoC specific wake-up rearm function
  */
 struct pcs_soc_data {
 	unsigned flags;
 	int irq;
 	unsigned irq_enable_mask;
 	unsigned irq_status_mask;
+	void (*rearm)(void);
 };
 
 /**
@@ -1622,6 +1626,8 @@ static void pcs_irq_unmask(struct irq_data *d)
 	struct pcs_soc_data *pcs_soc = irq_data_get_irq_chip_data(d);
 
 	pcs_irq_set(pcs_soc, d->irq, true);
+	if (pcs_soc->rearm)
+		pcs_soc->rearm();
 }
 
 /**
@@ -1672,6 +1678,11 @@ static int pcs_irq_handle(struct pcs_soc_data *pcs_soc)
 		}
 	}
 
+	/*
+	 * For debugging on omaps, you may want to call pcs_soc->rearm()
+	 * here to see wake-up interrupts during runtime also.
+	 */
+
 	return count;
 }
 
@@ -1838,6 +1849,7 @@ static int pcs_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	const struct of_device_id *match;
+	struct pcs_pdata *pdata;
 	struct resource *res;
 	struct pcs_device *pcs;
 	const struct pcs_soc_data *soc;
@@ -1952,6 +1964,17 @@ static int pcs_probe(struct platform_device *pdev)
 	if (pcs->socdata.irq)
 		pcs->flags |= PCS_FEAT_IRQ;
 
+	/* We still need auxdata for some omaps for PRM interrupts */
+	pdata = dev_get_platdata(&pdev->dev);
+	if (pdata) {
+		if (pdata->rearm)
+			pcs->socdata.rearm = pdata->rearm;
+		if (pdata->irq) {
+			pcs->socdata.irq = pdata->irq;
+			pcs->flags |= PCS_FEAT_IRQ;
+		}
+	}
+
 	if (PCS_HAS_IRQ) {
 		ret = pcs_irq_init_chained_handler(pcs, np);
 		if (ret < 0)
diff --git a/include/linux/platform_data/pinctrl-single.h b/include/linux/platform_data/pinctrl-single.h
new file mode 100644
index 0000000..72eacda
--- /dev/null
+++ b/include/linux/platform_data/pinctrl-single.h
@@ -0,0 +1,12 @@
+/**
+ * irq:		optional wake-up interrupt
+ * rearm:	optional soc specific rearm function
+ *
+ * Note that the irq and rearm setup should come from device
+ * tree except for omap where there are still some dependencies
+ * to the legacy PRM code.
+ */
+struct pcs_pdata {
+	int irq;
+	void (*rearm)(void);
+};

