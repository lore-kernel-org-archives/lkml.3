Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab3HGPYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:24:14 -0400
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:34345 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752416Ab3HGPYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:24:13 -0400
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: poeschel@lemonage.de, grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com
Subject: [PATCH] gpio: adnp: Fix segfault if request_threaded_irq fails
Date: Wed,  7 Aug 2013 17:23:58 +0200
Message-Id: <1375889038-7953-1-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

In case request_threaded_irq inside adnp_irq_setup fails, the driver
segfaults. This is because irq_domain_remove is called twice with
the same pointer. First time in adnp_irq_setup and then a second time
after leaving adnp_irq_setup in the error path of adnp_i2c_probe
inside adnp_teardown.
This fixes this by removing the call to irq_domain_remove from
adnp_irq_setup.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/gpio/gpio-adnp.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-adnp.c b/drivers/gpio/gpio-adnp.c
index e60567f..c0f3fc4 100644
--- a/drivers/gpio/gpio-adnp.c
+++ b/drivers/gpio/gpio-adnp.c
@@ -490,15 +490,11 @@ static int adnp_irq_setup(struct adnp *adnp)
 	if (err != 0) {
 		dev_err(chip->dev, "can't request IRQ#%d: %d\n",
 			adnp->client->irq, err);
-		goto error;
+		return err;
 	}
 
 	chip->to_irq = adnp_gpio_to_irq;
 	return 0;
-
-error:
-	irq_domain_remove(adnp->domain);
-	return err;
 }
 
 static void adnp_irq_teardown(struct adnp *adnp)
-- 
1.7.10.4

