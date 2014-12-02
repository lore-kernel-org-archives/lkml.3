Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbaLBNqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:46:09 -0500
Received: from gnurou.org ([207.192.72.5]:41337 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaLBNqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:46:08 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] gpio: fix deferred probe detection for legacy API
Date: Tue,  2 Dec 2014 22:42:04 +0900
Message-Id: <1417527724-24960-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <CAAVeFuJm_UXHioENBg6himgZkEmopr=T8iCbt0xD6-ds6AHyxA@mail.gmail.com>
References: <CAAVeFuJm_UXHioENBg6himgZkEmopr=T8iCbt0xD6-ds6AHyxA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 14e85c0e69d5 ("gpio: remove gpio_descs global array") changed
gpio_to_desc()'s behavior to return NULL not only for GPIOs numbers
not in the valid range, but also for all GPIOs whose controller has not
been probed yet. Although this behavior is more correct (nothing hints
that these GPIO numbers will be populated later), this affects
gpio_request() and gpio_request_one() which call gpiod_request() with a
NULL descriptor, causing it to return -EINVAL instead of the expected
-EPROBE_DEFER for a non-probed GPIO.

gpiod_request() is only called with a descriptor obtained from
gpio_to_desc() from these two functions, so address the issue there.

Other ways to obtain GPIOs rely on well-defined mappings and can thus
return -EPROBE_DEFER only for relevant GPIOs, and are thus not affected
by this issue.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
Hi Geert,

Could we have your Tested-by to confirm this fixes the issue? Thanks!

Hi Linus,

Once Geert confirms this does the trick, Please feel free to squash this
patch into the gpio_descs array removal one if it is not too late for that.

 drivers/gpio/gpiolib-legacy.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-legacy.c b/drivers/gpio/gpiolib-legacy.c
index 078ae6c..8b83099 100644
--- a/drivers/gpio/gpiolib-legacy.c
+++ b/drivers/gpio/gpiolib-legacy.c
@@ -24,6 +24,10 @@ int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
 
 	desc = gpio_to_desc(gpio);
 
+	/* Compatibility: assume unavailable "valid" GPIOs will appear later */
+	if (!desc && gpio_is_valid(gpio))
+		return -EPROBE_DEFER;
+
 	err = gpiod_request(desc, label);
 	if (err)
 		return err;
@@ -62,7 +66,13 @@ EXPORT_SYMBOL_GPL(gpio_request_one);
 
 int gpio_request(unsigned gpio, const char *label)
 {
-	return gpiod_request(gpio_to_desc(gpio), label);
+	struct gpio_desc *desc = gpio_to_desc(gpio);
+
+	/* Compatibility: assume unavailable "valid" GPIOs will appear later */
+	if (!desc && gpio_is_valid(gpio))
+		return -EPROBE_DEFER;
+
+	return gpiod_request(desc, label);
 }
 EXPORT_SYMBOL_GPL(gpio_request);
 
-- 
2.1.3

