Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab3ARQKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 11:10:04 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:51756 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab3ARQIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 11:08:09 -0500
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: [RFC PATCH v5 2/8] PCI: split registration of PCI bus devices into two stages
Date: Sat, 19 Jan 2013 00:07:40 +0800
Message-Id: <1358525267-14268-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When handling BUS_NOTIFY_ADD_DEVICE event for a PCI bridge device,
the notification handler can't hold reference count to the new PCI bus
because the device object for the new bus (pci_dev->subordinate->dev)
hasn't been initialized yet.

Split the registration of PCI bus device into two stages as below,
so that the event handler could hold reference count to the new PCI bus
when handling BUS_NOTIFY_ADD_DEVICE event.

1) device_initialize(&pci_dev->dev)
2) device_initialize(&pci_dev->subordinate->dev)
3) notify BUS_NOTIFY_ADD_DEVICE event for pci_dev
4) device_add(&pci_dev->dev)
5) device_add(&pci_dev->subordinate->dev)

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/bus.c    |    2 +-
 drivers/pci/probe.c  |    4 +++-
 drivers/pci/remove.c |   10 +++++-----
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index a543746..4c843cd 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -193,7 +193,7 @@ int pci_bus_add_child(struct pci_bus *bus)
 	if (bus->bridge)
 		bus->dev.parent = bus->bridge;
 
-	retval = device_register(&bus->dev);
+	retval = device_add(&bus->dev);
 	if (retval)
 		return retval;
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index ec5d28f..adb77c6 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -639,6 +639,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 	 */
 	child->dev.class = &pcibus_class;
 	dev_set_name(&child->dev, "%04x:%02x", pci_domain_nr(child), busnr);
+	device_initialize(&child->dev);
 
 	/*
 	 * Set up the primary, secondary and subordinate
@@ -1673,7 +1674,8 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	b->dev.class = &pcibus_class;
 	b->dev.parent = b->bridge;
 	dev_set_name(&b->dev, "%04x:%02x", pci_domain_nr(b), bus);
-	error = device_register(&b->dev);
+	device_initialize(&b->dev);
+	error = device_add(&b->dev);
 	if (error)
 		goto class_dev_reg_err;
 
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 10693f5..0d03026 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -48,11 +48,11 @@ void pci_remove_bus(struct pci_bus *bus)
 	list_del(&bus->node);
 	pci_bus_release_busn_res(bus);
 	up_write(&pci_bus_sem);
-	if (!bus->is_added)
-		return;
-
-	pci_remove_legacy_files(bus);
-	device_unregister(&bus->dev);
+	if (bus->is_added) {
+		pci_remove_legacy_files(bus);
+		device_del(&bus->dev);
+	}
+	put_device(&bus->dev);
 }
 EXPORT_SYMBOL(pci_remove_bus);
 
-- 
1.7.9.5

