Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbaDNWFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:05:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35517 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755575AbaDNWAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:00:14 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 03/11] pwm: renesas-tpu: remove useless struct tpu_pwm_platform_data
Date: Mon, 14 Apr 2014 23:59:45 +0200
Message-Id: <1397512793-10325-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397512793-10325-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1397512793-10325-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct tpu_pwm_platform_data is not used anymore and the polarity
initialization will be taken care of by the PWM core.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/pwm/pwm-renesas-tpu.c                 | 19 +++----------------
 include/linux/platform_data/pwm-renesas-tpu.h | 16 ----------------
 2 files changed, 3 insertions(+), 32 deletions(-)
 delete mode 100644 include/linux/platform_data/pwm-renesas-tpu.h

diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
index aff6ba9b49e7..9dbcf82b3e6c 100644
--- a/drivers/pwm/pwm-renesas-tpu.c
+++ b/drivers/pwm/pwm-renesas-tpu.c
@@ -21,13 +21,14 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
-#include <linux/platform_data/pwm-renesas-tpu.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/pwm.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
+#define TPU_CHANNEL_MAX		4
+
 #define TPU_TSTR		0x00	/* Timer start register (shared) */
 
 #define TPU_TCRn		0x00	/* Timer control register */
@@ -87,7 +88,6 @@ struct tpu_pwm_device {
 
 struct tpu_device {
 	struct platform_device *pdev;
-	enum pwm_polarity polarities[TPU_CHANNEL_MAX];
 	struct pwm_chip chip;
 	spinlock_t lock;
 
@@ -229,7 +229,7 @@ static int tpu_pwm_request(struct pwm_chip *chip, struct pwm_device *_pwm)
 
 	pwm->tpu = tpu;
 	pwm->channel = _pwm->hwpwm;
-	pwm->polarity = tpu->polarities[pwm->channel];
+	pwm->polarity = PWM_POLARITY_NORMAL;
 	pwm->prescaler = 0;
 	pwm->period = 0;
 	pwm->duty = 0;
@@ -388,16 +388,6 @@ static const struct pwm_ops tpu_pwm_ops = {
  * Probe and remove
  */
 
-static void tpu_parse_pdata(struct tpu_device *tpu)
-{
-	struct tpu_pwm_platform_data *pdata = tpu->pdev->dev.platform_data;
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(tpu->polarities); ++i)
-		tpu->polarities[i] = pdata ? pdata->channels[i].polarity
-				   : PWM_POLARITY_NORMAL;
-}
-
 static int tpu_probe(struct platform_device *pdev)
 {
 	struct tpu_device *tpu;
@@ -413,9 +403,6 @@ static int tpu_probe(struct platform_device *pdev)
 	spin_lock_init(&tpu->lock);
 	tpu->pdev = pdev;
 
-	/* Initialize device configuration from platform data. */
-	tpu_parse_pdata(tpu);
-
 	/* Map memory, get clock and pin control. */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	tpu->base = devm_ioremap_resource(&pdev->dev, res);
diff --git a/include/linux/platform_data/pwm-renesas-tpu.h b/include/linux/platform_data/pwm-renesas-tpu.h
deleted file mode 100644
index a7220b10ddab..000000000000
--- a/include/linux/platform_data/pwm-renesas-tpu.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef __PWM_RENESAS_TPU_H__
-#define __PWM_RENESAS_TPU_H__
-
-#include <linux/pwm.h>
-
-#define TPU_CHANNEL_MAX		4
-
-struct tpu_pwm_channel_data {
-	enum pwm_polarity polarity;
-};
-
-struct tpu_pwm_platform_data {
-	struct tpu_pwm_channel_data channels[TPU_CHANNEL_MAX];
-};
-
-#endif /* __PWM_RENESAS_TPU_H__ */
-- 
1.8.3.2

