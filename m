Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822AbbAPD4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 22:56:36 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:40988 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbbAPDrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 22:47:25 -0500
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
Subject: [PATCH 13/28] PCI/x86: Refine pci_acpi_scan_root() with generic pci_host_bridge
Date: Fri, 16 Jan 2015 09:44:11 +0800
Message-ID: <1421372666-12288-14-git-send-email-wangyijing@huawei.com>
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

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/x86/pci/acpi.c |   36 ++++++++++++++++++++----------------
 1 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 8edea63..f9a55c2 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -467,6 +467,18 @@ static void probe_pci_root_info(struct pci_root_info *info,
 				info);
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
@@ -475,6 +487,7 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 	int busnum = root->secondary.start;
 	LIST_HEAD(resources);
 	struct pci_bus *bus;
+	struct pci_host_bridge *host = NULL;
 	struct pci_sysdata *sd;
 	int node;
 
@@ -537,14 +550,13 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 
 		if (!setup_mcfg_map(info, domain, (u8)root->secondary.start,
 					(u8)root->secondary.end, root->mcfg_addr)) 
-			bus = pci_create_root_bus(NULL, PCI_DOMBUS(domain, busnum), 
-					&pci_root_ops, sd, &resources);
-
-		if (bus) {
-			pci_scan_child_bus(bus);
-			pci_set_host_bridge_release(
-				to_pci_host_bridge(bus->bridge),
-				release_pci_root_info, info);
+			host = pci_scan_root_bridge(NULL, PCI_DOMBUS(domain, busnum),
+					&pci_root_ops, sd, &resources, &phb_ops);
+
+		if (host) {
+			bus = host->bus;
+			pci_set_host_bridge_release(host, release_pci_root_info,
+					info);
 		} else {
 			pci_free_resource_list(&resources);
 			__release_pci_root_info(info);
@@ -566,14 +578,6 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 	return bus;
 }
 
-int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
-{
-	struct pci_sysdata *sd = bridge->bus->sysdata;
-
-	ACPI_COMPANION_SET(&bridge->dev, sd->companion);
-	return 0;
-}
-
 int __init pci_acpi_init(void)
 {
 	struct pci_dev *dev = NULL;
-- 
1.7.1

