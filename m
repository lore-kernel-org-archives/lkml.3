Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3AOEf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:35:57 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48173 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab3AOEfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:35:53 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/4] regulator-core: manage enable GPIO list
Thread-Topic: [PATCH v2 2/4] regulator-core: manage enable GPIO list
Thread-Index: Ac3y2clJXPFFYHnFTxynIulr371zMw==
Date: Tue, 15 Jan 2013 04:35:46 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E12B35@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 To support shared enable GPIO pin, replace GPIO code with new static functions

 regulator_ena_gpio_ctrl()
   Find a GPIO information in the enable GPIO list and control the pin.

 _do_ena_gpio_ctrl()
   Balance the reference count of each GPIO and actual pin control.
   The count is incremented with enabling GPIO.
   On the other hand, it is decremented on disabling GPIO.
   Actual GPIO pin is enabled at the initial use.(enable_count = 0)
   The pin is disabled if it is not used(shared) any more. (enable_count = 1)
   This concept is derived from the 'use_count' of regulator.
   Regardless of the enable count, update GPIO state of the regulator.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/core.c |   54 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 47 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 1273090..dc713c4 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1501,6 +1501,51 @@ static int regulator_ena_gpio_request(struct regulator_dev *rdev,
 	return 0;
 }
 
+/**
+ * Balance enable_count of each GPIO and actual GPIO pin control.
+ * GPIO is enabled in case of initial use. (enable_count is 0)
+ * GPIO is disabled when it is not shared any more. (enable_count is 1)
+ */
+static void _do_ena_gpio_ctrl(struct regulator_enable_gpio *pin,
+			struct regulator_dev *rdev, bool enable)
+{
+	if (enable) {
+		/* Enable GPIO at initial use */
+		if (pin->enable_count == 0)
+			gpio_set_value_cansleep(rdev->ena_gpio,
+						!rdev->ena_gpio_invert);
+
+		rdev->ena_gpio_state = 1;
+		pin->enable_count++;
+
+	} else {
+		rdev->ena_gpio_state = 0;
+		if (pin->enable_count > 1) {
+			pin->enable_count--;
+			return;
+		}
+
+		/* Disable GPIO if not used */
+		if (pin->enable_count == 1) {
+			gpio_set_value_cansleep(rdev->ena_gpio,
+						rdev->ena_gpio_invert);
+			pin->enable_count = 0;
+		}
+	}
+}
+
+static void regulator_ena_gpio_ctrl(struct regulator_dev *rdev, bool enable)
+{
+	struct regulator_enable_gpio *pin;
+
+	list_for_each_entry(pin, &regulator_ena_gpio_list, list) {
+		if (pin->gpio == rdev->ena_gpio) {
+			_do_ena_gpio_ctrl(pin, rdev, enable);
+			return;
+		}
+	}
+}
+
 static int _regulator_do_enable(struct regulator_dev *rdev)
 {
 	int ret, delay;
@@ -1517,9 +1562,7 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 	trace_regulator_enable(rdev_get_name(rdev));
 
 	if (rdev->ena_gpio) {
-		gpio_set_value_cansleep(rdev->ena_gpio,
-					!rdev->ena_gpio_invert);
-		rdev->ena_gpio_state = 1;
+		regulator_ena_gpio_ctrl(rdev, true);
 	} else if (rdev->desc->ops->enable) {
 		ret = rdev->desc->ops->enable(rdev);
 		if (ret < 0)
@@ -1621,10 +1664,7 @@ static int _regulator_do_disable(struct regulator_dev *rdev)
 	trace_regulator_disable(rdev_get_name(rdev));
 
 	if (rdev->ena_gpio) {
-		gpio_set_value_cansleep(rdev->ena_gpio,
-					rdev->ena_gpio_invert);
-		rdev->ena_gpio_state = 0;
-
+		regulator_ena_gpio_ctrl(rdev, false);
 	} else if (rdev->desc->ops->disable) {
 		ret = rdev->desc->ops->disable(rdev);
 		if (ret != 0)
-- 
1.7.9.5


Best Regards,
Milo


