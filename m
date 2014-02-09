Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaBIOaq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 09:30:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50482 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaBIOao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 09:30:44 -0500
Date: Sun, 9 Feb 2014 06:30:29 -0800
From: tip-bot for Stephen Boyd <tipbot@zytor.com>
Message-ID: <tip-0668d3065128d39449c097e62dbdb5707820137d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dmitry.torokhov@gmail.com, tglx@linutronix.de, sboyd@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, tglx@linutronix.de, sboyd@codeaurora.org
In-Reply-To: <1388709460-19222-3-git-send-email-sboyd@codeaurora.org>
References: <1388709460-19222-3-git-send-email-sboyd@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Add devm_request_any_context_irq()
Git-Commit-ID: 0668d3065128d39449c097e62dbdb5707820137d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 09 Feb 2014 06:30:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0668d3065128d39449c097e62dbdb5707820137d
Gitweb:     http://git.kernel.org/tip/0668d3065128d39449c097e62dbdb5707820137d
Author:     Stephen Boyd <sboyd@codeaurora.org>
AuthorDate: Thu, 2 Jan 2014 16:37:32 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 9 Feb 2014 15:27:21 +0100

genirq: Add devm_request_any_context_irq()

Some drivers use request_any_context_irq() but there isn't a
devm_* function for it. Add one so that these drivers don't need
to explicitly free the irq on driver detach.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: http://lkml.kernel.org/r/1388709460-19222-3-git-send-email-sboyd@codeaurora.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |  5 +++++
 kernel/irq/devres.c       | 45 +++++++++++++++++++++++++++++++++++++++++++++
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
