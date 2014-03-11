Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaCKRnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:43:04 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57762 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbaCKRnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:43:00 -0400
Subject: [PATCH 3/5] PCI: Check all IORESOURCE_TYPE_BITS in
 pci_bus_alloc_from_region()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 11 Mar 2014 11:42:57 -0600
Message-ID: <20140311174257.23084.80235.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140311173556.23084.57635.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140311173556.23084.57635.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocating space from a bus resource, i.e., from apertures leading to
this bus, make sure the entire resource type matches.  The previous code
assumed the IORESOURCE_TYPE_BITS field was a bitmask with only a single bit
set, but this is not true.  IORESOURCE_TYPE_BITS is really an enumeration,
and we have to check all the bits.

See 72dcb1197228 ("resources: Add register address resource type").

No functional change.  If we used this path for allocating IRQs, DMA
channels, or bus numbers, this would fix a bug because those types are
indistinguishable when masked by IORESOURCE_IO | IORESOURCE_MEM.  But we
don't, so this shouldn't make any difference.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 38901665c770..e3bdc88668ec 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -144,7 +144,7 @@ static int pci_bus_alloc_from_region(struct pci_bus *bus, struct resource *res,
 	struct resource *r, avail;
 	resource_size_t max;
 
-	type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
+	type_mask |= IORESOURCE_TYPE_BITS;
 
 	pci_bus_for_each_resource(bus, r, i) {
 		if (!r)

