Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaKZEsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 23:48:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:60465 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbaKZEsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 23:48:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,460,1413270000"; 
   d="scan'208";a="614155581"
From: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Denis Turischev <denis.turischev@compulab.co.il>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: [PATCHv4 1/3] gpio: sch: Consolidate similar algorithms
Date: Wed, 26 Nov 2014 12:47:58 +0800
Message-Id: <1416977280-27319-2-git-send-email-rebecca.swee.fun.chang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416977280-27319-1-git-send-email-rebecca.swee.fun.chang@intel.com>
References: <1416977280-27319-1-git-send-email-rebecca.swee.fun.chang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidating similar algorithms into common functions to make
GPIO SCH simpler and manageable.

Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
---
 drivers/gpio/gpio-sch.c |   81 ++++++++++++++++-------------------------------
 1 file changed, 28 insertions(+), 53 deletions(-)

diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index 99720c8..7967f14 100644
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
+	u8 curr_dirs;
 
-	offset = sch_gpio_offset(sch, gpio, GEN);
+	offset = sch_gpio_offset(sch, gpio, reg);
 	bit = sch_gpio_bit(sch, gpio);
 
-	enable = inb(sch->iobase + offset);
-	if (!(enable & (1 << bit)))
-		outb(enable | (1 << bit), sch->iobase + offset);
+	curr_dirs = !!(inb(sch->iobase + offset) & BIT(bit));
 
-	spin_unlock(&sch->lock);
+	return curr_dirs;
 }
 
-static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned  gpio_num)
+static void sch_gpio_reg_set(struct gpio_chip *gc, unsigned gpio, unsigned reg,
+			     int val)
 {
 	struct sch_gpio *sch = to_sch_gpio(gc);
-	u8 curr_dirs;
 	unsigned short offset, bit;
+	u8 curr_dirs;
 
-	spin_lock(&sch->lock);
-
-	offset = sch_gpio_offset(sch, gpio_num, GIO);
-	bit = sch_gpio_bit(sch, gpio_num);
+	offset = sch_gpio_offset(sch, gpio, reg);
+	bit = sch_gpio_bit(sch, gpio);
 
 	curr_dirs = inb(sch->iobase + offset);
 
-	if (!(curr_dirs & (1 << bit)))
-		outb(curr_dirs | (1 << bit), sch->iobase + offset);
+	if (val)
+		outb(curr_dirs | BIT(bit), sch->iobase + offset);
+	else
+		outb((curr_dirs & ~BIT(bit)), sch->iobase + offset);
+}
 
+static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned gpio_num)
+{
+	struct sch_gpio *sch = to_sch_gpio(gc);
+
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
1.7.9.5

