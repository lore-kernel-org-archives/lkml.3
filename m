Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbbAPDzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 22:55:55 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:40924 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbbAPDr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 22:47:26 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <jiang.liu@linux.intel.com>, <linux-pci@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        <linux-ia64@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Guan Xuetao" <gxt@mprc.pku.edu.cn>, <linux-alpha@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, Liviu Dudau <liviu@dudau.co.uk>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Yijing Wang" <wangyijing@huawei.com>
Subject: [PATCH 12/28] PCI: Introduce new scan function pci_scan_root_bridge()
Date: Fri, 16 Jan 2015 09:44:10 +0800
Message-ID: <1421372666-12288-13-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1421372666-12288-1-git-send-email-wangyijing@huawei.com>
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce new scan function pci_scan_root_bridge() to
support host bridge drivers that need to provide platform
own pci_host_bridge_ops.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/probe.c |   21 +++++++++++++++++++++
 include/linux/pci.h |    3 +++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5f748ed..51d69c3 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2068,6 +2068,27 @@ static struct pci_bus *__pci_scan_root_bus(
 	return b;
 }
 
+struct pci_host_bridge *pci_scan_root_bridge(struct device *parent,
+		u32 db, struct pci_ops *ops, void *sysdata,
+		struct list_head *resources, struct pci_host_bridge_ops *phb_ops)
+{
+	struct pci_host_bridge *host;
+	struct pci_bus *bus;
+
+	host = pci_create_host_bridge(parent, db, resources,
+			sysdata, phb_ops);
+	if (!host)
+		return NULL;
+
+	bus = __pci_scan_root_bus(host, ops);
+	if (!bus)
+		pci_free_host_bridge(host);
+
+	return host;
+}
+EXPORT_SYMBOL(pci_scan_root_bridge);
+
+
 struct pci_bus *pci_scan_root_bus(struct device *parent, u32 db,
 		struct pci_ops *ops, void *sysdata, struct list_head *resources)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c06b95d..5592737 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -797,6 +797,9 @@ void pci_bus_release_busn_res(struct pci_bus *b);
 struct pci_bus *pci_scan_root_bus(struct device *parent, u32 dombus,
 					     struct pci_ops *ops, void *sysdata,
 					     struct list_head *resources);
+struct pci_host_bridge *pci_scan_root_bridge(struct device *parent,
+		u32 dombus, struct pci_ops *ops, void *sysdata,
+		struct list_head *resources, struct pci_host_bridge_ops *phb_ops);
 struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
 				int busnr);
 void pcie_update_link_speed(struct pci_bus *bus, u16 link_status);
-- 
1.7.1

