Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab3I1RxB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 13:53:01 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:52229 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab3I1Rw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 13:52:59 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH] of: irq: Pass trigger type in IRQ resource flags
Date: Sat, 28 Sep 2013 19:52:51 +0200
Message-Id: <1380390771-4620-1-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers might rely on availability of trigger flags in IRQ
resource, for example to configure the hardware for particular interrupt
type. However current code creating IRQ resources from data in device
tree does not configure trigger flags in resulting resources.

This patch tries to solve the problem, based on the fact that
irq_of_parse_and_map() configures the trigger based on DT interrupt
specifier and IRQD_TRIGGER_* flags are consistent with IORESOURCE_IRQ_*,
and we can get correct trigger flags by calling irqd_get_trigger_type()
after mapping the interrupt.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/of/irq.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 1752988..12742d0 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -356,6 +356,16 @@ int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
 		r->start = r->end = irq;
 		r->flags = IORESOURCE_IRQ;
 		r->name = name ? name : dev->full_name;
+
+		/*
+		 * Some drivers might rely on availability of trigger flags
+		 * in IRQ resource. Since irq_of_parse_and_map() configures the
+		 * trigger based on interrupt specifier and IRQD_TRIGGER_*
+		 * flags are consistent with IORESOURCE_IRQ_*, we can get
+		 * trigger type that was just set and pass it through resource
+		 * flags as well.
+		 */
+		r->flags |= irqd_get_trigger_type(irq_get_irq_data(irq));
 	}
 
 	return irq;
-- 
1.8.3.2

