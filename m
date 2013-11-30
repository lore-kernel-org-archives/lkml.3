Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3K3Wlq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 17:41:46 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21674 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3K3Wky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 17:40:54 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 11/12] PCI: Sort pci root bus resources list
Date: Sat, 30 Nov 2013 14:40:37 -0800
Message-Id: <1385851238-21085-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
References: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some x86 systems expose above 4G 64bit mmio in _CRS as non-pref mmio range.
[   49.415281] PCI host bridge to bus 0000:00
[   49.419921] pci_bus 0000:00: root bus resource [bus 00-1e]
[   49.426107] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[   49.433041] pci_bus 0000:00: root bus resource [io  0x1000-0x5fff]
[   49.440010] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[   49.447768] pci_bus 0000:00: root bus resource [mem 0xfed8c000-0xfedfffff]
[   49.455532] pci_bus 0000:00: root bus resource [mem 0x90000000-0x9fffbfff]
[   49.463259] pci_bus 0000:00: root bus resource [mem 0x380000000000-0x381fffffffff]

During assign unassigned 64bit mmio resource, it will go through
every non-pref mmio for root bus in pci_bus_alloc_resource().
As the loop is with pci_bus_for_each_resource(), and could have chance
to use under 4G mmio range instead of above 4G mmio range if the requested
range is not big enough, even it could handle above 4G 64bit pref mmio.

For root bus, we can order list from high to low in pci_add_resource_offset(),
during creating root bus, it will still keep the same order in final bus
resource list.
	pci_acpi_scan_root
		==> add_resources
			==> pci_add_resource_offset: # Add to temp resources
		==> pci_create_root_bus
			==> pci_bus_add_resource # add to final bus resources.

After that, we can make sure 64bit pref mmio for pci bridges will be allocated
higest of mmio non-pref, and in this case it is above 4G instead of under 4G.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/bus.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 82eb234..30993ab 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -21,7 +21,8 @@
 void pci_add_resource_offset(struct list_head *resources, struct resource *res,
 			     resource_size_t offset)
 {
-	struct pci_host_bridge_window *window;
+	struct pci_host_bridge_window *window, *tmp;
+	struct list_head *n;
 
 	window = kzalloc(sizeof(struct pci_host_bridge_window), GFP_KERNEL);
 	if (!window) {
@@ -31,7 +32,17 @@ void pci_add_resource_offset(struct list_head *resources, struct resource *res,
 
 	window->res = res;
 	window->offset = offset;
-	list_add_tail(&window->list, resources);
+
+	/* sorted it according to res end */
+	n = resources;
+	list_for_each_entry(tmp, resources, list)
+		if (window->res->end > tmp->res->end) {
+			n = &tmp->list;
+			break;
+		}
+
+	/* Insert it just before n */
+	list_add_tail(&window->list, n);
 }
 EXPORT_SYMBOL(pci_add_resource_offset);
 
-- 
1.8.1.4

