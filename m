Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbbAOQPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:15:01 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54082 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbbAOQO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:14:57 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>, Simon Glass <sjg@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Chris Ball <chris@printf.net>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: [PATCH v2 08/11] mmc: pwrseq_simple: Add support for a delay
Date: Thu, 15 Jan 2015 17:12:20 +0100
Message-Id: <1421338359-27467-9-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 Documentation/devicetree/bindings/mmc/mmc,pwrseq-simple.txt | 2 ++
 drivers/mmc/core/pwrseq_simple.c                            | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/mmc,pwrseq-simple.txt b/Documentation/devicetree/bindings/mmc/mmc,pwrseq-simple.txt
index 6fe0cd6..b353381 100644
--- a/Documentation/devicetree/bindings/mmc/mmc,pwrseq-simple.txt
+++ b/Documentation/devicetree/bindings/mmc/mmc,pwrseq-simple.txt
@@ -14,10 +14,12 @@ Required properties:
 Optional properties:
 - reset-gpios : contains a list of GPIO specifiers, though currently only one
 		specifier is supported.
+- delay : delay to wait after driving the reset gpio active [ms].
 
 Example:
 
 	sdhci0_pwrseq {
 		compatible = "mmc,pwrseq-simple";
 		reset-gpios = <&gpio1 12 0>;
+		delay = <20>;
 	}
diff --git a/drivers/mmc/core/pwrseq_simple.c b/drivers/mmc/core/pwrseq_simple.c
index 42d9836..3e521cc 100644
--- a/drivers/mmc/core/pwrseq_simple.c
+++ b/drivers/mmc/core/pwrseq_simple.c
@@ -12,14 +12,17 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/gpio/consumer.h>
+#include <linux/of_platform.h>
 
 #include <linux/mmc/host.h>
 
+#include "core.h"
 #include "pwrseq.h"
 
 struct mmc_pwrseq_simple {
 	struct mmc_pwrseq pwrseq;
 	struct gpio_desc *reset_gpio;
+	unsigned int delay_ms;
 };
 
 static void mmc_pwrseq_simple_pre_power_on(struct mmc_host *host)
@@ -29,6 +32,9 @@ static void mmc_pwrseq_simple_pre_power_on(struct mmc_host *host)
 
 	if (!IS_ERR(pwrseq->reset_gpio))
 		gpiod_set_value_cansleep(pwrseq->reset_gpio, 1);
+
+	if (pwrseq->delay_ms)
+		mmc_delay(pwrseq->delay_ms);
 }
 
 static void mmc_pwrseq_simple_post_power_on(struct mmc_host *host)
@@ -76,6 +82,8 @@ int mmc_pwrseq_simple_alloc(struct mmc_host *host, struct device *dev)
 		goto free;
 	}
 
+	of_property_read_u32(dev->of_node, "delay", &pwrseq->delay_ms);
+
 	pwrseq->pwrseq.ops = &mmc_pwrseq_simple_ops;
 	host->pwrseq = &pwrseq->pwrseq;
 
-- 
1.9.3

