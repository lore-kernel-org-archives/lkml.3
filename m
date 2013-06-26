Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab3FZK00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 06:26:26 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:6847 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3FZK0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 06:26:24 -0400
From: Robin van der Gracht <robin@protonic.nl>
To: thierry.reding@gmail.com
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawn.guo@linaro.org, robin@protonic.nl
Subject: [PATCH v2] pwm: pwm-mxs: Wait for configuration to apply before disabling PWM.
Date: Wed, 26 Jun 2013 12:26:13 +0200
Message-Id: <1372242373-17962-1-git-send-email-robin@protonic.nl>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have to be sure that the last configuration has been applied. In most
cases drivers will have set the duty-cycle to 0%. To prevent the PWM
from locking at a 100% duty-cycle, we delay disabling the PWM for a
whole period to make sure any new configuration has been latched.

Signed-off-by: Robin van der Gracht <robin@protonic.nl>
---
 drivers/pwm/pwm-mxs.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pwm/pwm-mxs.c b/drivers/pwm/pwm-mxs.c
index a53d309..7e1fa0a 100644
--- a/drivers/pwm/pwm-mxs.c
+++ b/drivers/pwm/pwm-mxs.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
@@ -113,6 +114,12 @@ static int mxs_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 static void mxs_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct mxs_pwm_chip *mxs = to_mxs_pwm_chip(chip);
+	unsigned int period;
+
+	/* Ensure latest configuration applied. */
+	period = pwm_get_period(pwm);
+	period = DIV_ROUND_UP(period, NSEC_PER_USEC);
+	usleep_range(period, period + 1000);
 
 	writel(1 << pwm->hwpwm, mxs->base + PWM_CTRL + CLR);
 
-- 
1.7.9.5

