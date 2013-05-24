Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab3EXX21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 19:28:27 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.205]:61799 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754525Ab3EXX20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 19:28:26 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-131.messagelabs.com!1369438100!26400341!3
X-Originating-IP: [216.166.12.178]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/14] misc/ep93xx_pwm: remove ep93xx_pwm_read_tc() inline function
Date: Fri, 24 May 2013 16:26:41 -0700
User-Agent: KMail/1.9.9
CC: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>, <mcrapet@gmail.com>,
        <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201305241626.41902.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a simple wrapper around readl(), remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Matthieu Crapet <mcrapet@gmail.com>
---
 drivers/misc/ep93xx_pwm.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
index cdc2ffc..6f48375 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -39,11 +39,6 @@ struct ep93xx_pwm {
 	u32		duty_percent;
 };
 
-static inline u16 ep93xx_pwm_read_tc(struct ep93xx_pwm *pwm)
-{
-	return readl(pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
-}
-
 static inline int ep93xx_pwm_is_enabled(struct ep93xx_pwm *pwm)
 {
 	return readl(pwm->mmio_base + EP93XX_PWMx_ENABLE) & 0x1;
@@ -91,7 +86,7 @@ static ssize_t ep93xx_pwm_get_freq(struct device *dev,
 
 	if (ep93xx_pwm_is_enabled(pwm)) {
 		unsigned long rate = clk_get_rate(pwm->clk);
-		u16 term = ep93xx_pwm_read_tc(pwm);
+		u16 term = readl(pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
 
 		return sprintf(buf, "%ld\n", rate / (term + 1));
 	} else {
@@ -122,7 +117,7 @@ static ssize_t ep93xx_pwm_set_freq(struct device *dev,
 		if (val < 1)
 			val = 1;
 
-		term = ep93xx_pwm_read_tc(pwm);
+		term = readl(pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
 		duty = ((val + 1) * pwm->duty_percent / 100) - 1;
 
 		/* If pwm is running, order is important */
@@ -165,7 +160,7 @@ static ssize_t ep93xx_pwm_set_duty_percent(struct device *dev,
 		return -EINVAL;
 
 	if (val > 0 && val < 100) {
-		u32 term = ep93xx_pwm_read_tc(pwm);
+		u32 term = readl(pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
 		u32 duty = ((term + 1) * val / 100) - 1;
 
 		writel(duty, pwm->mmio_base + EP93XX_PWMx_DUTY_CYCLE);
-- 
1.8.1.4

