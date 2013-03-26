Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900Ab3CZCoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 22:44:44 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:12613 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933861Ab3CZCom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 22:44:42 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Tony Luck <tony.luck@intel.com>
CC: <linux-kernel@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>
Subject: [PATCH v5 1/5] PCI/AER: Fix pci_ops return NULL in pci_read/write_aer
Date: Tue, 26 Mar 2013 10:43:35 +0800
Message-ID: <1364265819-6732-2-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1364265819-6732-1-git-send-email-wangyijing@huawei.com>
References: <1364265819-6732-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we injected aer errors to the pcie device by aer_inject module, pci_ops of the pci
bus the device on will be assigned to pci_ops_aer.So if the target pci device
is a bridge, once we hot-remove and hot-add the bridge, the newly created child bus's pci_ops
will be assigned to pci_ops_aer too.Now every access to the child bus's device will cause the
system panic, because it will get a NULL pci_ops in pci_read_aer/pci_write_aer.

Reviewed-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Reviewed-by: Sven Dietrich <Sven.Dietrich@huawei.com>
---
 drivers/pci/pcie/aer/aer_inject.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
index 4e24cb8..fdab3bb 100644
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -109,6 +109,26 @@ static struct aer_error *__find_aer_error_by_dev(struct pci_dev *dev)
 	return __find_aer_error((u16)domain, dev->bus->number, dev->devfn);
 }
 
+/* find pci_ops of the nearest parent bus */
+static struct pci_ops *__find_pci_bus_ops_parent(struct pci_bus *bus)
+{
+	struct pci_bus_ops *bus_ops;
+	struct pci_bus *pbus = bus->parent;
+
+	if (!pbus)
+		return NULL;
+
+	while (pbus) {
+		list_for_each_entry(bus_ops, &pci_bus_ops_list, list)
+			if (bus_ops->bus == pbus)
+				return bus_ops->ops;
+
+		pbus = pbus->parent;
+	}
+
+	return NULL;
+}
+
 /* inject_lock must be held before calling */
 static struct pci_ops *__find_pci_bus_ops(struct pci_bus *bus)
 {
@@ -118,7 +138,9 @@ static struct pci_ops *__find_pci_bus_ops(struct pci_bus *bus)
 		if (bus_ops->bus == bus)
 			return bus_ops->ops;
 	}
-	return NULL;
+
+	/* can't find bus_ops, fall back to get bus_ops of parent bus */
+	return __find_pci_bus_ops_parent(bus);
 }
 
 static struct pci_bus_ops *pci_bus_ops_pop(void)
@@ -208,6 +230,7 @@ static int pci_read_aer(struct pci_bus *bus, unsigned int devfn, int where,
 	}
 out:
 	ops = __find_pci_bus_ops(bus);
+	BUG_ON(!ops);
 	spin_unlock_irqrestore(&inject_lock, flags);
 	return ops->read(bus, devfn, where, size, val);
 }
@@ -243,6 +266,7 @@ int pci_write_aer(struct pci_bus *bus, unsigned int devfn, int where, int size,
 	}
 out:
 	ops = __find_pci_bus_ops(bus);
+	BUG_ON(!ops);
 	spin_unlock_irqrestore(&inject_lock, flags);
 	return ops->write(bus, devfn, where, size, val);
 }
-- 
1.7.1


