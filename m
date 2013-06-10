Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab3FJAte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 20:49:34 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:64925 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab3FJAtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 20:49:31 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Grant Likely <grant.likely@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [RFC 01/10] irqdomain: Relax failure path on setting up mappings
Date: Mon, 10 Jun 2013 01:49:13 +0100
Message-Id: <1370825362-11145-2-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370825362-11145-1-git-send-email-grant.likely@linaro.org>
References: <1370825362-11145-1-git-send-email-grant.likely@linaro.org>
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

v2: Still output an information message on failed mappings and make sure
    attempted mapping gets cleared out of the irq_data structure.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdomain.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 20b677d..61d6d3c 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -464,23 +464,15 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
 				/*
 				 * If map() returns -EPERM, this interrupt is protected
 				 * by the firmware or some other service and shall not
-				 * be mapped.
-				 *
-				 * Since on some platforms we blindly try to map everything
-				 * we end up with a log full of backtraces.
-				 *
-				 * So instead, we silently fail on -EPERM, it is the
-				 * responsibility of the PIC driver to display a relevant
-				 * message if needed.
+				 * be mapped. Don't bother telling the user about it.
 				 */
 				if (ret != -EPERM) {
-					pr_err("irq-%i==>hwirq-0x%lx mapping failed: %d\n",
-					       virq, hwirq, ret);
-					WARN_ON(1);
+					pr_info("%s didn't like hwirq-0x%lx to VIRQ%i mapping (rc=%d)\n",
+					       of_node_full_name(domain->of_node), hwirq, virq, ret);
 				}
 				irq_data->domain = NULL;
 				irq_data->hwirq = 0;
-				goto err_unmap;
+				continue;
 			}
 		}
 
-- 
1.8.1.2

