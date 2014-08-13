Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaHMLfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:35:24 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64619 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaHMLfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:35:19 -0400
From: Guodong Xu <guodong.xu@linaro.org>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, sameo@linux.intel.com, lee.jones@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org, grant.likely@linaro.org,
        khilman@linaro.org, haojian.zhuang@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Guodong Xu <guodong.xu@linaro.org>
Subject: [PATCH v5 3/7] regulator: core: add guard delay between calling regulator_disable and _enable
Date: Wed, 13 Aug 2014 19:33:40 +0800
Message-Id: <1407929624-8737-4-git-send-email-guodong.xu@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407929624-8737-1-git-send-email-guodong.xu@linaro.org>
References: <1407929624-8737-1-git-send-email-guodong.xu@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some regulator require a minimum delay between its disable and next enable.
This is to avoid damages when out-of-range frequent disable/enable of a
single regulator can bring to the regulator chip.

Add @off_on_delay to struct regulator_desc. Device drivers' can use this field
to set this guard time.

Add @last_off_jiffy to struct regulator_dev. When @off_on_delay is set by
driver, regulator core can store its last off (disable) time into this field.

Signed-off-by: Guodong Xu <guodong.xu@linaro.org>
---
 drivers/regulator/core.c         | 31 +++++++++++++++++++++++++++++++
 include/linux/regulator/driver.h |  6 ++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 67d4246..c218c62 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1807,6 +1807,31 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 
 	trace_regulator_enable(rdev_get_name(rdev));
 
+	if (rdev->desc->off_on_delay) {
+		/* if needed, keep a distance of off_on_delay from last time
+		 * this regulator was disabled.
+		 */
+		unsigned long start_jiffy = jiffies;
+		unsigned long intended, max_delay, remaining;
+
+		max_delay = usecs_to_jiffies(rdev->desc->off_on_delay);
+		intended = rdev->last_off_jiffy + max_delay;
+
+		if (time_before(start_jiffy, intended)) {
+			/* calc remaining jiffies to deal with one-time
+			 * timer wrapping.
+			 * in case of multiple timer wrapping, either it can be
+			 * detected by out-of-range remaining, or it cannot be
+			 * detected and we gets a panelty of
+			 * _regulator_enable_delay().
+			 */
+			remaining = intended - start_jiffy;
+			if (remaining <= max_delay)
+				_regulator_enable_delay(
+						jiffies_to_usecs(remaining));
+		}
+	}
+
 	if (rdev->ena_pin) {
 		ret = regulator_ena_gpio_ctrl(rdev, true);
 		if (ret < 0)
@@ -1919,6 +1944,12 @@ static int _regulator_do_disable(struct regulator_dev *rdev)
 			return ret;
 	}
 
+	/* cares about last_off_jiffy only if off_on_delay is required by
+	 * device.
+	 */
+	if (rdev->desc->off_on_delay)
+		rdev->last_off_jiffy = jiffies;
+
 	trace_regulator_disable_complete(rdev_get_name(rdev));
 
 	return 0;
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 4b62813..efe058f 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -238,6 +238,7 @@ enum regulator_type {
  * @bypass_val_off: Disabling value for control when using regmap set_bypass
  *
  * @enable_time: Time taken for initial enable of regulator (in uS).
+ * @off_on_delay: guard time (in uS), before re-enabling a regulator
  */
 struct regulator_desc {
 	const char *name;
@@ -276,6 +277,8 @@ struct regulator_desc {
 	unsigned int bypass_val_off;
 
 	unsigned int enable_time;
+
+	unsigned int off_on_delay;
 };
 
 /**
@@ -348,6 +351,9 @@ struct regulator_dev {
 
 	struct regulator_enable_gpio *ena_pin;
 	unsigned int ena_gpio_state:1;
+
+	/* time when this regulator was disabled last time */
+	unsigned long last_off_jiffy;
 };
 
 struct regulator_dev *
-- 
1.9.1

