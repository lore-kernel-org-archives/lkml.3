Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab3BRGve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 01:51:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51019 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038Ab3BRGvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 01:51:32 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/4] regulator: core: manage enable GPIO list
Thread-Topic: [PATCH v3 2/4] regulator: core: manage enable GPIO list
Thread-Index: Ac4NpEfrgYRWH1fvRduBqK3XNCUZRQ==
Date: Mon, 18 Feb 2013 06:50:48 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F792729F9@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.62]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 To support shared enable GPIO pin, replace GPIO code with new static functions

 Reference count: 'enable_count'
   Balance the reference count of each GPIO and actual pin control.
   The count is incremented with enabling GPIO.
   On the other hand, it is decremented on disabling GPIO.
   Actual GPIO pin is enabled at the initial use.(enable_count = 0)
   The pin is disabled if it is not used(shared) any more. (enable_count <=1)
   Regardless of the enable count, update GPIO state of the regulator.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/core.c |   50 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 71d6adc..57d434d 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1529,6 +1529,42 @@ static void regulator_ena_gpio_free(struct regulator_dev *rdev)
 	}
 }
 
+/**
+ * Balance enable_count of each GPIO and actual GPIO pin control.
+ * GPIO is enabled in case of initial use. (enable_count is 0)
+ * GPIO is disabled when it is not shared any more. (enable_count <= 1)
+ */
+static int regulator_ena_gpio_ctrl(struct regulator_dev *rdev, bool enable)
+{
+	struct regulator_enable_gpio *pin = rdev->ena_pin;
+
+	if (!pin)
+		return -EINVAL;
+
+	if (enable) {
+		/* Enable GPIO at initial use */
+		if (pin->enable_count == 0)
+			gpio_set_value_cansleep(pin->gpio,
+						!pin->ena_gpio_invert);
+
+		pin->enable_count++;
+	} else {
+		if (pin->enable_count > 1) {
+			pin->enable_count--;
+			return 0;
+		}
+
+		/* Disable GPIO if not used */
+		if (pin->enable_count <= 1) {
+			gpio_set_value_cansleep(pin->gpio,
+						pin->ena_gpio_invert);
+			pin->enable_count = 0;
+		}
+	}
+
+	return 0;
+}
+
 static int _regulator_do_enable(struct regulator_dev *rdev)
 {
 	int ret, delay;
@@ -1544,9 +1580,10 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 
 	trace_regulator_enable(rdev_get_name(rdev));
 
-	if (rdev->ena_gpio) {
-		gpio_set_value_cansleep(rdev->ena_gpio,
-					!rdev->ena_gpio_invert);
+	if (rdev->ena_pin) {
+		ret = regulator_ena_gpio_ctrl(rdev, true);
+		if (ret < 0)
+			return ret;
 		rdev->ena_gpio_state = 1;
 	} else if (rdev->desc->ops->enable) {
 		ret = rdev->desc->ops->enable(rdev);
@@ -1648,9 +1685,10 @@ static int _regulator_do_disable(struct regulator_dev *rdev)
 
 	trace_regulator_disable(rdev_get_name(rdev));
 
-	if (rdev->ena_gpio) {
-		gpio_set_value_cansleep(rdev->ena_gpio,
-					rdev->ena_gpio_invert);
+	if (rdev->ena_pin) {
+		ret = regulator_ena_gpio_ctrl(rdev, false);
+		if (ret < 0)
+			return ret;
 		rdev->ena_gpio_state = 0;
 
 	} else if (rdev->desc->ops->disable) {
-- 
1.7.9.5


Best Regards,
Milo


