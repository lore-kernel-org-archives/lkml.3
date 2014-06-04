Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbaFEAWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:22:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbaFDXW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Bryan Wu <cooloney@gmail.com>
Subject: [PATCH 3.14 122/228] leds: leds-pwm: properly clean up after probe failure
Date: Wed,  4 Jun 2014 16:22:31 -0700
Message-Id: <20140604232351.967036990@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/leds/leds-pwm.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -84,6 +84,15 @@ static inline size_t sizeof_pwm_leds_pri
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
 static int led_pwm_create_of(struct platform_device *pdev,
 			     struct led_pwm_priv *priv)
 {
@@ -131,8 +140,7 @@ static int led_pwm_create_of(struct plat
 
 	return 0;
 err:
-	while (priv->num_leds--)
-		led_classdev_unregister(&priv->leds[priv->num_leds].cdev);
+	led_pwm_cleanup(priv);
 
 	return ret;
 }
@@ -200,8 +208,8 @@ static int led_pwm_probe(struct platform
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


