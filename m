Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbaJUVVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:21:05 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63635 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933726AbaJUVRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:17:51 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <darren.hart@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Grant Likely <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>
Subject: [PATCH v6 06/12] gpio: sch: Consolidate core and resume banks
Date: Tue, 21 Oct 2014 23:21:07 +0200
Message-ID: <2191670.HstTAR5ZMU@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <13750506.S2yVlRRDa2@vostro.rjw.lan>
References: <13750506.S2yVlRRDa2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

This is actually a single device with two sets of identical registers,
which just happen to start from a different offset. Instead of having
separate GPIO chips created we consolidate them to be single GPIO chip.

In addition having a single GPIO chip allows us to handle ACPI GPIO
translation in the core in a more generic way, since the two GPIO chips
share the same parent ACPI device.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/gpio/gpio-sch.c | 293 ++++++++++++++++++------------------------------
 1 file changed, 112 insertions(+), 181 deletions(-)

diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index 41e91d7..99720c8 100644
--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -29,290 +29,221 @@
 
 #include <linux/gpio.h>
 
-static DEFINE_SPINLOCK(gpio_lock);
-
-#define CGEN	(0x00)
-#define CGIO	(0x04)
-#define CGLV	(0x08)
-
-#define RGEN	(0x20)
-#define RGIO	(0x24)
-#define RGLV	(0x28)
-
-static unsigned short gpio_ba;
-
-static int sch_gpio_core_direction_in(struct gpio_chip *gc, unsigned  gpio_num)
-{
-	u8 curr_dirs;
-	unsigned short offset, bit;
-
-	spin_lock(&gpio_lock);
-
-	offset = CGIO + gpio_num / 8;
-	bit = gpio_num % 8;
-
-	curr_dirs = inb(gpio_ba + offset);
-
-	if (!(curr_dirs & (1 << bit)))
-		outb(curr_dirs | (1 << bit), gpio_ba + offset);
+#define GEN	0x00
+#define GIO	0x04
+#define GLV	0x08
+
+struct sch_gpio {
+	struct gpio_chip chip;
+	spinlock_t lock;
+	unsigned short iobase;
+	unsigned short core_base;
+	unsigned short resume_base;
+};
 
-	spin_unlock(&gpio_lock);
-	return 0;
-}
+#define to_sch_gpio(c)	container_of(c, struct sch_gpio, chip)
 
-static int sch_gpio_core_get(struct gpio_chip *gc, unsigned gpio_num)
+static unsigned sch_gpio_offset(struct sch_gpio *sch, unsigned gpio,
+				unsigned reg)
 {
-	int res;
-	unsigned short offset, bit;
+	unsigned base = 0;
 
-	offset = CGLV + gpio_num / 8;
-	bit = gpio_num % 8;
+	if (gpio >= sch->resume_base) {
+		gpio -= sch->resume_base;
+		base += 0x20;
+	}
 
-	res = !!(inb(gpio_ba + offset) & (1 << bit));
-	return res;
+	return base + reg + gpio / 8;
 }
 
-static void sch_gpio_core_set(struct gpio_chip *gc, unsigned gpio_num, int val)
+static unsigned sch_gpio_bit(struct sch_gpio *sch, unsigned gpio)
 {
-	u8 curr_vals;
-	unsigned short offset, bit;
-
-	spin_lock(&gpio_lock);
-
-	offset = CGLV + gpio_num / 8;
-	bit = gpio_num % 8;
-
-	curr_vals = inb(gpio_ba + offset);
-
-	if (val)
-		outb(curr_vals | (1 << bit), gpio_ba + offset);
-	else
-		outb((curr_vals & ~(1 << bit)), gpio_ba + offset);
-	spin_unlock(&gpio_lock);
+	if (gpio >= sch->resume_base)
+		gpio -= sch->resume_base;
+	return gpio % 8;
 }
 
