Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab3LSGJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 01:09:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51674 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3LSGJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 01:09:29 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Guo Chao <yan@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 1/3] PCI: Try to allocate mem64 above 4G at first
Date: Wed, 18 Dec 2013 22:09:38 -0800
Message-Id: <1387433380-18564-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1387433380-18564-1-git-send-email-yinghai@kernel.org>
References: <1387433380-18564-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
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
-v8: refresh after changes in pci/resource.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/bus.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 263b90c..1fd0bf8 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -100,6 +100,9 @@ void pci_bus_remove_resources(struct pci_bus *bus)
 
 /* The region that can be mapped by a 32-bit BAR. */
 static struct pci_bus_region pci_32_bit = {0, 0xffffffff};
+/* The region that can be mapped by a 64-bit BAR above 4G */
+static struct pci_bus_region pci_64_bit = {(resource_size_t)(1ULL<<32),
+					   (resource_size_t)(-1ULL)};
 
 /*
  * @res contains CPU addresses.  Clip it so the corresponding bus addresses
@@ -150,12 +153,12 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 {
 	int i, ret = -ENOMEM;
 	struct resource *r;
-	resource_size_t max;
 
 	type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
 
 	pci_bus_for_each_resource(bus, r, i) {
 		struct resource avail;
+		int try_again = 0;
 
 		if (!r)
 			continue;
@@ -174,12 +177,19 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 		 * Unless this is a 64-bit BAR, we have to clip the
 		 * available space to the part that maps to the region of
 		 * 32-bit bus addresses.
+		 * If this is a 64-bit BAR, try above 4G first.
 		 */
 		avail = *r;
 		if (!(res->flags & IORESOURCE_MEM_64)) {
 			pci_clip_resource_to_bus(bus, &avail, &pci_32_bit);
 			if (!resource_size(&avail))
 				continue;
+		} else {
+			pci_clip_resource_to_bus(bus, &avail, &pci_64_bit);
+			if (!resource_size(&avail))
+				avail = *r;
+			else
+				try_again = 1;
 		}
 
 		/*
@@ -188,16 +198,18 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 		 * this is an already-configured bridge window, its start
 		 * overrides "min".
 		 */
-		if (avail.start)
-			min = avail.start;
-
-		max = avail.end;
-
+again:
 		/* Ok, try it out.. */
-		ret = allocate_resource(r, res, size, min, max,
-					align, alignf, alignf_data);
+		ret = allocate_resource(r, res, size, avail.start ? : min,
+					avail.end, align, alignf, alignf_data);
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
1.8.4

