Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab3GSOKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:10:35 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:33472 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab3GSOKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:10:33 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/3] mfd: ucb1x00-core: Rewrite ucb1x00_add_dev()
Date: Fri, 19 Jul 2013 15:10:17 +0100
Message-Id: <1374243017-8515-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374243017-8515-1-git-send-email-lee.jones@linaro.org>
References: <1374243017-8515-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error handling is on-its-head in this function. After invoking a function we
should examine the return code and return the error value if there was one.
Instead, this function checks for success and goes onto provide functionality
if success was received. Not so bad in a simple function like this, but in
a more complex one this could end up drowning in curly brackets.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ucb1x00-core.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/ucb1x00-core.c b/drivers/mfd/ucb1x00-core.c
index 70f02da..0690ffd 100644
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -393,22 +393,24 @@ static struct irq_chip ucb1x00_irqchip = {
 static int ucb1x00_add_dev(struct ucb1x00 *ucb, struct ucb1x00_driver *drv)
 {
 	struct ucb1x00_dev *dev;
-	int ret = -ENOMEM;
+	int ret;
 
 	dev = kmalloc(sizeof(struct ucb1x00_dev), GFP_KERNEL);
-	if (dev) {
-		dev->ucb = ucb;
-		dev->drv = drv;
-
-		ret = drv->add(dev);
-
-		if (ret == 0) {
-			list_add_tail(&dev->dev_node, &ucb->devs);
-			list_add_tail(&dev->drv_node, &drv->devs);
-		} else {
-			kfree(dev);
-		}
+	if (!dev)
+		return -ENOMEM;
+
+	dev->ucb = ucb;
+	dev->drv = drv;
+
+	ret = drv->add(dev);
+	if (ret) {
+		kfree(dev);
+		return ret;
 	}
+
+	list_add_tail(&dev->dev_node, &ucb->devs);
+	list_add_tail(&dev->drv_node, &drv->devs);
+
 	return ret;
 }
 
-- 
1.8.1.2