-static int sch_gpio_core_direction_out(struct gpio_chip *gc,
-					unsigned gpio_num, int val)
+static void sch_gpio_enable(struct sch_gpio *sch, unsigned gpio)
 {
-	u8 curr_dirs;
 	unsigned short offset, bit;
+	u8 enable;
 
-	spin_lock(&gpio_lock);
+	spin_lock(&sch->lock);
 
-	offset = CGIO + gpio_num / 8;
-	bit = gpio_num % 8;
-
-	curr_dirs = inb(gpio_ba + offset);
-	if (curr_dirs & (1 << bit))
-		outb(curr_dirs & ~(1 << bit), gpio_ba + offset);
+	offset = sch_gpio_offset(sch, gpio, GEN);
+	bit = sch_gpio_bit(sch, gpio);
 
-	spin_unlock(&gpio_lock);
+	enable = inb(sch->iobase + offset);
+	if (!(enable & (1 << bit)))
+		outb(enable | (1 << bit), sch->iobase + offset);
 
-	/*
-	 * according to the datasheet, writing to the level register has no
-	 * effect when GPIO is programmed as input.
-	 * Actually the the level register is read-only when configured as input.
-	 * Thus presetting the output level before switching to output is _NOT_ possible.
-	 * Hence we set the level after configuring the GPIO as output.
-	 * But we cannot prevent a short low pulse if direction is set to high
-	 * and an external pull-up is connected.
-	 */
-	sch_gpio_core_set(gc, gpio_num, val);
-	return 0;
+	spin_unlock(&sch->lock);
 }
 
-static struct gpio_chip sch_gpio_core = {
-	.label			= "sch_gpio_core",
-	.owner			= THIS_MODULE,
-	.direction_input	= sch_gpio_core_direction_in,
-	.get			= sch_gpio_core_get,
-	.direction_output	= sch_gpio_core_direction_out,
-	.set			= sch_gpio_core_set,
-};
-
-static int sch_gpio_resume_direction_in(struct gpio_chip *gc,
-					unsigned gpio_num)
+static int sch_gpio_direction_in(struct gpio_chip *gc, unsigned  gpio_num)
 {
+	struct sch_gpio *sch = to_sch_gpio(gc);
 	u8 curr_dirs;
 	unsigned short offset, bit;
 
-	spin_lock(&gpio_lock);
+	spin_lock(&sch->lock);
 
-	offset = RGIO + gpio_num / 8;
-	bit = gpio_num % 8;
+	offset = sch_gpio_offset(sch, gpio_num, GIO);
+	bit = sch_gpio_bit(sch, gpio_num);
 
-	curr_dirs = inb(gpio_ba + offset);
+	curr_dirs = inb(sch->iobase + offset);
 
 	if (!(curr_dirs & (1 << bit)))
-		outb(curr_dirs | (1 << bit), gpio_ba + offset);
+		outb(curr_dirs | (1 << bit), sch->iobase + offset);
 
-	spin_unlock(&gpio_lock);
+	spin_unlock(&sch->lock);
 	return 0;
 }
 
-static int sch_gpio_resume_get(struct gpio_chip *gc, unsigned gpio_num)
+static int sch_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
 {
+	struct sch_gpio *sch = to_sch_gpio(gc);
+	int res;
 	unsigned short offset, bit;
 
-	offset = RGLV + gpio_num / 8;
-	bit = gpio_num % 8;
+	offset = sch_gpio_offset(sch, gpio_num, GLV);
+	bit = sch_gpio_bit(sch, gpio_num);
+
+	res = !!(inb(sch->iobase + offset) & (1 << bit));
 
-	return !!(inb(gpio_ba + offset) & (1 << bit));
+	return res;
 }
 
