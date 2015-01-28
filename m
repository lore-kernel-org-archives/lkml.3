Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761390AbbA1Umu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:42:50 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46209 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934105AbbA1Uml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:42:41 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kukjin Kim <kgene@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Arend van Spriel <arend@broadcom.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v2 4/6] mmc: pwrseq_simple: Add optional reference clock support
Date: Wed, 28 Jan 2015 19:15:51 +0100
Message-Id: <1422468953-7594-5-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1422468953-7594-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1422468953-7594-1-git-send-email-javier.martinez@collabora.co.uk>
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

Changes since v1:
 - Rebase on top of latest changes.
 - Use IS_ERR() instead of checking for NULL to see if the clock exists.
---
 drivers/mmc/core/pwrseq_simple.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/pwrseq_simple.c b/drivers/mmc/core/pwrseq_simple.c
index e53d3c7e059c..5e34c77efa5e 100644
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
@@ -20,6 +21,7 @@
 
 struct mmc_pwrseq_simple {
 	struct mmc_pwrseq pwrseq;
+	struct clk *ext_clk;
 	int nr_gpios;
 	struct gpio_desc *reset_gpios[0];
 };
@@ -39,6 +41,9 @@ static void mmc_pwrseq_simple_pre_power_on(struct mmc_host *host)
 	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
 					struct mmc_pwrseq_simple, pwrseq);
 
+	if (!IS_ERR(pwrseq->ext_clk))
+		clk_prepare_enable(pwrseq->ext_clk);
+
 	mmc_pwrseq_simple_set_gpios_value(pwrseq, 1);
 }
 
@@ -50,6 +55,17 @@ static void mmc_pwrseq_simple_post_power_on(struct mmc_host *host)
 	mmc_pwrseq_simple_set_gpios_value(pwrseq, 0);
 }
 
+static void mmc_pwrseq_simple_power_off(struct mmc_host *host)
+{
+	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
+					struct mmc_pwrseq_simple, pwrseq);
+
+	mmc_pwrseq_simple_set_gpios_value(pwrseq, 1);
+
+	if (!IS_ERR(pwrseq->ext_clk))
+		clk_disable_unprepare(pwrseq->ext_clk);
+}
+
 static void mmc_pwrseq_simple_free(struct mmc_host *host)
 {
 	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
@@ -60,6 +76,9 @@ static void mmc_pwrseq_simple_free(struct mmc_host *host)
 		if (!IS_ERR(pwrseq->reset_gpios[i]))
 			gpiod_put(pwrseq->reset_gpios[i]);
 
+	if (!IS_ERR(pwrseq->ext_clk))
+		clk_put(pwrseq->ext_clk);
+
 	kfree(pwrseq);
 	host->pwrseq = NULL;
 }
@@ -67,7 +86,7 @@ static void mmc_pwrseq_simple_free(struct mmc_host *host)
 static struct mmc_pwrseq_ops mmc_pwrseq_simple_ops = {
 	.pre_power_on = mmc_pwrseq_simple_pre_power_on,
 	.post_power_on = mmc_pwrseq_simple_post_power_on,
-	.power_off = mmc_pwrseq_simple_pre_power_on,
+	.power_off = mmc_pwrseq_simple_power_off,
 	.free = mmc_pwrseq_simple_free,
 };
 
@@ -85,6 +104,14 @@ int mmc_pwrseq_simple_alloc(struct mmc_host *host, struct device *dev)
 	if (!pwrseq)
 		return -ENOMEM;
 
+	pwrseq->ext_clk = clk_get(dev, "ext_clock");
+	if (IS_ERR(pwrseq->ext_clk) &&
+	    PTR_ERR(pwrseq->ext_clk) != -ENOENT &&
+	    PTR_ERR(pwrseq->ext_clk) != -ENOSYS) {
+		ret = PTR_ERR(pwrseq->ext_clk);
+		goto free;
+	}
+
 	for (i = 0; i < nr_gpios; i++) {
 		pwrseq->reset_gpios[i] = gpiod_get_index(dev, "reset", i,
 							 GPIOD_OUT_HIGH);
@@ -96,7 +123,7 @@ int mmc_pwrseq_simple_alloc(struct mmc_host *host, struct device *dev)
 			while (--i)
 				gpiod_put(pwrseq->reset_gpios[i]);
 
-			goto free;
+			goto clk_put;
 		}
 	}
 
@@ -105,6 +132,9 @@ int mmc_pwrseq_simple_alloc(struct mmc_host *host, struct device *dev)
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

