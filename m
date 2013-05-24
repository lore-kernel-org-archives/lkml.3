Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab3EXXZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 19:25:01 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.99]:24905 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880Ab3EXXY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 19:24:59 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-160.messagelabs.com!1369437896!5754328!6
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/14] misc/ep93xx_pwm: remove ep93xx_pwm_write_tc() inline function
Date: Fri, 24 May 2013 16:23:00 -0700
User-Agent: KMail/1.9.9
CC: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>, <mcrapet@gmail.com>,
        <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201305241623.00686.hartleys@visionengravers.com>
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
index 06f0c63..ab5a481 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -39,11 +39,6 @@ struct ep93xx_pwm {
 	u32		duty_percent;
 };
 
-static inline void ep93xx_pwm_write_tc(struct ep93xx_pwm *pwm, u16 value)
-{
-	writel(value, pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
-}
-
 static inline u16 ep93xx_pwm_read_tc(struct ep93xx_pwm *pwm)
 {
 	return readl(pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
@@ -157,11 +152,11 @@ static ssize_t ep93xx_pwm_set_freq(struct device *dev,
 
 		/* If pwm is running, order is important */
 		if (val > term) {
-			ep93xx_pwm_write_tc(pwm, val);
+			writel(val, pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
 			ep93xx_pwm_write_dc(pwm, duty);
 		} else {
 			ep93xx_pwm_write_dc(pwm, duty);
-			ep93xx_pwm_write_tc(pwm, val);
+			writel(val, pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
 		}
 
 		if (!ep93xx_pwm_is_enabled(pwm))
@@ -290,7 +285,7 @@ static int __init ep93xx_pwm_probe(struct platform_device *pdev)
 
 	/* disable pwm at startup. Avoids zero value. */
 	ep93xx_pwm_disable(pwm);
-	ep93xx_pwm_write_tc(pwm, EP93XX_PWM_MAX_COUNT);
+	writel(EP93XX_PWM_MAX_COUNT, pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
 	ep93xx_pwm_write_dc(pwm, EP93XX_PWM_MAX_COUNT / 2);
 
 	clk_enable(pwm->clk);
-- 
1.8.1.4

