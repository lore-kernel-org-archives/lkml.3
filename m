Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbbAPDz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 22:55:29 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:40984 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbbAPDr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 22:47:27 -0500
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
        "Yijing Wang" <wangyijing@huawei.com>,
        Yijing Wang <wangyijing0307@gmail.com>
Subject: [PATCH 14/28] PCI/IA64: Refine pci_acpi_scan_root() with generic pci_host_bridge
Date: Fri, 16 Jan 2015 09:44:12 +0800
Message-ID: <1421372666-12288-15-git-send-email-wangyijing@huawei.com>
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

From: Yijing Wang <wangyijing0307@gmail.com>

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/ia64/pci/pci.c |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index e457015..7736c02 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -420,6 +420,18 @@ probe_pci_root_info(struct pci_root_info *info, struct acpi_device *device,
 	return 0;
 }
 
+static int pci_host_bridge_prepare(struct pci_host_bridge *bridge)
+{
+	struct pci_sysdata *sd = dev_get_drvdata(&bridge->dev);
+
+	ACPI_COMPANION_SET(&bridge->dev, sd->companion);
+	return 0;
+}
+
+static struct pci_host_bridge_ops phb_ops = {
+	.phb_prepare = pci_host_bridge_prepare,
+};
+
 struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 {
 	struct acpi_device *device = root->device;
@@ -428,7 +440,7 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 	struct pci_controller *controller;
 	struct pci_root_info *info = NULL;
 	int busnum = root->secondary.start;
-	struct pci_bus *pbus;
+	struct pci_host_bridge *host;
 	int ret;
 
 	controller = alloc_pci_controller(domain);
@@ -465,26 +477,16 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 	 * should handle the case here, but it appears that IA64 hasn't
 	 * such quirk. So we just ignore the case now.
 	 */
-	pbus = pci_create_root_bus(NULL, PCI_DOMBUS(domain, bus), 
-			&pci_root_ops, controller, &info->resources);
-	if (!pbus) {
+	host = pci_scan_root_bridge(NULL, PCI_DOMBUS(domain, bus),
+			&pci_root_ops, controller, &info->resources, &phb_ops);
+	if (!host) {
 		pci_free_resource_list(&info->resources);
 		__release_pci_root_info(info);
 		return NULL;
 	}
 
-	pci_set_host_bridge_release(to_pci_host_bridge(pbus->bridge),
-			release_pci_root_info, info);
-	pci_scan_child_bus(pbus);
-	return pbus;
-}
-
-int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
-{
-	struct pci_controller *controller = bridge->bus->sysdata;
-
-	ACPI_COMPANION_SET(&bridge->dev, controller->companion);
-	return 0;
+	pci_set_host_bridge_release(host, release_pci_root_info, info);
+	return host->bus;
 }
 
 static int is_valid_resource(struct pci_dev *dev, int idx)
-- 
1.7.1

