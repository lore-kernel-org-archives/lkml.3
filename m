Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaLHJjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:39:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:38652 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbaLHJju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:39:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,537,1413270000"; 
   d="scan'208";a="634337811"
From: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        denis.turischev@compulab.co.il,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: [PATCHv5 1/2] gpio: sch: Consolidate similar algorithms
Date: Mon,  8 Dec 2014 17:38:09 +0800
Message-Id: <1418031490-17716-2-git-send-email-rebecca.swee.fun.chang@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418031490-17716-1-git-send-email-rebecca.swee.fun.chang@intel.com>
References: <1418031490-17716-1-git-send-email-rebecca.swee.fun.chang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidating similar algorithms into common functions to make
GPIO SCH simpler and manageable.

Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpio-sch.c | 81 +++++++++++++++++--------------------------------
 1 file changed, 28 insertions(+), 53 deletions(-)

diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index 99720c8..054a8ea 100644
--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
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
+	sch_gpio_reg_set(sch, gpio_num, GIO, 1);
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
+	sch_gpio_reg_set(sch, gpio_num, GIO, 0);
 	spin_unlock(&sch->lock);
 
 	/*
@@ -209,13 +184,13 @@ static int sch_gpio_probe(struct platform_device *pdev)
 		 * GPIO7 is configured by the CMC as SLPIOVR
 		 * Enable GPIO[9:8] core powered gpios explicitly
 		 */
-		sch_gpio_enable(sch, 8);
-		sch_gpio_enable(sch, 9);
+		sch_gpio_reg_set(sch, 8, GEN, 1);
+		sch_gpio_reg_set(sch, 9, GEN, 1);
 		/*
 		 * SUS_GPIO[2:0] enabled by default
 		 * Enable SUS_GPIO3 resume powered gpio explicitly
 		 */
-		sch_gpio_enable(sch, 13);
+		sch_gpio_reg_set(sch, 13, GEN, 1);
 		break;
 
 	case PCI_DEVICE_ID_INTEL_ITC_LPC:
-- 
1.9.1

