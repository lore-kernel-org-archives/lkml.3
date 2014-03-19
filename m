Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965303AbaCSNRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:17:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42114 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933739AbaCSNEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:04:04 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-leds@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 08/16] backlight: pwm_bl: set pwm polarity when using platform data
Date: Wed, 19 Mar 2014 14:03:21 +0100
Message-Id: <1395234209-15546-9-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set inversed polarity when .pwm_active_low is set in the platform_data. With
device tree, this is taken care of by of_pwm_xlate_with_flags(), called from
of_pwm_get().

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/video/backlight/pwm_bl.c | 8 ++++++++
 include/linux/pwm_backlight.h    | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index b75201ff46f6..ffdd3b2b2742 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -309,6 +309,14 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	if (data->pwm_period_ns > 0)
 		pwm_set_period(pb->pwm, data->pwm_period_ns);
 
+	/*
+	 * The DT case is taking care of polarity in of_pwm_get(). For the
+	 * non-DT case, set the polarity from platform data.
+	 */
+	if (data->pwm_active_low)
+		if (pwm_set_polarity(pb->pwm, PWM_POLARITY_INVERSED))
+			dev_err(&pdev->dev, "impossible to invert polarity\n");
+
 	pb->period = pwm_get_period(pb->pwm);
 	pb->lth_brightness = data->lth_brightness * (pb->period / pb->scale);
 
diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
index 2de2e275b2cb..b924fce5c97a 100644
--- a/include/linux/pwm_backlight.h
+++ b/include/linux/pwm_backlight.h
@@ -15,6 +15,7 @@ struct platform_pwm_backlight_data {
 	unsigned int dft_brightness;
 	unsigned int lth_brightness;
 	unsigned int pwm_period_ns;
+	bool pwm_active_low;
 	unsigned int *levels;
 	int enable_gpio;
 	unsigned long enable_gpio_flags;
-- 
1.8.3.2