-static void sch_gpio_resume_set(struct gpio_chip *gc,
-				unsigned gpio_num, int val)
+static void sch_gpio_set(struct gpio_chip *gc, unsigned gpio_num, int val)
 {
+	struct sch_gpio *sch = to_sch_gpio(gc);
 	u8 curr_vals;
 	unsigned short offset, bit;
 
-	spin_lock(&gpio_lock);
+	spin_lock(&sch->lock);
 
-	offset = RGLV + gpio_num / 8;
-	bit = gpio_num % 8;
+	offset = sch_gpio_offset(sch, gpio_num, GLV);
+	bit = sch_gpio_bit(sch, gpio_num);
 
-	curr_vals = inb(gpio_ba + offset);
+	curr_vals = inb(sch->iobase + offset);
 
 	if (val)
-		outb(curr_vals | (1 << bit), gpio_ba + offset);
+		outb(curr_vals | (1 << bit), sch->iobase + offset);
 	else
-		outb((curr_vals & ~(1 << bit)), gpio_ba + offset);
+		outb((curr_vals & ~(1 << bit)), sch->iobase + offset);
 
-	spin_unlock(&gpio_lock);
+	spin_unlock(&sch->lock);
 }
 
-static int sch_gpio_resume_direction_out(struct gpio_chip *gc,
-					unsigned gpio_num, int val)
+static int sch_gpio_direction_out(struct gpio_chip *gc, unsigned gpio_num,
+				  int val)
 {
+	struct sch_gpio *sch = to_sch_gpio(gc);
 	u8 curr_dirs;
 	unsigned short offset, bit;
 
-	offset = RGIO + gpio_num / 8;
-	bit = gpio_num % 8;
+	spin_lock(&sch->lock);
 
-	spin_lock(&gpio_lock);
+	offset = sch_gpio_offset(sch, gpio_num, GIO);
+	bit = sch_gpio_bit(sch, gpio_num);
 
-	curr_dirs = inb(gpio_ba + offset);
+	curr_dirs = inb(sch->iobase + offset);
 	if (curr_dirs & (1 << bit))
-		outb(curr_dirs & ~(1 << bit), gpio_ba + offset);
+		outb(curr_dirs & ~(1 << bit), sch->iobase + offset);
 
-	spin_unlock(&gpio_lock);
+	spin_unlock(&sch->lock);
 
 	/*
-	* according to the datasheet, writing to the level register has no
-	* effect when GPIO is programmed as input.
-	* Actually the the level register is read-only when configured as input.
-	* Thus presetting the output level before switching to output is _NOT_ possible.
-	* Hence we set the level after configuring the GPIO as output.
-	* But we cannot prevent a short low pulse if direction is set to high
-	* and an external pull-up is connected.
-	*/
-	sch_gpio_resume_set(gc, gpio_num, val);
+	 * according to the datasheet, writing to the level register has no
+	 * effect when GPIO is programmed as input.
+	 * Actually the the level register is read-only when configured as input.
+	 * Thus presetting the output level before switching to output is _NOT_ possible.
+	 * Hence we set the level after configuring the GPIO as output.
+	 * But we cannot prevent a short low pulse if direction is set to high
+	 * and an external pull-up is connected.
+	 */
+	sch_gpio_set(gc, gpio_num, val);
 	return 0;
 }
 
