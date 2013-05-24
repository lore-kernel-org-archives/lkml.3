Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3EXX0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 19:26:32 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.106]:32634 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707Ab3EXX0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 19:26:31 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1369437986!7512604!7
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/14] misc/ep93xx_pwm: remove ep93xx_pwm_disable() inline function
Date: Fri, 24 May 2013 16:24:51 -0700
User-Agent: KMail/1.9.9
CC: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>, <mcrapet@gmail.com>,
        <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201305241624.52837.hartleys@visionengravers.com>
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
 drivers/misc/ep93xx_pwm.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
index cf42347..320d911 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -44,11 +44,6 @@ static inline u16 ep93xx_pwm_read_tc(struct ep93xx_pwm *pwm)
 	return readl(pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
 }
 
-static inline void ep93xx_pwm_disable(struct ep93xx_pwm *pwm)
-{
-	writel(0x0, pwm->mmio_base + EP93XX_PWMx_ENABLE);
-}
-
 static inline int ep93xx_pwm_is_enabled(struct ep93xx_pwm *pwm)
 {
 	return readl(pwm->mmio_base + EP93XX_PWMx_ENABLE) & 0x1;
@@ -127,7 +122,7 @@ static ssize_t ep93xx_pwm_set_freq(struct device *dev,
 		return -EINVAL;
 
 	if (val == 0) {
-		ep93xx_pwm_disable(pwm);
+		writel(0x0, pwm->mmio_base + EP93XX_PWMx_ENABLE);
 	} else if (val <= (clk_get_rate(pwm->clk) / 2)) {
 		u32 term, duty;
 
@@ -276,7 +271,7 @@ static int __init ep93xx_pwm_probe(struct platform_device *pdev)
 	pwm->duty_percent = 50;
 
 	/* disable pwm at startup. Avoids zero value. */
-	ep93xx_pwm_disable(pwm);
+	writel(0x0, pwm->mmio_base + EP93XX_PWMx_ENABLE);
 	writel(EP93XX_PWM_MAX_COUNT, pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
 	writel(EP93XX_PWM_MAX_COUNT/2, pwm->mmio_base + EP93XX_PWMx_DUTY_CYCLE);
 
@@ -290,7 +285,7 @@ static int __exit ep93xx_pwm_remove(struct platform_device *pdev)
 {
 	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
 
-	ep93xx_pwm_disable(pwm);
+	writel(0x0, pwm->mmio_base + EP93XX_PWMx_ENABLE);
 	clk_disable(pwm->clk);
 	sysfs_remove_group(&pdev->dev.kobj, &ep93xx_pwm_sysfs_files);
 	ep93xx_pwm_release_gpio(pdev);
-- 
1.8.1.4

