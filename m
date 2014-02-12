Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaBLKPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:15:11 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49251 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaBLKKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:10:06 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, b.brezillon@overkiz.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregory.clement@free-electrons.com,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v4 2/8] at91: pinctrl: don't request GPIOs used for interrupts but lock them as IRQ
Date: Wed, 12 Feb 2014 11:06:41 +0100
Message-Id: <1392199607-27452-3-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
References: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the xlate stage of the DT interrupt parsing, the at91 pinctrl driver
requests the GPIOs that are described as interrupt sources. This prevents a
driver to request the gpio later to get its electrical value.
This patch replaces the gpio_request with a gpio_lock_as_irq to prevent the
gpio to be set as an ouput while allowing a subsequent gpio_request to succeed

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 drivers/pinctrl/pinctrl-at91.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index d990e33..db55b96 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1478,18 +1478,17 @@ static int at91_gpio_irq_domain_xlate(struct irq_domain *d,
 {
 	struct at91_gpio_chip *at91_gpio = d->host_data;
 	int ret;
-	int pin = at91_gpio->chip.base + intspec[0];
 
 	if (WARN_ON(intsize < 2))
 		return -EINVAL;
 	*out_hwirq = intspec[0];
 	*out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
 
-	ret = gpio_request(pin, ctrlr->full_name);
+	ret = gpio_lock_as_irq(&at91_gpio->chip, intspec[0]);
 	if (ret)
 		return ret;
 
-	ret = gpio_direction_input(pin);
+	ret = at91_gpio_direction_input(&at91_gpio->chip, intspec[0]);
 	if (ret)
 		return ret;
 
-- 
1.8.5.3

