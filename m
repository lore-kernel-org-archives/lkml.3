Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbaFPVkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:40:23 -0400
Received: from mail-oa0-f73.google.com ([209.85.219.73]:55975 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbaFPVkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:40:19 -0400
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        Wolfram Sang <wsa@the-dreams.de>, broonie@kernel.org,
        Doug Anderson <dianders@chromium.org>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] mfd: cros_ec: IRQs for cros_ec should be optional
Date: Mon, 16 Jun 2014 14:39:52 -0700
Message-Id: <1402954800-28215-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1402954800-28215-1-git-send-email-dianders@chromium.org>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Richardson <wfrichar@chromium.org>

Preparing the way for the LPC device, which is just a plaform_device without
interrupts.

Signed-off-by: Bill Richardson <wfrichar@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/mfd/cros_ec.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
index 38fe9bf..bd6f936 100644
--- a/drivers/mfd/cros_ec.c
+++ b/drivers/mfd/cros_ec.c
@@ -119,17 +119,15 @@ int cros_ec_register(struct cros_ec_device *ec_dev)
 			return -ENOMEM;
 	}
 
-	if (!ec_dev->irq) {
-		dev_dbg(dev, "no valid IRQ: %d\n", ec_dev->irq);
-		return err;
-	}
-
-	err = request_threaded_irq(ec_dev->irq, NULL, ec_irq_thread,
-				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				   "chromeos-ec", ec_dev);
-	if (err) {
-		dev_err(dev, "request irq %d: error %d\n", ec_dev->irq, err);
-		return err;
+	if (ec_dev->irq) {
+		err = request_threaded_irq(ec_dev->irq, NULL, ec_irq_thread,
+					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					"chromeos-ec", ec_dev);
+		if (err) {
+			dev_err(dev, "request irq %d: error %d\n",
+				ec_dev->irq, err);
+			return err;
+		}
 	}
 
 	err = mfd_add_devices(dev, 0, cros_devs,
@@ -145,7 +143,8 @@ int cros_ec_register(struct cros_ec_device *ec_dev)
 	return 0;
 
 fail_mfd:
-	free_irq(ec_dev->irq, ec_dev);
+	if (ec_dev->irq)
+		free_irq(ec_dev->irq, ec_dev);
 
 	return err;
 }
@@ -154,7 +153,8 @@ EXPORT_SYMBOL(cros_ec_register);
 int cros_ec_remove(struct cros_ec_device *ec_dev)
 {
 	mfd_remove_devices(ec_dev->dev);
-	free_irq(ec_dev->irq, ec_dev);
+	if (ec_dev->irq)
+		free_irq(ec_dev->irq, ec_dev);
 
 	return 0;
 }
-- 
2.0.0.526.g5318336

