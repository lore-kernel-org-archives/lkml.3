Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3EXXYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 19:24:53 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.193]:42631 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880Ab3EXXYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 19:24:52 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-132.messagelabs.com!1369437890!9402380!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/14] misc/ep93xx_pwm: remove ep93xx_pwm_write_dc() inline function
Date: Fri, 24 May 2013 16:23:38 -0700
User-Agent: KMail/1.9.9
CC: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>, <mcrapet@gmail.com>,
        <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201305241623.38893.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a simple wrapper around writel(), remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Matthieu Crapet <mcrapet@gmail.com>
---
 drivers/misc/ep93xx_pwm.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
index ab5a481..7a13304 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -44,11 +44,6 @@ static inline u16 ep93xx_pwm_read_tc(struct ep93xx_pwm *pwm)
 	return readl(pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
 }
 
-static inline void ep93xx_pwm_write_dc(struct ep93xx_pwm *pwm, u16 value)
-{
-	writel(value, pwm->mmio_base + EP93XX_PWMx_DUTY_CYCLE);
-}
-
 static inline void ep93xx_pwm_enable(struct ep93xx_pwm *pwm)
 {
 	writel(0x1, pwm->mmio_base + EP93XX_PWMx_ENABLE);
@@ -153,9 +148,9 @@ static ssize_t ep93xx_pwm_set_freq(struct device *dev,
 		/* If pwm is running, order is important */
 		if (val > term) {
 			writel(val, pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
-			ep93xx_pwm_write_dc(pwm, duty);
+			writel(duty, pwm->mmio_base + EP93XX_PWMx_DUTY_CYCLE);
 		} else {
-			ep93xx_pwm_write_dc(pwm, duty);
+			writel(duty, pwm->mmio_base + EP93XX_PWMx_DUTY_CYCLE);
 			writel(val, pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
 		}
 
@@ -191,7 +186,9 @@ static ssize_t ep93xx_pwm_set_duty_percent(struct device *dev,
 
 	if (val > 0 && val < 100) {
 		u32 term = ep93xx_pwm_read_tc(pwm);
-		ep93xx_pwm_write_dc(pwm, ((term + 1) * val / 100) - 1);
+		u32 duty = ((term + 1) * val / 100) - 1;
+
+		writel(duty, pwm->mmio_base + EP93XX_PWMx_DUTY_CYCLE);
 		pwm->duty_percent = val;
 		return count;
 	}
@@ -286,7 +283,7 @@ static int __init ep93xx_pwm_probe(struct platform_device *pdev)
 	/* disable pwm at startup. Avoids zero value. */
 	ep93xx_pwm_disable(pwm);
 	writel(EP93XX_PWM_MAX_COUNT, pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
-	ep93xx_pwm_write_dc(pwm, EP93XX_PWM_MAX_COUNT / 2);
+	writel(EP93XX_PWM_MAX_COUNT/2, pwm->mmio_base + EP93XX_PWMx_DUTY_CYCLE);
 
 	clk_enable(pwm->clk);
 
-- 
1.8.1.4

