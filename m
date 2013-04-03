Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892Ab3DCRkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:40:40 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:58178 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397Ab3DCRkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:40:39 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, jimwall@q.com,
        brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] gpio: pca953x: fix irq_domain_add_simple usage
Date: Wed,  3 Apr 2013 19:40:14 +0200
Message-Id: <1365010814-3263-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We actually have to pass chip as the host_data parameter of
irq_domain_add_simple() as later on, it is used to initialize chip_data
in pca953x_gpio_irq_map(). Failing to do so is leading to a NULL pointer
dereference after calling irq_data_get_irq_chip_data() in
pca953x_irq_mask(), pca953x_irq_unmask(), pca953x_irq_bus_lock(),
pca953x_irq_bus_sync_unlock() and pca953x_irq_set_type().

Fixes regression introduced by commit
0e8f2fdacf1d44651aa7e57063c76142d1f4988b (gpio: pca953x: use simple
irqdomain)

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---

This would probably be good to introduce that patch in the next 3.9 rc as the
regression leads to a lot of breakage (and cursing).

 drivers/gpio/gpio-pca953x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index e2dcac5..ea26e59 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -575,7 +575,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 						chip->gpio_chip.ngpio,
 						irq_base,
 						&pca953x_irq_simple_ops,
-						NULL);
+						chip);
 		if (!chip->domain)
 			return -ENODEV;
 
-- 
1.7.10.4

