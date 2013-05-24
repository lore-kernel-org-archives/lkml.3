Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab3EXMHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:07:44 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:50450 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab3EXMHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:07:41 -0400
From: <patrice.chotard.st@gmail.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH 3/3] pinctrl: abx500: fix abx500_gpio_dbg_show_one() to show pull up/down
Date: Fri, 24 May 2013 14:06:31 +0200
Message-Id: <1369397191-16643-4-git-send-email-patrice.chotard.st@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1369397191-16643-1-git-send-email-patrice.chotard.st@gmail.com>
References: <1369397191-16643-1-git-send-email-patrice.chotard.st@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

_ rework abx500_gpio_dbg_show_one() to take in account pull up/down
  feature available on AB8540 only.
_ add abx500_get_pull_updown() needed by abx500_gpio_dbg_show_one()
_ rename abx500_config_pull_updown() to abx500_set_pull_updown()

Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
---
 drivers/pinctrl/pinctrl-abx500.c |   86 +++++++++++++++++++++++++++++++-------
 1 file changed, 70 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 7f2202a..0157fd3 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -181,10 +181,11 @@ static void abx500_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
 		dev_err(pct->dev, "%s write failed\n", __func__);
 }
 
-static int abx500_config_pull_updown(struct abx500_pinctrl *pct,
-				     int offset, enum abx500_gpio_pull_updown val)
+static int abx500_get_pull_updown(struct abx500_pinctrl *pct, int offset,
+				  enum abx500_gpio_pull_updown *pull_updown)
 {
 	u8 pos;
+	u8 val;
 	int ret;
 	struct pullud *pullud;
 
@@ -203,6 +204,40 @@ static int abx500_config_pull_updown(struct abx500_pinctrl *pct,
 		goto out;
 	}
 
+	ret = abx500_get_register_interruptible(pct->dev,
+			AB8500_MISC, AB8540_GPIO_PULL_UPDOWN_REG, &val);
+
+	pos = (offset - pullud->first_pin) << 1;
+	*pull_updown = (val >> pos) & AB8540_GPIO_PULL_UPDOWN_MASK;
+
+out:
+	if (ret < 0)
+		dev_err(pct->dev, "%s failed (%d)\n", __func__, ret);
+
+	return ret;
+}
+
+static int abx500_set_pull_updown(struct abx500_pinctrl *pct,
+				  int offset, enum abx500_gpio_pull_updown val)
+{
+	u8 pos;
+	int ret;
+	struct pullud *pullud;
+
+	if (!pct->soc->pullud) {
+		dev_err(pct->dev, "%s AB chip doesn't support pull up/down feature",
+				__func__);
+		ret = -EPERM;
+		goto out;
+	}
+
+	pullud = pct->soc->pullud;
+
+	if ((offset < pullud->first_pin)
+		|| (offset > pullud->last_pin)) {
+		ret = -EINVAL;
+		goto out;
+	}
 	pos = (offset - pullud->first_pin) << 1;
 
 	ret = abx500_mask_and_set_register_interruptible(pct->dev,
@@ -238,7 +273,7 @@ static int abx500_gpio_direction_output(struct gpio_chip *chip,
 	/* if supported, disable both pull down and pull up */
 	gpio = offset + 1;
 	if (pullud && gpio >= pullud->first_pin && gpio <= pullud->last_pin) {
-		ret = abx500_config_pull_updown(pct,
+		ret = abx500_set_pull_updown(pct,
 				gpio,
 				ABX500_GPIO_PULL_NONE);
 		if (ret < 0)
@@ -462,11 +497,14 @@ static void abx500_gpio_dbg_show_one(struct seq_file *s,
 				     struct gpio_chip *chip,
 				     unsigned offset, unsigned gpio)
 {
+	struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
+	struct pullud *pullud = pct->soc->pullud;
 	const char *label = gpiochip_is_requested(chip, offset - 1);
 	u8 gpio_offset = offset - 1;
 	int mode = -1;
 	bool is_out;
-	bool pull;
+	bool pd;
+	enum abx500_gpio_pull_updown pud;
 
 	const char *modes[] = {
 		[ABX500_DEFAULT]	= "default",
@@ -475,21 +513,37 @@ static void abx500_gpio_dbg_show_one(struct seq_file *s,
 		[ABX500_ALT_C]		= "altC",
 	};
 
+	const char *pull_up_down[] = {
+		[ABX500_GPIO_PULL_DOWN]		= "pull down",
+		[ABX500_GPIO_PULL_NONE]		= "pull none",
+		[ABX500_GPIO_PULL_NONE + 1]	= "pull none",
+		[ABX500_GPIO_PULL_UP]		= "pull up",
+	};
+
 	abx500_gpio_get_bit(chip, AB8500_GPIO_DIR1_REG, gpio_offset, &is_out);
-	abx500_gpio_get_bit(chip, AB8500_GPIO_PUD1_REG, gpio_offset, &pull);
+
+	seq_printf(s, " gpio-%-3d (%-20.20s) %-3s",
+		   gpio, label ?: "(none)",
+		   is_out ? "out" : "in ");
+
+	if (!is_out) {
+		if (pullud &&
+		   (offset >= pullud->first_pin) &&
+		   (offset <= pullud->last_pin)) {
+			abx500_get_pull_updown(pct, offset, &pud);
+			seq_printf(s, " %-9s", pull_up_down[pud]);
+		} else {
+			abx500_gpio_get_bit(chip, AB8500_GPIO_PUD1_REG,
+					    gpio_offset, &pd);
+			seq_printf(s, " %-9s", pull_up_down[pd]);
+		}
+	} else
+		seq_printf(s, " %-9s", chip->get(chip, offset) ? "hi" : "lo");
 
 	if (pctldev)
 		mode = abx500_get_mode(pctldev, chip, offset);
 
-	seq_printf(s, " gpio-%-3d (%-20.20s) %-3s %-9s %s",
-		   gpio, label ?: "(none)",
-		   is_out ? "out" : "in ",
-		   is_out ?
-		   (chip->get
-		   ? (chip->get(chip, offset) ? "hi" : "lo")
-		   : "?  ")
-		   : (pull ? "pull up" : "pull down"),
-		   (mode < 0) ? "unknown" : modes[mode]);
+	seq_printf(s, " %s", (mode < 0) ? "unknown" : modes[mode]);
 }
 
 static void abx500_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
@@ -754,7 +808,7 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 		if (pullud &&
 		    pin >= pullud->first_pin &&
 		    pin <= pullud->last_pin)
-			ret = abx500_config_pull_updown(pct,
+			ret = abx500_set_pull_updown(pct,
 				pin,
 				argument ? ABX500_GPIO_PULL_DOWN : ABX500_GPIO_PULL_NONE);
 		else
@@ -779,7 +833,7 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 		if (pullud &&
 		    pin >= pullud->first_pin &&
 		    pin <= pullud->last_pin) {
-			ret = abx500_config_pull_updown(pct,
+			ret = abx500_set_pull_updown(pct,
 				pin,
 				argument ? ABX500_GPIO_PULL_UP : ABX500_GPIO_PULL_NONE);
 		}
-- 
1.7.10

