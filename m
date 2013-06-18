Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505Ab3FRQaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:30:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab3FRQRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:17:46 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 13/48] s390/pci: Implement IRQ functions if !PCI
Date: Tue, 18 Jun 2013 09:17:39 -0700
Message-Id: <20130618161727.767561192@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit c46b54f7406780ec4cf9c9124d1cfb777674dc70 upstream.

All architectures must implement IRQ functions.  Since various
dependencies on !S390 were removed, there are various drivers that can
be selected but will fail to link.  Provide a dummy implementation of
these functions for the !PCI case.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/irq.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++++
 arch/s390/pci/pci.c    |   33 -------------------------
 2 files changed, 64 insertions(+), 33 deletions(-)

--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -313,3 +313,67 @@ void measurement_alert_subclass_unregist
 	spin_unlock(&ma_subclass_lock);
 }
 EXPORT_SYMBOL(measurement_alert_subclass_unregister);
+
+void synchronize_irq(unsigned int irq)
+{
+	/*
+	 * Not needed, the handler is protected by a lock and IRQs that occur
+	 * after the handler is deleted are just NOPs.
+	 */
+}
+EXPORT_SYMBOL_GPL(synchronize_irq);
+
+#ifndef CONFIG_PCI
+
+/* Only PCI devices have dynamically-defined IRQ handlers */
+
+int request_irq(unsigned int irq, irq_handler_t handler,
+		unsigned long irqflags, const char *devname, void *dev_id)
+{
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(request_irq);
+
+void free_irq(unsigned int irq, void *dev_id)
+{
+	WARN_ON(1);
+}
+EXPORT_SYMBOL_GPL(free_irq);
+
+void enable_irq(unsigned int irq)
+{
+	WARN_ON(1);
+}
+EXPORT_SYMBOL_GPL(enable_irq);
+
+void disable_irq(unsigned int irq)
+{
+	WARN_ON(1);
+}
+EXPORT_SYMBOL_GPL(disable_irq);
+
+#endif /* !CONFIG_PCI */
+
+void disable_irq_nosync(unsigned int irq)
+{
+	disable_irq(irq);
+}
+EXPORT_SYMBOL_GPL(disable_irq_nosync);
+
+unsigned long probe_irq_on(void)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(probe_irq_on);
+
+int probe_irq_off(unsigned long val)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(probe_irq_off);
+
+unsigned int probe_irq_mask(unsigned long val)
+{
+	return val;
+}
+EXPORT_SYMBOL_GPL(probe_irq_mask);
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -306,15 +306,6 @@ static int zpci_cfg_store(struct zpci_de
 	return rc;
 }
 
-void synchronize_irq(unsigned int irq)
-{
-	/*
-	 * Not needed, the handler is protected by a lock and IRQs that occur
-	 * after the handler is deleted are just NOPs.
-	 */
-}
-EXPORT_SYMBOL_GPL(synchronize_irq);
-
 void enable_irq(unsigned int irq)
 {
 	struct msi_desc *msi = irq_get_msi_desc(irq);
@@ -331,30 +322,6 @@ void disable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL_GPL(disable_irq);
 
-void disable_irq_nosync(unsigned int irq)
-{
-	disable_irq(irq);
-}
-EXPORT_SYMBOL_GPL(disable_irq_nosync);
-
-unsigned long probe_irq_on(void)
-{
-	return 0;
-}
-EXPORT_SYMBOL_GPL(probe_irq_on);
-
-int probe_irq_off(unsigned long val)
-{
-	return 0;
-}
-EXPORT_SYMBOL_GPL(probe_irq_off);
-
-unsigned int probe_irq_mask(unsigned long val)
-{
-	return val;
-}
-EXPORT_SYMBOL_GPL(probe_irq_mask);
-
 void pcibios_fixup_bus(struct pci_bus *bus)
 {
 }


