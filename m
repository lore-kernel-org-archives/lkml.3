Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab3BDIKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 03:10:34 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:34208 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3BDIKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 03:10:33 -0500
X-Auth-Info: snB3PbjaE2UsVMnGgcZbQKhykiWx29HwnW2yA5gZj/M=
From: Anatolij Gustschin <agust@denx.de>
To: linus.walleij@linaro.org
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Anatolij Gustschin <agust@denx.de>
Subject: [PATCH] gpio: mpc8xxx: don't set IRQ_TYPE_NONE when creating irq mapping
Date: Mon,  4 Feb 2013 09:10:15 +0100
Message-Id: <1359965415-3887-1-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1359461275-7059-1-git-send-email-agust@denx.de>
References: <1359461275-7059-1-git-send-email-agust@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exporting gpios over sysfs GPIO interface throws genirq
error messages, i.e. on an mpc5121 based board exporting
GPIO 5 triggers it:

    # echo 229 > /sys/class/gpio/export
    genirq: Setting trigger mode 0 for irq 44 failed
    (mpc512x_irq_set_type+0x0/0x18c)

Similar error messages appear in the kernel boot log since the
board specifies GPIOs for matrix keypad and also SD Card write
protect and card detect GPIOs in its device tree. For all these
GPIOs there is an error message in the log.

The issue is triggered by setting the irq type to IRQ_TYPE_NONE
in the driver's irq_domain map function mpc8xxx_gpio_irq_map().

...
  mpc8xxx_gpio_irq_map
    irq_set_irq_type
      __irq_set_trigger

__irq_set_trigger() calls irq_set_type() callback of the mpc8xxx gpio
irq chip with the IRQ_TYPE_NONE in its 'flags' argument. This callback
is either mpc8xxx_irq_set_type() or mpc512x_irq_set_type(). Both these
functions return -EINVAL in the case if IRQ_TYPE_NONE is passed in the
flow_type argument. This return value triggers the observed error
message in __irq_set_trigger(). Modifying these callbacks to not
return an error in IRQ_TYPE_NONE case doesn't make any sense to me.
The line setting IRQ_TYPE_NONE type has been originally added by
commit 345e5c8a "powerpc: Add interrupt support to mpc8xxx_gpio".
At this time set_irq_type() checked its type argument and returned 0
if the type argument didn't specify any meaningful type in its type
sense bits (and thus was equal to IRQ_TYPE_NONE). Effectively this
line was a nop and I wonder what was the point of adding it.

Remove IRQ_TYPE_NONE setting in the irq_domain mapping function.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 drivers/gpio/gpio-mpc8xxx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 5a1817e..0ca67cb 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -292,7 +292,6 @@ static int mpc8xxx_gpio_irq_map(struct irq_domain *h, unsigned int virq,
 
 	irq_set_chip_data(virq, h->host_data);
 	irq_set_chip_and_handler(virq, &mpc8xxx_irq_chip, handle_level_irq);
-	irq_set_irq_type(virq, IRQ_TYPE_NONE);
 
 	return 0;
 }
-- 
1.7.5.4

