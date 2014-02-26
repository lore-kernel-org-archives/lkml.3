Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbaBZTha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:37:30 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:56502 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbaBZThZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:37:25 -0500
Subject: [PATCH 3/9] PCI: Remove pci_find_parent_resource() use for
 allocation
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 12:37:23 -0700
Message-ID: <20140226193723.10125.15799.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the resource hasn't been allocated yet, pci_find_parent_resource() is
documented as returning the region "where it should be allocated from."
This is impossible in general because there may be several candidates: a
prefetchable BAR can be put in either a prefetchable or non-prefetchable
window, a transparent bridge may have overlapping positively- and
subtractively-decoded windows, and a root bus may have several windows of
the same type.

Allocation should be done by pci_bus_alloc_resource(), which iterates
through all bus resources and looks for the best match, e.g., one with the
desired prefetchability attributes, and falls back to less-desired
possibilities.

The only valid use of pci_find_parent_resource() is to find the parent of
an already-allocated resource so we can claim it via request_resource(),
and all we need for that is a bus region of the correct type that contains
the resource.

Note that like 8c8def26bfaa ("PCI: allow matching of prefetchable resources
to non-prefetchable windows"), this depends on pci_bus_for_each_resource()
iterating through positively-decoded regions before subtractively-decoded
ones.  We prefer not to return a subtractively-decoded region because
requesting from it will likely conflict with the overlapping positively-
decoded window (see Launchpad report below).

Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/424142
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
---
 drivers/pci/pci.c |   39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 1febe90831b4..99293fa40db9 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -401,33 +401,40 @@ EXPORT_SYMBOL_GPL(pci_find_ht_capability);
  * @res: child resource record for which parent is sought
  *
  *  For given resource region of given device, return the resource
- *  region of parent bus the given region is contained in or where
- *  it should be allocated from.
+ *  region of parent bus the given region is contained in.
  */
 struct resource *
 pci_find_parent_resource(const struct pci_dev *dev, struct resource *res)
 {
 	const struct pci_bus *bus = dev->bus;
+	struct resource *r;
 	int i;
-	struct resource *best = NULL, *r;
 
 	pci_bus_for_each_resource(bus, r, i) {
 		if (!r)
 			continue;
-		if (res->start && !(res->start >= r->start && res->end <= r->end))
-			continue;	/* Not contained */
-		if ((res->flags ^ r->flags) & (IORESOURCE_IO | IORESOURCE_MEM))
-			continue;	/* Wrong type */
-		if (!((res->flags ^ r->flags) & IORESOURCE_PREFETCH))
-			return r;	/* Exact match */
-		/* We can't insert a non-prefetch resource inside a prefetchable parent .. */
-		if (r->flags & IORESOURCE_PREFETCH)
-			continue;
-		/* .. but we can put a prefetchable resource inside a non-prefetchable one */
-		if (!best)
-			best = r;
+		if (res->start && resource_contains(r, res)) {
+
+			/*
+			 * If the window is prefetchable but the BAR is
+			 * not, the allocator made a mistake.
+			 */
+			if (r->flags & IORESOURCE_PREFETCH &&
+			    !(res->flags & IORESOURCE_PREFETCH))
+				return NULL;
+
+			/*
+			 * If we're below a transparent bridge, there may
+			 * be both a positively-decoded aperture and a
+			 * subtractively-decoded region that contain the BAR.
+			 * We want the positively-decoded one, so this depends
+			 * on pci_bus_for_each_resource() giving us those
+			 * first.
+			 */
+			return r;
+		}
 	}
-	return best;
+	return NULL;
 }
 
 /**

