Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab3GWHhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:37:07 -0400
Received: from intranet.asianux.com ([58.214.24.6]:25430 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3GWHhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:37:05 -0400
X-Spam-Score: -100.8
Message-ID: <51EE3264.7010801@asianux.com>
Date: Tue, 23 Jul 2013 15:36:04 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/irq/devres.c: move "kernel/irq/devres.c" to "drivers/base/devres_irq.c"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"kernel/irq/devres.c" is a driver extension tool for irq (with devres)
which is independent on 'GENERIC_HARDIRQS', so it is not suitable to
still be in "kernel/irq/" which depends on 'GENERIC_HARDIRQS'.

It is a basic tool for drivers, so can move it to "drivers/base/" to be
independent on 'GENERIC_HARDIRQS'.

It is about irq features, so if can not find other more suitable place,
can still let their declaration in "include/linux/interrupts.h".

The related error (with randconfig which disable 'GENERIC_HARDIRQS')

  drivers/built-in.o: In function `dw_dma_probe':
  (.text+0x3747a): undefined reference to `devm_request_threaded_irq'


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/base/Makefile     |    2 +-
 drivers/base/devres_irq.c |   94 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/irq/Makefile       |    2 +-
 kernel/irq/devres.c       |   94 ---------------------------------------------
 4 files changed, 96 insertions(+), 96 deletions(-)
 create mode 100644 drivers/base/devres_irq.c
 delete mode 100644 kernel/irq/devres.c

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 94e8a80..cb706f9 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -2,7 +2,7 @@
 
 obj-y			:= core.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
-			   cpu.o firmware.o init.o map.o devres.o \
+			   cpu.o firmware.o init.o map.o devres.o devres_irq.o \
 			   attribute_container.o transport_class.o \
 			   topology.o
 obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
diff --git a/drivers/base/devres_irq.c b/drivers/base/devres_irq.c
new file mode 100644
index 0000000..bd8e788
--- /dev/null
+++ b/drivers/base/devres_irq.c
@@ -0,0 +1,94 @@
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/gfp.h>
+
+/*
+ * Device resource management aware IRQ request/free implementation.
+ */
+struct irq_devres {
+	unsigned int irq;
+	void *dev_id;
+};
+
+static void devm_irq_release(struct device *dev, void *res)
+{
+	struct irq_devres *this = res;
+
+	free_irq(this->irq, this->dev_id);
+}
+
+static int devm_irq_match(struct device *dev, void *res, void *data)
+{
+	struct irq_devres *this = res, *match = data;
+
+	return this->irq == match->irq && this->dev_id == match->dev_id;
+}
+
+/**
+ *	devm_request_threaded_irq - allocate an interrupt line for a managed device
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
+ *	request_irq().  IRQs requested with this function will be
+ *	automatically freed on driver detach.
+ *
+ *	If an IRQ allocated with this function needs to be freed
+ *	separately, devm_free_irq() must be used.
+ */
+int devm_request_threaded_irq(struct device *dev, unsigned int irq,
+			      irq_handler_t handler, irq_handler_t thread_fn,
+			      unsigned long irqflags, const char *devname,
+			      void *dev_id)
+{
+	struct irq_devres *dr;
+	int rc;
+
+	dr = devres_alloc(devm_irq_release, sizeof(struct irq_devres),
+			  GFP_KERNEL);
+	if (!dr)
+		return -ENOMEM;
+
+	rc = request_threaded_irq(irq, handler, thread_fn, irqflags, devname,
+				  dev_id);
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
+EXPORT_SYMBOL(devm_request_threaded_irq);
+
+/**
+ *	devm_free_irq - free an interrupt
+ *	@dev: device to free interrupt for
+ *	@irq: Interrupt line to free
+ *	@dev_id: Device identity to free
+ *
+ *	Except for the extra @dev argument, this function takes the
+ *	same arguments and performs the same function as free_irq().
+ *	This function instead of free_irq() should be used to manually
+ *	free IRQs allocated with devm_request_irq().
+ */
+void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id)
+{
+	struct irq_devres match_data = { irq, dev_id };
+
+	WARN_ON(devres_destroy(dev, devm_irq_release, devm_irq_match,
+			       &match_data));
+	free_irq(irq, dev_id);
+}
+EXPORT_SYMBOL(devm_free_irq);
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index fff1738..d98eec9 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -1,5 +1,5 @@
 
-obj-y := irqdesc.o handle.o manage.o spurious.o resend.o chip.o dummychip.o devres.o
+obj-y := irqdesc.o handle.o manage.o spurious.o resend.o chip.o dummychip.o
 obj-$(CONFIG_GENERIC_IRQ_CHIP) += generic-chip.o
 obj-$(CONFIG_GENERIC_IRQ_PROBE) += autoprobe.o
 obj-$(CONFIG_IRQ_DOMAIN) += irqdomain.o
diff --git a/kernel/irq/devres.c b/kernel/irq/devres.c
deleted file mode 100644
index bd8e788..0000000
--- a/kernel/irq/devres.c
+++ /dev/null
@@ -1,94 +0,0 @@
-#include <linux/module.h>
-#include <linux/interrupt.h>
-#include <linux/device.h>
-#include <linux/gfp.h>
-
-/*
- * Device resource management aware IRQ request/free implementation.
- */
-struct irq_devres {
-	unsigned int irq;
-	void *dev_id;
-};
-
-static void devm_irq_release(struct device *dev, void *res)
-{
-	struct irq_devres *this = res;
-
-	free_irq(this->irq, this->dev_id);
-}
-
-static int devm_irq_match(struct device *dev, void *res, void *data)
-{
-	struct irq_devres *this = res, *match = data;
-
-	return this->irq == match->irq && this->dev_id == match->dev_id;
-}
-
-/**
- *	devm_request_threaded_irq - allocate an interrupt line for a managed device
- *	@dev: device to request interrupt for
- *	@irq: Interrupt line to allocate
- *	@handler: Function to be called when the IRQ occurs
- *	@thread_fn: function to be called in a threaded interrupt context. NULL
- *		    for devices which handle everything in @handler
- *	@irqflags: Interrupt type flags
- *	@devname: An ascii name for the claiming device
- *	@dev_id: A cookie passed back to the handler function
- *
- *	Except for the extra @dev argument, this function takes the
- *	same arguments and performs the same function as
- *	request_irq().  IRQs requested with this function will be
- *	automatically freed on driver detach.
- *
- *	If an IRQ allocated with this function needs to be freed
- *	separately, devm_free_irq() must be used.
- */
-int devm_request_threaded_irq(struct device *dev, unsigned int irq,
-			      irq_handler_t handler, irq_handler_t thread_fn,
-			      unsigned long irqflags, const char *devname,
-			      void *dev_id)
-{
-	struct irq_devres *dr;
-	int rc;
-
-	dr = devres_alloc(devm_irq_release, sizeof(struct irq_devres),
-			  GFP_KERNEL);
-	if (!dr)
-		return -ENOMEM;
-
-	rc = request_threaded_irq(irq, handler, thread_fn, irqflags, devname,
-				  dev_id);
-	if (rc) {
-		devres_free(dr);
-		return rc;
-	}
-
-	dr->irq = irq;
-	dr->dev_id = dev_id;
-	devres_add(dev, dr);
-
-	return 0;
-}
-EXPORT_SYMBOL(devm_request_threaded_irq);
-
-/**
- *	devm_free_irq - free an interrupt
- *	@dev: device to free interrupt for
- *	@irq: Interrupt line to free
- *	@dev_id: Device identity to free
- *
- *	Except for the extra @dev argument, this function takes the
- *	same arguments and performs the same function as free_irq().
- *	This function instead of free_irq() should be used to manually
- *	free IRQs allocated with devm_request_irq().
- */
-void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id)
-{
-	struct irq_devres match_data = { irq, dev_id };
-
-	WARN_ON(devres_destroy(dev, devm_irq_release, devm_irq_match,
-			       &match_data));
-	free_irq(irq, dev_id);
-}
-EXPORT_SYMBOL(devm_free_irq);
-- 
1.7.7.6
