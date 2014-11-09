Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaKIPKx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 10:10:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:62496 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbaKIPKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 10:10:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,346,1413270000"; 
   d="scan'208";a="604933522"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, x86@kernel.org,
        Mike Marciniszyn <infinipath@intel.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rdma@vger.kernel.org
Subject: [RFC Part4 v1 16/17] x86, htirq: Kill struct ht_irq_msg by reusing struct msi_msg
Date: Sun,  9 Nov 2014 23:10:38 +0800
Message-Id: <1415545839-28263-17-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reuse struct msi_msg for HT interrupts, so we could use common MSI code
to manage HT interrupts later.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/htirq.c                |    6 +++---
 drivers/infiniband/hw/ipath/ipath_iba6110.c |    2 +-
 drivers/pci/htirq.c                         |    8 ++++----
 include/linux/htirq.h                       |   14 +++++---------
 4 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/apic/htirq.c b/arch/x86/kernel/apic/htirq.c
index 1448df3f9e9f..b6503510f1af 100644
--- a/arch/x86/kernel/apic/htirq.c
+++ b/arch/x86/kernel/apic/htirq.c
@@ -34,7 +34,7 @@ ht_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
 	if (ret >= 0) {
-		struct ht_irq_msg msg;
+		struct msi_msg msg;
 		struct irq_cfg *cfg = irqd_cfg(data);
 
 		fetch_ht_irq_msg(data->irq, &msg);
@@ -115,7 +115,7 @@ static void htirq_domain_free(struct irq_domain *domain, unsigned int virq,
 static void htirq_domain_activate(struct irq_domain *domain,
 				  struct irq_data *irq_data)
 {
-	struct ht_irq_msg msg;
+	struct msi_msg msg;
 	struct irq_cfg *cfg = irqd_cfg(irq_data);
 
 	msg.address_hi = HT_IRQ_HIGH_DEST_ID(cfg->dest_apicid);
@@ -137,7 +137,7 @@ static void htirq_domain_activate(struct irq_domain *domain,
 static void htirq_domain_deactivate(struct irq_domain *domain,
 				    struct irq_data *irq_data)
 {
-	struct ht_irq_msg msg;
+	struct msi_msg msg;
 
 	memset(&msg, 0, sizeof(msg));
 	write_ht_irq_msg(irq_data->irq, &msg);
diff --git a/drivers/infiniband/hw/ipath/ipath_iba6110.c b/drivers/infiniband/hw/ipath/ipath_iba6110.c
index 7cc305488a3d..b49ce8942b57 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba6110.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba6110.c
@@ -986,7 +986,7 @@ static int ipath_ht_intconfig(struct ipath_devdata *dd)
 }
 
 static void ipath_ht_irq_update(struct pci_dev *dev, int irq,
-				struct ht_irq_msg *msg)
+				struct msi_msg *msg)
 {
 	struct ipath_devdata *dd = pci_get_drvdata(dev);
 	u64 prev_intconfig = dd->ipath_intconfig;
diff --git a/drivers/pci/htirq.c b/drivers/pci/htirq.c
index 7eb4109a3df4..3bbbc5cdcb9b 100644
--- a/drivers/pci/htirq.c
+++ b/drivers/pci/htirq.c
@@ -23,7 +23,7 @@
  */
 static DEFINE_SPINLOCK(ht_irq_lock);
 
-void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
+void write_ht_irq_msg(unsigned int irq, struct msi_msg *msg)
 {
 	struct ht_irq_cfg *cfg = irq_get_handler_data(irq);
 	unsigned long flags;
@@ -43,7 +43,7 @@ void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
 	cfg->msg = *msg;
 }
 
-void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
+void fetch_ht_irq_msg(unsigned int irq, struct msi_msg *msg)
 {
 	struct ht_irq_cfg *cfg = irq_get_handler_data(irq);
 
@@ -53,7 +53,7 @@ void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
 void mask_ht_irq(struct irq_data *data)
 {
 	struct ht_irq_cfg *cfg = irq_data_get_irq_handler_data(data);
-	struct ht_irq_msg msg = cfg->msg;
+	struct msi_msg msg = cfg->msg;
 
 	msg.address_lo |= 1;
 	write_ht_irq_msg(data->irq, &msg);
@@ -62,7 +62,7 @@ void mask_ht_irq(struct irq_data *data)
 void unmask_ht_irq(struct irq_data *data)
 {
 	struct ht_irq_cfg *cfg = irq_data_get_irq_handler_data(data);
-	struct ht_irq_msg msg = cfg->msg;
+	struct msi_msg msg = cfg->msg;
 
 	msg.address_lo &= ~1;
 	write_ht_irq_msg(data->irq, &msg);
diff --git a/include/linux/htirq.h b/include/linux/htirq.h
index d4a527e58434..98e432f7f9b1 100644
--- a/include/linux/htirq.h
+++ b/include/linux/htirq.h
@@ -1,16 +1,12 @@
 #ifndef LINUX_HTIRQ_H
 #define LINUX_HTIRQ_H
+#include <linux/msi.h>
 
 struct pci_dev;
 struct irq_data;
 
-struct ht_irq_msg {
-	u32	address_lo;	/* low 32 bits of the ht irq message */
-	u32	address_hi;	/* high 32 bits of the it irq message */
-};
-
 typedef void (ht_irq_update_t)(struct pci_dev *dev, int irq,
-			       struct ht_irq_msg *msg);
+			       struct msi_msg *msg);
 
 struct ht_irq_cfg {
 	struct pci_dev *dev;
@@ -18,12 +14,12 @@ struct ht_irq_cfg {
 	ht_irq_update_t *update;
 	unsigned pos;
 	unsigned idx;
-	struct ht_irq_msg msg;
+	struct msi_msg msg;
 };
 
 /* Helper functions.. */
-void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
-void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
+void fetch_ht_irq_msg(unsigned int irq, struct msi_msg *msg);
+void write_ht_irq_msg(unsigned int irq, struct msi_msg *msg);
 void mask_ht_irq(struct irq_data *data);
 void unmask_ht_irq(struct irq_data *data);
 
-- 
1.7.10.4

