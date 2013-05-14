Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab3ENQxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:53:13 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:39434 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757610Ab3ENQxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:53:09 -0400
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
Subject: [RFC PATCH v2, part 2 09/18] PCI, PPC: use hotplug-safe iterators to walk PCI buses
Date: Wed, 15 May 2013 00:51:53 +0800
Message-Id: <1368550322-1045-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
References: <1368550322-1045-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance PPC architecture specific code to use hotplug-safe iterators
to walk PCI buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Bjorn Helgaas <bhelgaas@google.com>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
---
 arch/powerpc/kernel/pci-common.c |  4 ++--
 arch/powerpc/kernel/pci_64.c     | 13 +++++--------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index fa12ae4..26fca09 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1400,7 +1400,7 @@ void __init pcibios_resource_survey(void)
 	struct pci_bus *b;
 
 	/* Allocate and assign resources */
-	list_for_each_entry(b, &pci_root_buses, node)
+	for_each_pci_root_bus(b)
 		pcibios_allocate_bus_resources(b);
 	pcibios_allocate_resources(0);
 	pcibios_allocate_resources(1);
@@ -1410,7 +1410,7 @@ void __init pcibios_resource_survey(void)
 	 * bus available resources to avoid allocating things on top of them
 	 */
 	if (!pci_has_flag(PCI_PROBE_ONLY)) {
-		list_for_each_entry(b, &pci_root_buses, node)
+		for_each_pci_root_bus(b)
 			pcibios_reserve_legacy_regions(b);
 	}
 
diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
index 51a133a..a41c6dd 100644
--- a/arch/powerpc/kernel/pci_64.c
+++ b/arch/powerpc/kernel/pci_64.c
@@ -208,7 +208,6 @@ long sys_pciconfig_iobase(long which, unsigned long in_bus,
 			  unsigned long in_devfn)
 {
 	struct pci_controller* hose;
-	struct list_head *ln;
 	struct pci_bus *bus = NULL;
 	struct device_node *hose_node;
 
@@ -229,18 +228,16 @@ long sys_pciconfig_iobase(long which, unsigned long in_bus,
 	/* That syscall isn't quite compatible with PCI domains, but it's
 	 * used on pre-domains setup. We return the first match
 	 */
-
-	for (ln = pci_root_buses.next; ln != &pci_root_buses; ln = ln->next) {
-		bus = pci_bus_b(ln);
-		if (in_bus >= bus->number && in_bus <= bus->busn_res.end)
+	for_each_pci_root_bus(bus)
+		if (in_bus >= bus->number && in_bus <= bus->busn_res.end &&
+		    bus->dev.of_node)
 			break;
-		bus = NULL;
-	}
-	if (bus == NULL || bus->dev.of_node == NULL)
+	if (bus == NULL)
 		return -ENODEV;
 
 	hose_node = bus->dev.of_node;
 	hose = PCI_DN(hose_node)->phb;
+	pci_bus_put(bus);
 
 	switch (which) {
 	case IOBASE_BRIDGE_NUMBER:
-- 
1.8.1.2

