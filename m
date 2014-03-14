Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbaCNOTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:19:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48114 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755560AbaCNOTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:19:18 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Bo Shen <voice.shen@atmel.com>, linux-pwm@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 1/2] PWM: atmel: Fix polarity handling
Date: Fri, 14 Mar 2014 15:19:08 +0100
Message-Id: <1394806749-29778-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394806749-29778-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1394806749-29778-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When atmel_pwm_config() calculates and then sets the prescaler, it is
overwriting the channel's CMR register so we are losing the CPOL configuration.

As atmel_pwm_config() is always called before enabling a channel, inverting the
polarity doesn't work.

Fix that by reading CMR first and only overwriting the prescaler bits.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/pwm/pwm-atmel.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
index bf4144a14661..2d69e9c431dd 100644
--- a/drivers/pwm/pwm-atmel.c
+++ b/drivers/pwm/pwm-atmel.c
@@ -32,6 +32,7 @@
 /* Bit field in CMR */
 #define PWM_CMR_CPOL		(1 << 9)
 #define PWM_CMR_UPD_CDTY	(1 << 10)
+#define PWM_CMR_CPRE_MSK	0xF
 
 /* The following registers for PWM v1 */
 #define PWMV1_CDTY		0x04
@@ -104,6 +105,7 @@ static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	unsigned long clk_rate, prd, dty;
 	unsigned long long div;
 	unsigned int pres = 0;
+	u32 val;
 	int ret;
 
 	if (test_bit(PWMF_ENABLED, &pwm->flags) && (period_ns != pwm->period)) {
@@ -139,7 +141,10 @@ static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 		return ret;
 	}
 
-	atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, pres);
+	/* It is necessary to preserve CPOL, inside CMR */
+	val = atmel_pwm_ch_readl(atmel_pwm, pwm->hwpwm, PWM_CMR);
+	val = (val & ~PWM_CMR_CPRE_MSK) | (pres & PWM_CMR_CPRE_MSK);
+	atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, val);
 	atmel_pwm->config(chip, pwm, dty, prd);
 
 	clk_disable(atmel_pwm->clk);
-- 
1.8.3.2

