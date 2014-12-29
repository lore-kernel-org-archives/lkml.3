Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaL2Xcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 18:32:32 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:41060 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaL2Xc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 18:32:26 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        marc.zyngier@arm.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH v2 01/12] genirq: generic chip: support hierarchy domain
Date: Tue, 30 Dec 2014 00:32:04 +0100
Message-Id: <1419895935-22966-2-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1419895935-22966-1-git-send-email-stefan@agner.ch>
References: <1419895935-22966-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new helper function irq_domain_set_info to make sure the
function irq_domain_set_hwirq_and_chip is being called, which is
crucial to save irqdomain specific data to irq_data.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 kernel/irq/generic-chip.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 61024e8..15b370d 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -360,7 +360,7 @@ static struct lock_class_key irq_nested_lock_class;
 int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
 			 irq_hw_number_t hw_irq)
 {
-	struct irq_data *data = irq_get_irq_data(virq);
+	struct irq_data *data = irq_domain_get_irq_data(d, virq);
 	struct irq_domain_chip_generic *dgc = d->gc;
 	struct irq_chip_generic *gc;
 	struct irq_chip_type *ct;
@@ -405,8 +405,7 @@ int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
 	else
 		data->mask = 1 << idx;
 
-	irq_set_chip_and_handler(virq, chip, ct->handler);
-	irq_set_chip_data(virq, gc);
+	irq_domain_set_info(d, virq, hw_irq, chip, gc, ct->handler, NULL, NULL);
 	irq_modify_status(virq, dgc->irq_flags_to_clear, dgc->irq_flags_to_set);
 	return 0;
 }
-- 
2.2.1

