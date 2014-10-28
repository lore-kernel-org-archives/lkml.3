Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbaJ1E1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:27:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933980AbaJ1Dw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:52:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Douglas Lehr <dllehr@us.ibm.com>, Anton Blanchard <anton@samba.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Milton Miller <miltonm@us.ibm.com>
Subject: [PATCH 3.10 29/43] PCI: Increase IBM ipr SAS Crocodile BARs to at least system page size
Date: Tue, 28 Oct 2014 11:36:27 +0800
Message-Id: <20141028033524.655940944@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033523.407092670@linuxfoundation.org>
References: <20141028033523.407092670@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/quirks.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -28,6 +28,7 @@
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/ktime.h>
+#include <linux/mm.h>
 #include <asm/dma.h>	/* isa_dma_bridge_buggy */
 #include "pci.h"
 
@@ -291,6 +292,25 @@ static void quirk_citrine(struct pci_dev
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


