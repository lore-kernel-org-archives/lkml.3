Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935009Ab3E2CLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 22:11:05 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:35199 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934983Ab3E2CLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 22:11:00 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de
Cc: Grant Likely <grant.likely@linaro.org>, Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 2/3] irqdomain: Relax failure path on setting up mappings
Date: Wed, 29 May 2013 03:10:53 +0100
Message-Id: <1369793454-19197-3-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369793454-19197-1-git-send-email-grant.likely@linaro.org>
References: <1369793454-19197-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 98aa468e, "irqdomain: Support for static IRQ mapping and
association" introduced an API for directly associating blocks of hwirqs
to linux irqs. However, if any irq in that block failed to map (say if
the mapping functions returns an error because the irq is already
mapped) then the whole thing will fail and roll back. This is probably
too aggressive since there are valid reasons why a mapping may fail.
ie. Firmware may have a particular IRQ marked as unusable.

This patch drops the error path out of irq_domain_associate(). If a
mapping fails, then it is simply skipped. There is no reason to fail the
entire allocation.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdomain.c | 29 +++--------------------------
 1 file changed, 3 insertions(+), 26 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 1db9e70..428ae1db 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -455,28 +455,9 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
 		irq_data->domain = domain;
 		if (domain->ops->map) {
 			ret = domain->ops->map(domain, virq, hwirq);
-			if (ret != 0) {
-				/*
-				 * If map() returns -EPERM, this interrupt is protected
-				 * by the firmware or some other service and shall not
-				 * be mapped.
-				 *
-				 * Since on some platforms we blindly try to map everything
-				 * we end up with a log full of backtraces.
-				 *
-				 * So instead, we silently fail on -EPERM, it is the
-				 * responsibility of the PIC driver to display a relevant
-				 * message if needed.
-				 */
-				if (ret != -EPERM) {
-					pr_err("irq-%i==>hwirq-0x%lx mapping failed: %d\n",
-					       virq, hwirq, ret);
-					WARN_ON(1);
-				}
-				irq_data->domain = NULL;
-				irq_data->hwirq = 0;
-				goto err_unmap;
-			}
+			/* Some maps are refused; this is probably just fine */
+			if (ret)
+				continue;
 		}
 
 		switch (domain->revmap_type) {
@@ -495,10 +476,6 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
 	}
 
 	return 0;
-
- err_unmap:
-	irq_domain_disassociate_many(domain, irq_base, i);
-	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(irq_domain_associate_many);
 
-- 
1.8.1.2

