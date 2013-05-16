Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3EPPvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:51:35 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:49197 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab3EPPvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:51:31 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2, part3 04/11] PCI: introduce helper function pci_stop_and_remove_device()
Date: Thu, 16 May 2013 23:50:52 +0800
Message-Id: <1368719459-24800-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
References: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a helper function pci_stop_and_remove_device(), which
removes a PCI device in a safe way by locking parent and all
affected descendant PCI buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/remove.c | 19 +++++++++++++++++++
 include/linux/pci.h  |  1 +
 2 files changed, 20 insertions(+)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 2f01f72..8e9b272 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -1,6 +1,7 @@
 #include <linux/pci.h>
 #include <linux/module.h>
 #include <linux/pci-aspm.h>
+#include <linux/delay.h>
 #include "pci.h"
 
 static void pci_stop_bus_device(struct pci_dev *dev);
@@ -148,6 +149,24 @@ void pci_stop_and_remove_bus_device(struct pci_dev *dev)
 }
 EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
 
+void pci_stop_and_remove_device(struct pci_dev *pdev)
+{
+	int ret;
+	struct pci_bus *bus = pdev->bus;
+
+	do {
+		ret = pci_bus_lock_timeout(bus, PCI_BUS_STATE_STOPPING - 1,
+					   true, HZ / 10);
+		if (ret == 0) {
+			pci_stop_and_remove_bus_device(pdev);
+			pci_bus_unlock(bus, true);
+			break;
+		}
+	} while (pci_bus_get_state(bus) <= PCI_BUS_STATE_STARTED &&
+		 pci_dev_get_state(pdev) <= PCI_DEV_STATE_STARTED);
+}
+EXPORT_SYMBOL(pci_stop_and_remove_device);
+
 void pci_stop_root_bus(struct pci_bus *bus)
 {
 	BUG_ON(!pci_bus_is_locked(bus));
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d3f61f8..45d4aea 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -817,6 +817,7 @@ struct pci_dev *pci_dev_get(struct pci_dev *dev);
 void pci_dev_put(struct pci_dev *dev);
 void pci_remove_bus(struct pci_bus *b);
 void pci_stop_and_remove_bus_device(struct pci_dev *dev);
+void pci_stop_and_remove_device(struct pci_dev *dev);
 void pci_stop_root_bus(struct pci_bus *bus);
 void pci_remove_root_bus(struct pci_bus *bus);
 void pci_setup_cardbus(struct pci_bus *bus);
-- 
1.8.1.2

