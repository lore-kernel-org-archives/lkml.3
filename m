Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab3BETtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:49:22 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:50384 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756707Ab3BETtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:49:18 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 08/14] pinctrl/abx500: replace IRQ offsets with table read-in values
Date: Tue, 5 Feb 2013 20:48:29 +0100
Message-ID: <1360093715-6348-9-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

The ABx500 GPIO controller used to provide a set of virtual contiguous
IRQs for use by sub-devices, but they have been removed after a request
from Mainline Maintainers. Now the AB8500 core driver deals with almost
all IRQ related issues instead.

The ABx500 GPIO driver is now only used to convert between GPIO and IRQ
numbers which is actually quite difficult, as the ABx500 GPIO's
associated IRQs are clustered together throughout the interrupt number
space at irregular intervals. To solve this quandary, we have placed the
read-in values into the existing cluster information table to use during
conversion.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
[Moved irq_base removal into this patch]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-ab8500.c |  6 +++---
 drivers/pinctrl/pinctrl-ab8505.c | 10 +++++-----
 drivers/pinctrl/pinctrl-ab8540.c |  5 +++--
 drivers/pinctrl/pinctrl-ab9540.c |  8 ++++----
 drivers/pinctrl/pinctrl-abx500.c | 18 +++++++++++-------
 drivers/pinctrl/pinctrl-abx500.h | 10 ++++++----
 6 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ab8500.c b/drivers/pinctrl/pinctrl-ab8500.c
