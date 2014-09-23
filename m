Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbaIWXRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 19:17:36 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:64326 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbaIWXRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 19:17:34 -0400
From: Doug Anderson <dianders@chromium.org>
To: thierry.reding@gmail.com, Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>
Cc: Chris Zhong <zyw@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        Sonny Rao <sonnyrao@chromium.org>,
        Doug Anderson <dianders@chromium.org>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] pwm: Add the concept of an "active" pinctrl
Date: Tue, 23 Sep 2014 16:17:26 -0700
Message-Id: <1411514246-6163-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are cases where you really don't want a PWM's pinctrl to take
effect until you know that the PWM is driving at the proper rate.  A
good example of this is a PWM-controlled regulator, where the boot
state of the pin (maybe a pulled down input) could cause a vastly
different voltage to take effect than having the pin setup as a PWM
but not having the PWM enabled yet.

Let's add a feature where you can define an "active" pinctrl state.
This state (if it exists) will be applied after the PWM has actually
been enabled.  If the PWM is ever disabled we'll go back to "default"
state.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
I'm sure Linus W or Thierry or Mark will tell me this is an idiotic
idea (or totally the wrong way to do it), but I figured I'd float it
out there and maybe someone can tell me something better to do.  ;)

 drivers/pwm/core.c  | 34 +++++++++++++++++++++++++++++++---
 include/linux/pwm.h |  8 ++++++++
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 966497d..12f86e0 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -245,6 +245,14 @@ int pwmchip_add(struct pwm_chip *chip)
 	if (ret < 0)
 		goto out;
 
+	chip->pinctrl = devm_pinctrl_get(chip->dev);
+	if (!IS_ERR_OR_NULL(chip->pinctrl)) {
+		chip->state_default = pinctrl_lookup_state(chip->pinctrl,
+							   "default");
+		chip->state_active = pinctrl_lookup_state(chip->pinctrl,
+							  "active");
+	}
+
 	chip->pwms = kzalloc(chip->npwm * sizeof(*pwm), GFP_KERNEL);
 	if (!chip->pwms) {
 		ret = -ENOMEM;
@@ -457,8 +465,17 @@ EXPORT_SYMBOL_GPL(pwm_set_polarity);
  */
 int pwm_enable(struct pwm_device *pwm)
 {
-	if (pwm && !test_and_set_bit(PWMF_ENABLED, &pwm->flags))
-		return pwm->chip->ops->enable(pwm->chip, pwm);
+	int ret;
+
+	if (pwm && !test_and_set_bit(PWMF_ENABLED, &pwm->flags)) {
+		ret = pwm->chip->ops->enable(pwm->chip, pwm);
+
+		if (!ret && !IS_ERR_OR_NULL(pwm->chip->state_active))
+			ret = pinctrl_select_state(pwm->chip->pinctrl,
+						   pwm->chip->state_active);
+
+		return ret;
+	}
 
 	return pwm ? 0 : -EINVAL;
 }
@@ -470,8 +487,19 @@ EXPORT_SYMBOL_GPL(pwm_enable);
  */
 void pwm_disable(struct pwm_device *pwm)
 {
-	if (pwm && test_and_clear_bit(PWMF_ENABLED, &pwm->flags))
+	int ret;
+
+	if (pwm && test_and_clear_bit(PWMF_ENABLED, &pwm->flags)) {
+		if (!IS_ERR_OR_NULL(pwm->chip->state_default)) {
+			ret = pinctrl_select_state(pwm->chip->pinctrl,
+						   pwm->chip->state_default);
+			if (ret)
+				dev_warn(pwm->chip->dev,
+					 "Couldn't set def state: %d\n", ret);
+		}
+
 		pwm->chip->ops->disable(pwm->chip, pwm);
+	}
 }
 EXPORT_SYMBOL_GPL(pwm_disable);
 
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index e90628c..039c898 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -162,6 +162,10 @@ struct pwm_ops {
  * @pwms: array of PWM devices allocated by the framework
  * @can_sleep: must be true if the .config(), .enable() or .disable()
  *             operations may sleep
+ *
+ * @pinctrl: Pointer to the a pinctrl for the dev
+ * @state_default: We'll apply this when a PWM is disabled
+ * @state_active: We'll apply this when a PWM is enabled
  */
 struct pwm_chip {
 	struct device		*dev;
@@ -176,6 +180,10 @@ struct pwm_chip {
 					    const struct of_phandle_args *args);
 	unsigned int		of_pwm_n_cells;
 	bool			can_sleep;
+
+	struct pinctrl *pinctrl;
+	struct pinctrl_state *state_default;
+	struct pinctrl_state *state_active;
 };
 
 #if IS_ENABLED(CONFIG_PWM)
-- 
2.1.0.rc2.206.gedb03e5

