Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab3EMQJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 12:09:05 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:50090 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab3EMQJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 12:09:01 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>
Subject: [PATCH v2, part 1 2/9] PCI: Introduce pci_alloc_dev(struct pci_bus*) to replace alloc_pci_dev()
Date: Tue, 14 May 2013 00:08:26 +0800
Message-Id: <1368461313-4371-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368461313-4371-1-git-send-email-jiang.liu@huawei.com>
References: <1368461313-4371-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gu Zheng <guz.fnst@cn.fujitsu.com>

<marker to prevent gmail from removing below "From:">
From: Gu Zheng <guz.fnst@cn.fujitsu.com>

Now here we introduce a new interface to replace alloc_pci_dev():
	struct pci_dev *pci_alloc_dev(struct pci_bus *bus)

It take a "struct pci_bus *" argument, so we can alloc a pci device
on a target pci bus, and it acquire the reference of the pci_bus.
We use pci_alloc_dev(NULL) to simplify the old alloc_pci_dev(),
and keep it for a while but mark it as __deprecated.

Jiang Liu <jiang.liu@huawei.com>
Minor code tweaks and change
__deprecated struct pci_dev * alloc_pci_dev(void);
to
struct pci_dev * __deprecated alloc_pci_dev(void);

This enhancement makes it safe to reference pci_dev->bus when holding
a reference on a pci_dev.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/probe.c | 16 +++++++++++-----
 include/linux/pci.h |  3 ++-
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 43ece5d..4f0bc0a 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1201,18 +1201,24 @@ static void pci_release_bus_bridge_dev(struct device *dev)
 	kfree(bridge);
 }
 
-struct pci_dev *alloc_pci_dev(void)
+struct pci_dev *pci_alloc_dev(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
 
 	dev = kzalloc(sizeof(struct pci_dev), GFP_KERNEL);
-	if (!dev)
-		return NULL;
-
-	INIT_LIST_HEAD(&dev->bus_list);
+	if (dev) {
+		INIT_LIST_HEAD(&dev->bus_list);
+		dev->bus = pci_bus_get(bus);
+	}
 
 	return dev;
 }
+EXPORT_SYMBOL(pci_alloc_dev);
+
+struct pci_dev *alloc_pci_dev(void)
+{
+	return pci_alloc_dev(NULL);
+}
 EXPORT_SYMBOL(alloc_pci_dev);
 
 bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *l,
diff --git a/include/linux/pci.h b/include/linux/pci.h
index f5e13f0..68beb11 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -364,7 +364,8 @@ static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
 	return dev;
 }
 
-struct pci_dev *alloc_pci_dev(void);
+struct pci_dev *pci_alloc_dev(struct pci_bus *bus);
+struct pci_dev * __deprecated alloc_pci_dev(void);
 
 #define	to_pci_dev(n) container_of(n, struct pci_dev, dev)
 #define for_each_pci_dev(d) while ((d = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, d)) != NULL)
-- 
1.8.1.2

