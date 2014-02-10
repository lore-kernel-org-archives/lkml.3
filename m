Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaBJEHG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 23:07:06 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:8339 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaBJEFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 23:05:00 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH part1 v5 1/7] PCI: rework pci_find_next_ext_capability()
Date: Mon, 10 Feb 2014 12:04:05 +0800
Message-ID: <1392005051-54508-2-git-send-email-wangyijing@huawei.com>
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

Rework pci_find_next_ext_capability(), use
pci_bus_read_config_xxx() instead of
pci_read_config_xxx(). So we can use this
function before pci_dev setup.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/pci.c   |   17 +++++++++--------
 include/linux/pci.h |    2 +-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 1febe90..a263c0a 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -256,7 +256,8 @@ int pci_bus_find_capability(struct pci_bus *bus, unsigned int devfn, int cap)
 
 /**
  * pci_find_next_ext_capability - Find an extended capability
- * @dev: PCI device to query
+ * @bus: the PCI bus to query
+ * @devfn: PCI device to query
  * @start: address at which to start looking (0 to start at beginning of list)
  * @cap: capability code
  *
@@ -265,7 +266,7 @@ int pci_bus_find_capability(struct pci_bus *bus, unsigned int devfn, int cap)
  * not support it.  Some capabilities can occur several times, e.g., the
  * vendor-specific capability, and this provides a way to find them all.
  */
-int pci_find_next_ext_capability(struct pci_dev *dev, int start, int cap)
+int pci_find_next_ext_capability(struct pci_bus *bus, int devfn, int start, int cap)
 {
 	u32 header;
 	int ttl;
@@ -274,13 +275,10 @@ int pci_find_next_ext_capability(struct pci_dev *dev, int start, int cap)
 	/* minimum 8 bytes per capability */
 	ttl = (PCI_CFG_SPACE_EXP_SIZE - PCI_CFG_SPACE_SIZE) / 8;
 
-	if (dev->cfg_size <= PCI_CFG_SPACE_SIZE)
-		return 0;
-
 	if (start)
 		pos = start;
 
-	if (pci_read_config_dword(dev, pos, &header) != PCIBIOS_SUCCESSFUL)
+	if (pci_bus_read_config_dword(bus, devfn, pos, &header) != PCIBIOS_SUCCESSFUL)
 		return 0;
 
 	/*
@@ -298,7 +296,7 @@ int pci_find_next_ext_capability(struct pci_dev *dev, int start, int cap)
 		if (pos < PCI_CFG_SPACE_SIZE)
 			break;
 
-		if (pci_read_config_dword(dev, pos, &header) != PCIBIOS_SUCCESSFUL)
+		if (pci_bus_read_config_dword(bus, devfn, pos, &header) != PCIBIOS_SUCCESSFUL)
 			break;
 	}
 
@@ -322,7 +320,10 @@ EXPORT_SYMBOL_GPL(pci_find_next_ext_capability);
  */
 int pci_find_ext_capability(struct pci_dev *dev, int cap)
 {
-	return pci_find_next_ext_capability(dev, 0, cap);
+	if (dev->cfg_size <= PCI_CFG_SPACE_SIZE)
+		return 0;
+
+	return pci_find_next_ext_capability(dev->bus, dev->devfn, 0, cap);
 }
 EXPORT_SYMBOL_GPL(pci_find_ext_capability);
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index fb57c89..df495e9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -796,7 +796,7 @@ enum pci_lost_interrupt_reason pci_lost_interrupt(struct pci_dev *dev);
 int pci_find_capability(struct pci_dev *dev, int cap);
 int pci_find_next_capability(struct pci_dev *dev, u8 pos, int cap);
 int pci_find_ext_capability(struct pci_dev *dev, int cap);
-int pci_find_next_ext_capability(struct pci_dev *dev, int pos, int cap);
+int pci_find_next_ext_capability(struct pci_bus *bus, int devfn, int pos, int cap);
 int pci_find_ht_capability(struct pci_dev *dev, int ht_cap);
 int pci_find_next_ht_capability(struct pci_dev *dev, int pos, int ht_cap);
 struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
-- 
1.7.1


