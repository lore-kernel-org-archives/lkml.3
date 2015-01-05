Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbbAEBNt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 20:13:49 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:35365 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbbAEBNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 20:13:32 -0500
From: Tim Kryger <tim.kryger@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Scott Branden <sbranden@broadcom.com>,
        Arun Ramamurthy <arunrama@broadcom.com>,
        Jonathan Richardson <jonathar@broadcom.com>
Cc: Ray Jui <rjui@broadcom.com>, Linux PWM <linux-pwm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback 
	<bcm-kernel-feedback-list@broadcom.com>,
        Tim Kryger <tim.kryger@gmail.com>
Subject: [PATCH 2/2] drivers: pwm: bcm-kona: Dont set polarity in probe
Date: Sun,  4 Jan 2015 17:12:56 -0800
Message-Id: <1420420376-13087-3-git-send-email-tim.kryger@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420420376-13087-1-git-send-email-tim.kryger@gmail.com>
References: <1420420376-13087-1-git-send-email-tim.kryger@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arun Ramamurthy <arunrama@broadcom.com>

Omit setting the polarity to normal during probe and instead use the
new pwmchip_add_inversed function to register a PWM chip with default
polarity of inversed for all channels as this is the actual hardware
default.

Signed-off-by: Arun Ramamurthy <arunrama@broadcom.com>
Reviewed-by: Ray Jui <rjui@broadcom.com>
Signed-off-by: Scott Branden <sbranden@broadcom.com>
Signed-off-by: Tim Kryger <tim.kryger@gmail.com>
---

This is based on Arun's patch (originally posted by Scott)

https://lkml.org/lkml/2014/11/25/1019

I modified it to use the pwmchip_add_inversed function so the polarity
could be safely left at the power on default and updated the commit
message accordingly.

 drivers/pwm/pwm-bcm-kona.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
index 02bc048..32b3ec6 100644
--- a/drivers/pwm/pwm-bcm-kona.c
+++ b/drivers/pwm/pwm-bcm-kona.c
@@ -266,18 +266,15 @@ static int kona_pwmc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	/* Set smooth mode, push/pull, and normal polarity for all channels */
-	for (chan = 0; chan < kp->chip.npwm; chan++) {
-		value |= (1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
+	/* Set push/pull for all channels */
+	for (chan = 0; chan < kp->chip.npwm; chan++)
 		value |= (1 << PWM_CONTROL_TYPE_SHIFT(chan));
-		value |= (1 << PWM_CONTROL_POLARITY_SHIFT(chan));
-	}
 
 	writel(value, kp->base + PWM_CONTROL_OFFSET);
 
 	clk_disable_unprepare(kp->clk);
 
-	ret = pwmchip_add(&kp->chip);
+	ret = pwmchip_add_inversed(&kp->chip);
 	if (ret < 0)
 		dev_err(&pdev->dev, "failed to add PWM chip: %d\n", ret);
 
-- 
1.9.1

