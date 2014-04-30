Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbaD3QLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:11:12 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:56442 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaD3QLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:11:10 -0400
From: Levente Kurusa <levex@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux ATA/IDE <linux-ide@vger.kernel.org>,
        Joe Thomas <Joe.Thomas@dothill.com>, Levente Kurusa <levex@linux.com>
Subject: [PATCH] ahci: unregister acpi notify handler when a ZPODD is unbound
Date: Wed, 30 Apr 2014 18:04:47 +0200
Message-Id: <1398873887-23920-1-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a ZPODD device is unbound via sysfs, the acpi notify handler
is not removed. This causes panics as observed in Bug #74601. The
panic only happens when the wake happens from outside the kernel
(i.e. inserting media or pressing a button). Implement a new
ahci_remove_one function which causes zpodd_exit to be called for all
ZPODD devices on the unbound PCI device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---

Hi,

I am not sure if the loop below is correct. Maybe there is a better
solution to loop through all the devices which might use ZPODD?

Thanks, Lev.

 drivers/ata/ahci.c         | 21 +++++++++++++++++++++
 drivers/ata/ahci.h         |  4 ++++
 drivers/ata/libata-zpodd.c |  1 +
 3 files changed, 26 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 5a0bf8e..6d92bc9 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -475,12 +475,33 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ }	/* terminate list */
 };
 
+#ifdef CONFIG_SATA_ZPODD
+void ahci_remove_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = pci_get_drvdata(pdev);
+	struct ata_link *link;
+	struct ata_device *dev;
+	int i;
+
+	for (i = 0; i < host->n_ports; i++)
+		ata_for_each_link(link, host->ports[i], HOST_FIRST)
+			ata_for_each_dev(dev, link, ALL)
+				if (dev->zpodd)
+					zpodd_exit(dev);
+
+	ata_pci_remove_one(pdev);
+}
+#endif
 
 static struct pci_driver ahci_pci_driver = {
 	.name			= DRV_NAME,
 	.id_table		= ahci_pci_tbl,
 	.probe			= ahci_init_one,
+#ifdef CONFIG_SATA_ZPODD
+	.remove			= ahci_remove_one,
+#else
 	.remove			= ata_pci_remove_one,
+#endif
 #ifdef CONFIG_PM
 	.suspend		= ahci_pci_device_suspend,
 	.resume			= ahci_pci_device_resume,
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 51af275..87e4e6d 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -383,6 +383,10 @@ void ahci_print_info(struct ata_host *host, const char *scc_s);
 int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis);
 void ahci_error_handler(struct ata_port *ap);
 
+#ifdef CONFIG_SATA_ZPODD
+extern void zpodd_exit(struct ata_device *dev);
+#endif /* CONFIG_SATA_ZPODD */
+
 static inline void __iomem *__ahci_port_base(struct ata_host *host,
 					     unsigned int port_no)
 {
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index f3a65a3..fe66949 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -281,3 +281,4 @@ void zpodd_exit(struct ata_device *dev)
 	kfree(dev->zpodd);
 	dev->zpodd = NULL;
 }
+EXPORT_SYMBOL_GPL(zpodd_exit);
-- 
1.8.3.1

