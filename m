Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaBLCxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:53:52 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:12962 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaBLCxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:53:50 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH part1 v6 2/7] PCI: introduce pci_bus_find_ext_capability()
Date: Wed, 12 Feb 2014 10:52:48 +0800
Message-ID: <1392173573-59844-3-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1392173573-59844-1-git-send-email-wangyijing@huawei.com>
References: <1392173573-59844-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes we need to find PCI EXT CAP before
pci_dev set up. So introduce pci_bus_find_ext_capability(),
it will be used to get PCI EXT DSN before pci_dev set up.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/pci.c   |   32 ++++++++++++++++++++++++++++++++
 include/linux/pci.h |    1 +
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index a263c0a..4502e6f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -327,6 +327,38 @@ int pci_find_ext_capability(struct pci_dev *dev, int cap)
 }
 EXPORT_SYMBOL_GPL(pci_find_ext_capability);
 
+/**
+ * pci_bus_find_ext_capability - Find an extended capability
+ * @bus: the PCI bus to query
+ * @devfn: PCI device to query
+ * @cap: capability code
+ *
+ * Like pci_find_ext_capability() but works for pci devices that do not have a
+ * pci_dev structure set up yet.
+ *
+ * Returns the address of the requested capability structure within the
+ * device's PCI configuration space or 0 in case the device does not
+ * support it.
+ *
+ * */
+int pci_bus_find_ext_capability(struct pci_bus *bus, int devfn, int cap)
+{
+	int pos;
+	u32 status;
+
+	pos = pci_bus_find_capability(bus, devfn, PCI_CAP_ID_EXP);
+	if (!pos)
+		return 0;
+
+	if (pci_bus_read_config_dword(bus, devfn, PCI_CFG_SPACE_SIZE,
+			&status) !=
+			PCIBIOS_SUCCESSFUL || status == 0xffffffff)
+		return 0;
+
+	return pci_find_next_ext_capability(bus, devfn, 0, cap);
+}
+
+
 static int __pci_find_next_ht_cap(struct pci_dev *dev, int pos, int ht_cap)
 {
 	int rc, ttl = PCI_FIND_CAP_TTL;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index df495e9..470de02 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -797,6 +797,7 @@ int pci_find_capability(struct pci_dev *dev, int cap);
 int pci_find_next_capability(struct pci_dev *dev, u8 pos, int cap);
 int pci_find_ext_capability(struct pci_dev *dev, int cap);
 int pci_find_next_ext_capability(struct pci_bus *bus, int devfn, int pos, int cap);
+int pci_bus_find_ext_capability(struct pci_bus *bus, int devfn, int cap);
 int pci_find_ht_capability(struct pci_dev *dev, int ht_cap);
 int pci_find_next_ht_capability(struct pci_dev *dev, int pos, int ht_cap);
 struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
-- 
1.7.1


