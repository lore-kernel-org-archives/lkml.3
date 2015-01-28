Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964987AbbA1Fci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:32:38 -0500
Received: from mail.kernel.org ([198.145.29.136]:36789 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760466AbbA1EN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:13:57 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Douglas Lehr <dllehr@us.ibm.com>,
        Anton Blanchard <anton@samba.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 008/177] PCI: Increase IBM ipr SAS Crocodile BARs to at least system page size
Date: Wed, 28 Jan 2015 12:06:22 +0800
Message-Id: <1422418236-12852-15-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Douglas Lehr <dllehr@us.ibm.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/pci/quirks.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 61bc33e..e587d00 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -28,6 +28,7 @@
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/ktime.h>
+#include <linux/mm.h>
 #include <asm/dma.h>	/* isa_dma_bridge_buggy */
 #include "pci.h"
 
@@ -291,6 +292,25 @@ static void __devinit quirk_citrine(struct pci_dev *dev)
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

