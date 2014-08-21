Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaHUQym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:54:42 -0400
Received: from exprod5og120.obsmtp.com ([64.18.0.137]:59901 "HELO
	exprod5og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751865AbaHUQyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:54:41 -0400
From: Feng Kan <fkan@apm.com>
To: tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com,
        linux-kernel@vger.kernel.org, dann.frazier@canonical.com
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH] irqchip: gic: correct gic_set_type trigger acceptance criteria
Date: Thu, 21 Aug 2014 09:56:23 -0700
Message-Id: <1408640183-8804-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GIC is designed to support two types of trigger mechanism. Either active level
high or edge rising.

static int gic_set_type(struct irq_data *d, unsigned int type)
{
	...
        if (type != IRQ_TYPE_LEVEL_HIGH && type != IRQ_TYPE_EDGE_RISING)
                return -EINVAL;

However, this cause problem with requesting driver uses combo selections to tie
down trigger mechanism. In below case gpio_keys_setup_key tries to use either
rising or falling edge trigger, but accidently cause a false positive in the
gic code.

static int gpio_keys_setup_key(struct platform_device *pdev,
{
                irqflags = IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING;

This patch fixes this problem by filter the selection type first.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 drivers/irqchip/irq-gic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index c31eea4..bea167e 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -194,6 +194,7 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 	if (gicirq < 16)
 		return -EINVAL;
 
+	type &= IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING;
 	if (type != IRQ_TYPE_LEVEL_HIGH && type != IRQ_TYPE_EDGE_RISING)
 		return -EINVAL;
 
-- 
1.9.1

