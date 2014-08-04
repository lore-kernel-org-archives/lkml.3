Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaHDROd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:14:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56464 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746AbaHDQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        "Roland Dreier" <roland@purestorage.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.285626990@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 82/94] x86, ioremap: Speed up check for RAM pages
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/mm/ioremap.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 597ac15..bc7527e 100644
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

