Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbaIEPWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:22:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:64644 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920AbaIEPWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:22:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,473,1406617200"; 
   d="scan'208";a="568912997"
From: Octavian Purdila <octavian.purdila@intel.com>
To: linus.walleij@linaro.org, gnurou@gmail.com
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH] gpiolib: fix a few issues with gpiochip_remove
Date: Fri,  5 Sep 2014 18:22:04 +0300
Message-Id: <1409930524-1529-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of gpiochip_remove() does not check to see
if the GPIO pins are busy before removing the associated irqchip and
this is causing the following warning:

WARNING: CPU: 3 PID: 553 at fs/proc/generic.c:521 remove_proc_entry+0x19f/0x1b0()
remove_proc_entry: removing non-empty directory 'irq/24', leaking at least 'bmc150_accel_event'
Call Trace:
 [<ffffffff81a78504>] dump_stack+0x4e/0x7a
 [<ffffffff810c79bd>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff810c7a2c>] warn_slowpath_fmt+0x4c/0x50
 [<ffffffff8125259f>] remove_proc_entry+0x19f/0x1b0
 [<ffffffff811138ae>] unregister_irq_proc+0xce/0xf0
 [<ffffffff8110dbc1>] free_desc+0x31/0x70
 [<ffffffff8110dc3c>] irq_free_descs+0x3c/0x80
 [<ffffffff81113096>] irq_dispose_mapping+0x36/0x50
 [<ffffffff8148549a>] gpiochip_remove+0x5a/0x160
 [<ffffffff814895d8>] dln2_do_remove+0x18/0x80
 [<ffffffff8148966a>] dln2_gpio_remove+0x2a/0x30
 [<ffffffff816143bd>] platform_drv_remove+0x1d/0x40
...

and bug:

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:97
in_atomic(): 1, irqs_disabled(): 1, pid: 553, name: khubd
Preemption disabled at:[<ffffffff81485462>] gpiochip_remove+0x22/0x160
Call Trace:
 [<ffffffff81a78504>] dump_stack+0x4e/0x7a
 [<ffffffff810e8dff>] __might_sleep+0x10f/0x180
 [<ffffffff81a7f3f0>] mutex_lock+0x20/0x3d
 [<ffffffff8110dbcd>] free_desc+0x3d/0x70
 [<ffffffff8110dc3c>] irq_free_descs+0x3c/0x80
 [<ffffffff81113096>] irq_dispose_mapping+0x36/0x50
 [<ffffffff8148549a>] gpiochip_remove+0x5a/0x160
 [<ffffffff814895d8>] dln2_do_remove+0x18/0x80
 [<ffffffff8148966a>] dln2_gpio_remove+0x2a/0x30
 [<ffffffff816143bd>] platform_drv_remove+0x1d/0x40
...

The current implementaion also does a partial cleanup if one of the
pins is busy, which makes it impossible to retry the remove operation
later.

A retry operation is needed in the case of MFD devices that bundles a
GPIO device and another device that is an indirect consumer of the
GPIO device (typical an I2C bus).

In this case, when the MFD device is removed, if an I2C device
associated with the I2C bus of the MFD device is using a GPIO pin (as
an interrupt source for example), and the remove routine for the GPIO
device is called first, then the removal of the gpio chip will fail.

However, we can later retry the gpio chip removal, as the I2C bus will
eventually be removed which will cause the I2C device to release the
GPIO pin.

This patch modifies gpiochip_remove to be atomic (i.e. if it fails no
partial cleanup is done) and it also moves gpiochip_irqchip_remove()
out of the spinlock to avoid the bug above.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/gpio/gpiolib.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 15cc0bb..0f53bef 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -314,14 +314,8 @@ int gpiochip_remove(struct gpio_chip *chip)
 	int		status = 0;
 	unsigned	id;
 
-	acpi_gpiochip_remove(chip);
-
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	gpiochip_irqchip_remove(chip);
-	gpiochip_remove_pin_ranges(chip);
-	of_gpiochip_remove(chip);
-
 	for (id = 0; id < chip->ngpio; id++) {
 		if (test_bit(FLAG_REQUESTED, &chip->desc[id].flags)) {
 			status = -EBUSY;
@@ -337,8 +331,13 @@ int gpiochip_remove(struct gpio_chip *chip)
 
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
-	if (status == 0)
+	if (status == 0) {
+		gpiochip_irqchip_remove(chip);
+		gpiochip_remove_pin_ranges(chip);
+		of_gpiochip_remove(chip);
+		acpi_gpiochip_remove(chip);
 		gpiochip_unexport(chip);
+	}
 
 	return status;
 }
-- 
1.9.1

