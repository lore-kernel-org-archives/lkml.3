Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbaLLG7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:59:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51727 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758614AbaLLGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Bjorn Helgaas" <bhelgaas@google.com>,
        "Douglas Lehr" <dllehr@us.ibm.com>,
        "Anton Blanchard" <anton@samba.org>,
        "Milton Miller" <miltonm@us.ibm.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.102134355@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 009/164] PCI: Increase IBM ipr SAS Crocodile BARs to
 at least system page size
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Lehr <dllehr@us.ibm.com>

commit 9fe373f9997b48fcd6222b95baf4a20c134b587a upstream.

The Crocodile chip occasionally comes up with 4k and 8k BAR sizes.  Due to
an erratum, setting the SR-IOV page size causes the physical function BARs
to expand to the system page size.  Since ppc64 uses 64k pages, when Linux
tries to assign the smaller resource sizes to the now 64k BARs the address
will be truncated and the BARs will overlap.

Force Linux to allocate the resource as a full page, which avoids the
overlap.

[bhelgaas: print expanded resource, too]
Signed-off-by: Douglas Lehr <dllehr@us.ibm.com>
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Milton Miller <miltonm@us.ibm.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/quirks.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -26,6 +26,7 @@
 #include <linux/dmi.h>
 #include <linux/pci-aspm.h>
 #include <linux/ioport.h>
+#include <linux/mm.h>
 #include <asm/dma.h>	/* isa_dma_bridge_buggy */
 #include "pci.h"
 
@@ -352,6 +353,25 @@ static void __devinit quirk_citrine(stru
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_IBM,	PCI_DEVICE_ID_IBM_CITRINE,	quirk_citrine);
 
+/*  On IBM Crocodile ipr SAS adapters, expand BAR to system page size */
+static void quirk_extend_bar_to_page(struct pci_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < PCI_STD_RESOURCE_END; i++) {
+		struct resource *r = &dev->resource[i];
+
+		if (r->flags & IORESOURCE_MEM && resource_size(r) < PAGE_SIZE) {
+			r->end = PAGE_SIZE - 1;
+			r->start = 0;
+			r->flags |= IORESOURCE_UNSET;
+			dev_info(&dev->dev, "expanded BAR %d to page size: %pR\n",
+				 i, r);
+		}
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_IBM, 0x034a, quirk_extend_bar_to_page);
+
 /*
  *  S3 868 and 968 chips report region size equal to 32M, but they decode 64M.
  *  If it's needed, re-allocate the region.

