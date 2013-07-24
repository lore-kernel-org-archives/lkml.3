Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab3GXDIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:08:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24545 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3GXDH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:07:58 -0400
Message-ID: <51EF44FA.4020903@oracle.com>
Date: Wed, 24 Jul 2013 11:07:38 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>
CC: bhelgaas@google.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Feng Jin <joe.jin@oracle.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
Subject: [PATCH 1/3] Refactor msi/msix restore code Part1
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move default_restore_msi_irqs down to reference some static function
msi_mask_irq and msix_mask_irq.

Tested-by: Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 drivers/pci/msi.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index aca7578..87223ae 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -96,26 +96,6 @@ void default_teardown_msi_irqs(struct pci_dev *dev)
 # define HAVE_DEFAULT_MSI_RESTORE_IRQS
 #endif
 
-#ifdef HAVE_DEFAULT_MSI_RESTORE_IRQS
-void default_restore_msi_irqs(struct pci_dev *dev, int irq)
-{
-	struct msi_desc *entry;
-
-	entry = NULL;
-	if (dev->msix_enabled) {
-		list_for_each_entry(entry, &dev->msi_list, list) {
-			if (irq == entry->irq)
-				break;
-		}
-	} else if (dev->msi_enabled)  {
-		entry = irq_get_msi_desc(irq);
-	}
-
-	if (entry)
-		write_msi_msg(irq, &entry->msg);
-}
-#endif
-
 static void msi_set_enable(struct pci_dev *dev, int enable)
 {
 	u16 control;
@@ -233,6 +213,26 @@ void unmask_msi_irq(struct irq_data *data)
 
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
+#ifdef HAVE_DEFAULT_MSI_RESTORE_IRQS
+void default_restore_msi_irqs(struct pci_dev *dev, int irq)
+{
+	struct msi_desc *entry;
+
+	entry = NULL;
+	if (dev->msix_enabled) {
+		list_for_each_entry(entry, &dev->msi_list, list) {
+			if (irq == entry->irq)
+				break;
+		}
+	} else if (dev->msi_enabled)  {
+		entry = irq_get_msi_desc(irq);
+	}
+
+	if (entry)
+		write_msi_msg(irq, &entry->msg);
+}
+#endif
+
 void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	BUG_ON(entry->dev->current_state != PCI_D0);
-- 
1.7.3

