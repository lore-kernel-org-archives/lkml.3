Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbaLVWRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:17:35 -0500
Received: from sauhun.de ([89.238.76.85]:53777 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702AbaLVWRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:17:33 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: linux-gpio@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 1/3] gpu: drm: tilcdc: don't use devm_pinctrl_get_select_default() in probe
Date: Mon, 22 Dec 2014 23:16:53 +0100
Message-Id: <1419286616-9893-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ab78029ecc34 (drivers/pinctrl: grab default handles from device
core), we can rely on device core for setting the default pins.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/gpu/drm/tilcdc/tilcdc_panel.c  | 7 -------
 drivers/gpu/drm/tilcdc/tilcdc_slave.c  | 7 -------
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c | 7 -------
 3 files changed, 21 deletions(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_panel.c b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
index 7a0315855e90..5aec25d273f4 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_panel.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
@@ -15,8 +15,6 @@
  * this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#include <linux/pinctrl/pinmux.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/backlight.h>
 #include <linux/gpio/consumer.h>
 #include <video/display_timing.h>
@@ -351,7 +349,6 @@ static int panel_probe(struct platform_device *pdev)
 	struct device_node *bl_node, *node = pdev->dev.of_node;
 	struct panel_module *panel_mod;
 	struct tilcdc_module *mod;
-	struct pinctrl *pinctrl;
 	int ret;
 
 	/* bail out early if no DT data: */
@@ -399,10 +396,6 @@ static int panel_probe(struct platform_device *pdev)
 
 	tilcdc_module_init(mod, "panel", &panel_module_ops);
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev, "pins are not configured\n");
-
 	panel_mod->timings = of_get_display_timings(node);
 	if (!panel_mod->timings) {
 		dev_err(&pdev->dev, "could not get panel timings\n");
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_slave.c b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
index 3775fd49dac4..67cae0846365 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_slave.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
@@ -16,8 +16,6 @@
  */
 
 #include <linux/i2c.h>
-#include <linux/pinctrl/pinmux.h>
-#include <linux/pinctrl/consumer.h>
 #include <drm/drm_encoder_slave.h>
 
 #include "tilcdc_drv.h"
@@ -312,7 +310,6 @@ static int slave_probe(struct platform_device *pdev)
 	struct device_node *i2c_node;
 	struct slave_module *slave_mod;
 	struct tilcdc_module *mod;
-	struct pinctrl *pinctrl;
 	uint32_t i2c_phandle;
 	struct i2c_adapter *slavei2c;
 	int ret = -EINVAL;
@@ -361,10 +358,6 @@ static int slave_probe(struct platform_device *pdev)
 
 	tilcdc_module_init(mod, "slave", &slave_module_ops);
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev, "pins are not configured\n");
-
 	tilcdc_slave_probedefer(false);
 
 	return 0;
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
index 354c47ca6374..205f46135da4 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
@@ -18,8 +18,6 @@
 #include <linux/i2c.h>
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
-#include <linux/pinctrl/pinmux.h>
-#include <linux/pinctrl/consumer.h>
 
 #include "tilcdc_drv.h"
 
@@ -312,7 +310,6 @@ static int tfp410_probe(struct platform_device *pdev)
 	struct device_node *i2c_node;
 	struct tfp410_module *tfp410_mod;
 	struct tilcdc_module *mod;
-	struct pinctrl *pinctrl;
 	uint32_t i2c_phandle;
 	int ret = -EINVAL;
 
@@ -331,10 +328,6 @@ static int tfp410_probe(struct platform_device *pdev)
 
 	tilcdc_module_init(mod, "tfp410", &tfp410_module_ops);
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev, "pins are not configured\n");
-
 	if (of_property_read_u32(node, "i2c", &i2c_phandle)) {
 		dev_err(&pdev->dev, "could not get i2c bus phandle\n");
 		goto fail;
-- 
2.1.3

