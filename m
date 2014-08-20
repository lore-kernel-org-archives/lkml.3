Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaHTSyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 14:54:10 -0400
Received: from mail-pd0-f202.google.com ([209.85.192.202]:48817 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaHTSyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 14:54:07 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Caesar Wang <caesar.wang@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, olof@lixom.net,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 2/4] ARM: rockchip: rk3288: Switch to use the proper PWM IP
Date: Wed, 20 Aug 2014 11:54:00 -0700
Message-Id: <1408560842-3746-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1408560842-3746-1-git-send-email-dianders@chromium.org>
References: <1408560842-3746-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rk3288 SoC has an option to switch all of the PWMs in the system
between the old IP block and the new IP block.  The rk3288 PWM driver
is written for the new block, so make sure that we enable the new
block in the GRF (general register file) when the PWM driver probes.

We emulate the solution to this problem used in i2c-rk3x.c.  One
difference for the PWM is that there's a single "enable new IP" that's
used for all 4 PWMs.  That means we set this bit 4 times if we've got
all 4 PWMs enabled.  That shouldn't hurt.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v4:
- Totally rewrote to go in the PWM driver.
- Reordered IP switch to be atop invert patch.

Changes in v3: None
Changes in v2:
- Check for failed ioremap()

 .../devicetree/bindings/pwm/pwm-rockchip.txt       |  4 +++
 drivers/pwm/pwm-rockchip.c                         | 29 ++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt b/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
index b8be3d0..39190ec 100644
--- a/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
+++ b/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
@@ -10,6 +10,10 @@ Required properties:
  - #pwm-cells: must be 2 (rk2928) or 3 (rk3288). See pwm.txt in this directory
    for a description of the cell format.
 
+Required for "rockchip,rk3288-pwm":
+ - rockchip,grf : the phandle of the syscon node for the general register
+		  file (GRF)
+
 Example:
 
 	pwm0: pwm@20030000 {
diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
index 9442df2..08cbde6 100644
--- a/drivers/pwm/pwm-rockchip.c
+++ b/drivers/pwm/pwm-rockchip.c
@@ -16,7 +16,12 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/pwm.h>
+#include <linux/regmap.h>
 #include <linux/time.h>
+#include <linux/mfd/syscon.h>
+
+#define RK3288_GRF_PWM_ENABLE_OFFSET	0x024c
+#define RK3288_GRF_PWM_ENABLE_BIT	0
 
 #define PWM_CTRL_TIMER_EN	(1 << 0)
 #define PWM_CTRL_OUTPUT_EN	(1 << 3)
@@ -231,6 +236,7 @@ MODULE_DEVICE_TABLE(of, rockchip_pwm_dt_ids);
 
 static int rockchip_pwm_probe(struct platform_device *pdev)
 {
+	struct device_node *np = pdev->dev.of_node;
 	const struct of_device_id *id;
 	struct rockchip_pwm_chip *pc;
 	struct resource *r;
@@ -240,6 +246,29 @@ static int rockchip_pwm_probe(struct platform_device *pdev)
 	if (!id)
 		return -EINVAL;
 
+	/*
+	 * Switch to new interface on rk3288.
+	 * The control bit is located in the GRF register space.
+	 */
+	if (of_device_is_compatible(np, "rockchip,rk3288-pwm")) {
+		struct regmap *grf;
+
+		grf = syscon_regmap_lookup_by_phandle(np, "rockchip,grf");
+		if (IS_ERR(grf)) {
+			dev_err(&pdev->dev, "Missing rockchip,grf property\n");
+			return PTR_ERR(grf);
+		}
+
+		/* Set bit 16 for write mask, 0 for switch to new IP */
+		ret = regmap_write(grf, RK3288_GRF_PWM_ENABLE_OFFSET,
+				   BIT(RK3288_GRF_PWM_ENABLE_BIT + 16) |
+				   BIT(RK3288_GRF_PWM_ENABLE_BIT));
+		if (ret != 0) {
+			dev_err(&pdev->dev, "Could not access GRF: %d\n", ret);
+			return ret;
+		}
+	}
+
 	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
 	if (!pc)
 		return -ENOMEM;
-- 
2.1.0.rc2.206.gedb03e5

