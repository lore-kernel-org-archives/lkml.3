Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbaLKBHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:07:03 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:30005 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855AbaLKBG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:06:59 -0500
X-IronPort-AV: E=Sophos;i="5.07,554,1413270000"; 
   d="scan'208";a="52624513"
From: Jonathan Richardson <jonathar@broadcom.com>
To: Tim Kryger <tim.kryger@gmail.com>
CC: Scott Branden <sbranden@broadcom.com>,
        Arun Ramamurthy <arun.ramamurthy@broadcom.com>,
        Thierry Reding <thierry.reding@gmail.com>, Ray Jui <rjui@broadcom.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-kernel@vger.kernel.org>, <linux-pwm@vger.kernel.org>,
        "Jonathan Richardson" <jonathar@broadcom.com>
Subject: [PATCH v2 2/2] pwm: kona: Remove setting default smooth type and polarity for all channels
Date: Wed, 10 Dec 2014 17:07:39 -0800
Message-ID: <1418260059-1642-2-git-send-email-jonathar@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418260059-1642-1-git-send-email-jonathar@broadcom.com>
References: <Jonathan Richardson <jonathar@broadcom.com>
 <1418260059-1642-1-git-send-email-jonathar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting the default polarity in probe to normal for all channels caused
the speaker pwm channel to click. The polarity does need to be set to
normal because the hw default is inversed whereas the pwm framework
defaults to normal. If a channel is enabled without setting the polarity
then the signal would be inversed while linux reports normal. A check
is now done prior to enabling the channel to ensure that the hw polarity
matches the desired polarity and is changed if there is a discrepency. This
prevents unnecessary settings being applied to unused channels but still
ensures the correct polarity to be set.

Reviewed-by: Scott Branden <sbranden@broadcom.com>
Tested-by: Scott Branden <sbranden@broadcom.com>
Signed-off-by: Jonathan Richardson <jonathar@broadcom.com>
---
 drivers/pwm/pwm-bcm-kona.c |   38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
index 6d92026..46a3da5 100644
--- a/drivers/pwm/pwm-bcm-kona.c
+++ b/drivers/pwm/pwm-bcm-kona.c
@@ -95,6 +95,32 @@ static void kona_pwmc_apply_settings(struct kona_pwmc *kp, unsigned int chan)
 	ndelay(400);
 }
 
+static void kona_pwmc_check_set_polarity(struct pwm_chip *chip,
+	struct pwm_device *pwm)
+{
+	struct kona_pwmc *kp = to_kona_pwmc(chip);
+	unsigned int chan = pwm->hwpwm;
+	enum pwm_polarity polarity = pwm->polarity;
+	unsigned int hw_pol;
+	unsigned int value = 0;
+
+	value = hw_pol = readl(kp->base + PWM_CONTROL_OFFSET);
+	hw_pol = (hw_pol >> PWM_CONTROL_POLARITY_SHIFT(chan)) & 0x1;
+
+	/*
+	 * If current polarity not the same as h/w then set polarity so that
+	 * they match.
+	 */
+	if (!hw_pol != polarity) {
+		if (polarity == PWM_POLARITY_NORMAL)
+			value |= 1 << PWM_CONTROL_POLARITY_SHIFT(chan);
+		else
+			value &= ~(1 << PWM_CONTROL_POLARITY_SHIFT(chan));
+
+		writel(value, kp->base + PWM_CONTROL_OFFSET);
+	}
+}
+
 static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device *pwm,
 			    int duty_ns, int period_ns)
 {
@@ -162,6 +188,13 @@ static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	dev_dbg(chip->dev, "pwm[%d]: period=%lu, duty_high=%lu, prescale=%lu\n",
 		chan, pc, dc, prescale);
 
+	/*
+	 * Ensure polarity is set properly. The default value for h/w and the
+	 * PWM framework are different. If a channel is enabled without setting
+	 * the polarity, the default value would be inconsistent to the signal.
+	 */
+	kona_pwmc_check_set_polarity(chip, pwm);
+
 	value = readl(kp->base + PWM_CONTROL_OFFSET);
 
 	/*
@@ -310,11 +343,8 @@ static int kona_pwmc_probe(struct platform_device *pdev)
 	}
 
 	/* Set smooth mode, push/pull, and normal polarity for all channels */
-	for (chan = 0; chan < kp->chip.npwm; chan++) {
-		value |= (1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
+	for (chan = 0; chan < kp->chip.npwm; chan++)
 		value |= (1 << PWM_CONTROL_TYPE_SHIFT(chan));
-		value |= (1 << PWM_CONTROL_POLARITY_SHIFT(chan));
-	}
 
 	writel(value, kp->base + PWM_CONTROL_OFFSET);
 
-- 
1.7.9.5

