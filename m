Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356AbbA1Urr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:47:47 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46225 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934265AbbA1Url (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:47:41 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kukjin Kim <kgene@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 2/5] mmc: pwrseq_simple: Extend to support more pins
Date: Wed, 28 Jan 2015 11:10:16 +0100
Message-Id: <1422439819-29854-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1422439819-29854-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1422439819-29854-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many WLAN attached to a SDIO/MMC interface, needs more than one pin for
their reset sequence. For example, is very common for chips to have two
pins: one for reset and one for power enable.

This patch adds support for more reset pins to the pwrseq_simple driver
and instead hardcoding a fixed number, it uses the of_gpio_named_count()
since the MMC power sequence is only built when CONFIG_OF is enabled.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/mmc/core/pwrseq_simple.c | 54 ++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 13 deletions(-)

diff --git a/drivers/mmc/core/pwrseq_simple.c b/drivers/mmc/core/pwrseq_simple.c
index 0958c696137f..9e51fe1051c5 100644
--- a/drivers/mmc/core/pwrseq_simple.c
+++ b/drivers/mmc/core/pwrseq_simple.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/of_gpio.h>
 #include <linux/gpio/consumer.h>
 
 #include <linux/mmc/host.h>
@@ -19,34 +20,44 @@
 
 struct mmc_pwrseq_simple {
 	struct mmc_pwrseq pwrseq;
-	struct gpio_desc *reset_gpio;
+	struct gpio_desc **reset_gpio;
+	int nr_gpios;
 };
 
 static void mmc_pwrseq_simple_pre_power_on(struct mmc_host *host)
 {
 	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
 					struct mmc_pwrseq_simple, pwrseq);
+	int i;
 
-	if (!IS_ERR(pwrseq->reset_gpio))
-		gpiod_set_value_cansleep(pwrseq->reset_gpio, 1);
+	for (i = 0; i < pwrseq->nr_gpios; i++)
+		if (!IS_ERR(pwrseq->reset_gpio[i]))
+			gpiod_set_value_cansleep(pwrseq->reset_gpio[i], 1);
 }
 
 static void mmc_pwrseq_simple_post_power_on(struct mmc_host *host)
 {
 	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
 					struct mmc_pwrseq_simple, pwrseq);
+	int i;
 
-	if (!IS_ERR(pwrseq->reset_gpio))
-		gpiod_set_value_cansleep(pwrseq->reset_gpio, 0);
+	for (i = 0; i < pwrseq->nr_gpios; i++)
+		if (!IS_ERR(pwrseq->reset_gpio[i]))
+			gpiod_set_value_cansleep(pwrseq->reset_gpio[i], 0);
 }
 
 static void mmc_pwrseq_simple_free(struct mmc_host *host)
 {
 	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
 					struct mmc_pwrseq_simple, pwrseq);
+	int i;
 
-	if (!IS_ERR(pwrseq->reset_gpio))
-		gpiod_put(pwrseq->reset_gpio);
+	if (pwrseq->nr_gpios > 0) {
+		for (i = 0; i < pwrseq->nr_gpios; i++)
+			if (!IS_ERR(pwrseq->reset_gpio[i]))
+				gpiod_put(pwrseq->reset_gpio[i]);
+		kfree(pwrseq->reset_gpio);
+	}
 
 	kfree(pwrseq);
 	host->pwrseq = NULL;
@@ -63,17 +74,27 @@ int mmc_pwrseq_simple_alloc(struct mmc_host *host, struct device *dev)
 {
 	struct mmc_pwrseq_simple *pwrseq;
 	int ret = 0;
+	int i;
 
 	pwrseq = kzalloc(sizeof(struct mmc_pwrseq_simple), GFP_KERNEL);
 	if (!pwrseq)
 		return -ENOMEM;
 
-	pwrseq->reset_gpio = gpiod_get_index(dev, "reset", 0, GPIOD_OUT_HIGH);
-	if (IS_ERR(pwrseq->reset_gpio) &&
-		PTR_ERR(pwrseq->reset_gpio) != -ENOENT &&
-		PTR_ERR(pwrseq->reset_gpio) != -ENOSYS) {
-		ret = PTR_ERR(pwrseq->reset_gpio);
-		goto free;
+	pwrseq->nr_gpios = of_gpio_named_count(dev->of_node, "reset-gpios");
+	if (pwrseq->nr_gpios > 0) {
+		pwrseq->reset_gpio = kzalloc(sizeof(struct gpio_desc *) *
+					     pwrseq->nr_gpios, GFP_KERNEL);
+
+		for (i = 0; i < pwrseq->nr_gpios; i++) {
+			pwrseq->reset_gpio[i] = gpiod_get_index(dev, "reset", i,
+								GPIOD_OUT_HIGH);
+			if (IS_ERR(pwrseq->reset_gpio[i]) &&
+			    PTR_ERR(pwrseq->reset_gpio[i]) != -ENOENT &&
+			    PTR_ERR(pwrseq->reset_gpio[i]) != -ENOSYS) {
+				ret = PTR_ERR(pwrseq->reset_gpio[i]);
+				goto free;
+			}
+		}
 	}
 
 	pwrseq->pwrseq.ops = &mmc_pwrseq_simple_ops;
@@ -81,6 +102,13 @@ int mmc_pwrseq_simple_alloc(struct mmc_host *host, struct device *dev)
 
 	return 0;
 free:
+	if (pwrseq->nr_gpios > 0) {
+		for (i = 0; i < pwrseq->nr_gpios; i++)
+			if (!IS_ERR_OR_NULL(pwrseq->reset_gpio[i]))
+				gpiod_put(pwrseq->reset_gpio[i]);
+		kfree(pwrseq->reset_gpio);
+	}
+
 	kfree(pwrseq);
 	return ret;
 }
-- 
2.1.3

