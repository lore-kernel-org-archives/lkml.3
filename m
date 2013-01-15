Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab3AOHjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 02:39:12 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:39739 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab3AOHjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 02:39:10 -0500
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, tglx@linutronix.de,
        Mike Qiu <qiudayu@linux.vnet.ibm.com>
Subject: [PATCH 1/3] irq: Set multiple MSI descriptor data for multiple IRQs
Date: Tue, 15 Jan 2013 15:38:54 +0800
Message-Id: <1358235536-32741-2-git-send-email-qiudayu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com>
References: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011507-2000-0000-0000-00000A99D1D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple MSI only requires the IRQ in msi_desc entry to be set as
the value of irq_base.

This patch implements the above mentioned technique.

Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
---
 include/linux/irq.h |    2 ++
 kernel/irq/chip.c   |   40 ++++++++++++++++++++++++++++++----------
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index fdf2c4a..60ef45b 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -528,6 +528,8 @@ extern int irq_set_handler_data(unsigned int irq, void *data);
 extern int irq_set_chip_data(unsigned int irq, void *data);
 extern int irq_set_irq_type(unsigned int irq, unsigned int type);
 extern int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry);
+extern int irq_set_multiple_msi_desc(unsigned int irq_base, unsigned int nvec,
+					struct msi_desc *entry);
 extern struct irq_data *irq_get_irq_data(unsigned int irq);
 
 static inline struct irq_chip *irq_get_chip(unsigned int irq)
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 3aca9f2..c4c39d3 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -90,6 +90,35 @@ int irq_set_handler_data(unsigned int irq, void *data)
 EXPORT_SYMBOL(irq_set_handler_data);
 
 /**
+ *	irq_set_multiple_msi_desc - set Multiple MSI descriptor data
+ *	for multiple IRQs
+ *	@irq_base:	Interrupt number base
+ *	@nvec:	The number of interrupts
+ *	@entry:	Pointer to MSI descriptor data
+ *
+ *	Set IRQ descriptors for multiple MSIs
+ */
+int irq_set_multiple_msi_desc(unsigned int irq_base, unsigned int nvec,
+				struct msi_desc *entry)
+{
+	unsigned long flags, i;
+	struct irq_desc *desc;
+
+	for (i = 0; i < nvec; i++) {
+		desc = irq_get_desc_lock(irq_base + i, &flags,
+					IRQ_GET_DESC_CHECK_GLOBAL);
+		if (!desc)
+			return -EINVAL;
+		desc->irq_data.msi_desc = entry;
+		if (i == 0 && entry)
+			entry->irq = irq_base;
+		irq_put_desc_unlock(desc, flags);
+	}
+
+	return 0;
+}
+
+/**
  *	irq_set_msi_desc - set MSI descriptor data for an irq
  *	@irq:	Interrupt number
  *	@entry:	Pointer to MSI descriptor data
@@ -98,16 +127,7 @@ EXPORT_SYMBOL(irq_set_handler_data);
  */
 int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry)
 {
-	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
-
-	if (!desc)
-		return -EINVAL;
-	desc->irq_data.msi_desc = entry;
-	if (entry)
-		entry->irq = irq;
-	irq_put_desc_unlock(desc, flags);
-	return 0;
+	return irq_set_multiple_msi_desc(irq, 1, entry);
 }
 
 /**
-- 
1.7.7.6

