Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaBJEFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 23:05:12 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:8405 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaBJEFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 23:05:05 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        Paul Bolle <pebolle@tiscali.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Oliver Neukum <oneukum@suse.de>, Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: [PATCH part1 v5 3/7] PCI: Add support for Device Serial Number capability
Date: Mon, 10 Feb 2014 12:04:07 +0800
Message-ID: <1392005051-54508-4-git-send-email-wangyijing@huawei.com>
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

Add support for the Device Serial Number capability, so we can use the
unique device serial number to identify the physical device.  This helps
determine whether a device was replaced while the system was suspended.

[bhelgaas: changelog, drop pci_dsn_init(), spell out "serial_number"]
Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 drivers/pci/pci.c   |   30 ++++++++++++++++++++++++++++++
 drivers/pci/pci.h   |    2 +-
 drivers/pci/probe.c |    2 ++
 include/linux/pci.h |    1 +
 4 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 432ac86..af06064 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2168,6 +2168,36 @@ void pci_free_cap_save_buffers(struct pci_dev *dev)
 }
 
 /**
+ * pci_device_serial_number - get device serial number
+ * @bus: PCI bus the device on
+ * @devfn: the PCI device
+ *
+ * return the device serial number if device support,
+ * otherwise return 0.
+ */
+static u64 pci_device_serial_number(struct pci_bus *bus, int devfn)
+{
+	int pos;
+	u32 lo, hi;
+
+	if (!pci_bus_find_capability(bus, devfn, PCI_CAP_ID_EXP))
+		return 0;
+
+	pos = pci_bus_find_ext_capability(bus, devfn, PCI_EXT_CAP_ID_DSN);
+	if (!pos)
+		return 0;
+
+	pci_bus_read_config_dword(bus, devfn, pos + 4, &lo);
+	pci_bus_read_config_dword(bus, devfn, pos + 8, &hi);
+	return ((u64)hi << 32) | lo;
+}
+
+void pci_dsn_init(struct pci_dev *dev)
+{
+	dev->sn = pci_device_serial_number(dev->bus, dev->devfn);
+}
+
+/**
  * pci_configure_ari - enable or disable ARI forwarding
  * @dev: the PCI device
  *
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 4df38df..685301a 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -208,7 +208,7 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
 void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
 				      struct list_head *realloc_head,
 				      struct list_head *fail_head);
-
+void pci_dsn_init(struct pci_dev *dev);
 /**
  * pci_ari_enabled - query ARI forwarding status
  * @bus: the PCI bus
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 6e34498..27d3e6f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1324,6 +1324,8 @@ static void pci_init_capabilities(struct pci_dev *dev)
 	/* Vital Product Data */
 	pci_vpd_pci22_init(dev);
 
+	pci_dsn_init(dev);
+
 	/* Alternative Routing-ID Forwarding */
 	pci_configure_ari(dev);
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 470de02..3631859 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -354,6 +354,7 @@ struct pci_dev {
 	struct list_head msi_list;
 	const struct attribute_group **msi_irq_groups;
 #endif
+	u64 sn;		/* device serial number, 0 if not support */
 	struct pci_vpd *vpd;
 #ifdef CONFIG_PCI_ATS
 	union {
-- 
1.7.1


