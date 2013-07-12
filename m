Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab3GLJkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 05:40:06 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:7973 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab3GLJkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 05:40:03 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, Don Dutile <ddutile@redhat.com>,
        Paul Bolle <pebolle@tiscali.nl>, <linux-pci@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        Oliver Neukum <oneukum@suse.de>, Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: [PATCH -v3 1/3] PCI: introduce PCIe Device Serial Number Capability support
Date: Fri, 12 Jul 2013 17:32:21 +0800
Message-ID: <1373621543-54836-2-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1373621543-54836-1-git-send-email-wangyijing@huawei.com>
References: <1373621543-54836-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce PCIe Ext Capability Device Serial Number support,
so we can use the unique device serial number to identify
the physical device. During system suspend, if the PCIe
device was removed and reinserted a new same device, during
system resume there is no good way to identify it, maybe
Device Serial Number is a good choice if device support.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/pci.c   |   30 ++++++++++++++++++++++++++++++
 drivers/pci/pci.h   |    1 +
 drivers/pci/probe.c |    2 ++
 include/linux/pci.h |    3 +++
 4 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e37fea6..156e251 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1985,6 +1985,11 @@ void pci_pm_init(struct pci_dev *dev)
 	}
 }
 
+void pci_dsn_init(struct pci_dev *dev)
+{
+	dev->sn = pci_device_serial_number(dev);
+}
+
 static void pci_add_saved_cap(struct pci_dev *pci_dev,
 	struct pci_cap_saved_state *new_cap)
 {
@@ -2048,6 +2053,31 @@ void pci_free_cap_save_buffers(struct pci_dev *dev)
 }
 
 /**
+ * pci_device_serial_number - get device serial number
+ * @dev: the PCI device
+ *
+ * return the device serial number if device support,
+ * otherwise return 0.
+ */
+u64 pci_device_serial_number(struct pci_dev *dev)
+{
+	int pos;
+	u32 lo, hi;
+
+	if (!pci_is_pcie(dev))
+		return 0;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DSN);
+	if (!pos)
+		return 0;
+
+	pci_read_config_dword(dev, pos + 4, &lo);
+	pci_read_config_dword(dev, pos + 8, &hi);
+	return ((u64)hi << 32) | lo;
+}
+EXPORT_SYMBOL(pci_device_serial_number);
+
+/**
  * pci_configure_ari - enable or disable ARI forwarding
  * @dev: the PCI device
  *
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 68678ed..f626006 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -202,6 +202,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		    struct resource *res, unsigned int reg);
 int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type);
 void pci_configure_ari(struct pci_dev *dev);
+void pci_dsn_init(struct pci_dev *dev);
 
 /**
  * pci_ari_enabled - query ARI forwarding status
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 46ada5c..b37534f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1322,6 +1322,8 @@ static void pci_init_capabilities(struct pci_dev *dev)
 	/* Power Management */
 	pci_pm_init(dev);
 
+	pci_dsn_init(dev);
+
 	/* Vital Product Data */
 	pci_vpd_pci22_init(dev);
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0fd1f15..f2c6ed9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -342,6 +342,7 @@ struct pci_dev {
 	struct list_head msi_list;
 	struct kset *msi_kset;
 #endif
+	u64 sn;		/* device serial number, 0 if not support */
 	struct pci_vpd *vpd;
 #ifdef CONFIG_PCI_ATS
 	union {
@@ -995,6 +996,8 @@ ssize_t pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
 ssize_t pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void *buf);
 int pci_vpd_truncate(struct pci_dev *dev, size_t size);
 
+u64 pci_device_serial_number(struct pci_dev *dev);
+
 /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
 resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx);
 void pci_bus_assign_resources(const struct pci_bus *bus);
-- 
1.7.1


