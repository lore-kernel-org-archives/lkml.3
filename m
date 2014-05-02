Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaEBSSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 14:18:47 -0400
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:60682 "HELO
	na3sys010aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752569AbaEBSSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 14:18:46 -0400
From: Roland Dreier <roland@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Sandeep Mann <sandeep@purestorage.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86, ioremap: Speed up check for RAM pages
Date: Fri,  2 May 2014 11:18:41 -0700
Message-Id: <1399054721-1331-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

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
---
 arch/x86/mm/ioremap.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 597ac155c91c..bc7527e109c8 100644
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
1.9.1

