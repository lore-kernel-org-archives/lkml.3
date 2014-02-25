Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaBYQcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 11:32:00 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59104 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbaBYQb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 11:31:59 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: tglx@linutronix.de, linus.walleij@linaro.org
Cc: grant.likely@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH] irq: Consider a negative return value of irq_startup() as an error
Date: Tue, 25 Feb 2014 17:28:39 +0100
Message-Id: <1393345719-3707-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq_startup() function returns the return value of the irq_startup callback
of the underlying irq_chip. Currently this value only tells if the interrupt is
pending, but we can make it also return an error code when it fails.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---

Hi Thomas,

This patch updates the semantic of the return value of the irq_startup()
callback of an irq_chip : a negative value indicates an error. The purpose is
to make __setup_irq() fail if the irq_chip can't startup the interrupt.
I checked in the kernel for drivers impacted by this. It turns out that most
of the implementation of irq_startup() return 0. The only drivers that return
non-zero values are:
 * arch/x86/kernel/apic/io_apic.c: returns 1 when an interrupt is pending
 * drivers/pinctrl/pinctrl-adi2.c: may return -ENODEV.

GPIO-based irq_chip could use this feature because an output gpio can't be used
as an interrupt, and thus a call to irq_startup() is likely to fail. You can
check out http://www.spinics.net/lists/arm-kernel/msg302713.html for a
reference.

Regards,

Jean-Jacques

 include/linux/irq.h    | 2 ++
 kernel/irq/autoprobe.c | 2 +-
 kernel/irq/manage.c    | 4 +++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7dc1003..d566855 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -282,6 +282,8 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  *
  * @name:		name for /proc/interrupts
  * @irq_startup:	start up the interrupt (defaults to ->enable if NULL)
+ *			negative return values indicate an error, otherwise the
+ *			return values indicates if an interrupt is pending
  * @irq_shutdown:	shut down the interrupt (defaults to ->disable if NULL)
  * @irq_enable:		enable the interrupt (defaults to chip->unmask if NULL)
  * @irq_disable:	disable the interrupt
diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index 0119b9d..64794fa 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -70,7 +70,7 @@ unsigned long probe_irq_on(void)
 		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && irq_settings_can_probe(desc)) {
 			desc->istate |= IRQS_AUTODETECT | IRQS_WAITING;
-			if (irq_startup(desc, false))
+			if (irq_startup(desc, false) > 0)
 				desc->istate |= IRQS_PENDING;
 		}
 		raw_spin_unlock_irq(&desc->lock);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 481a13c..58c6be0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1116,7 +1116,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			desc->istate |= IRQS_ONESHOT;
 
 		if (irq_settings_can_autoenable(desc))
-			irq_startup(desc, true);
+			ret = irq_startup(desc, true);
+			if (ret < 0)
+				goto out_mask;
 		else
 			/* Undo nested disables: */
 			desc->depth = 1;
-- 
1.9.0

