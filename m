Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbaK0LX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:23:57 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10326 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbaK0LVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:21:14 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-12-54770927d87c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 3/7] regulator: of: Parse ena-gpios property from DTS
Date: Thu, 27 Nov 2014 12:20:49 +0100
Message-id: <1417087253-12306-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xK7rqnOUhBl3vLS02zljPajH14RM2
	i/lHzrFavH5haNH/+DWzxdmmN+wW978eZbT4dqWDyWLT42usFpd3zWGzmHF+H5PF2iN32R14
	PHbOusvusWlVJ5vHnWt72Dw2L6n36NuyitHj8ya5ALYoLpuU1JzMstQifbsErozjj3ewFmyX
	qmi6c46tgfGGaBcjJ4eEgInEviM9LBC2mMSFe+vZuhi5OIQEljJKLH01nR3C6WOS6Ly+jBGk
	ik3AWGLz8iVsILaIwApGieM3FEFsZoH1TBIPtjmB2MICHhJT1/Yxg9gsAqoSUxZdANvAK+Au
	sf1VLxvENjmJk8cms4LYnED1e2/dBqsRAqrZ8+oOywRG3gWMDKsYRVNLkwuKk9JzDfWKE3OL
	S/PS9ZLzczcxQsLxyw7GxcesDjEKcDAq8fAmPC4LEWJNLCuuzD3EKMHBrCTCy8VYHiLEm5JY
	WZValB9fVJqTWnyIkYmDU6qBUUrzwmr1HwpP0j81MjasUnu30C1iy/QcN1mrX/0NHZds1Hru
	+m3PXvh/LSvT2U0rF+18tmffn5vzlfSiOnJu7G8V6l3z6WhQXajJuV0/jdVMGuYa3bgj3tt/
	1eSg7aGvJZNerY6YuOxOCuuBN3H7/4fdL28vrVr5tOX+Hcuexcy74s/MP/2j8bMSS3FGoqEW
	c1FxIgCeBEwfJQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers often add custom DTS properties for parsing the GPIO for
regulator enable control. Some of them don't have to do this in a
special custom way and would work with a generic approach (e.g. S5M8767,
S2MPS1x, MAX77686). As such drivers have to do this on their own,
multiple different bindings are added and each driver duplicates similar
code.

Add a generic binding so the regulator core will do this work for
drivers. This should offload some work from drivers and also limit
creation of new custom properties for GPIO control.

The patch only fills regulator constraints with data from DTS. Data will
be used by regulator core in consecutive patch.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/of_regulator.c  | 11 +++++++++++
 include/linux/regulator/machine.h | 13 +++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 03edb175f3ae..f64739a97296 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/of_gpio.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/of_regulator.h>
@@ -31,6 +32,7 @@ static void of_get_regulation_constraints(struct device_node *np,
 	struct regulation_constraints *constraints = &(*init_data)->constraints;
 	struct regulator_state *suspend_state;
 	struct device_node *suspend_np;
+	enum of_gpio_flags gpio_flags;
 	int ret, i;
 	u32 pval;
 
@@ -81,6 +83,15 @@ static void of_get_regulation_constraints(struct device_node *np,
 	if (!ret)
 		constraints->enable_time = pval;
 
+	constraints->ena_gpio = of_get_named_gpio_flags(np, "ena-gpios", 0,
+							&gpio_flags);
+	if (gpio_is_valid(constraints->ena_gpio)) {
+		constraints->use_ena_gpio = true;
+		constraints->ena_gpio_open_drain = of_property_read_bool(np,
+							   "ena-gpio-open-drain");
+		constraints->ena_gpio_flags = gpio_flags;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(regulator_states); i++) {
 		switch (i) {
 		case PM_SUSPEND_MEM:
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 0b08d05d470b..2faf2b3b71e7 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -95,6 +95,13 @@ struct regulator_state {
  *                 mode.
  * @initial_state: Suspend state to set by default.
  * @initial_mode: Mode to set at startup.
+ *
+ * @use_ena_gpio: True if ena_gpio is a valid GPIO to use for enable control.
+ *                If false, all other ena_gpio* fields are ignored.
+ * @ena_gpio: GPIO to use for enable control
+ * @ena_gpio_open_drain: Is GPIO open drain
+ * @ena_gpio_flags: Flags for GPIO request, see enum of_gpio_flags
+ *
  * @ramp_delay: Time to settle down after voltage change (unit: uV/us)
  * @enable_time: Turn-on time of the rails (unit: microseconds)
  */
@@ -130,6 +137,12 @@ struct regulation_constraints {
 	/* mode to set on startup */
 	unsigned int initial_mode;
 
+	/* enable control over GPIO */
+	bool use_ena_gpio;
+	int ena_gpio;
+	bool ena_gpio_open_drain;
+	unsigned int ena_gpio_flags;
+
 	unsigned int ramp_delay;
 	unsigned int enable_time;
 
-- 
1.9.1

