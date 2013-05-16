Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab3EPPwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:52:14 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:41121 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab3EPPv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:51:59 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2, part3 10/11] PCI, pciehp: use PCI bus lock to protect PCI device hotplug
Date: Thu, 16 May 2013 23:50:58 +0800
Message-Id: <1368719459-24800-11-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
References: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI bus lock to protect concurrent PCI device hotplug operations.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/hotplug/pciehp_pci.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
index aac7a40..ddc29ae 100644
--- a/drivers/pci/hotplug/pciehp_pci.c
+++ b/drivers/pci/hotplug/pciehp_pci.c
@@ -51,8 +51,14 @@ int pciehp_configure_device(struct slot *p_slot)
 		return -EINVAL;
 	}
 
+	if (pci_bus_lock(parent, PCI_BUS_STATE_STOPPING - 1, true) < 0) {
+		ctrl_err(ctrl, "Parent bus has been removed\n");
+		return -EBUSY;
+	}
+
 	num = pci_scan_slot(parent, PCI_DEVFN(0, 0));
 	if (num == 0) {
+		pci_bus_unlock(parent, true);
 		ctrl_err(ctrl, "No new device found\n");
 		return -ENODEV;
 	}
@@ -72,6 +78,7 @@ int pciehp_configure_device(struct slot *p_slot)
 	}
 
 	pci_bus_add_devices(parent);
+	pci_bus_unlock(parent, true);
 
 	return 0;
 }
@@ -88,6 +95,12 @@ int pciehp_unconfigure_device(struct slot *p_slot)
 
 	ctrl_dbg(ctrl, "%s: domain:bus:dev = %04x:%02x:00\n",
 		 __func__, pci_domain_nr(parent), parent->number);
+
+	if (pci_bus_lock(parent, PCI_BUS_STATE_REMOVED - 1, true) < 0) {
+		ctrl_dbg(ctrl, "Parent bus has been removed\n");
+		return 0;
+	}
+
 	ret = pciehp_get_adapter_status(p_slot, &presence);
 	if (ret)
 		presence = 0;
@@ -119,5 +132,7 @@ int pciehp_unconfigure_device(struct slot *p_slot)
 		pci_dev_put(dev);
 	}
 
+	pci_bus_unlock(parent, true);
+
 	return rc;
 }
-- 
1.8.1.2

