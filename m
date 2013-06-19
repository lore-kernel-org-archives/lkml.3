Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096Ab3FSC3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 22:29:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49966 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933836Ab3FSC3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 22:29:17 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCHv4 1/6] thermal: ti-soc-thermal: use standard GPIO DT bindings
Date: Tue, 18 Jun 2013 22:28:58 -0400
Message-ID: <1371608938-25836-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1370637968-23299-2-git-send-email-eduardo.valentin@ti.com>
References: <1370637968-23299-2-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change updates the ti-soc-thermal driver to use
standard GPIO DT bindings to read the GPIO number associated
to thermal shutdown IRQ, in case the device features it.

Previously, the code was using a specific DT bindings.
As now OMAP supports the standard way to model GPIOs,
there is no point in having a ti specific binding.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt | 9 +++++----
 drivers/thermal/ti-soc-thermal/ti-bandgap.c                  | 8 ++------
 2 files changed, 7 insertions(+), 10 deletions(-)
---
Rui,

This is the rebased version of patch 01. It has been rebased on
your thermal/next. Please send it for 3.11. All remaining patches
on this series have been applied to respective for_3.11 branches
on corresponding trees.

diff --git a/Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt b/Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt
index 1953b33..0c9222d 100644
--- a/Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt
+++ b/Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt
@@ -17,8 +17,9 @@ Required properties:
 - interrupts : this entry should indicate which interrupt line
 the talert signal is routed to;
 Specific:
-- ti,tshut-gpio : this entry should be used to inform which GPIO
-line the tshut signal is routed to;
+- gpios : this entry should be used to inform which GPIO
+line the tshut signal is routed to. The informed GPIO will
+be treated as an IRQ;
 - regs : this entry must also be specified and it is specific
 to each bandgap version, because the mapping may change from
 soc to soc, apart of depending on available features.
@@ -37,7 +38,7 @@ bandgap {
 		0x4a002378 0x18>;
 	compatible = "ti,omap4460-bandgap";
 	interrupts = <0 126 4>; /* talert */
-	ti,tshut-gpio = <86>;
+	gpios = <&gpio3 22 0>; /* tshut */
 };
 
 OMAP4470:
@@ -47,7 +48,7 @@ bandgap {
 		0x4a002378 0x18>;
 	compatible = "ti,omap4470-bandgap";
 	interrupts = <0 126 4>; /* talert */
-	ti,tshut-gpio = <86>;
+	gpios = <&gpio3 22 0>; /* tshut */
 };
 
 OMAP5430:
diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index 7c0b3eb..9dfd471 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -38,6 +38,7 @@
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
 #include <linux/of_irq.h>
+#include <linux/of_gpio.h>
 #include <linux/io.h>
 
 #include "ti-bandgap.h"
@@ -1129,7 +1130,6 @@ static struct ti_bandgap *ti_bandgap_build(struct platform_device *pdev)
 	const struct of_device_id *of_id;
 	struct ti_bandgap *bgp;
 	struct resource *res;
-	u32 prop;
 	int i;
 
 	/* just for the sake */
@@ -1173,11 +1173,7 @@ static struct ti_bandgap *ti_bandgap_build(struct platform_device *pdev)
 	} while (res);
 
 	if (TI_BANDGAP_HAS(bgp, TSHUT)) {
-		if (of_property_read_u32(node, "ti,tshut-gpio", &prop) < 0) {
-			dev_err(&pdev->dev, "missing tshut gpio in device tree\n");
-			return ERR_PTR(-EINVAL);
-		}
-		bgp->tshut_gpio = prop;
+		bgp->tshut_gpio = of_get_gpio(node, 0);
 		if (!gpio_is_valid(bgp->tshut_gpio)) {
 			dev_err(&pdev->dev, "invalid gpio for tshut (%d)\n",
 				bgp->tshut_gpio);
-- 
1.8.2.1.342.gfa7285d