index 67dc942..42675ee 100644
--- a/drivers/pinctrl/pinctrl-ab8500.c
+++ b/drivers/pinctrl/pinctrl-ab8500.c
@@ -456,9 +456,9 @@ struct alternate_functions ab8500_alternate_functions[AB8500_GPIO_MAX_NUMBER + 1
  *	GPIO36 to GPIO41
  */
 struct abx500_gpio_irq_cluster ab8500_gpio_irq_cluster[] = {
-	GPIO_IRQ_CLUSTER(6, 13, 0),
-	GPIO_IRQ_CLUSTER(24, 25, 0),
-	GPIO_IRQ_CLUSTER(36, 41, 0),
+	GPIO_IRQ_CLUSTER(6,  13, 34),
+	GPIO_IRQ_CLUSTER(24, 25, 24),
+	GPIO_IRQ_CLUSTER(36, 41, 14),
 };
 
 static struct abx500_pinctrl_soc_data ab8500_soc = {
diff --git a/drivers/pinctrl/pinctrl-ab8505.c b/drivers/pinctrl/pinctrl-ab8505.c
index 825710a..f8075c6 100644
--- a/drivers/pinctrl/pinctrl-ab8505.c
+++ b/drivers/pinctrl/pinctrl-ab8505.c
@@ -349,11 +349,11 @@ struct alternate_functions ab8505_alternate_functions[AB8505_GPIO_MAX_NUMBER + 1
  *	GPIO52 to GPIO53
  */
 struct abx500_gpio_irq_cluster ab8505_gpio_irq_cluster[] = {
-	GPIO_IRQ_CLUSTER(10, 11, 0),
-	GPIO_IRQ_CLUSTER(13, 13, 0),
-	GPIO_IRQ_CLUSTER(40, 41, 0),
-	GPIO_IRQ_CLUSTER(50, 50, 0),
-	GPIO_IRQ_CLUSTER(52, 53, 0),
+	GPIO_IRQ_CLUSTER(10, 11, 34),
+	GPIO_IRQ_CLUSTER(13, 13, 34),
+	GPIO_IRQ_CLUSTER(40, 41, 14),
+	GPIO_IRQ_CLUSTER(50, 50, 63),
+	GPIO_IRQ_CLUSTER(52, 53, 63),
 };
 
 static struct abx500_pinctrl_soc_data ab8505_soc = {
diff --git a/drivers/pinctrl/pinctrl-ab8540.c b/drivers/pinctrl/pinctrl-ab8540.c
index 0fcd943..ac2e135 100644
--- a/drivers/pinctrl/pinctrl-ab8540.c
+++ b/drivers/pinctrl/pinctrl-ab8540.c
@@ -377,8 +377,9 @@ static struct pullud ab8540_pullud = {
  *	GPIO51 to GPIO54
  */
 struct abx500_gpio_irq_cluster ab8540_gpio_irq_cluster[] = {
-	GPIO_IRQ_CLUSTER(43, 44, 2),
-	GPIO_IRQ_CLUSTER(51, 54, 0),
+	GPIO_IRQ_CLUSTER(43, 43, 126),
+	GPIO_IRQ_CLUSTER(44, 44, 127),
+	GPIO_IRQ_CLUSTER(51, 54, 63),
 };
 
 static struct abx500_pinctrl_soc_data ab8540_soc = {
diff --git a/drivers/pinctrl/pinctrl-ab9540.c b/drivers/pinctrl/pinctrl-ab9540.c
index 28dfb2e..a169e5b 100644
--- a/drivers/pinctrl/pinctrl-ab9540.c
+++ b/drivers/pinctrl/pinctrl-ab9540.c
@@ -455,10 +455,10 @@ struct alternate_functions ab9540alternate_functions[AB9540_GPIO_MAX_NUMBER + 1]
 };
 
 struct abx500_gpio_irq_cluster ab9540_gpio_irq_cluster[] = {
-	GPIO_IRQ_CLUSTER(10, 13, 0),
-	GPIO_IRQ_CLUSTER(24, 25, 0),
-	GPIO_IRQ_CLUSTER(40, 41, 0),
-	GPIO_IRQ_CLUSTER(50, 54, 0),
+	GPIO_IRQ_CLUSTER(10, 13, 34),
+	GPIO_IRQ_CLUSTER(24, 25, 24),
+	GPIO_IRQ_CLUSTER(40, 41, 14),
+	GPIO_IRQ_CLUSTER(50, 54, 63),
 };
 
 static struct abx500_pinctrl_soc_data ab9540_soc = {
diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 716c835..ded8f21 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -98,7 +98,6 @@ struct abx500_pinctrl {
 	struct gpio_chip chip;
 	struct ab8500 *parent;
 	struct mutex lock;
-	u32 irq_base;
 	struct abx500_gpio_irq_cluster *irq_cluster;
 	int irq_cluster_size;
 };
@@ -260,18 +259,24 @@ static int abx500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	struct abx500_pinctrl *pct = to_abx500_pinctrl(chip);
 	/* The AB8500 GPIO numbers are off by one */
 	int gpio = offset + 1;
-	int base = pct->irq_base;
+	int hwirq;
 	int i;
 
 	for (i = 0; i < pct->irq_cluster_size; i++) {
 		struct abx500_gpio_irq_cluster *cluster =
 			&pct->irq_cluster[i];
 
-		if (gpio >= cluster->start && gpio <= cluster->end)
-			return base + gpio - cluster->start;
+		if (gpio >= cluster->start && gpio <= cluster->end) {
+			/*
+			 * The ABx500 GPIO's associated IRQs are clustered together
+			 * throughout the interrupt numbers at irregular intervals.
+			 * To solve this quandry, we have placed the read-in values
+			 * into the cluster information table.
+			 */
+			hwirq = gpio + cluster->to_irq;
 
-		/* Advance by the number of gpios in this cluster */
-		base += cluster->end + cluster->offset - cluster->start + 1;
+			return irq_create_mapping(pct->parent->domain, hwirq);
+		}
 	}
 
 	return -EINVAL;
@@ -850,7 +855,6 @@ static int abx500_gpio_probe(struct platform_device *pdev)
 	pct->chip = abx500gpio_chip;
 	pct->chip.dev = &pdev->dev;
 	pct->chip.base = pdata->gpio_base;
-	pct->irq_base = pdata->irq_base;
 
 	/* initialize the lock */
 	mutex_init(&pct->lock);
diff --git a/drivers/pinctrl/pinctrl-abx500.h b/drivers/pinctrl/pinctrl-abx500.h
index df8e0ff..eeca8f9 100644
--- a/drivers/pinctrl/pinctrl-abx500.h
+++ b/drivers/pinctrl/pinctrl-abx500.h
@@ -98,7 +98,7 @@ struct pullud {
 {					\
 	.start = a,			\
 	.end = b,			\
-	.offset = c,			\
+	.to_irq = c,			\
 }
 
 /**
@@ -106,14 +106,16 @@ struct pullud {
  *			capable
  * @start:		The pin number of the first pin interrupt capable
  * @end:		The pin number of the last pin interrupt capable
- * @offset:		offset used to compute specific setting strategy of
- *			the interrupt line
+ * @to_irq:		The ABx500 GPIO's associated IRQs are clustered
+ *                      together throughout the interrupt numbers at irregular
+ *                      intervals. To solve this quandary, we will place the
+ *                      read-in values into the cluster information table
  */
 
 struct abx500_gpio_irq_cluster {
 	int start;
 	int end;
-	int offset;
+	int to_irq;
 };
 
 /**
-- 
1.7.11.3

