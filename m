Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab3IBCa6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 22:30:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42455 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758032Ab3IBCap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 22:30:45 -0400
From: George Cherian <george.cherian@ti.com>
To: <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <kuninori.morimoto.gx@renesas.com>,
        <n.a.balandin@gmail.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v3 2/3] gpio: pcf857x: remove the irq_demux_work
Date: Mon, 2 Sep 2013 08:00:03 +0530
Message-ID: <1378089004-14478-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378089004-14478-1-git-send-email-george.cherian@ti.com>
References: <1378089004-14478-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we are using devm_request_threaded_irq no need for
irq_demux_work. Remove all its references.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/gpio/gpio-pcf857x.c | 35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index 4d0d28c..4890e97 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -30,7 +30,6 @@
 #include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/workqueue.h>
 
 
 static const struct i2c_device_id pcf857x_id[] = {
@@ -89,7 +88,6 @@ struct pcf857x {
 	struct gpio_chip	chip;
 	struct i2c_client	*client;
 	struct mutex		lock;		/* protect 'out' */
-	struct work_struct	work;		/* irq demux work */
 	struct irq_domain	*irq_domain;	/* for irq demux  */
 	spinlock_t		slock;		/* protect irq demux */
 	unsigned		out;		/* software latch */
@@ -210,38 +208,6 @@ static irqreturn_t pcf857x_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void pcf857x_irq_demux_work(struct work_struct *work)
-{
-	struct pcf857x *gpio = container_of(work,
-					       struct pcf857x,
-					       work);
-	unsigned long change, i, status, flags;
-
-	status = gpio->read(gpio->client);
-
-	spin_lock_irqsave(&gpio->slock, flags);
-
-	change = gpio->status ^ status;
-	for_each_set_bit(i, &change, gpio->chip.ngpio)
-		generic_handle_irq(irq_find_mapping(gpio->irq_domain, i));
-	gpio->status = status;
-
-	spin_unlock_irqrestore(&gpio->slock, flags);
-}
-
-static irqreturn_t pcf857x_irq_demux(int irq, void *data)
-{
-	struct pcf857x	*gpio = data;
-
-	/*
-	 * pcf857x can't read/write data here,
-	 * since i2c data access might go to sleep.
-	 */
-	schedule_work(&gpio->work);
-
-	return IRQ_HANDLED;
-}
-
 static int pcf857x_irq_domain_map(struct irq_domain *domain, unsigned int virq,
 				 irq_hw_number_t hw)
 {
@@ -284,7 +250,6 @@ static int pcf857x_irq_domain_init(struct pcf857x *gpio,
 		goto fail;
 
 	/* enable gpio_to_irq() */
-	INIT_WORK(&gpio->work, pcf857x_irq_demux_work);
 	gpio->chip.to_irq	= pcf857x_to_irq;
 	gpio->irq		= client->irq;
 
-- 
1.8.1.4

