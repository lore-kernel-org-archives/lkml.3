Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab3K3WlY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 17:41:24 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21636 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab3K3Wkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 17:40:46 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 08/12] PCI: Try to allocate mem64 above 4G at first
Date: Sat, 30 Nov 2013 14:40:34 -0800
Message-Id: <1385851238-21085-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
References: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On system with more pcie cards, we do not have enough range under 4G
to allocate those pci devices.

On 64bit system, we could try to allocate mem64 above 4G at first,
and fall back to below 4g if it can not find any above 4g.

x86 32bit without X86_PAE support will have bottom set to 0, because
resource_size_t is 32bit.
For 32bit kernel that resource_size_t is 64bit when pae is support.
we are safe because iomem_resource is limited to 32bit according to
x86_phys_bits.

-v2: update bottom assigning to make it clear for non-pae support machine.
-v3: Bjorn's change:
        use MAX_RESOURCE instead of -1
        use start/end instead of bottom/max
        for all arch instead of just x86_64
-v4: updated after PCI_MAX_RESOURCE_32 change.
-v5: restore io handling to use PCI_MAX_RESOURCE_32 as limit.
-v6: checking pcibios_resource_to_bus return for every bus res, to decide it
	if we need to try high at first.
     It supports all arches instead of just x86_64.
-v7: split 4G limit change out to another patch according to Bjorn.
     also use pci_clip_resource instead.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/bus.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index e75bb17..82eb234 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -99,6 +99,8 @@ void pci_bus_remove_resources(struct pci_bus *bus)
 }
 
 static struct pci_bus_region pci_mem_32 = {0, 0xffffffff};
+static struct pci_bus_region pci_mem_64 = {(resource_size_t)(1ULL<<32),
+					   (resource_size_t)(-1ULL)};
 
 static void pci_clip_resource(struct resource *res, struct pci_bus *bus,
 			      struct pci_bus_region *region)
@@ -149,6 +151,7 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 
 	pci_bus_for_each_resource(bus, r, i) {
 		struct resource avail;
+		int try_again = 0;
 
 		if (!r)
 			continue;
@@ -165,15 +168,23 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 
 		/*
 		 * don't allocate too high if the pref mem doesn't
-		 * support 64bit.
+		 * support 64bit, also if this is a 64-bit mem
+		 * resource, try above 4GB first
 		 */
 		avail = *r;
-		if (!(res->flags & IORESOURCE_MEM_64)) {
+		if (res->flags & IORESOURCE_MEM_64) {
+			pci_clip_resource(&avail, bus, &pci_mem_64);
+			if (!resource_size(&avail))
+				avail = *r;
+			else
+				try_again = 1;
+		} else {
 			pci_clip_resource(&avail, bus, &pci_mem_32);
 			if (!resource_size(&avail))
 				continue;
 		}
 
+again:
 		/* Ok, try it out.. */
 		ret = allocate_resource(r, res, size,
 					max(avail.start, r->start ? : min),
@@ -181,6 +192,12 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 					alignf, alignf_data);
 		if (ret == 0)
 			break;
+
+		if (try_again) {
+			avail = *r;
+			try_again = 0;
+			goto again;
+		}
 	}
 	return ret;
 }
-- 
1.8.1.4

