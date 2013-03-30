Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab3C3QFh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 12:05:37 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:41782 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609Ab3C3QFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 12:05:36 -0400
Message-ID: <1364659529.15109.4.camel@phoenix>
Subject: [RFT][PATCH 1/2] pwm: lpc32xx: Properly set PWM_ENABLE bit in
 lpc32xx_pwm_[enable|disable]
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Roland Stigge <stigge@antcom.de>, linux-kernel@vger.kernel.org
Date: Sun, 31 Mar 2013 00:05:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the LPC32x0 User Manual [1]:

PWMx Control Registers:
BIT 31 (PWMx_EN):
0 = PWM disabled. (Default)
1 = PWM enabled

In lpc32xx_pwm_enable(), we should set PWM_ENABLE bit.
In lpc32xx_pwm_disable(), we should just clear PWM_ENABLE bit rather than
write 0 to the register which will also clear PWMx_RELOADV and PWMx_DUTY bits.

[1] http://www.nxp.com/documents/user_manual/UM10326.pdf

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi,
I don't have this hardware handy so I'd appreciate if someone can test this
patch serial.

Thanks,
Axel

 drivers/pwm/pwm-lpc32xx.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
index b3f0d0d..1a5075e 100644
--- a/drivers/pwm/pwm-lpc32xx.c
+++ b/drivers/pwm/pwm-lpc32xx.c
@@ -77,15 +77,29 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 static int lpc32xx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct lpc32xx_pwm_chip *lpc32xx = to_lpc32xx_pwm_chip(chip);
+	u32 val;
+	int ret;
+
+	ret = clk_enable(lpc32xx->clk);
+	if (ret)
+		return ret;
 
-	return clk_enable(lpc32xx->clk);
+	val = readl(lpc32xx->base + (pwm->hwpwm << 2));
+	val |= PWM_ENABLE;
+	writel(val, lpc32xx->base + (pwm->hwpwm << 2));
+
+	return 0;
 }
 
 static void lpc32xx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct lpc32xx_pwm_chip *lpc32xx = to_lpc32xx_pwm_chip(chip);
+	u32 val;
+
+	val = readl(lpc32xx->base + (pwm->hwpwm << 2));
+	val &= ~PWM_ENABLE;
+	writel(val, lpc32xx->base + (pwm->hwpwm << 2));
 
-	writel(0, lpc32xx->base + (pwm->hwpwm << 2));
 	clk_disable(lpc32xx->clk);
 }
 
-- 
1.7.10.4



