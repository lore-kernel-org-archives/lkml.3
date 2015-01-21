Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbbAUKdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:33:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:45244 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbbAUKcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:32:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,440,1418112000"; 
   d="scan'208";a="654193831"
From: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Mika Westerberg <mika.westerberg@intel.com>
Cc: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] gpio: sch: Consolidate similar algorithms
Date: Wed, 21 Jan 2015 18:32:21 +0800
Message-Id: <1421836341-2036-2-git-send-email-rebecca.swee.fun.chang@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421836341-2036-1-git-send-email-rebecca.swee.fun.chang@intel.com>
References: <1421836341-2036-1-git-send-email-rebecca.swee.fun.chang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidating similar algorithms into common functions to make
GPIO SCH simpler and manageable.

Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
---
 drivers/gpio/gpio-sch.c | 83 +++++++++++++++++--------------------------------
 1 file changed, 29 insertions(+), 54 deletions(-)

diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index 0271022..b72906f 100644
--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -41,7 +41,7 @@ struct sch_gpio {
 	unsigned short resume_base;
 };
 
-#define to_sch_gpio(c)	container_of(c, struct sch_gpio, chip)
+#define to_sch_gpio(gc)	container_of(gc, struct sch_gpio, chip)
 
 static unsigned sch_gpio_offset(struct sch_gpio *sch, unsigned gpio,
 				unsigned reg)
@@ -63,75 +63,59 @@ static unsigned sch_gpio_bit(struct sch_gpio *sch, unsigned gpio)
 	return gpio % 8;
 }
 
-static void sch_gpio_enable(struct sch_gpio *sch, unsigned gpio)
+static int sch_gpio_reg_get(struct gpio_chip *gc, unsigned gpio, unsigned reg)
 {
+	struct sch_gpio *sch = to_sch_gpio(gc);
 	unsigned short offset, bit;
-	u8 enable;
-
-	spin_lock(&sch->lock);
+	u8 reg_val;
 
-	offset = sch_gpio_offset(sch, gpio, GEN);
+	offset = sch_gpio_offset(sch, gpio, reg);
 	bit = sch_gpio_bit(sch, gpio);
 
-	enable = inb(sch->iobase + offset);
-	if (!(enable & (1 << bit)))
-		outb(enable | (1 << bit), sch->iobase + offset);
+	reg_val = !!(inb(sch->iobase + offset) & BIT(bit));
 
-	spin_unlock(&sch->lock);
+	return reg_val;
 }
 
-static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned  gpio_num)
+static void sch_gpio_reg_set(struct gpio_chip *gc, unsigned gpio, unsigned reg,
+			     int val)
 {
 	struct sch_gpio *sch = to_sch_gpio(gc);
-	u8 curr_dirs;
 	unsigned short offset, bit;
+	u8 reg_val;
 
-	spin_lock(&sch->lock);
+	offset = sch_gpio_offset(sch, gpio, reg);
+	bit = sch_gpio_bit(sch, gpio);
 
-	offset = sch_gpio_offset(sch, gpio_num, GIO);
-	bit = sch_gpio_bit(sch, gpio_num);
+	reg_val = inb(sch->iobase + offset);
 
-	curr_dirs = inb(sch->iobase + offset);
+	if (val)
+		outb(reg_val | BIT(bit), sch->iobase + offset);
+	else
+		outb((reg_val & ~BIT(bit)), sch->iobase + offset);
+}
 
-	if (!(curr_dirs & (1 << bit)))
-		outb(curr_dirs | (1 << bit), sch->iobase + offset);
+static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned gpio_num)
+{
+	struct sch_gpio *sch = to_sch_gpio(gc);
 
+	spin_lock(&sch->lock);
+	sch_gpio_reg_set(gc, gpio_num, GIO, 1);
 	spin_unlock(&sch->lock);
 	return 0;
 }
 
 static int sch_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
 {
-	struct sch_gpio *sch = to_sch_gpio(gc);
-	int res;
-	unsigned short offset, bit;
-
-	offset = sch_gpio_offset(sch, gpio_num, GLV);
-	bit = sch_gpio_bit(sch, gpio_num);
-
-	res = !!(inb(sch->iobase + offset) & (1 << bit));
-
-	return res;
+	return sch_gpio_reg_get(gc, gpio_num, GLV);
 }
 
 static void sch_gpio_set(struct gpio_chip *gc, unsigned gpio_num, int val)
 {
 	struct sch_gpio *sch = to_sch_gpio(gc);
-	u8 curr_vals;
-	unsigned short offset, bit;
 
 	spin_lock(&sch->lock);
-
-	offset = sch_gpio_offset(sch, gpio_num, GLV);
-	bit = sch_gpio_bit(sch, gpio_num);
-
-	curr_vals = inb(sch->iobase + offset);
-
-	if (val)
-		outb(curr_vals | (1 << bit), sch->iobase + offset);
-	else
-		outb((curr_vals & ~(1 << bit)), sch->iobase + offset);
-
+	sch_gpio_reg_set(gc, gpio_num, GLV, val);
 	spin_unlock(&sch->lock);
 }
 
@@ -139,18 +123,9 @@ static int sch_gpio_direction_out(struct gpio_chip *gc, unsigned gpio_num,
 				  int val)
 {
 	struct sch_gpio *sch = to_sch_gpio(gc);
-	u8 curr_dirs;
-	unsigned short offset, bit;
 
 	spin_lock(&sch->lock);
-
-	offset = sch_gpio_offset(sch, gpio_num, GIO);
-	bit = sch_gpio_bit(sch, gpio_num);
-
-	curr_dirs = inb(sch->iobase + offset);
-	if (curr_dirs & (1 << bit))
-		outb(curr_dirs & ~(1 << bit), sch->iobase + offset);
-
+	sch_gpio_reg_set(gc, gpio_num, GIO, 0);
 	spin_unlock(&sch->lock);
 
 	/*
@@ -209,13 +184,13 @@ static int sch_gpio_probe(struct platform_device *pdev)
 		 * GPIO7 is configured by the CMC as SLPIOVR
 		 * Enable GPIO[9:8] core powered gpios explicitly
 		 */
-		sch_gpio_enable(sch, 8);
-		sch_gpio_enable(sch, 9);
+		sch_gpio_reg_set(&sch->chip, 8, GEN, 1);
+		sch_gpio_reg_set(&sch->chip, 9, GEN, 1);
 		/*
 		 * SUS_GPIO[2:0] enabled by default
 		 * Enable SUS_GPIO3 resume powered gpio explicitly
 		 */
-		sch_gpio_enable(sch, 13);
+		sch_gpio_reg_set(&sch->chip, 13, GEN, 1);
 		break;
 
 	case PCI_DEVICE_ID_INTEL_ITC_LPC:
-- 
1.9.1

