Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaL3Qfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 11:35:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbaL3Qfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 11:35:51 -0500
Date: Tue, 30 Dec 2014 18:35:33 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, cornelia.huck@de.ibm.com,
        trivial@kernel.org, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com
Subject: [PATCH RFC v2 1/7] mn10300: drop dead code
Message-ID: <1419957310-26009-2-git-send-email-mst@redhat.com>
References: <1419957310-26009-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419957310-26009-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci-iomap.c was (apparently, mistakenly) reintroduced as part of
commit 83c2dc15ce824450e7044b9f90cd529c25747ae0
    MN10300: Handle cacheable PCI regions in pci_iomap()
probably as side-effect of forward-porting the patch
from an old kernel.

It's not really needed: the generic pci_iomap does the right thing here.

The new file isn't compiled so it's safe to drop.

Cc: trivial@kernel.org
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/mn10300/unit-asb2305/pci-iomap.c | 35 -----------------------------------
 1 file changed, 35 deletions(-)
 delete mode 100644 arch/mn10300/unit-asb2305/pci-iomap.c

diff --git a/arch/mn10300/unit-asb2305/pci-iomap.c b/arch/mn10300/unit-asb2305/pci-iomap.c
deleted file mode 100644
index bd65dae..0000000
--- a/arch/mn10300/unit-asb2305/pci-iomap.c
+++ /dev/null
@@ -1,35 +0,0 @@
-/* ASB2305 PCI I/O mapping handler
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#include <linux/pci.h>
-#include <linux/module.h>
-
-/*
- * Create a virtual mapping cookie for a PCI BAR (memory or IO)
- */
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
-{
-	resource_size_t start = pci_resource_start(dev, bar);
-	resource_size_t len = pci_resource_len(dev, bar);
-	unsigned long flags = pci_resource_flags(dev, bar);
-
-	if (!len || !start)
-		return NULL;
-
-	if ((flags & IORESOURCE_IO) || (flags & IORESOURCE_MEM)) {
-		if (flags & IORESOURCE_CACHEABLE && !(flags & IORESOURCE_IO))
-			return ioremap(start, len);
-		else
-			return ioremap_nocache(start, len);
-	}
-
-	return NULL;
-}
-EXPORT_SYMBOL(pci_iomap);
-- 
MST

