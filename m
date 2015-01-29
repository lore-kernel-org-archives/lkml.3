Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbbA2PC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:02:28 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:47389 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbbA2PAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:00:31 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kukjin Kim <kgene@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Arend van Spriel <arend@broadcom.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 4/6] mmc: pwrseq_simple: Add optional reference clock support
Date: Thu, 29 Jan 2015 16:00:06 +0100
Message-Id: <1422543608-24704-5-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1422543608-24704-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1422543608-24704-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some WLAN chips attached to a SDIO interface, need a reference clock.

Since this is very common, extend the prseq_simple driver to support
an optional clock that is enabled prior the card power up procedure.

Note: the external clock is optional. Thus an error is not returned
if the clock is not found.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since v2:
 - Add a clk_enabled bool to struct mmc_pwrseq_simple to track clock
   gate/ungate since .power_off can be called prior to .pre_power_on.
   Suggested by Ulf Hansson.
 - clk_get() does not return -ENOSYS so don't check for that.
   Suggested by Ulf Hansson.

Changes since v1:
 - Rebase on top of latest changes.
 - Use IS_ERR() instead of checking for NULL to see if the clock exists.
---
 drivers/mmc/core/pwrseq_simple.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/pwrseq_simple.c b/drivers/mmc/core/pwrseq_simple.c
index e53d3c7e059c..50d09d920430 100644
--- a/drivers/mmc/core/pwrseq_simple.c
+++ b/drivers/mmc/core/pwrseq_simple.c
@@ -7,6 +7,7 @@
  *
  *  Simple MMC power sequence management
  */
+#include <linux/clk.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/device.h>
@@ -20,6 +21,8 @@
 
 struct mmc_pwrseq_simple {
 	struct mmc_pwrseq pwrseq;
+	bool clk_enabled;
+	struct clk *ext_clk;
 	int nr_gpios;
 	struct gpio_desc *reset_gpios[0];
 };
@@ -39,6 +42,11 @@ static void mmc_pwrseq_simple_pre_power_on(struct mmc_host *host)
 	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
 					struct mmc_pwrseq_simple, pwrseq);
 
+	if (!IS_ERR(pwrseq->ext_clk)) {
+		clk_prepare_enable(pwrseq->ext_clk);
+		pwrseq->clk_enabled = true;
+	}
+
 	mmc_pwrseq_simple_set_gpios_value(pwrseq, 1);
 }
 
@@ -50,6 +58,19 @@ static void mmc_pwrseq_simple_post_power_on(struct mmc_host *host)
 	mmc_pwrseq_simple_set_gpios_value(pwrseq, 0);
 }
 
+static void mmc_pwrseq_simple_power_off(struct mmc_host *host)
+{
+	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
+					struct mmc_pwrseq_simple, pwrseq);
+
+	mmc_pwrseq_simple_set_gpios_value(pwrseq, 1);
+
+	if (pwrseq->clk_enabled) {
+		clk_disable_unprepare(pwrseq->ext_clk);
+		pwrseq->clk_enabled = false;
+	}
+}
+
 static void mmc_pwrseq_simple_free(struct mmc_host *host)
 {
 	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
@@ -60,6 +81,9 @@ static void mmc_pwrseq_simple_free(struct mmc_host *host)
 		if (!IS_ERR(pwrseq->reset_gpios[i]))
 			gpiod_put(pwrseq->reset_gpios[i]);
 
+	if (!IS_ERR(pwrseq->ext_clk))
+		clk_put(pwrseq->ext_clk);
+
 	kfree(pwrseq);
 	host->pwrseq = NULL;
 }
@@ -67,7 +91,7 @@ static void mmc_pwrseq_simple_free(struct mmc_host *host)
 static struct mmc_pwrseq_ops mmc_pwrseq_simple_ops = {
 	.pre_power_on = mmc_pwrseq_simple_pre_power_on,
 	.post_power_on = mmc_pwrseq_simple_post_power_on,
-	.power_off = mmc_pwrseq_simple_pre_power_on,
+	.power_off = mmc_pwrseq_simple_power_off,
 	.free = mmc_pwrseq_simple_free,
 };
 
@@ -85,6 +109,13 @@ int mmc_pwrseq_simple_alloc(struct mmc_host *host, struct device *dev)
 	if (!pwrseq)
 		return -ENOMEM;
 
+	pwrseq->ext_clk = clk_get(dev, "ext_clock");
+	if (IS_ERR(pwrseq->ext_clk) &&
+	    PTR_ERR(pwrseq->ext_clk) != -ENOENT) {
+		ret = PTR_ERR(pwrseq->ext_clk);
+		goto free;
+	}
+
 	for (i = 0; i < nr_gpios; i++) {
 		pwrseq->reset_gpios[i] = gpiod_get_index(dev, "reset", i,
 							 GPIOD_OUT_HIGH);
@@ -96,7 +127,7 @@ int mmc_pwrseq_simple_alloc(struct mmc_host *host, struct device *dev)
 			while (--i)
 				gpiod_put(pwrseq->reset_gpios[i]);
 
-			goto free;
+			goto clk_put;
 		}
 	}
 
@@ -105,6 +136,9 @@ int mmc_pwrseq_simple_alloc(struct mmc_host *host, struct device *dev)
 	host->pwrseq = &pwrseq->pwrseq;
 
 	return 0;
+clk_put:
+	if (!IS_ERR(pwrseq->ext_clk))
+		clk_put(pwrseq->ext_clk);
 free:
 	kfree(pwrseq);
 	return ret;
-- 
2.1.3

