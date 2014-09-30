Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaI3OMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 10:12:18 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:44025 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916AbaI3OMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 10:12:16 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-gpio@vger.kernel.org
Subject: [PATCH 2/2] mfd: remove use of gpiochip_remove() retval
Date: Tue, 30 Sep 2014 19:45:42 +0530
Message-Id: <1412086542-1662-2-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412086542-1662-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1412086542-1662-1-git-send-email-pramod.gurav@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of using return value from gpiochip_remove() as it returns
void.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
CC: Lee Jones <lee.jones@linaro.org>
Cc: linux-gpio@vger.kernel.org

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/mfd/asic3.c        |    3 ++-
 drivers/mfd/htc-i2cpld.c   |    6 +-----
 drivers/mfd/sm501.c        |   17 +++--------------
 drivers/mfd/tc6393xb.c     |   13 ++++---------
 drivers/mfd/ucb1x00-core.c |    8 ++------
 5 files changed, 12 insertions(+), 35 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 9fc4186..977bd3a 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -605,7 +605,8 @@ static int asic3_gpio_remove(struct platform_device *pdev)
 {
 	struct asic3 *asic = platform_get_drvdata(pdev);
 
-	return gpiochip_remove(&asic->gpio);
+	gpiochip_remove(&asic->gpio);
+	return 0;
 }
 
 static void asic3_clk_enable(struct asic3 *asic, struct asic3_clk *clk)
diff --git a/drivers/mfd/htc-i2cpld.c b/drivers/mfd/htc-i2cpld.c
index 6bdb78c..e14fe3e 100644
--- a/drivers/mfd/htc-i2cpld.c
+++ b/drivers/mfd/htc-i2cpld.c
@@ -481,14 +481,10 @@ static int htcpld_register_chip_gpio(
 
 	ret = gpiochip_add(&(chip->chip_in));
 	if (ret) {
-		int error;
-
 		dev_warn(dev, "Unable to register input GPIOs for 0x%x: %d\n",
 			 plat_chip_data->addr, ret);
 
-		error = gpiochip_remove(&(chip->chip_out));
-		if (error)
-			dev_warn(dev, "Error while trying to unregister gpio chip: %d\n", error);
+		gpiochip_remove(&(chip->chip_out));
 
 		return ret;
 	}
diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 81e6d09..02027b7 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1047,7 +1047,6 @@ static int sm501_register_gpio(struct sm501_devdata *sm)
 	struct sm501_gpio *gpio = &sm->gpio;
 	resource_size_t iobase = sm->io_res->start + SM501_GPIO;
 	int ret;
-	int tmp;
 
 	dev_dbg(sm->dev, "registering gpio block %08llx\n",
 		(unsigned long long)iobase);
@@ -1086,11 +1085,7 @@ static int sm501_register_gpio(struct sm501_devdata *sm)
 	return 0;
 
  err_low_chip:
-	tmp = gpiochip_remove(&gpio->low.gpio);
-	if (tmp) {
-		dev_err(sm->dev, "cannot remove low chip, cannot tidy up\n");
-		return ret;
-	}
+	gpiochip_remove(&gpio->low.gpio);
 
  err_mapped:
 	iounmap(gpio->regs);
@@ -1105,18 +1100,12 @@ static int sm501_register_gpio(struct sm501_devdata *sm)
 static void sm501_gpio_remove(struct sm501_devdata *sm)
 {
 	struct sm501_gpio *gpio = &sm->gpio;
-	int ret;
 
 	if (!sm->gpio.registered)
 		return;
 
-	ret = gpiochip_remove(&gpio->low.gpio);
-	if (ret)
-		dev_err(sm->dev, "cannot remove low chip, cannot tidy up\n");
-
-	ret = gpiochip_remove(&gpio->high.gpio);
-	if (ret)
-		dev_err(sm->dev, "cannot remove high chip, cannot tidy up\n");
+	gpiochip_remove(&gpio->low.gpio);
+	gpiochip_remove(&gpio->high.gpio);
 
 	iounmap(gpio->regs);
 	release_resource(gpio->regs_res);
diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index 11c19e5..4fac16b 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -607,7 +607,7 @@ static int tc6393xb_probe(struct platform_device *dev)
 	struct tc6393xb_platform_data *tcpd = dev_get_platdata(&dev->dev);
 	struct tc6393xb *tc6393xb;
 	struct resource *iomem, *rscr;
-	int ret, temp;
+	int ret;
 
 	iomem = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!iomem)
@@ -714,7 +714,7 @@ err_setup:
 
 err_gpio_add:
 	if (tc6393xb->gpio.base != -1)
-		temp = gpiochip_remove(&tc6393xb->gpio);
+		gpiochip_remove(&tc6393xb->gpio);
 	tcpd->disable(dev);
 err_enable:
 	clk_disable(tc6393xb->clk);
@@ -744,13 +744,8 @@ static int tc6393xb_remove(struct platform_device *dev)
 
 	tc6393xb_detach_irq(dev);
 
-	if (tc6393xb->gpio.base != -1) {
-		ret = gpiochip_remove(&tc6393xb->gpio);
-		if (ret) {
-			dev_err(&dev->dev, "Can't remove gpio chip: %d\n", ret);
-			return ret;
-		}
-	}
+	if (tc6393xb->gpio.base != -1)
+		gpiochip_remove(&tc6393xb->gpio);
 
 	ret = tcpd->disable(dev);
 	clk_disable(tc6393xb->clk);
diff --git a/drivers/mfd/ucb1x00-core.c b/drivers/mfd/ucb1x00-core.c
index 153d595..58ea9fd 100644
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -621,7 +621,6 @@ static void ucb1x00_remove(struct mcp *mcp)
 	struct ucb1x00_plat_data *pdata = mcp->attached_device.platform_data;
 	struct ucb1x00 *ucb = mcp_get_drvdata(mcp);
 	struct list_head *l, *n;
-	int ret;
 
 	mutex_lock(&ucb1x00_mutex);
 	list_del(&ucb->node);
@@ -631,11 +630,8 @@ static void ucb1x00_remove(struct mcp *mcp)
 	}
 	mutex_unlock(&ucb1x00_mutex);
 
-	if (ucb->gpio.base != -1) {
-		ret = gpiochip_remove(&ucb->gpio);
-		if (ret)
-			dev_err(&ucb->dev, "Can't remove gpio chip: %d\n", ret);
-	}
+	if (ucb->gpio.base != -1)
+		gpiochip_remove(&ucb->gpio);
 
 	irq_set_chained_handler(ucb->irq, NULL);
 	irq_free_descs(ucb->irq_base, 16);
-- 
1.7.9.5

