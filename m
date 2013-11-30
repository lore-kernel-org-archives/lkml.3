Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab3K3Wl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 17:41:26 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21635 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3K3Wkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 17:40:46 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 07/12] PCI: Don't use 4G bus address directly in resource allocation
Date: Sat, 30 Nov 2013 14:40:33 -0800
Message-Id: <1385851238-21085-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
References: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current we are using PCIBIOS_MAX_MEM_32 (4G limit) directly in the
pci_bus_alloc_resource to make sure that don't allocate too high
pref 64bit above 4G in the system that does not support that.

That is not right, as allocate_resource() should take resource limit.

Add pci_clip_resource() and use it check the pci bus address limit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/bus.c | 41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 1ffd95b..e75bb17 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -98,6 +98,25 @@ void pci_bus_remove_resources(struct pci_bus *bus)
 	}
 }
 
+static struct pci_bus_region pci_mem_32 = {0, 0xffffffff};
+
+static void pci_clip_resource(struct resource *res, struct pci_bus *bus,
+			      struct pci_bus_region *region)
+{
+	struct pci_bus_region r;
+
+	__pcibios_resource_to_bus(bus, &r, res);
+	if (r.start < region->start)
+		r.start = region->start;
+	if (r.end > region->end)
+		r.end = region->end;
+
+	if (r.end < r.start)
+		res->end = res->start - 1;
+	else
+		__pcibios_bus_to_resource(bus, res, &r);
+}
+
 /**
  * pci_bus_alloc_resource - allocate a resource from a parent bus
  * @bus: PCI bus
@@ -125,15 +144,12 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 {
 	int i, ret = -ENOMEM;
 	struct resource *r;
-	resource_size_t max = -1;
 
 	type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
 
-	/* don't allocate too high if the pref mem doesn't support 64bit*/
-	if (!(res->flags & IORESOURCE_MEM_64))
-		max = PCIBIOS_MAX_MEM_32;
-
 	pci_bus_for_each_resource(bus, r, i) {
+		struct resource avail;
+
 		if (!r)
 			continue;
 
@@ -147,10 +163,21 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 		    !(res->flags & IORESOURCE_PREFETCH))
 			continue;
 
+		/*
+		 * don't allocate too high if the pref mem doesn't
+		 * support 64bit.
+		 */
+		avail = *r;
+		if (!(res->flags & IORESOURCE_MEM_64)) {
+			pci_clip_resource(&avail, bus, &pci_mem_32);
+			if (!resource_size(&avail))
+				continue;
+		}
+
 		/* Ok, try it out.. */
 		ret = allocate_resource(r, res, size,
-					r->start ? : min,
-					max, align,
+					max(avail.start, r->start ? : min),
+					avail.end, align,
 					alignf, alignf_data);
 		if (ret == 0)
 			break;
-- 
1.8.1.4

