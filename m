Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaBJEGO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 23:06:14 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:8503 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaBJEFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 23:05:06 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH part1 v5 5/7] PCI: Add pci_dummy_ops to isolate pci device temporarily
Date: Mon, 10 Feb 2014 12:04:09 +0800
Message-ID: <1392005051-54508-6-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1392005051-54508-1-git-send-email-wangyijing@huawei.com>
References: <1392005051-54508-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pci_dummy_ops does nothing when we use it to read/write
pci_device. So we can isolate pci device by replace its
bus pci_ops by pci_dummy_ops. This is preparation for
the later patch.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/pci.c   |   54 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    3 ++
 2 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8f31ab3..bbef95e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2225,6 +2225,60 @@ bool pci_serial_number_changed(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(pci_serial_number_changed);
 
+static int pci_dummy_read(struct pci_bus *bus, unsigned int devfn, 
+		int where, int size, u32 *val)
+{
+	return PCIBIOS_DEVICE_NOT_FOUND;
+}
+
+static int pci_dummy_write(struct pci_bus *bus, unsigned int devfn,
+		int reg, int size, u32 val)
+{
+	return PCIBIOS_DEVICE_NOT_FOUND;
+}
+
+static struct pci_ops pci_dummy_ops = {
+	.read = pci_dummy_read,
+	.write = pci_dummy_write,
+};
+
+static DEFINE_SPINLOCK(pci_freeze_lock);
+/**
+ * pci_bus_freeze_device - freeze pci bus to access pci device
+ * @bus: the pci bus to freeze
+ *
+ * Replace pci bus ops by pci_dummy_ops, protect system from
+ * accessing pci devices.
+ */
+void pci_bus_freeze_device(struct pci_bus *bus)
+{
+	struct pci_ops *ops;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pci_freeze_lock, flags);
+	ops = pci_bus_set_ops(bus, &pci_dummy_ops);
+	bus->save_ops = ops;
+	spin_unlock_irqrestore(&pci_freeze_lock, flags);
+}
+
+/**
+ * pci_bus_unfreeze_device - unfreeze pci bus to acess pci devices
+ * @bus: the pci bus to unfreeze
+ *
+ * Restore pci bus original ops, so pci bus can access
+ * pci devices normally.
+ */
+void pci_bus_unfreeze_device(struct pci_bus *bus)
+{
+	unsigned long flags;
+
+	BUG_ON(!bus->save_ops);
+	spin_lock_irqsave(&pci_freeze_lock, flags);
+	pci_bus_set_ops(bus, bus->save_ops);
+	bus->save_ops = NULL;
+	spin_unlock_irqrestore(&pci_freeze_lock, flags);
+}
+
 /**
  * pci_configure_ari - enable or disable ARI forwarding
  * @dev: the PCI device
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d60c0b6..74dd968 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -442,6 +442,7 @@ struct pci_bus {
 	struct resource busn_res;	/* bus numbers routed to this bus */
 
 	struct pci_ops	*ops;		/* configuration access functions */
+	struct pci_ops	*save_ops;		/* save configuration access functions */
 	struct msi_chip	*msi;		/* MSI controller */
 	void		*sysdata;	/* hook for sys-specific extension */
 	struct proc_dir_entry *procdir;	/* directory entry in /proc/bus/pci */
@@ -1026,6 +1027,8 @@ ssize_t pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
 ssize_t pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void *buf);
 
 bool pci_serial_number_changed(struct pci_dev *pdev);
+void pci_bus_freeze_device(struct pci_bus *bus);
+void pci_bus_unfreeze_device(struct pci_bus *bus);
 
 /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
 resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx);
-- 
1.7.1


