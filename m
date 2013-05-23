Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733Ab3EWP0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:26:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38806 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759611Ab3EWPZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:25:52 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/16] mfd: cros_ec: Convert to managed resources for allocating memory
Date: Thu, 23 May 2013 16:25:10 +0100
Message-Id: <1369322717-30429-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
References: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/cros_ec.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
index 10cd14e..1f36885 100644
--- a/drivers/mfd/cros_ec.c
+++ b/drivers/mfd/cros_ec.c
@@ -104,23 +104,19 @@ int cros_ec_register(struct cros_ec_device *ec_dev)
 	ec_dev->command_sendrecv = cros_ec_command_sendrecv;
 
 	if (ec_dev->din_size) {
-		ec_dev->din = kmalloc(ec_dev->din_size, GFP_KERNEL);
-		if (!ec_dev->din) {
-			err = -ENOMEM;
-			goto fail_din;
-		}
+		ec_dev->din = devm_kzalloc(dev, ec_dev->din_size, GFP_KERNEL);
+		if (!ec_dev->din)
+			return -ENOMEM;
 	}
 	if (ec_dev->dout_size) {
-		ec_dev->dout = kmalloc(ec_dev->dout_size, GFP_KERNEL);
-		if (!ec_dev->dout) {
-			err = -ENOMEM;
-			goto fail_dout;
-		}
+		ec_dev->dout = devm_kzalloc(dev, ec_dev->dout_size, GFP_KERNEL);
+		if (!ec_dev->dout)
+			return -ENOMEM;
 	}
 
 	if (!ec_dev->irq) {
 		dev_dbg(dev, "no valid IRQ: %d\n", ec_dev->irq);
-		goto fail_irq;
+		return err;
 	}
 
 	err = request_threaded_irq(ec_dev->irq, NULL, ec_irq_thread,
@@ -128,7 +124,7 @@ int cros_ec_register(struct cros_ec_device *ec_dev)
 				   "chromeos-ec", ec_dev);
 	if (err) {
 		dev_err(dev, "request irq %d: error %d\n", ec_dev->irq, err);
-		goto fail_irq;
+		return err;
 	}
 
 	err = mfd_add_devices(dev, 0, cros_devs,
@@ -145,11 +141,7 @@ int cros_ec_register(struct cros_ec_device *ec_dev)
 
 fail_mfd:
 	free_irq(ec_dev->irq, ec_dev);
-fail_irq:
-	kfree(ec_dev->dout);
-fail_dout:
-	kfree(ec_dev->din);
-fail_din:
+
 	return err;
 }
 EXPORT_SYMBOL(cros_ec_register);
@@ -158,8 +150,6 @@ int cros_ec_remove(struct cros_ec_device *ec_dev)
 {
 	mfd_remove_devices(ec_dev->dev);
 	free_irq(ec_dev->irq, ec_dev);
-	kfree(ec_dev->dout);
-	kfree(ec_dev->din);
 
 	return 0;
 }
-- 
1.7.10.4

