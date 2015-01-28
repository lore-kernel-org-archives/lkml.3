Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761439AbbA2CTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:19:42 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37983 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995AbbA2CTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:19:40 -0500
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 1/2] mmc: pwrseq: Add support to control multiple gpios in simple pwrseq
Date: Wed, 28 Jan 2015 13:16:59 +0000
Message-Id: <1422451019-9372-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422450981-9328-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1422450981-9328-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to reset/powerup multiple gpio pins on a given
sdio bus. The use case is simple, on sdio we could have multiple devices
like WLAN, BT which are controlled by there own reset lines. So having
multiple reset is something more useful in such cases.

Without this patch I could not get BT and WLAN working at same time on IFC6410.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/core/pwrseq_simple.c | 64 ++++++++++++++++++++++++++++------------
 1 file changed, 45 insertions(+), 19 deletions(-)

diff --git a/drivers/mmc/core/pwrseq_simple.c b/drivers/mmc/core/pwrseq_simple.c
index 0958c69..bb9aadd 100644
--- a/drivers/mmc/core/pwrseq_simple.c
+++ b/drivers/mmc/core/pwrseq_simple.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/device.h>
+#include <linux/of.h>
 #include <linux/err.h>
 #include <linux/gpio/consumer.h>
 
@@ -19,34 +20,44 @@
 
 struct mmc_pwrseq_simple {
 	struct mmc_pwrseq pwrseq;
-	struct gpio_desc *reset_gpio;
+	int		ngpios;
+	struct gpio_desc *reset_gpios[0];
 };
 
-static void mmc_pwrseq_simple_pre_power_on(struct mmc_host *host)
+static void __mmc_pwrseq_simple_pre_post_power_on_off(struct mmc_host *host,
+						      bool on)
 {
 	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
 					struct mmc_pwrseq_simple, pwrseq);
+	int i;
 
-	if (!IS_ERR(pwrseq->reset_gpio))
-		gpiod_set_value_cansleep(pwrseq->reset_gpio, 1);
+	if (!IS_ERR(pwrseq->reset_gpios)) {
+		for (i = 0; i < pwrseq->ngpios; i++)
+			gpiod_set_value_cansleep(pwrseq->reset_gpios[i],
+						 on ? : 0);
+	}
 }
 
-static void mmc_pwrseq_simple_post_power_on(struct mmc_host *host)
+static void mmc_pwrseq_simple_pre_power_on(struct mmc_host *host)
 {
-	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
-					struct mmc_pwrseq_simple, pwrseq);
+	__mmc_pwrseq_simple_pre_post_power_on_off(host, true);
+}
 
-	if (!IS_ERR(pwrseq->reset_gpio))
-		gpiod_set_value_cansleep(pwrseq->reset_gpio, 0);
+static void mmc_pwrseq_simple_post_power_on(struct mmc_host *host)
+{
+	__mmc_pwrseq_simple_pre_post_power_on_off(host, false);
 }
 
 static void mmc_pwrseq_simple_free(struct mmc_host *host)
 {
 	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
 					struct mmc_pwrseq_simple, pwrseq);
+	int i;
 
-	if (!IS_ERR(pwrseq->reset_gpio))
-		gpiod_put(pwrseq->reset_gpio);
+	if (!IS_ERR(pwrseq->reset_gpios)) {
+		for (i = 0; i < pwrseq->ngpios; i++)
+			gpiod_put(pwrseq->reset_gpios[i]);
+	}
 
 	kfree(pwrseq);
 	host->pwrseq = NULL;
@@ -62,20 +73,35 @@ static struct mmc_pwrseq_ops mmc_pwrseq_simple_ops = {
 int mmc_pwrseq_simple_alloc(struct mmc_host *host, struct device *dev)
 {
 	struct mmc_pwrseq_simple *pwrseq;
-	int ret = 0;
+	int ngpios, i, ret = 0;
+
+	ngpios = of_count_phandle_with_args(dev->of_node,
+					    "reset-gpios", "#gpio-cells");
 
-	pwrseq = kzalloc(sizeof(struct mmc_pwrseq_simple), GFP_KERNEL);
+	if (!ngpios)
+		return -ENOENT;
+
+	pwrseq = kzalloc(sizeof(struct mmc_pwrseq_simple) +
+			 ngpios * sizeof(struct gpio_desc *), GFP_KERNEL);
 	if (!pwrseq)
 		return -ENOMEM;
 
-	pwrseq->reset_gpio = gpiod_get_index(dev, "reset", 0, GPIOD_OUT_HIGH);
-	if (IS_ERR(pwrseq->reset_gpio) &&
-		PTR_ERR(pwrseq->reset_gpio) != -ENOENT &&
-		PTR_ERR(pwrseq->reset_gpio) != -ENOSYS) {
-		ret = PTR_ERR(pwrseq->reset_gpio);
-		goto free;
+	for (i = 0; i < ngpios; i++) {
+		pwrseq->reset_gpios[i] = gpiod_get_index(dev, "reset",
+							 i, GPIOD_OUT_HIGH);
+		if (IS_ERR(pwrseq->reset_gpios[i]) &&
+			PTR_ERR(pwrseq->reset_gpios[i]) != -ENOENT &&
+			PTR_ERR(pwrseq->reset_gpios[i]) != -ENOSYS) {
+			ret = PTR_ERR(pwrseq->reset_gpios[i]);
+
+			while (--i)
+				gpiod_put(pwrseq->reset_gpios[i]);
+
+			goto free;
+		}
 	}
 
+	pwrseq->ngpios = ngpios;
 	pwrseq->pwrseq.ops = &mmc_pwrseq_simple_ops;
 	host->pwrseq = &pwrseq->pwrseq;
 
-- 
1.9.1

