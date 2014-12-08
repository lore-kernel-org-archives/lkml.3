Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbaLHVxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 16:53:13 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20679 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaLHVxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 16:53:11 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?q?Marek=20Kord=C3=ADk?= <kordikmarek@gmail.com>,
        zermond@gmail.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] PCI: Clear bridge MEM_64 flag if one child does not support it
Date: Mon,  8 Dec 2014 13:52:32 -0800
Message-Id: <1418075552-26495-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zermond and Marek reported 3.16 and later kernel broke the ati radeon support.
And it points to commit 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources").

The root causes:
BIOS does not assign resource for the bridge correctly.
[    0.113672] pci 0000:01:00.0: reg 0x10: [mem 0xc0000000-0xcfffffff pref]
[    0.113683] pci 0000:01:00.0: reg 0x14: [io  0xa000-0xa0ff]
[    0.113695] pci 0000:01:00.0: reg 0x18: [mem 0xfdff0000-0xfdffffff]
[    0.113729] pci 0000:01:00.0: reg 0x30: [mem 0xfdfc0000-0xfdfdffff pref]
[    0.113776] pci 0000:01:00.0: supports D1 D2
[    0.115016] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.115022] pci 0000:00:01.0:   bridge window [io  0x8000-0xafff]
[    0.115027] pci 0000:00:01.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.115034] pci 0000:00:01.0:   bridge window [mem 0xbdf00000-0xddefffff 64bit pref]
but
[    0.158601] pci 0000:00:01.0: address space collision: [mem
0xbdf00000-0xddefffff 64bit pref] conflicts with System RAM [mem
0x00100000-0xbff9ffff]
so kernel reject them, and try to allocate the resource to it.

Current code after the commit
 1. when bridge does not support 64bit mmio pref, child mmio non 64bit will be
allocated from bridge mmio pref.
2. when bridge does support 64bit mmio pref, child mmio non 64bit will be
 allocated from bridge mmio.

In this case, mmio bar is not big enough and realloc is not triggerd and
it will not be increased, so child device 01:00.0 will not get allocated
mmio pref range.

Solution would be:
1. specify pci=realloc to scratch the bridge mmio register and get bigger
   range for it and then allocate to child mmio pref.
2. or scan the children resource other than ROM to clear bridge MEM_64
   for mmio pref.

The patch is using second way so will keep child mmio pref into bridge
mmio pref range.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
Reported-by: zermond@gmail.com
Reported-and-tested-by: Marek Kordik <kordikmarek@gmail.com>
Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -1118,6 +1118,52 @@ handle_done:
 	;
 }
 
+static void pbus_check_mem64(struct pci_bus *bus, unsigned long mask,
+			 unsigned long type, struct list_head *realloc_head)
+{
+	struct pci_dev *dev;
+	resource_size_t align;
+	resource_size_t aligns[18];	/* Alignments from 1Mb to 128Gb */
+	int order;
+	unsigned int mem64_mask = 0;
+	struct resource *b_res = find_free_bus_resource(bus, mask, type);
+
+	if (!b_res || !(b_res->flags & IORESOURCE_MEM_64))
+		return;
+
+	memset(aligns, 0, sizeof(aligns));
+
+	mem64_mask = IORESOURCE_MEM_64;
+	b_res->flags &= ~IORESOURCE_MEM_64;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		int i;
+
+		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+			struct resource *r = &dev->resource[i];
+
+			if (r->parent || (r->flags & mask) != type)
+				continue;
+#ifdef CONFIG_PCI_IOV
+			if (realloc_head && i >= PCI_IOV_RESOURCES &&
+					i <= PCI_IOV_RESOURCE_END)
+				continue;
+#endif
+			align = pci_resource_alignment(dev, r);
+			order = __ffs(align) - 20;
+			if (order < 0)
+				order = 0;
+			if (order >= ARRAY_SIZE(aligns))
+				continue;
+
+			if (i != PCI_ROM_RESOURCE)
+				mem64_mask &= r->flags & IORESOURCE_MEM_64;
+		}
+	}
+
+	b_res->flags |= mem64_mask;
+}
+
 void __pci_bus_size_bridges(struct pci_bus *bus, struct list_head *realloc_head)
 {
 	struct pci_dev *dev;
@@ -1171,6 +1217,7 @@ void __pci_bus_size_bridges(struct pci_b
 		b_res = &bus->self->resource[PCI_BRIDGE_RESOURCES];
 		mask = IORESOURCE_MEM;
 		prefmask = IORESOURCE_MEM | IORESOURCE_PREFETCH;
+		pbus_check_mem64(bus, prefmask, prefmask, realloc_head);
 		if (b_res[2].flags & IORESOURCE_MEM_64) {
 			prefmask |= IORESOURCE_MEM_64;
 			ret = pbus_size_mem(bus, prefmask, prefmask,
