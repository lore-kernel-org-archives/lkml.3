Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaBLCxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:53:35 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:21559 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaBLCxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:53:33 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        Paul Bolle <pebolle@tiscali.nl>, Oliver Neukum <oneukum@suse.de>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: [PATCH part1 v6 4/7] PCI: Introduce pci_serial_number_changed()
Date: Wed, 12 Feb 2014 10:52:50 +0800
Message-ID: <1392173573-59844-5-git-send-email-wangyijing@huawei.com>
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

Sometimes OS do not know the physical device swap,
for instance, some device hotplug during system suspend.
Interrupt can not deliver to OS in some platform.
So we can use pci serial number capability to detect this
issue if device supports serial number.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/pci.c   |   28 ++++++++++++++++++++++++++++
 include/linux/pci.h |    2 ++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index a8c1c2d..af34057 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2199,6 +2199,34 @@ void pci_dsn_init(struct pci_dev *dev)
 }
 
 /**
+ * pci_serial_number_changed - check the device SN is changed
+ * @pdev: the PCI device
+ *
+ * check the device serial number is changed.
+ * if device does not support device serial number,
+ * return false.
+ */
+bool pci_serial_number_changed(struct pci_dev *pdev)
+{
+	u64 old, new;
+	old = pdev->sn;
+
+	if (!pci_is_pcie(pdev))
+		return false;
+
+	new = pci_device_serial_number(pdev->bus,
+			pdev->devfn);
+
+	if (old != new) {
+		pr_info("%s: Device Serial Number Changed!\n",
+				pci_name(pdev));
+		return true;
+	} else
+		return false;
+}
+EXPORT_SYMBOL(pci_serial_number_changed);
+
+/**
  * pci_configure_ari - enable or disable ARI forwarding
  * @dev: the PCI device
  *
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 3631859..d60c0b6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1025,6 +1025,8 @@ void pci_unlock_rescan_remove(void);
 ssize_t pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
 ssize_t pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void *buf);
 
+bool pci_serial_number_changed(struct pci_dev *pdev);
+
 /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
 resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx);
 void pci_bus_assign_resources(const struct pci_bus *bus);
-- 
1.7.1


