Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbaDKAAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 20:00:33 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:15467 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbaDKAAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 20:00:31 -0400
X-IronPort-AV: E=Sophos;i="4.97,837,1389772800"; 
   d="scan'208";a="24255257"
From: Tim Kryger <tim.kryger@linaro.org>
To: Markus Mayer <markus.mayer@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux GPIO Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio: bcm-kona: Add irq_set_wake method
Date: Thu, 10 Apr 2014 17:00:24 -0700
Message-ID: <1397174424-30855-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a consumer of a GPIO-based IRQ identifies itself as wanting to
have the capability to wake up the system through that interrupt,
update the flags to keep that interrupt enabled in suspend.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
---
 drivers/gpio/gpio-bcm-kona.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/gpio/gpio-bcm-kona.c b/drivers/gpio/gpio-bcm-kona.c
index 3f6b33c..b0e0971 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/irqdomain.h>
 #include <linux/irqchip/chained_irq.h>
+#include <linux/interrupt.h>
 
 #define BCM_GPIO_PASSWD				0x00a5a501
 #define GPIO_PER_BANK				32
@@ -340,6 +341,23 @@ static void bcm_kona_gpio_irq_ack(struct irq_data *d)
 	spin_unlock_irqrestore(&kona_gpio->lock, flags);
 }
 
+#ifdef CONFIG_SUSPEND
+static int bcm_kona_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
+{
+
+	struct irq_desc *desc = container_of(d, struct irq_desc, irq_data);
+
+	if (on)
+		desc->action->flags |= IRQF_NO_SUSPEND;
+	else
+		desc->action->flags &= ~IRQF_NO_SUSPEND;
+
+	return 0;
+}
+#else
+#define bcm_kona_gpio_irq_set_wake NULL
+#endif
+
 static void bcm_kona_gpio_irq_mask(struct irq_data *d)
 {
 	struct bcm_kona_gpio *kona_gpio;
@@ -494,6 +512,7 @@ static struct irq_chip bcm_gpio_irq_chip = {
 	.irq_set_type = bcm_kona_gpio_irq_set_type,
 	.irq_request_resources = bcm_kona_gpio_irq_reqres,
 	.irq_release_resources = bcm_kona_gpio_irq_relres,
+	.irq_set_wake = bcm_kona_gpio_irq_set_wake,
 };
 
 static struct __initconst of_device_id bcm_kona_gpio_of_match[] = {
-- 
1.7.9.5

