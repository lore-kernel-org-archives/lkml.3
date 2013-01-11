Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3AKWlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:41:46 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38489 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab3AKWlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:41:24 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 21/22] PCI: add match_driver in struct pci_dev
Date: Fri, 11 Jan 2013 14:40:48 -0800
Message-Id: <1357944049-29620-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with that we could move out attaching driver for pci device,
out of device_add for pci hot add path.

pci_bus_attach_device() will attach driver to pci device.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/bus.c        |   10 ++++++++++
 drivers/pci/pci-driver.c |    6 +++++-
 include/linux/pci.h      |    1 +
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 5f9c728..1f5916a 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -160,6 +160,15 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 
 void __weak pcibios_resource_survey_bus(struct pci_bus *bus) { }
 
+static void pci_bus_attach_device(struct pci_dev *dev)
+{
+	int ret;
+
+	dev->match_driver = true;
+	ret = device_attach(&dev->dev);
+	WARN_ON(ret < 0);
+}
+
 /**
  * pci_bus_add_device - add a single device
  * @dev: device to add
@@ -181,6 +190,7 @@ int pci_bus_add_device(struct pci_dev *dev)
 	if (retval)
 		return retval;
 
+	pci_bus_attach_device(dev);
 	dev->is_added = 1;
 	pci_proc_attach_device(dev);
 	pci_create_sysfs_dev_files(dev);
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index f79cbcd..acdcc3c 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1186,9 +1186,13 @@ pci_dev_driver(const struct pci_dev *dev)
 static int pci_bus_match(struct device *dev, struct device_driver *drv)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct pci_driver *pci_drv = to_pci_driver(drv);
+	struct pci_driver *pci_drv;
 	const struct pci_device_id *found_id;
 
+	if (!pci_dev->match_driver)
+		return 0;
+
+	pci_drv = to_pci_driver(drv);
 	found_id = pci_match_device(pci_drv, pci_dev);
 	if (found_id)
 		return 1;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 907b455..d73af08 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -286,6 +286,7 @@ struct pci_dev {
 	unsigned int	irq;
 	struct resource resource[DEVICE_COUNT_RESOURCE]; /* I/O and memory regions + expansion ROMs */
 
+	bool match_driver;
 	/* These fields are used by common fixups */
 	unsigned int	transparent:1;	/* Transparent PCI bridge */
 	unsigned int	multifunction:1;/* Part of multi-function device */
-- 
1.7.10.4

