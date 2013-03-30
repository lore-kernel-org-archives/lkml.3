Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab3C3QZF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 12:25:05 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:43545 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790Ab3C3QZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 12:25:03 -0400
Message-ID: <1364660697.17470.1.camel@phoenix>
Subject: [RFT][PATCH v2 2/2] pwm: lpc32xx: Don't change PWM_ENABLE bit in
 lpc32xx_pwm_config
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Roland Stigge <stigge@antcom.de>, linux-kernel@vger.kernel.org
Date: Sun, 31 Mar 2013 00:24:57 +0800
In-Reply-To: <1364659529.15109.4.camel@phoenix>
References: <1364659529.15109.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lpc32xx_pwm_config() is supposed to set duty_ns and period_ns,
it should not change PWM_ENABLE and other bits.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pwm/pwm-lpc32xx.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
index 1a5075e..e936202 100644
--- a/drivers/pwm/pwm-lpc32xx.c
+++ b/drivers/pwm/pwm-lpc32xx.c
@@ -37,6 +37,7 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	struct lpc32xx_pwm_chip *lpc32xx = to_lpc32xx_pwm_chip(chip);
 	unsigned long long c;
 	int period_cycles, duty_cycles;
+	u32 val;
 
 	c = clk_get_rate(lpc32xx->clk) / 256;
 	c = c * period_ns;
@@ -68,8 +69,10 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 		c = 255;
 	duty_cycles = 256 - c;
 
-	writel(PWM_ENABLE | PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles),
-		lpc32xx->base + (pwm->hwpwm << 2));
+	val = readl(lpc32xx->base + (pwm->hwpwm << 2));
+	val &= ~0xFFFF;
+	val |= PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles);
+	writel(val, lpc32xx->base + (pwm->hwpwm << 2));
 
 	return 0;
 }
-- 
1.7.10.4



