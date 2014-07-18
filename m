Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161025AbaGRNOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:14:42 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17760 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935041AbaGRNOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:14:38 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Roland Dreier <roland@purestorage.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 169/170] x86, ioremap: Speed up check for RAM pages
Date: Fri, 18 Jul 2014 14:12:54 +0200
Message-Id: <c2e7732e2d1f83ac1edf319a87f5e60cdf189d01.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c81c8a1eeede61e92a15103748c23d100880cc8a upstream.

In __ioremap_caller() (the guts of ioremap), we loop over the range of
pfns being remapped and checks each one individually with page_is_ram().
For large ioremaps, this can be very slow.  For example, we have a
device with a 256 GiB PCI BAR, and ioremapping this BAR can take 20+
seconds -- sometimes long enough to trigger the soft lockup detector!

Internally, page_is_ram() calls walk_system_ram_range() on a single
page.  Instead, we can make a single call to walk_system_ram_range()
from __ioremap_caller(), and do our further checks only for any RAM
pages that we find.  For the common case of MMIO, this saves an enormous
amount of work, since the range being ioremapped doesn't intersect
system RAM at all.

With this change, ioremap on our 256 GiB BAR takes less than 1 second.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Link: http://lkml.kernel.org/r/1399054721-1331-1-git-send-email-roland@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/mm/ioremap.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 799580cabc78..94bd24771812 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -50,6 +50,21 @@ int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 	return err;
 }
 
+static int __ioremap_check_ram(unsigned long start_pfn, unsigned long nr_pages,
+			       void *arg)
+{
+	unsigned long i;
+
+	for (i = 0; i < nr_pages; ++i)
+		if (pfn_valid(start_pfn + i) &&
+		    !PageReserved(pfn_to_page(start_pfn + i)))
+			return 1;
+
+	WARN_ONCE(1, "ioremap on RAM pfn 0x%lx\n", start_pfn);
+
+	return 0;
+}
+
 /*
  * Remap an arbitrary physical address space into the kernel virtual
  * address space. Needed when the kernel wants to access high addresses
@@ -93,14 +108,11 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	/*
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
+	pfn      = phys_addr >> PAGE_SHIFT;
 	last_pfn = last_addr >> PAGE_SHIFT;
-	for (pfn = phys_addr >> PAGE_SHIFT; pfn <= last_pfn; pfn++) {
-		int is_ram = page_is_ram(pfn);
-
-		if (is_ram && pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)))
-			return NULL;
-		WARN_ON_ONCE(is_ram);
-	}
+	if (walk_system_ram_range(pfn, last_pfn - pfn + 1, NULL,
+				  __ioremap_check_ram) == 1)
+		return NULL;
 
 	/*
 	 * Mappings have to be page-aligned
-- 
2.0.0

