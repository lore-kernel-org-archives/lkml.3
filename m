Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934725Ab3FSMOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:14:21 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:24465 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934108Ab3FSMOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:14:18 -0400
X-Greylist: delayed 1359 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jun 2013 08:14:18 EDT
From: Robin van der Gracht <robin@protonic.nl>
To: thierry.reding@avionic-design.de
Cc: linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        Robin van der Gracht <robin@protonic.nl>
Subject: [PATCH] pwm: pwm-mxs: Apply configuration before disabling PWM.
Date: Wed, 19 Jun 2013 13:51:26 +0200
Message-Id: <1371642686-10300-1-git-send-email-robin@protonic.nl>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When disabling the pwm, the output state locks at its current state.
We have to be sure the last configuration applied. Which in most
cases sets duty cycle to 0%. To prevent the pwm from taking on
100% duty cycle when disabled during a high state.

Configuration applies at the beginning of a new output period.

Signed-off-by: Robin van der Gracht <robin@protonic.nl>
---
 drivers/pwm/pwm-mxs.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pwm/pwm-mxs.c b/drivers/pwm/pwm-mxs.c
index 3febddd..4ddc063 100644
--- a/drivers/pwm/pwm-mxs.c
+++ b/drivers/pwm/pwm-mxs.c
@@ -21,6 +21,7 @@
 #include <linux/pwm.h>
 #include <linux/slab.h>
 #include <linux/stmp_device.h>
+#include <linux/delay.h>
 
 #define SET	0x4
 #define CLR	0x8
@@ -40,6 +41,7 @@ struct mxs_pwm_chip {
 	struct pwm_chip chip;
 	struct clk *clk;
 	void __iomem *base;
+	unsigned long period_ns;
 };
 
 #define to_mxs_pwm_chip(_chip) container_of(_chip, struct mxs_pwm_chip, chip)
@@ -92,6 +94,7 @@ static int mxs_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (!test_bit(PWMF_ENABLED, &pwm->flags))
 		clk_disable_unprepare(mxs->clk);
 
+	mxs->period_ns = period_ns;
 	return 0;
 }
 
@@ -113,6 +116,11 @@ static void mxs_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct mxs_pwm_chip *mxs = to_mxs_pwm_chip(chip);
 
+	/*
+	 * Ensure latest configuration applied.
+	 */
+	ndelay(mxs->period_ns);
+
 	writel(1 << pwm->hwpwm, mxs->base + PWM_CTRL + CLR);
 
 	clk_disable_unprepare(mxs->clk);
-- 
1.7.9.5

