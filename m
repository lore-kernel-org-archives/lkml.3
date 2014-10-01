Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaJAFyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 01:54:18 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:48002 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbaJAFyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 01:54:16 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH] serial: remove use of gpiochip_remove() retval
Date: Wed,  1 Oct 2014 11:27:49 +0530
Message-Id: <1412143069-18562-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of using return value from gpiochip_remove() as it returns
void with a new change in kernel.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Cc: linux-gpio@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/tty/serial/max310x.c   |   10 ++++------
 drivers/tty/serial/sc16is7xx.c |   13 +++++--------
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 82573dc..0041a64 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1248,7 +1248,7 @@ static int max310x_probe(struct device *dev, struct max310x_devtype *devtype,
 	mutex_destroy(&s->mutex);
 
 #ifdef CONFIG_GPIOLIB
-	WARN_ON(gpiochip_remove(&s->gpio));
+	gpiochip_remove(&s->gpio);
 
 out_uart:
 #endif
@@ -1263,12 +1263,10 @@ out_clk:
 static int max310x_remove(struct device *dev)
 {
 	struct max310x_port *s = dev_get_drvdata(dev);
-	int i, ret = 0;
+	int i;
 
 #ifdef CONFIG_GPIOLIB
-	ret = gpiochip_remove(&s->gpio);
-	if (ret)
-		return ret;
+	gpiochip_remove(&s->gpio);
 #endif
 
 	for (i = 0; i < s->uart.nr; i++) {
@@ -1282,7 +1280,7 @@ static int max310x_remove(struct device *dev)
 	uart_unregister_driver(&s->uart);
 	clk_disable_unprepare(s->clk);
 
-	return ret;
+	return 0;
 }
 
 static const struct of_device_id __maybe_unused max310x_dt_ids[] = {
diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 3284c31..6246820 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1157,7 +1157,7 @@ static int sc16is7xx_probe(struct device *dev,
 
 #ifdef CONFIG_GPIOLIB
 	if (devtype->nr_gpio)
-		WARN_ON(gpiochip_remove(&s->gpio));
+		gpiochip_remove(&s->gpio);
 
 out_uart:
 #endif
@@ -1173,14 +1173,11 @@ out_clk:
 static int sc16is7xx_remove(struct device *dev)
 {
 	struct sc16is7xx_port *s = dev_get_drvdata(dev);
-	int i, ret = 0;
+	int i;
 
 #ifdef CONFIG_GPIOLIB
-	if (s->devtype->nr_gpio) {
-		ret = gpiochip_remove(&s->gpio);
-		if (ret)
-			return ret;
-	}
+	if (s->devtype->nr_gpio)
+		gpiochip_remove(&s->gpio);
 #endif
 
 	for (i = 0; i < s->uart.nr; i++) {
@@ -1195,7 +1192,7 @@ static int sc16is7xx_remove(struct device *dev)
 	if (!IS_ERR(s->clk))
 		clk_disable_unprepare(s->clk);
 
-	return ret;
+	return 0;
 }
 
 static const struct of_device_id __maybe_unused sc16is7xx_dt_ids[] = {
-- 
1.7.9.5

