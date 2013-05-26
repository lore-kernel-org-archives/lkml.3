Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab3EZP6J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 11:58:09 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64324 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab3EZP6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 11:58:04 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Bill Pemberton <wfp5p@virginia.edu>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3, part2 10/20] PCI, PPC: use hotplug-safe iterators to walk PCI buses
Date: Sun, 26 May 2013 23:53:07 +0800
Message-Id: <1369583597-3801-11-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance PPC architecture specific code to use hotplug-safe iterators
to walk PCI buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
---
 arch/powerpc/kernel/pci-common.c |  4 ++--
 arch/powerpc/kernel/pci_64.c     | 22 ++++++++--------------
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index f5c5c90..56ad3a4 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1386,7 +1386,7 @@ void __init pcibios_resource_survey(void)
 	struct pci_bus *b;
 
 	/* Allocate and assign resources */
-	list_for_each_entry(b, &pci_root_buses, node)
+	for_each_pci_root_bus(b)
 		pcibios_allocate_bus_resources(b);
 	pcibios_allocate_resources(0);
 	pcibios_allocate_resources(1);
@@ -1396,7 +1396,7 @@ void __init pcibios_resource_survey(void)
 	 * bus available resources to avoid allocating things on top of them
 	 */
 	if (!pci_has_flag(PCI_PROBE_ONLY)) {
-		list_for_each_entry(b, &pci_root_buses, node)
+		for_each_pci_root_bus(b)
 			pcibios_reserve_legacy_regions(b);
 	}
 
diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
index 873050d..d71249b 100644
--- a/arch/powerpc/kernel/pci_64.c
+++ b/arch/powerpc/kernel/pci_64.c
@@ -207,10 +207,8 @@ void pcibios_setup_phb_io_space(struct pci_controller *hose)
 long sys_pciconfig_iobase(long which, unsigned long in_bus,
 			  unsigned long in_devfn)
 {
-	struct pci_controller* hose;
-	struct list_head *ln;
-	struct pci_bus *bus = NULL;
-	struct device_node *hose_node;
+	struct pci_controller* hose = NULL;
+	struct pci_bus *bus;
 
 	/* Argh ! Please forgive me for that hack, but that's the
 	 * simplest way to get existing XFree to not lockup on some
@@ -229,19 +227,15 @@ long sys_pciconfig_iobase(long which, unsigned long in_bus,
 	/* That syscall isn't quite compatible with PCI domains, but it's
 	 * used on pre-domains setup. We return the first match
 	 */
-
-	for (ln = pci_root_buses.next; ln != &pci_root_buses; ln = ln->next) {
-		bus = pci_bus_b(ln);
-		if (in_bus >= bus->number && in_bus <= bus->busn_res.end)
+	for_each_pci_root_bus(bus)
+		if (in_bus >= bus->number && in_bus <= bus->busn_res.end) {
+			hose = pci_bus_to_host(bus);
+			pci_bus_put(bus);
 			break;
-		bus = NULL;
-	}
-	if (bus == NULL || bus->dev.of_node == NULL)
+		}
+	if (hose == NULL)
 		return -ENODEV;
 
-	hose_node = bus->dev.of_node;
-	hose = PCI_DN(hose_node)->phb;
-
 	switch (which) {
 	case IOBASE_BRIDGE_NUMBER:
 		return (long)hose->first_busno;
-- 
1.8.1.2

