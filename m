Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbbAMNmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:42:05 -0500
Received: from exprod5og119.obsmtp.com ([64.18.0.189]:33582 "EHLO
	exprod5og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbAMNmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:42:03 -0500
From: Semen Protsenko <semen.protsenko@globallogic.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Marc Zyngier <maz@misterjones.org>,
        Grygorii Strashko <grygorii.strashko@globallogic.com>,
        Illia Smyrnov <illia.smyrnov@globallogic.com>
Subject: [PATCH 3/4] gpio: max732x: Fix possible deadlock
Date: Tue, 13 Jan 2015 15:41:44 +0200
Message-Id: <1421156505-16600-4-git-send-email-semen.protsenko@globallogic.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421156505-16600-1-git-send-email-semen.protsenko@globallogic.com>
References: <1421156505-16600-1-git-send-email-semen.protsenko@globallogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was derived from next one:
"gpio: fix pca953x set_type 'scheduling while atomic' bug".

After adding entry that consumes max732x GPIO as interrupt line to dts
file, deadlock appears somewhere in max732x probe function.

Deadlock caught by lockdep (from kernel log):
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< cut here >>>>>>>>>>>>>>>>>>>>>>>>>>>
[    0.473419] ======================================================
[    0.473419] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[    0.473449] 3.x.xx-xxxxx-xxxxxxxx-dirty #2 Tainted: G        W
[    0.473449] ------------------------------------------------------
[    0.473449] swapper/0/1 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[    0.473449]  (&lock->wait_lock){+.+...}, at: [<c072e350>] rt_mutex_trylock+0xc/0x74
[    0.473480]
[    0.473480] and this task is already holding:
[    0.473510]  (&chip->lock){......}, at: [<c0314514>] max732x_gpio_set_value+0x2c/0xa4
[    0.473541] which would create a new lock dependency:
[    0.473541]  (&chip->lock){......} -> (&lock->wait_lock){+.+...}

...

[    0.474273]  *** DEADLOCK ***
[    0.474273]
[    0.474273] 5 locks held by swapper/0/1:
[    0.474273]  #0:  (&__lockdep_no_validate__){......}, at: [<c03b2328>] __driver_attach+0x48/0x98
[    0.474304]  #1:  (&__lockdep_no_validate__){......}, at: [<c03b2338>] __driver_attach+0x58/0x98
[    0.474334]  #2:  (&chip->irq_lock){+.+...}, at: [<c0313e3c>] max732x_irq_bus_lock+0x14/0x20
[    0.474365]  #3:  (&irq_desc_lock_class){-.....}, at: [<c00a65a4>] __irq_get_desc_lock+0x48/0x88
[    0.474365]  #4:  (&chip->lock){......}, at: [<c0314514>] max732x_gpio
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< cut here >>>>>>>>>>>>>>>>>>>>>>>>>>>

Signed-off-by: Semen Protsenko <semen.protsenko@globallogic.com>
---
 drivers/gpio/gpio-max732x.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-max732x.c b/drivers/gpio/gpio-max732x.c
index f8f3e80..5fbab13 100644
--- a/drivers/gpio/gpio-max732x.c
+++ b/drivers/gpio/gpio-max732x.c
@@ -377,8 +377,18 @@ static void max732x_irq_bus_lock(struct irq_data *d)
 static void max732x_irq_bus_sync_unlock(struct irq_data *d)
 {
 	struct max732x_chip *chip = irq_data_get_irq_chip_data(d);
+	uint16_t new_irqs;
+	uint16_t level;
 
 	max732x_irq_update_mask(chip);
+
+	new_irqs = chip->irq_trig_fall | chip->irq_trig_raise;
+	while (new_irqs) {
+		level = __ffs(new_irqs);
+		max732x_gpio_direction_input(&chip->gpio_chip, level);
+		new_irqs &= ~(1 << level);
+	}
+
 	mutex_unlock(&chip->irq_lock);
 }
 
@@ -410,7 +420,7 @@ static int max732x_irq_set_type(struct irq_data *d, unsigned int type)
 	else
 		chip->irq_trig_raise &= ~mask;
 
-	return max732x_gpio_direction_input(&chip->gpio_chip, off);
+	return 0;
 }
 
 static struct irq_chip max732x_irq_chip = {
-- 
1.7.9.5

