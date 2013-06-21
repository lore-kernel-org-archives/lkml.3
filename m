Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423266Ab3FUQNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:13:08 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:33228 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161564Ab3FUQNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:13:06 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] PCI: export three functions to support modular host bridge driver
Date: Sat, 22 Jun 2013 00:12:46 +0800
Message-Id: <1371831169-17291-2-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371831169-17291-1-git-send-email-liuj97@gmail.com>
References: <1371831169-17291-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

The xen-pcifront host bridge driver could be built as a module,
so export pci_create_root_bus(), pci_stop_and_remove_root_bus() and
pci_set_host_bridge_release() to support modular host bridge driver.
It's a preparation for coming xen-pcifront refinement.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com
Cc: virtualization@lists.linux-foundation.org
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/host-bridge.c | 1 +
 drivers/pci/probe.c       | 1 +
 drivers/pci/remove.c      | 7 +++++++
 include/linux/pci.h       | 1 +
 4 files changed, 10 insertions(+)

diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index a68dc61..6e390a6 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -34,6 +34,7 @@ void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
 	bridge->release_fn = release_fn;
 	bridge->release_data = release_data;
 }
+EXPORT_SYMBOL(pci_set_host_bridge_release);
 
 static bool resource_contains(struct resource *res1, struct resource *res2)
 {
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 46ada5c..ed768d8 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1801,6 +1801,7 @@ err_out:
 	kfree(b);
 	return NULL;
 }
+EXPORT_SYMBOL(pci_create_root_bus);
 
 int pci_bus_insert_busn_res(struct pci_bus *b, int bus, int bus_max)
 {
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 8fc54b7..f328668 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -147,3 +147,10 @@ void pci_remove_root_bus(struct pci_bus *bus)
 	/* remove the host bridge */
 	put_device(&host_bridge->dev);
 }
+
+void pci_stop_and_remove_root_bus(struct pci_bus *bus)
+{
+	pci_stop_root_bus(bus);
+	pci_remove_root_bus(bus);
+}
+EXPORT_SYMBOL(pci_stop_and_remove_root_bus);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0fd1f15..f1229c7 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -757,6 +757,7 @@ void pci_remove_bus(struct pci_bus *b);
 void pci_stop_and_remove_bus_device(struct pci_dev *dev);
 void pci_stop_root_bus(struct pci_bus *bus);
 void pci_remove_root_bus(struct pci_bus *bus);
+void pci_stop_and_remove_root_bus(struct pci_bus *bus);
 void pci_setup_cardbus(struct pci_bus *bus);
 void pci_sort_breadthfirst(void);
 #define dev_is_pci(d) ((d)->bus == &pci_bus_type)
-- 
1.8.1.2

