Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbaCYX4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 19:56:55 -0400
Received: from gloria.sntech.de ([95.129.55.99]:50241 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbaCYX4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 19:56:54 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Beniamino Galvani <b.galvani@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] pinctrl: rockchip: add return value to rockchip_set_mux
Date: Wed, 26 Mar 2014 00:57 +0100
Message-ID: <15012226.smy7tTQaIe@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1647754.qr1tAySXax@diego>
References: <1395700561-3793-1-git-send-email-b.galvani@gmail.com> <20140325194357.GA27520@gmail.com> <1647754.qr1tAySXax@diego>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a following change, rockchip_set_mux gets the possibility to fail.
Therefore add a return value to it and honor error codes in functions
using rockchip_set_mux.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/pinctrl/pinctrl-rockchip.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 23e8812..80e28e5 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -342,7 +342,7 @@ static const struct pinctrl_ops rockchip_pctrl_ops = {
  * @pin: pin to change
  * @mux: new mux function to set
  */
-static void rockchip_set_mux(struct rockchip_pin_bank *bank, int pin, int mux)
+static int rockchip_set_mux(struct rockchip_pin_bank *bank, int pin, int mux)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 	void __iomem *reg = info->reg_base + info->ctrl->mux_offset;
@@ -365,6 +365,8 @@ static void rockchip_set_mux(struct rockchip_pin_bank *bank, int pin, int mux)
 	writel(data, reg);
 
 	spin_unlock_irqrestore(&bank->slock, flags);
+
+	return 0;
 }
 
 #define RK2928_PULL_OFFSET		0x118
@@ -560,7 +562,7 @@ static int rockchip_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
 	const unsigned int *pins = info->groups[group].pins;
 	const struct rockchip_pin_config *data = info->groups[group].data;
 	struct rockchip_pin_bank *bank;
-	int cnt;
+	int cnt, ret = 0;
 
 	dev_dbg(info->dev, "enable function %s group %s\n",
 		info->functions[selector].name, info->groups[group].name);
@@ -571,8 +573,18 @@ static int rockchip_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
 	 */
 	for (cnt = 0; cnt < info->groups[group].npins; cnt++) {
 		bank = pin_to_bank(info, pins[cnt]);
-		rockchip_set_mux(bank, pins[cnt] - bank->pin_base,
-				 data[cnt].func);
+		ret = rockchip_set_mux(bank, pins[cnt] - bank->pin_base,
+				       data[cnt].func);
+		if (ret)
+			break;
+	}
+
+	if (ret) {
+		/* revert the already done pin settings */
+		for (cnt--; cnt >= 0; cnt--)
+			rockchip_set_mux(bank, pins[cnt] - bank->pin_base, 0);
+
+		return ret;
 	}
 
 	return 0;
@@ -607,7 +619,7 @@ static int rockchip_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
 	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
 	struct rockchip_pin_bank *bank;
 	struct gpio_chip *chip;
-	int pin;
+	int pin, ret;
 	u32 data;
 
 	chip = range->gc;
@@ -617,7 +629,9 @@ static int rockchip_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
 	dev_dbg(info->dev, "gpio_direction for pin %u as %s-%d to %s\n",
 		 offset, range->name, pin, input ? "input" : "output");
 
-	rockchip_set_mux(bank, pin, RK_FUNC_GPIO);
+	ret = rockchip_set_mux(bank, pin, RK_FUNC_GPIO);
+	if (ret < 0)
+		return ret;
 
 	data = readl_relaxed(bank->reg_base + GPIO_SWPORT_DDR);
 	/* set bit to 1 for output, 0 for input */
@@ -1144,9 +1158,13 @@ static int rockchip_irq_set_type(struct irq_data *d, unsigned int type)
 	u32 polarity;
 	u32 level;
 	u32 data;
+	int ret;
 
 	/* make sure the pin is configured as gpio input */
-	rockchip_set_mux(bank, d->hwirq, RK_FUNC_GPIO);
+	ret = rockchip_set_mux(bank, d->hwirq, RK_FUNC_GPIO);
+	if (ret < 0)
+		return ret;
+
 	data = readl_relaxed(bank->reg_base + GPIO_SWPORT_DDR);
 	data &= ~mask;
 	writel_relaxed(data, bank->reg_base + GPIO_SWPORT_DDR);
-- 
1.9.0


