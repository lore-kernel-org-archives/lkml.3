Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbbAOCAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 21:00:53 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:53960 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbbAOCAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 21:00:51 -0500
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH RESEND V2 2/2] power: collie_battery: support generating wakeup event
Date: Thu, 15 Jan 2015 05:00:38 +0300
Message-Id: <1421287238-23522-2-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421287238-23522-1-git-send-email-dbaryshkov@gmail.com>
References: <1421287238-23522-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Teach collie_battery driver to communicate to the kernel that it can
generate wakeup events. Handle enabling/disabling wakeup on battery full
event in suspend/resume callbacks.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/power/collie_battery.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/power/collie_battery.c b/drivers/power/collie_battery.c
index d02ae02..594e4db 100644
--- a/drivers/power/collie_battery.c
+++ b/drivers/power/collie_battery.c
@@ -26,6 +26,7 @@
 static DEFINE_MUTEX(bat_lock); /* protects gpio pins */
 static struct work_struct bat_work;
 static struct ucb1x00 *ucb;
+static int wakeup_enabled;
 
 struct collie_bat {
 	int status;
@@ -291,11 +292,21 @@ static int collie_bat_suspend(struct ucb1x00_dev *dev)
 {
 	/* flush all pending status updates */
 	flush_work(&bat_work);
+
+	if (device_may_wakeup(&dev->ucb->dev) &&
+	    collie_bat_main.status == POWER_SUPPLY_STATUS_CHARGING)
+		wakeup_enabled = !enable_irq_wake(gpio_to_irq(COLLIE_GPIO_CO));
+	else
+		wakeup_enabled = 0;
+
 	return 0;
 }
 
 static int collie_bat_resume(struct ucb1x00_dev *dev)
 {
+	if (wakeup_enabled)
+		disable_irq_wake(gpio_to_irq(COLLIE_GPIO_CO));
+
 	/* things may have changed while we were away */
 	schedule_work(&bat_work);
 	return 0;
@@ -334,10 +345,15 @@ static int collie_bat_probe(struct ucb1x00_dev *dev)
 				collie_bat_gpio_isr,
 				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 				"main full", &collie_bat_main);
-	if (!ret) {
-		schedule_work(&bat_work);
-		return 0;
-	}
+	if (ret)
+		goto err_irq;
+
+	device_init_wakeup(&ucb->dev, 1);
+	schedule_work(&bat_work);
+
+	return 0;
+
+err_irq:
 	power_supply_unregister(&collie_bat_bu.psy);
 err_psy_reg_bu:
 	power_supply_unregister(&collie_bat_main.psy);
-- 
2.1.4

