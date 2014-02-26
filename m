Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbaBZThU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:37:20 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:46780 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbaBZThM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:37:12 -0500
Subject: [PATCH 1/9] resource: Add resource_contains()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 12:37:10 -0700
Message-ID: <20140226193710.10125.95477.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have two identical copies of resource_contains() already, and more
places that could use it.  This moves it to ioport.h where it can be
shared.

resource_contains(struct resource *r1, struct resource *r2) returns true
iff r1 and r2 are the same type (most callers already checked this
separately) and the r1 address range completely contains r2.

In addition, the new resource_contains() checks that both r1 and r2 have
addresses assigned to them.  If a resource is IORESOURCE_UNSET, it doesn't
have a valid address and can't contain or be contained by another resource.
Some callers already check this or for res->start.

No functional change.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/host-bridge.c |    8 --------
 include/linux/ioport.h    |   10 ++++++++++
 kernel/resource.c         |    8 ++------
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index 06ace6248c61..47aaf22d814e 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -32,11 +32,6 @@ void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
 	bridge->release_data = release_data;
 }
 
-static bool resource_contains(struct resource *res1, struct resource *res2)
-{
-	return res1->start <= res2->start && res1->end >= res2->end;
-}
-
 void pcibios_resource_to_bus(struct pci_bus *bus, struct pci_bus_region *region,
 			     struct resource *res)
 {
@@ -45,9 +40,6 @@ void pcibios_resource_to_bus(struct pci_bus *bus, struct pci_bus_region *region,
 	resource_size_t offset = 0;
 
 	list_for_each_entry(window, &bridge->windows, list) {
-		if (resource_type(res) != resource_type(window->res))
-			continue;
-
 		if (resource_contains(window->res, res)) {
 			offset = window->offset;
 			break;
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 89b7c24a36e9..9fcaac8bc4f6 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -169,6 +169,16 @@ static inline unsigned long resource_type(const struct resource *res)
 {
 	return res->flags & IORESOURCE_TYPE_BITS;
 }
+/* True iff r1 completely contains r2 */
+static inline bool resource_contains(struct resource *r1, struct resource *r2)
+{
+	if (resource_type(r1) != resource_type(r2))
+		return false;
+	if (r1->flags & IORESOURCE_UNSET || r2->flags & IORESOURCE_UNSET)
+		return false;
+	return r1->start <= r2->start && r1->end >= r2->end;
+}
+
 
 /* Convenience shorthand with allocation */
 #define request_region(start,n,name)		__request_region(&ioport_resource, (start), (n), (name), 0)
diff --git a/kernel/resource.c b/kernel/resource.c
index 3f285dce9347..a8344dda7049 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -432,11 +432,6 @@ static void resource_clip(struct resource *res, resource_size_t min,
 		res->end = max;
 }
 
-static bool resource_contains(struct resource *res1, struct resource *res2)
-{
-	return res1->start <= res2->start && res1->end >= res2->end;
-}
-
 /*
  * Find empty slot in the resource tree with the given range and
  * alignment constraints
@@ -471,10 +466,11 @@ static int __find_resource(struct resource *root, struct resource *old,
 		arch_remove_reservations(&tmp);
 
 		/* Check for overflow after ALIGN() */
-		avail = *new;
 		avail.start = ALIGN(tmp.start, constraint->align);
 		avail.end = tmp.end;
+		avail.flags = new->flags & ~IORESOURCE_UNSET;
 		if (avail.start >= tmp.start) {
+			alloc.flags = avail.flags;
 			alloc.start = constraint->alignf(constraint->alignf_data, &avail,
 					size, constraint->align);
 			alloc.end = alloc.start + size - 1;

