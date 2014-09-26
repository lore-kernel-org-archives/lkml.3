Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbaIZKHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:07:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:7420 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598AbaIZKHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:07:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="391941539"
From: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mika Westerberg <mika.westerberg@intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 1/3] gpio: sch: Consolidate similar algorithms
Date: Fri, 26 Sep 2014 18:07:25 +0800
Message-Id: <1411726047-3224-2-git-send-email-rebecca.swee.fun.chang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411726047-3224-1-git-send-email-rebecca.swee.fun.chang@intel.com>
References: <1411726047-3224-1-git-send-email-rebecca.swee.fun.chang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidating similar algorithms into common functions to make
GPIO SCH simpler and manageable.

Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
---
 drivers/gpio/gpio-sch.c |   95 ++++++++++++++++++++++++++---------------------
 1 file changed, 53 insertions(+), 42 deletions(-)

diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index 99720c8..6e89be9 100644
--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -63,94 +63,105 @@ static unsigned sch_gpio_bit(struct sch_gpio *sch, unsigned gpio)
 	return gpio % 8;
 }
 
-static void sch_gpio_enable(struct sch_gpio *sch, unsigned gpio)
+static void sch_gpio_register_set(struct sch_gpio *sch, unsigned gpio,
+				  unsigned reg)
 {
 	unsigned short offset, bit;
 	u8 enable;
 
 	spin_lock(&sch->lock);
 
-	offset = sch_gpio_offset(sch, gpio, GEN);
+	offset = sch_gpio_offset(sch, gpio, reg);
 	bit = sch_gpio_bit(sch, gpio);
 
 	enable = inb(sch->iobase + offset);
-	if (!(enable & (1 << bit)))
-		outb(enable | (1 << bit), sch->iobase + offset);
+	if (!(enable & BIT(bit)))
+		outb(enable | BIT(bit), sch->iobase + offset);
 
 	spin_unlock(&sch->lock);
 }
 
-static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned  gpio_num)
+static void sch_gpio_register_clear(struct sch_gpio *sch, unsigned gpio,
+				    unsigned reg)
 {
-	struct sch_gpio *sch = to_sch_gpio(gc);
-	u8 curr_dirs;
 	unsigned short offset, bit;
+	u8 disable;
 
 	spin_lock(&sch->lock);
 
-	offset = sch_gpio_offset(sch, gpio_num, GIO);
-	bit = sch_gpio_bit(sch, gpio_num);
-
-	curr_dirs = inb(sch->iobase + offset);
+	offset = sch_gpio_offset(sch, gpio, reg);
+	bit = sch_gpio_bit(sch, gpio);
 
-	if (!(curr_dirs & (1 << bit)))
-		outb(curr_dirs | (1 << bit), sch->iobase + offset);
+	disable = inb(sch->iobase + offset);
+	if (disable & BIT(bit))
+		outb(disable & ~BIT(bit), sch->iobase + offset);
 
 	spin_unlock(&sch->lock);
-	return 0;
 }
 
-static int sch_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
+static int sch_gpio_reg_get(struct gpio_chip *gc, unsigned gpio, unsigned reg)
 {
 	struct sch_gpio *sch = to_sch_gpio(gc);
-	int res;
 	unsigned short offset, bit;
+	u8 curr_dirs;
 
-	offset = sch_gpio_offset(sch, gpio_num, GLV);
-	bit = sch_gpio_bit(sch, gpio_num);
+	offset = sch_gpio_offset(sch, gpio, reg);
+	bit = sch_gpio_bit(sch, gpio);
 
-	res = !!(inb(sch->iobase + offset) & (1 << bit));
+	curr_dirs = !!(inb(sch->iobase + offset) & BIT(bit));
 
-	return res;
+	return curr_dirs;
 }
 
-static void sch_gpio_set(struct gpio_chip *gc, unsigned gpio_num, int val)
+static void sch_gpio_reg_set(struct gpio_chip *gc, unsigned gpio, unsigned reg,
+			     int val)
 {
 	struct sch_gpio *sch = to_sch_gpio(gc);
-	u8 curr_vals;
 	unsigned short offset, bit;
+	u8 curr_dirs;
 
-	spin_lock(&sch->lock);
-
-	offset = sch_gpio_offset(sch, gpio_num, GLV);
-	bit = sch_gpio_bit(sch, gpio_num);
+	offset = sch_gpio_offset(sch, gpio, reg);
+	bit = sch_gpio_bit(sch, gpio);
 
-	curr_vals = inb(sch->iobase + offset);
+	curr_dirs = inb(sch->iobase + offset);
 
 	if (val)
-		outb(curr_vals | (1 << bit), sch->iobase + offset);
+		outb(curr_dirs | BIT(bit), sch->iobase + offset);
 	else
-		outb((curr_vals & ~(1 << bit)), sch->iobase + offset);
+		outb((curr_dirs & ~BIT(bit)), sch->iobase + offset);
+}
 
+static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned gpio_num)
+{
+	struct sch_gpio *sch = to_sch_gpio(gc);
+
+	spin_lock(&sch->lock);
+	sch_gpio_register_set(sch, gpio_num, GIO);
 	spin_unlock(&sch->lock);
+	return 0;
 }
 
-static int sch_gpio_direction_out(struct gpio_chip *gc, unsigned gpio_num,
-				  int val)
+static int sch_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
+{
+	return sch_gpio_reg_get(gc, gpio_num, GLV);
+}
+
+static void sch_gpio_set(struct gpio_chip *gc, unsigned gpio_num, int val)
 {
 	struct sch_gpio *sch = to_sch_gpio(gc);
-	u8 curr_dirs;
-	unsigned short offset, bit;
 
 	spin_lock(&sch->lock);
+	sch_gpio_reg_set(gc, gpio_num, GLV, val);
+	spin_unlock(&sch->lock);
+}
 
-	offset = sch_gpio_offset(sch, gpio_num, GIO);
-	bit = sch_gpio_bit(sch, gpio_num);
-
-	curr_dirs = inb(sch->iobase + offset);
-	if (curr_dirs & (1 << bit))
-		outb(curr_dirs & ~(1 << bit), sch->iobase + offset);
+static int sch_gpio_direction_out(struct gpio_chip *gc, unsigned gpio_num,
+				  int val)
+{
+	struct sch_gpio *sch = to_sch_gpio(gc);
 
+	spin_lock(&sch->lock);
+	sch_gpio_register_clear(sch, gpio_num, GIO);
 	spin_unlock(&sch->lock);
 
 	/*
@@ -209,13 +220,13 @@ static int sch_gpio_probe(struct platform_device *pdev)
 		 * GPIO7 is configured by the CMC as SLPIOVR
 		 * Enable GPIO[9:8] core powered gpios explicitly
 		 */
-		sch_gpio_enable(sch, 8);
-		sch_gpio_enable(sch, 9);
+		sch_gpio_register_set(sch, 8, GEN);
+		sch_gpio_register_set(sch, 9, GEN);
 		/*
 		 * SUS_GPIO[2:0] enabled by default
 		 * Enable SUS_GPIO3 resume powered gpio explicitly
 		 */
-		sch_gpio_enable(sch, 13);
+		sch_gpio_register_set(sch, 13, GEN);
 		break;
 
 	case PCI_DEVICE_ID_INTEL_ITC_LPC:
-- 
1.7.9.5

