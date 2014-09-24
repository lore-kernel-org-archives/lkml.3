Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbaIXNsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:48:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51015 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbaIXNsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:48:00 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/22] usb: phy: twl4030-usb: Use mutex instead of spinlock for protecting the data
Date: Wed, 24 Sep 2014 19:17:12 +0530
Message-ID: <1411566440-19169-15-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411566440-19169-1-git-send-email-kishon@ti.com>
References: <1411566440-19169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

We're using threaded irq on a I2C bus and we're sleeping in
twl4030_usb_irq() as it calls twl4030_usb_linkstat() which
calls the i2c functions. If we ever need to lock for longer
I2C transaction sequences a mutex will allow us to do that
easily.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-twl4030-usb.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index 24ff3c6..1e0e2d1 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -28,7 +28,6 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
-#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/io.h>
 #include <linux/delay.h>
@@ -155,7 +154,7 @@ struct twl4030_usb {
 	struct regulator	*usb3v1;
 
 	/* for vbus reporting with irqs disabled */
-	spinlock_t		lock;
+	struct mutex		lock;
 
 	/* pin configuration */
 	enum twl4030_usb_mode	usb_mode;
@@ -516,13 +515,12 @@ static ssize_t twl4030_usb_vbus_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct twl4030_usb *twl = dev_get_drvdata(dev);
-	unsigned long flags;
 	int ret = -EINVAL;
 
-	spin_lock_irqsave(&twl->lock, flags);
+	mutex_lock(&twl->lock);
 	ret = sprintf(buf, "%s\n",
 			twl->vbus_supplied ? "on" : "off");
-	spin_unlock_irqrestore(&twl->lock, flags);
+	mutex_unlock(&twl->lock);
 
 	return ret;
 }
@@ -536,12 +534,12 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
 
 	status = twl4030_usb_linkstat(twl);
 
-	spin_lock_irq(&twl->lock);
+	mutex_lock(&twl->lock);
 	if (status >= 0 && status != twl->linkstat) {
 		twl->linkstat = status;
 		status_changed = true;
 	}
-	spin_unlock_irq(&twl->lock);
+	mutex_unlock(&twl->lock);
 
 	if (status_changed) {
 		/* FIXME add a set_power() method so that B-devices can
@@ -695,8 +693,8 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	if (IS_ERR(phy_provider))
 		return PTR_ERR(phy_provider);
 
-	/* init spinlock for workqueue */
-	spin_lock_init(&twl->lock);
+	/* init mutex for workqueue */
+	mutex_init(&twl->lock);
 
 	INIT_DELAYED_WORK(&twl->id_workaround_work, twl4030_id_workaround_work);
 
-- 
1.7.9.5