-static struct gpio_chip sch_gpio_resume = {
-	.label			= "sch_gpio_resume",
+static struct gpio_chip sch_gpio_chip = {
+	.label			= "sch_gpio",
 	.owner			= THIS_MODULE,
-	.direction_input	= sch_gpio_resume_direction_in,
-	.get			= sch_gpio_resume_get,
-	.direction_output	= sch_gpio_resume_direction_out,
-	.set			= sch_gpio_resume_set,
+	.direction_input	= sch_gpio_direction_in,
+	.get			= sch_gpio_get,
+	.direction_output	= sch_gpio_direction_out,
+	.set			= sch_gpio_set,
 };
 
 static int sch_gpio_probe(struct platform_device *pdev)
 {
+	struct sch_gpio *sch;
 	struct resource *res;
-	int err, id;
 
-	id = pdev->id;
-	if (!id)
-		return -ENODEV;
+	sch = devm_kzalloc(&pdev->dev, sizeof(*sch), GFP_KERNEL);
+	if (!sch)
+		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	if (!res)
 		return -EBUSY;
 
-	if (!request_region(res->start, resource_size(res), pdev->name))
+	if (!devm_request_region(&pdev->dev, res->start, resource_size(res),
+				 pdev->name))
 		return -EBUSY;
 
-	gpio_ba = res->start;
+	spin_lock_init(&sch->lock);
+	sch->iobase = res->start;
+	sch->chip = sch_gpio_chip;
+	sch->chip.label = dev_name(&pdev->dev);
+	sch->chip.dev = &pdev->dev;
 
-	switch (id) {
+	switch (pdev->id) {
 	case PCI_DEVICE_ID_INTEL_SCH_LPC:
-		sch_gpio_core.base = 0;
-		sch_gpio_core.ngpio = 10;
-		sch_gpio_resume.base = 10;
-		sch_gpio_resume.ngpio = 4;
+		sch->core_base = 0;
+		sch->resume_base = 10;
+		sch->chip.ngpio = 14;
+
 		/*
 		 * GPIO[6:0] enabled by default
 		 * GPIO7 is configured by the CMC as SLPIOVR
 		 * Enable GPIO[9:8] core powered gpios explicitly
 		 */
-		outb(0x3, gpio_ba + CGEN + 1);
+		sch_gpio_enable(sch, 8);
+		sch_gpio_enable(sch, 9);
 		/*
 		 * SUS_GPIO[2:0] enabled by default
 		 * Enable SUS_GPIO3 resume powered gpio explicitly
 		 */
-		outb(0x8, gpio_ba + RGEN);
+		sch_gpio_enable(sch, 13);
 		break;
 
 	case PCI_DEVICE_ID_INTEL_ITC_LPC:
-		sch_gpio_core.base = 0;
-		sch_gpio_core.ngpio = 5;
-		sch_gpio_resume.base = 5;
-		sch_gpio_resume.ngpio = 9;
+		sch->core_base = 0;
+		sch->resume_base = 5;
+		sch->chip.ngpio = 14;
 		break;
 
 	case PCI_DEVICE_ID_INTEL_CENTERTON_ILB:
-		sch_gpio_core.base = 0;
-		sch_gpio_core.ngpio = 21;
-		sch_gpio_resume.base = 21;
-		sch_gpio_resume.ngpio = 9;
+		sch->core_base = 0;
+		sch->resume_base = 21;
+		sch->chip.ngpio = 30;
 		break;
 
 	default:
-		err = -ENODEV;
-		goto err_sch_gpio_core;
+		return -ENODEV;
 	}
 
-	sch_gpio_core.dev = &pdev->dev;
-	sch_gpio_resume.dev = &pdev->dev;
-
-	err = gpiochip_add(&sch_gpio_core);
-	if (err < 0)
-		goto err_sch_gpio_core;
+	platform_set_drvdata(pdev, sch);
 
-	err = gpiochip_add(&sch_gpio_resume);
-	if (err < 0)
-		goto err_sch_gpio_resume;
-
-	return 0;
-
-err_sch_gpio_resume:
-	gpiochip_remove(&sch_gpio_core);
-
-err_sch_gpio_core:
-	release_region(res->start, resource_size(res));
-	gpio_ba = 0;
-
-	return err;
+	return gpiochip_add(&sch->chip);
 }
 
 static int sch_gpio_remove(struct platform_device *pdev)
 {
-	struct resource *res;
-	if (gpio_ba) {
-
-		gpiochip_remove(&sch_gpio_core);
-		gpiochip_remove(&sch_gpio_resume);
-
-		res = platform_get_resource(pdev, IORESOURCE_IO, 0);
-
-		release_region(res->start, resource_size(res));
-		gpio_ba = 0;
-	}
+	struct sch_gpio *sch = platform_get_drvdata(pdev);
 
+	gpiochip_remove(&sch->chip);
 	return 0;
 }
 
-- 
1.9.3


