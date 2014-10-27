Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbaJ0T0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:26:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52428 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaJ0S5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:57:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Douglas Lehr <dllehr@us.ibm.com>, Anton Blanchard <anton@samba.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 017/105] PCI: Increase IBM ipr SAS Crocodile BARs to at least system page size
Date: Mon, 27 Oct 2014 11:55:52 -0700
Message-Id: <1414436240-13879-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/pci/quirks.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index fbc066d..0fdf4d1 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -24,6 +24,7 @@
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/ktime.h>
+#include <linux/mm.h>
 #include <asm/dma.h>	/* isa_dma_bridge_buggy */
 #include "pci.h"
 
@@ -287,6 +288,25 @@ static void quirk_citrine(struct pci_dev *dev)
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
-- 
1.9.1

