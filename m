Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaIYQKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:10:19 -0400
Received: from mga14.intel.com ([192.55.52.115]:36518 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbaIYQKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:10:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,598,1406617200"; 
   d="scan'208";a="596818143"
From: Octavian Purdila <octavian.purdila@intel.com>
To: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org
Cc: arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v6 3/4] gpiolib: add irq_not_threaded flag to gpio_chip
Date: Thu, 25 Sep 2014 19:07:33 +0300
Message-Id: <1411661254-5204-4-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411661254-5204-1-git-send-email-octavian.purdila@intel.com>
References: <1411661254-5204-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some GPIO chips (e.g. the DLN2 USB adapter) have blocking get/set
operation but do not need a threaded irq handler.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/gpio/gpiolib.c      | 2 +-
 include/linux/gpio/driver.h | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 15cc0bb..3fa7e73 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -447,7 +447,7 @@ static int gpiochip_irq_map(struct irq_domain *d, unsigned int irq,
 	irq_set_lockdep_class(irq, &gpiochip_irq_lock_class);
 	irq_set_chip_and_handler(irq, chip->irqchip, chip->irq_handler);
 	/* Chips that can sleep need nested thread handlers */
-	if (chip->can_sleep)
+	if (chip->can_sleep && !chip->irq_not_threaded)
 		irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 	set_irq_flags(irq, IRQF_VALID);
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index e78a237..44161ac 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -56,6 +56,8 @@ struct seq_file;
  *	as the chip access may sleep when e.g. reading out the IRQ status
  *	registers.
  * @exported: flags if the gpiochip is exported for use from sysfs. Private.
+ * @irq_not_threaded: flag must be set if @can_sleep is set but the
+ *	IRQs don't need to be threaded
  *
  * A gpio_chip can help platforms abstract various sources of GPIOs so
  * they can all be accessed through a common programing interface.
@@ -101,6 +103,7 @@ struct gpio_chip {
 	struct gpio_desc	*desc;
 	const char		*const *names;
 	bool			can_sleep;
+	bool			irq_not_threaded;
 	bool			exported;
 
 #ifdef CONFIG_GPIOLIB_IRQCHIP
-- 
1.9.1

