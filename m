Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbbAWRJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:09:41 -0500
Received: from down.free-electrons.com ([37.187.137.238]:52688 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752211AbbAWRJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:09:36 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 1/5] genirq: Authorize chained handlers to remain disabled when initialized
Date: Fri, 23 Jan 2015 18:09:27 +0100
Message-Id: <1422032971-14139-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422032971-14139-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1422032971-14139-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is no way to keep a chained handler disabled when
registering it.
This might be annoying for irq demuxer that want to keep the source irq
disabled until at least one of their child irq is requested.

Replace the is_chained argument of __irq_set_handler by an enum, thus
adding a new CHAINED_NOSTARTUP mode which explicitly ask for the
interruption to remain disabled.
Update all __irq_set_handler users to use the enum value instead of a
numerical one and add a new irq_set_chained_handler_nostartup helper
function (as done for irq_set_handler and irq_set_chained_handler).

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 include/linux/irq.h    | 26 ++++++++++++++++++++++----
 kernel/irq/chip.c      | 12 +++++++-----
 kernel/irq/irqdomain.c |  2 +-
 kernel/irq/msi.c       |  3 ++-
 4 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index d09ec7a..247b2d1 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -489,25 +489,43 @@ static inline void irq_set_chip_and_handler(unsigned int irq, struct irq_chip *c
 
 extern int irq_set_percpu_devid(unsigned int irq);
 
+enum chained_mode {
+	IRQ_CHAINED_NONE,
+	IRQ_CHAINED_STARTUP,
+	IRQ_CHAINED_NOSTARTUP,
+};
+
 extern void
-__irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
+__irq_set_handler(unsigned int irq, irq_flow_handler_t handle,
+		  enum chained_mode chained_mode,
 		  const char *name);
 
 static inline void
 irq_set_handler(unsigned int irq, irq_flow_handler_t handle)
 {
-	__irq_set_handler(irq, handle, 0, NULL);
+	__irq_set_handler(irq, handle, IRQ_CHAINED_NONE, NULL);
 }
 
 /*
  * Set a highlevel chained flow handler for a given IRQ.
- * (a chained handler is automatically enabled and set to
+ * (this chained handler is automatically enabled and set to
  *  IRQ_NOREQUEST, IRQ_NOPROBE, and IRQ_NOTHREAD)
  */
 static inline void
 irq_set_chained_handler(unsigned int irq, irq_flow_handler_t handle)
 {
-	__irq_set_handler(irq, handle, 1, NULL);
+	__irq_set_handler(irq, handle, IRQ_CHAINED_STARTUP, NULL);
+}
+
+/*
+ * Set a highlevel chained flow handler for a given IRQ without starting it.
+ * (this chained handler is kept disabled and set to IRQ_NOREQUEST,
+ * IRQ_NOPROBE, and IRQ_NOTHREAD)
+ */
+static inline void
+irq_set_chained_handler_nostartup(unsigned int irq, irq_flow_handler_t handle)
+{
+	__irq_set_handler(irq, handle, IRQ_CHAINED_NOSTARTUP, NULL);
 }
 
 void irq_modify_status(unsigned int irq, unsigned long clr, unsigned long set);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 6f1c7a5..5de82dc0 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -719,7 +719,8 @@ void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc)
 }
 
 void
-__irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
+__irq_set_handler(unsigned int irq, irq_flow_handler_t handle,
+		  enum chained_mode chained_mode,
 		  const char *name)
 {
 	unsigned long flags;
@@ -748,7 +749,7 @@ __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 			 * and the interrrupt supposed to be started
 			 * right away.
 			 */
-			if (WARN_ON(is_chained))
+			if (WARN_ON(chained_mode != IRQ_CHAINED_NONE))
 				goto out;
 			/* Try the parent */
 			irq_data = irq_data->parent_data;
@@ -768,11 +769,12 @@ __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 	desc->handle_irq = handle;
 	desc->name = name;
 
-	if (handle != handle_bad_irq && is_chained) {
+	if (handle != handle_bad_irq && chained_mode != IRQ_CHAINED_NONE) {
 		irq_settings_set_noprobe(desc);
 		irq_settings_set_norequest(desc);
 		irq_settings_set_nothread(desc);
-		irq_startup(desc, true);
+		if (chained_mode == IRQ_CHAINED_STARTUP)
+			irq_startup(desc, true);
 	}
 out:
 	irq_put_desc_busunlock(desc, flags);
@@ -784,7 +786,7 @@ irq_set_chip_and_handler_name(unsigned int irq, struct irq_chip *chip,
 			      irq_flow_handler_t handle, const char *name)
 {
 	irq_set_chip(irq, chip);
-	__irq_set_handler(irq, handle, 0, name);
+	__irq_set_handler(irq, handle, IRQ_CHAINED_NONE, name);
 }
 EXPORT_SYMBOL_GPL(irq_set_chip_and_handler_name);
 
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 7fac311..d5aee6c 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -943,7 +943,7 @@ void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
 			 void *handler_data, const char *handler_name)
 {
 	irq_domain_set_hwirq_and_chip(domain, virq, hwirq, chip, chip_data);
-	__irq_set_handler(virq, handler, 0, handler_name);
+	__irq_set_handler(virq, handler, IRQ_CHAINED_NONE, handler_name);
 	irq_set_handler_data(virq, handler_data);
 }
 
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 3e18163..84b626c 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -164,7 +164,8 @@ static int msi_domain_ops_init(struct irq_domain *domain,
 	irq_domain_set_hwirq_and_chip(domain, virq, hwirq, info->chip,
 				      info->chip_data);
 	if (info->handler && info->handler_name) {
-		__irq_set_handler(virq, info->handler, 0, info->handler_name);
+		__irq_set_handler(virq, info->handler, IRQ_CHAINED_NONE,
+				  info->handler_name);
 		if (info->handler_data)
 			irq_set_handler_data(virq, info->handler_data);
 	}
-- 
1.9.1

