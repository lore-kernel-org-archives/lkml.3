Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaHTX04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 19:26:56 -0400
Received: from ozlabs.org ([103.22.144.67]:53184 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbaHTX0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 19:26:54 -0400
Date: Thu, 21 Aug 2014 09:26:52 +1000
From: Anton Blanchard <anton@samba.org>
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, dllehr@us.ibm.com, miltonm@us.ibm.com
Subject: [PATCH] PCI: Increase BAR size quirk for IBM ipr SAS Crocodile
 adapters
Message-ID: <20140821092652.604d7484@kryten>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Douglas Lehr <dllehr@us.ibm.com>

The Crocodile chip occasionally comes up with 4k and 8k BAR sizes.
Due to an errata, setting the SR-IOV page size causes the physical
function BARs to expand to the system page size.  Since ppc64 uses
64k pages, when Linux tries to assign the smaller resource sizes
to the now 64k BARs the address will be truncated and the BARs will
overlap.

This quirk will force Linux to allocate the resource as a full page,
which will avoid the overlap.

Cc: <stable@vger.kernel.org> 
Signed-off-by: Douglas Lehr <dllehr@us.ibm.com>
Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Milton Miller <miltonm@us.ibm.com>
---
 drivers/pci/quirks.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 80c2d01..45b946d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -24,6 +24,7 @@
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/ktime.h>
+#include <linux/mm.h>
 #include <asm/dma.h>	/* isa_dma_bridge_buggy */
 #include "pci.h"
 
@@ -287,6 +288,24 @@ static void quirk_citrine(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_IBM,	PCI_DEVICE_ID_IBM_CITRINE,	quirk_citrine);
 
+/*  On IBM Crocodile ipr SAS adapters, expand bar size to system page size. */
+static void quirk_extend_bar_to_page(struct pci_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < PCI_STD_RESOURCE_END; i++) {
+		struct resource *r = &dev->resource[i];
+
+		if (r->flags & IORESOURCE_MEM && resource_size(r) < PAGE_SIZE) {
+			dev_info(&dev->dev, "Setting Bar size to Page size");
+			r->end = PAGE_SIZE-1;
+			r->start = 0;
+			r->flags |= IORESOURCE_UNSET;
+		}
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_IBM, 0x034a, quirk_extend_bar_to_page);
+
 /*
  *  S3 868 and 968 chips report region size equal to 32M, but they decode 64M.
  *  If it's needed, re-allocate the region.
-- 
1.7.9.5

