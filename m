Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583AbaFII60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:58:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58564 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932201AbaFIIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Bryan Wu <cooloney@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 082/146] leds: leds-pwm: properly clean up after probe failure
Date: Mon,  9 Jun 2014 10:50:17 +0200
Message-Id: <22e8818b7fbe6f9ffa854cf895352d027766690a.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 392369019eb96e914234ea21eda806cb51a1073e upstream.

When probing with DT, we add each LED one at a time.  If we find a LED
without a PWM device (because it is not available yet) we fail the
initialisation, unregister previous LEDs, and then by way of managed
resources, we free the structure.

The problem with this is we may have a scheduled and active work_struct
in this structure, and this results in a nasty kernel oops.

We need to cancel this work_struct properly upon cleanup - and the
cleanup we require is the same cleanup as we do when the LED platform
device is removed.  Rather than writing this same code three times,
move it into a separate function and use it in all three places.

Fixes: c971ff185f64 ("leds: leds-pwm: Defer led_pwm_set() if PWM can sleep")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Bryan Wu <cooloney@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/leds/leds-pwm.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index bb6f94898541..305e88a6f625 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -82,6 +82,15 @@ static inline size_t sizeof_pwm_leds_priv(int num_leds)
 		      (sizeof(struct led_pwm_data) * num_leds);
 }
 
+static void led_pwm_cleanup(struct led_pwm_priv *priv)
+{
+	while (priv->num_leds--) {
+		led_classdev_unregister(&priv->leds[priv->num_leds].cdev);
+		if (priv->leds[priv->num_leds].can_sleep)
+			cancel_work_sync(&priv->leds[priv->num_leds].work);
+	}
+}
+
 static struct led_pwm_priv *led_pwm_create_of(struct platform_device *pdev)
 {
 	struct device_node *node = pdev->dev.of_node;
@@ -139,8 +148,7 @@ static struct led_pwm_priv *led_pwm_create_of(struct platform_device *pdev)
 
 	return priv;
 err:
-	while (priv->num_leds--)
-		led_classdev_unregister(&priv->leds[priv->num_leds].cdev);
+	led_pwm_cleanup(priv);
 
 	return NULL;
 }
@@ -200,8 +208,8 @@ static int led_pwm_probe(struct platform_device *pdev)
 	return 0;
 
 err:
-	while (i--)
-		led_classdev_unregister(&priv->leds[i].cdev);
+	priv->num_leds = i;
+	led_pwm_cleanup(priv);
 
 	return ret;
 }
@@ -209,13 +217,8 @@ err:
 static int led_pwm_remove(struct platform_device *pdev)
 {
 	struct led_pwm_priv *priv = platform_get_drvdata(pdev);
-	int i;
 
-	for (i = 0; i < priv->num_leds; i++) {
-		led_classdev_unregister(&priv->leds[i].cdev);
-		if (priv->leds[i].can_sleep)
-			cancel_work_sync(&priv->leds[i].work);
-	}
+	led_pwm_cleanup(priv);
 
 	return 0;
 }
-- 
1.9.3

