Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbbAOCAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 21:00:50 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:47408 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbbAOCAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 21:00:49 -0500
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: [PATCH RESEND V2 1/2] power: gpio-charger: balance enable/disable_irq_wake calls
Date: Thu, 15 Jan 2015 05:00:37 +0300
Message-Id: <1421287238-23522-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enable_irq_wakeup returns 0 in case it correctly enabled the IRQ to
generate the wakeup event (and thus resume should call disable_irq_wake).
Currently gpio-charger driver has this logic inverted. Correct that thus
correcting enable/disable_irq_wake() calls balance.

Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/power/gpio-charger.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index 7536933..e5deb11 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -168,7 +168,7 @@ static int gpio_charger_suspend(struct device *dev)
 
 	if (device_may_wakeup(dev))
 		gpio_charger->wakeup_enabled =
-			enable_irq_wake(gpio_charger->irq);
+			!enable_irq_wake(gpio_charger->irq);
 
 	return 0;
 }
@@ -178,7 +178,7 @@ static int gpio_charger_resume(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct gpio_charger *gpio_charger = platform_get_drvdata(pdev);
 
-	if (gpio_charger->wakeup_enabled)
+	if (device_may_wakeup(dev) && gpio_charger->wakeup_enabled)
 		disable_irq_wake(gpio_charger->irq);
 	power_supply_changed(&gpio_charger->charger);
 
-- 
2.1.4

