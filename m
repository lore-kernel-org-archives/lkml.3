Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab3LOHDB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 02:03:01 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:5906 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029Ab3LOHCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 02:02:01 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Subject: [PATCH 2/4] pinctrl-msm: Tidy up error handling
Date: Sat, 14 Dec 2013 23:01:52 -0800
Message-ID: <1387090914-4755-3-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1387090914-4755-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1387090914-4755-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/pinctrl/pinctrl-msm.c |   76 ++++++++++++++---------------------------
 1 file changed, 26 insertions(+), 50 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index 322bc0a..c1a3053 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -57,7 +57,7 @@ struct msm_pinctrl {
 	struct pinctrl_dev *pctrl;
 	struct irq_domain *domain;
 	struct gpio_chip chip;
-	unsigned irq;
+	int irq;
 
 	spinlock_t lock;
 
@@ -201,7 +201,7 @@ static const struct pinmux_ops msm_pinmux_ops = {
 static int msm_config_reg(struct msm_pinctrl *pctrl,
 			  const struct msm_pingroup *g,
 			  unsigned param,
-			  unsigned *reg,
+			  s16 *reg,
 			  unsigned *mask,
 			  unsigned *bit)
 {
@@ -272,7 +272,7 @@ static int msm_config_group_get(struct pinctrl_dev *pctldev,
 	unsigned mask;
 	unsigned arg;
 	unsigned bit;
-	unsigned reg;
+	s16 reg;
 	int ret;
 	u32 val;
 
@@ -322,7 +322,7 @@ static int msm_config_group_set(struct pinctrl_dev *pctldev,
 	unsigned mask;
 	unsigned arg;
 	unsigned bit;
-	unsigned reg;
+	s16 reg;
 	int ret;
 	u32 val;
 	int i;
@@ -350,7 +350,7 @@ static int msm_config_group_set(struct pinctrl_dev *pctldev,
 			break;
 		case PIN_CONFIG_DRIVE_STRENGTH:
 			/* Check for invalid values */
-			if (arg > ARRAY_SIZE(msm_drive_to_regval))
+			if (arg >= ARRAY_SIZE(msm_drive_to_regval))
 				arg = -1;
 			else
 				arg = msm_drive_to_regval[arg];
@@ -399,12 +399,8 @@ static int msm_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 	unsigned long flags;
 	u32 val;
 
-	if (WARN_ON(offset >= pctrl->soc->ngroups))
-		return -EINVAL;
-
 	g = &pctrl->soc->groups[offset];
-
-	if (WARN_ON(g->oe_bit < 0))
+	if (WARN_ON(g->io_reg < 0))
 		return -EINVAL;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
@@ -425,12 +421,8 @@ static int msm_gpio_direction_output(struct gpio_chip *chip, unsigned offset, in
 	unsigned long flags;
 	u32 val;
 
-	if (WARN_ON(offset >= pctrl->soc->ngroups))
-		return -EINVAL;
-
 	g = &pctrl->soc->groups[offset];
-
-	if (WARN_ON(g->oe_bit < 0))
+	if (WARN_ON(g->io_reg < 0))
 		return -EINVAL;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
@@ -452,10 +444,9 @@ static int msm_gpio_get(struct gpio_chip *chip, unsigned offset)
 	struct msm_pinctrl *pctrl = container_of(chip, struct msm_pinctrl, chip);
 	u32 val;
 
-	if (WARN_ON(offset >= pctrl->soc->ngroups))
-		return -EINVAL;
-
 	g = &pctrl->soc->groups[offset];
+	if (WARN_ON(g->io_reg < 0))
+		return -EINVAL;
 
 	val = readl(pctrl->regs + g->io_reg);
 	return !!(val & BIT(g->in_bit));
@@ -468,10 +459,9 @@ static void msm_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 	unsigned long flags;
 	u32 val;
 
-	if (WARN_ON(offset >= pctrl->soc->ngroups))
-		return;
-
 	g = &pctrl->soc->groups[offset];
+	if (WARN_ON(g->io_reg < 0))
+		return;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
 
@@ -616,13 +606,9 @@ static void msm_gpio_irq_mask(struct irq_data *d)
 	u32 val;
 
 	pctrl = irq_data_get_irq_chip_data(d);
-	if (!pctrl)
-		return;
-
-	if (WARN_ON(d->hwirq >= pctrl->soc->ngroups))
-		return;
-
 	g = &pctrl->soc->groups[d->hwirq];
+	if (WARN_ON(g->intr_cfg_reg < 0))
+		return;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
 
@@ -643,13 +629,9 @@ static void msm_gpio_irq_unmask(struct irq_data *d)
 	u32 val;
 
 	pctrl = irq_data_get_irq_chip_data(d);
-	if (!pctrl)
-		return;
-
-	if (WARN_ON(d->hwirq >= pctrl->soc->ngroups))
-		return;
-
 	g = &pctrl->soc->groups[d->hwirq];
+	if (WARN_ON(g->intr_status_reg < 0))
+		return;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
 
@@ -674,13 +656,9 @@ static void msm_gpio_irq_ack(struct irq_data *d)
 	u32 val;
 
 	pctrl = irq_data_get_irq_chip_data(d);
-	if (!pctrl)
-		return;
-
-	if (WARN_ON(d->hwirq >= pctrl->soc->ngroups))
-		return;
-
 	g = &pctrl->soc->groups[d->hwirq];
+	if (WARN_ON(g->intr_status_reg < 0))
+		return;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
 
@@ -704,13 +682,9 @@ static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	u32 val;
 
 	pctrl = irq_data_get_irq_chip_data(d);
-	if (!pctrl)
-		return -EINVAL;
-
-	if (WARN_ON(d->hwirq >= pctrl->soc->ngroups))
-		return -EINVAL;
-
 	g = &pctrl->soc->groups[d->hwirq];
+	if (WARN_ON(g->intr_cfg_reg < 0))
+		return -EINVAL;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
 
@@ -802,9 +776,6 @@ static int msm_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 	unsigned ngpio;
 
 	pctrl = irq_data_get_irq_chip_data(d);
-	if (!pctrl)
-		return -EINVAL;
-
 	ngpio = pctrl->chip.ngpio;
 
 	spin_lock_irqsave(&pctrl->lock, flags);
@@ -983,7 +954,7 @@ int msm_pinctrl_probe(struct platform_device *pdev,
 	if (IS_ERR(pctrl->regs))
 		return PTR_ERR(pctrl->regs);
 
-	pctrl->irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
+	pctrl->irq = platform_get_irq(pdev, 0);
 	if (pctrl->irq < 0) {
 		dev_err(&pdev->dev, "No interrupt defined for msmgpio\n");
 		return pctrl->irq;
@@ -1017,9 +988,14 @@ int msm_pinctrl_remove(struct platform_device *pdev)
 	struct msm_pinctrl *pctrl = platform_get_drvdata(pdev);
 	int ret;
 
+	ret = gpiochip_remove(&pctrl->chip);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to remove gpiochip\n");
+		return ret;
+	}
+
 	irq_set_chained_handler(pctrl->irq, NULL);
 	irq_domain_remove(pctrl->domain);
-	ret = gpiochip_remove(&pctrl->chip);
 	pinctrl_unregister(pctrl->pctrl);
 
 	return 0;
-- 
1.7.9.5

