Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3KKOhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:37:34 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:64941 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab3KKOh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:37:27 -0500
From: Evgeny Boger <eugenyboger@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, Evgeny Boger <eugenyboger@gmail.com>,
        Evgeny Boger <boger@contactless.ru>
Subject: [PATCH 1/1] Add strong pullup emulation to w1-gpio master driver.
Date: Mon, 11 Nov 2013 18:36:54 +0400
Message-Id: <1384180614-9025-1-git-send-email-boger@contactless.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Strong pullup is emulated by driving pin logic high after write command when
 using tri-state push-pull GPIO.


Signed-off-by: Evgeny Boger <boger@contactless.ru>
---
 drivers/w1/masters/w1-gpio.c | 22 ++++++++++++++++++++++
 drivers/w1/w1_int.c          | 12 ------------
 include/linux/w1-gpio.h      |  1 +
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index f54ece2..cb7f89b 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -18,10 +18,31 @@
 #include <linux/of_gpio.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <linux/delay.h>

 #include "../w1.h"
 #include "../w1_int.h"

+static u8 w1_gpio_set_pullup(void *data, int delay)
+{
+	struct w1_gpio_platform_data *pdata = data;
+
+	if (delay) {
+		pdata->pullup_duration = delay;
+	} else {
+		if (pdata->pullup_duration) {
+			gpio_direction_output(pdata->pin, 1);
+
+			msleep(pdata->pullup_duration);
+
+			gpio_direction_input(pdata->pin);
+		}
+		pdata->pullup_duration = 0;
+	}
+
+	return 0;
+}
+
 static void w1_gpio_write_bit_dir(void *data, u8 bit)
 {
	struct w1_gpio_platform_data *pdata = data;
@@ -125,6 +146,7 @@ static int w1_gpio_probe(struct platform_device *pdev)
	} else {
		gpio_direction_input(pdata->pin);
		master->write_bit = w1_gpio_write_bit_dir;
+		master->set_pullup = w1_gpio_set_pullup;
	}

	err = w1_add_master_device(master);
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 5a98649..590bd8a 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -117,18 +117,6 @@ int w1_add_master_device(struct w1_bus_master *master)
		printk(KERN_ERR "w1_add_master_device: invalid function set\n");
		return(-EINVAL);
         }
-	/* While it would be electrically possible to make a device that
-	 * generated a strong pullup in bit bang mode, only hardware that
-	 * controls 1-wire time frames are even expected to support a strong
-	 * pullup.  w1_io.c would need to support calling set_pullup before
-	 * the last write_bit operation of a w1_write_8 which it currently
-	 * doesn't.
-	 */
-	if (!master->write_byte && !master->touch_bit && master->set_pullup) {
-		printk(KERN_ERR "w1_add_master_device: set_pullup requires "
-			"write_byte or touch_bit, disabling\n");
-		master->set_pullup = NULL;
-	}

	/* Lock until the device is added (or not) to w1_masters. */
	mutex_lock(&w1_mlock);
diff --git a/include/linux/w1-gpio.h b/include/linux/w1-gpio.h
index 065e3ae..d58594a 100644
--- a/include/linux/w1-gpio.h
+++ b/include/linux/w1-gpio.h
@@ -20,6 +20,7 @@ struct w1_gpio_platform_data {
	unsigned int is_open_drain:1;
	void (*enable_external_pullup)(int enable);
	unsigned int ext_pullup_enable_pin;
+	unsigned int pullup_duration;
 };

 #endif /* _LINUX_W1_GPIO_H */
--
1.8.1.2
