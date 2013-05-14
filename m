Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab3ENQxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:53:25 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:64498 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136Ab3ENQxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:53:20 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [RFC PATCH v2, part 2 11/18] PCI, x86: use hotplug-safe iterators to walk PCI buses
Date: Wed, 15 May 2013 00:51:55 +0800
Message-Id: <1368550322-1045-11-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
References: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance x86 architecture specific code to use hotplug-safe iterators
to walk PCI buses.

In other words, replace pci_find_bus(), pci_find_next_bus() and
pci_root_buses with pci_bus_exists(), pci_get_bus(), pci_get_next_bus()
and pci_get_next_root_bus() etc.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Myron Stowe <myron.stowe@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/pci/acpi.c   | 3 ++-
 arch/x86/pci/common.c | 3 ++-
 arch/x86/pci/i386.c   | 9 ++++-----
 arch/x86/pci/irq.c    | 2 +-
 arch/x86/pci/legacy.c | 2 +-
 5 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 3e72425..b972f04 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -526,7 +526,7 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 	 * Maybe the desired pci bus has been already scanned. In such case
 	 * it is unnecessary to scan the pci bus with the given domain,busnum.
 	 */
-	bus = pci_find_bus(domain, busnum);
+	bus = pci_get_bus(domain, busnum);
 	if (bus) {
 		/*
 		 * If the desired bus exits, the content of bus->sysdata will
@@ -534,6 +534,7 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 		 */
 		memcpy(bus->sysdata, sd, sizeof(*sd));
 		kfree(info);
+		pci_bus_put(bus);
 	} else {
 		probe_pci_root_info(info, device, busnum, domain);
 
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 305c68b..51cc1be 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -460,8 +460,9 @@ struct pci_bus *pcibios_scan_root(int busnum)
 {
 	struct pci_bus *bus = NULL;
 
-	while ((bus = pci_find_next_bus(bus)) != NULL) {
+	for_each_pci_root_bus(bus) {
 		if (bus->number == busnum) {
+			pci_bus_put(bus);
 			/* Already scanned */
 			return bus;
 		}
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 94919e3..6481d25 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -343,7 +343,7 @@ static int __init pcibios_assign_resources(void)
 	struct pci_bus *bus;
 
 	if (!(pci_probe & PCI_ASSIGN_ROMS))
-		list_for_each_entry(bus, &pci_root_buses, node)
+		for_each_pci_root_bus(bus)
 			pcibios_allocate_rom_resources(bus);
 
 	pci_assign_unassigned_resources();
@@ -371,12 +371,11 @@ void __init pcibios_resource_survey(void)
 
 	DBG("PCI: Allocating resources\n");
 
-	list_for_each_entry(bus, &pci_root_buses, node)
+	for_each_pci_root_bus(bus)
 		pcibios_allocate_bus_resources(bus);
-
-	list_for_each_entry(bus, &pci_root_buses, node)
+	for_each_pci_root_bus(bus)
 		pcibios_allocate_resources(bus, 0);
-	list_for_each_entry(bus, &pci_root_buses, node)
+	for_each_pci_root_bus(bus)
 		pcibios_allocate_resources(bus, 1);
 
 	e820_reserve_resources_late();
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 372e9b8..65898f6 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -137,7 +137,7 @@ static void __init pirq_peer_trick(void)
 	}
 	for (i = 1; i < 256; i++) {
 		int node;
-		if (!busmap[i] || pci_find_bus(0, i))
+		if (!busmap[i] || pci_bus_exists(0, i))
 			continue;
 		node = get_mp_bus_to_node(i);
 		if (pci_scan_bus_on_node(i, &pci_root_ops, node))
diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index 4db96fb..1fb7922 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -40,7 +40,7 @@ void pcibios_scan_specific_bus(int busn)
 	long node;
 	u32 l;
 
-	if (pci_find_bus(0, busn))
+	if (pci_bus_exists(0, busn))
 		return;
 
 	node = get_mp_bus_to_node(busn);
-- 
1.8.1.2

