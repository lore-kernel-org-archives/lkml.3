Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473AbbA1Vbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:31:31 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46229 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934278AbbA1Urm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:47:42 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kukjin Kim <kgene@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 4/5] mmc: pwrseq_simple: Add optional reference clock support
Date: Wed, 28 Jan 2015 11:10:18 +0100
Message-Id: <1422439819-29854-5-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1422439819-29854-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1422439819-29854-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some WLAN chips attached to a SDIO interface, need a reference clock.

Since this is very common, extend the prseq_simple driver to support
an optional clock that is enabled prior the card power up procedure.

Note, the external clock is optional. Thus an error is not returned
if the clock is not found.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/mmc/core/pwrseq_simple.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/pwrseq_simple.c b/drivers/mmc/core/pwrseq_simple.c
index 9e51fe1051c5..5ef6db7323f3 100644
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
@@ -16,12 +17,14 @@
 
 #include <linux/mmc/host.h>
 
+#include "core.h"
 #include "pwrseq.h"
 
 struct mmc_pwrseq_simple {
 	struct mmc_pwrseq pwrseq;
 	struct gpio_desc **reset_gpio;
 	int nr_gpios;
+	struct clk *ext_clk;
 };
 
 static void mmc_pwrseq_simple_pre_power_on(struct mmc_host *host)
@@ -30,6 +33,9 @@ static void mmc_pwrseq_simple_pre_power_on(struct mmc_host *host)
 					struct mmc_pwrseq_simple, pwrseq);
 	int i;
 
+	if (pwrseq->ext_clk)
+		clk_prepare_enable(pwrseq->ext_clk);
+
 	for (i = 0; i < pwrseq->nr_gpios; i++)
 		if (!IS_ERR(pwrseq->reset_gpio[i]))
 			gpiod_set_value_cansleep(pwrseq->reset_gpio[i], 1);
@@ -46,12 +52,29 @@ static void mmc_pwrseq_simple_post_power_on(struct mmc_host *host)
 			gpiod_set_value_cansleep(pwrseq->reset_gpio[i], 0);
 }
 
+static void mmc_pwrseq_simple_power_off(struct mmc_host *host)
+{
+	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
+					struct mmc_pwrseq_simple, pwrseq);
+	int i;
+
+	for (i = 0; i < pwrseq->nr_gpios; i++)
+		if (!IS_ERR(pwrseq->reset_gpio[i]))
+			gpiod_set_value_cansleep(pwrseq->reset_gpio[i], 1);
+
+	if (pwrseq->ext_clk)
+		clk_disable_unprepare(pwrseq->ext_clk);
+}
+
 static void mmc_pwrseq_simple_free(struct mmc_host *host)
 {
 	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
 					struct mmc_pwrseq_simple, pwrseq);
 	int i;
 
+	if (pwrseq->ext_clk)
+		clk_put(pwrseq->ext_clk);
+
 	if (pwrseq->nr_gpios > 0) {
 		for (i = 0; i < pwrseq->nr_gpios; i++)
 			if (!IS_ERR(pwrseq->reset_gpio[i]))
@@ -66,7 +89,7 @@ static void mmc_pwrseq_simple_free(struct mmc_host *host)
 static struct mmc_pwrseq_ops mmc_pwrseq_simple_ops = {
 	.pre_power_on = mmc_pwrseq_simple_pre_power_on,
 	.post_power_on = mmc_pwrseq_simple_post_power_on,
-	.power_off = mmc_pwrseq_simple_pre_power_on,
+	.power_off = mmc_pwrseq_simple_power_off,
 	.free = mmc_pwrseq_simple_free,
 };
 
@@ -97,6 +120,14 @@ int mmc_pwrseq_simple_alloc(struct mmc_host *host, struct device *dev)
 		}
 	}
 
+	pwrseq->ext_clk = clk_get(dev, "ext_clock");
+	if (IS_ERR(pwrseq->ext_clk) &&
+	    PTR_ERR(pwrseq->ext_clk) != -ENOENT &&
+	    PTR_ERR(pwrseq->ext_clk) != -ENOSYS) {
+		ret = PTR_ERR(pwrseq->ext_clk);
+		goto free;
+	}
+
 	pwrseq->pwrseq.ops = &mmc_pwrseq_simple_ops;
 	host->pwrseq = &pwrseq->pwrseq;
 
-- 
2.1.3

