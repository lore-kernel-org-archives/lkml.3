Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaBOTbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 14:31:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:47784 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbaBOTbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 14:31:22 -0500
Date: Sat, 15 Feb 2014 20:31:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT Pull] irq core for 3.14
Message-ID: <alpine.DEB.2.02.1402152026430.21991@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-core-for-linus

This patch provides a new function in the irq/devres code, which is a
prerequisite for driver developers to get rid of boilerplate code all
over the place.

Not a bugfix, but it has zero impact on the current kernel due to the
lack of users. It's simpler to provide the infrastructure to
interested parties via your tree than fulfilling the wishlist of
driver maintainers on which particular commit or tag this should be
based on.

Thanks,

	tglx

------------------>
Stephen Boyd (1):
      genirq: Add devm_request_any_context_irq()


 include/linux/interrupt.h |    5 +++++
 kernel/irq/devres.c       |   45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 0053add..a2678d3 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -158,6 +158,11 @@ devm_request_irq(struct device *dev, unsigned int irq, irq_handler_t handler,
 					 devname, dev_id);
 }
 
+extern int __must_check
+devm_request_any_context_irq(struct device *dev, unsigned int irq,
+		 irq_handler_t handler, unsigned long irqflags,
+		 const char *devname, void *dev_id);
+
 extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
 
 /*
diff --git a/kernel/irq/devres.c b/kernel/irq/devres.c
index bd8e788..1ef0606 100644
--- a/kernel/irq/devres.c
+++ b/kernel/irq/devres.c
@@ -73,6 +73,51 @@ int devm_request_threaded_irq(struct device *dev, unsigned int irq,
 EXPORT_SYMBOL(devm_request_threaded_irq);
 
 /**
+ *	devm_request_any_context_irq - allocate an interrupt line for a managed device
+ *	@dev: device to request interrupt for
+ *	@irq: Interrupt line to allocate
+ *	@handler: Function to be called when the IRQ occurs
+ *	@thread_fn: function to be called in a threaded interrupt context. NULL
+ *		    for devices which handle everything in @handler
+ *	@irqflags: Interrupt type flags
+ *	@devname: An ascii name for the claiming device
+ *	@dev_id: A cookie passed back to the handler function
+ *
+ *	Except for the extra @dev argument, this function takes the
+ *	same arguments and performs the same function as
+ *	request_any_context_irq().  IRQs requested with this function will be
+ *	automatically freed on driver detach.
+ *
+ *	If an IRQ allocated with this function needs to be freed
+ *	separately, devm_free_irq() must be used.
+ */
+int devm_request_any_context_irq(struct device *dev, unsigned int irq,
+			      irq_handler_t handler, unsigned long irqflags,
+			      const char *devname, void *dev_id)
+{
+	struct irq_devres *dr;
+	int rc;
+
+	dr = devres_alloc(devm_irq_release, sizeof(struct irq_devres),
+			  GFP_KERNEL);
+	if (!dr)
+		return -ENOMEM;
+
+	rc = request_any_context_irq(irq, handler, irqflags, devname, dev_id);
+	if (rc) {
+		devres_free(dr);
+		return rc;
+	}
+
+	dr->irq = irq;
+	dr->dev_id = dev_id;
+	devres_add(dev, dr);
+
+	return 0;
+}
+EXPORT_SYMBOL(devm_request_any_context_irq);
+
+/**
  *	devm_free_irq - free an interrupt
  *	@dev: device to free interrupt for
  *	@irq: Interrupt line to free
