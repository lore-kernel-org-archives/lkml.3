Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaCLPHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:07:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52023 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbaCLPHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:07:00 -0400
Date: Wed, 12 Mar 2014 08:06:31 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-c1bacbae8192dd2a9ebadd22d793b68054f6c6e5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, jjhiblot@traphandler.com, tglx@linutronix.de,
        linus.walleij@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, jjhiblot@traphandler.com,
        tglx@linutronix.de, linus.walleij@linaro.org
In-Reply-To: <alpine.DEB.2.02.1403080857160.18573@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1403080857160.18573@ionos.tec.linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide irq_request/
 release_resources chip callbacks
Git-Commit-ID: c1bacbae8192dd2a9ebadd22d793b68054f6c6e5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1bacbae8192dd2a9ebadd22d793b68054f6c6e5
Gitweb:     http://git.kernel.org/tip/c1bacbae8192dd2a9ebadd22d793b68054f6c6e5
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 8 Mar 2014 08:59:58 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 12 Mar 2014 16:00:24 +0100

genirq: Provide irq_request/release_resources chip callbacks

For certain irq types, e.g. gpios, it's necessary to request resources
before starting up the irq.

This might fail so we cannot use the irq_startup() callback because we
might call the irq_set_type() callback before that which does not make
sense when the resource is not available. Calling irq_startup() before
irq_set_type() can lead to spurious interrupts which is not desired
either.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org 
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1403080857160.18573@ionos.tec.linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |  6 ++++++
 kernel/irq/manage.c | 28 +++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7dc1003..e675971 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -303,6 +303,10 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  * @irq_pm_shutdown:	function called from core code on shutdown once per chip
  * @irq_calc_mask:	Optional function to set irq_data.mask for special cases
  * @irq_print_chip:	optional to print special chip info in show_interrupts
+ * @irq_request_resources:	optional to request resources before calling
+ *				any other callback related to this irq
+ * @irq_release_resources:	optional to release resources acquired with
+ *				irq_request_resources
  * @flags:		chip specific flags
  */
 struct irq_chip {
@@ -336,6 +340,8 @@ struct irq_chip {
 	void		(*irq_calc_mask)(struct irq_data *data);
 
 	void		(*irq_print_chip)(struct irq_data *data, struct seq_file *p);
+	int		(*irq_request_resources)(struct irq_data *data);
+	void		(*irq_release_resources)(struct irq_data *data);
 
 	unsigned long	flags;
 };
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index d3bf660..5d35cbe 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -896,6 +896,23 @@ static void irq_setup_forced_threading(struct irqaction *new)
 	}
 }
 
+static int irq_request_resources(struct irq_desc *desc)
+{
+	struct irq_data *d = &desc->irq_data;
+	struct irq_chip *c = d->chip;
+
+	return c->irq_request_resources ? c->irq_request_resources(d) : 0;
+}
+
+static void irq_release_resources(struct irq_desc *desc)
+{
+	struct irq_data *d = &desc->irq_data;
+	struct irq_chip *c = d->chip;
+
+	if (c->irq_release_resources)
+		c->irq_release_resources(d);
+}
+
 /*
  * Internal function to register an irqaction - typically used to
  * allocate special interrupts that are part of the architecture.
@@ -1091,6 +1108,13 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	}
 
 	if (!shared) {
+		ret = irq_request_resources(desc);
+		if (ret) {
+			pr_err("Failed to request resources for %s (irq %d) on irqchip %s\n",
+			       new->name, irq, desc->irq_data.chip->name);
+			goto out_mask;
+		}
+
 		init_waitqueue_head(&desc->wait_for_threads);
 
 		/* Setup the type (level, edge polarity) if configured: */
@@ -1261,8 +1285,10 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	*action_ptr = action->next;
 
 	/* If this was the last handler, shut down the IRQ line: */
-	if (!desc->action)
+	if (!desc->action) {
 		irq_shutdown(desc);
+		irq_release_resources(desc);
+	}
 
 #ifdef CONFIG_SMP
 	/* make sure affinity_hint is cleaned up */
