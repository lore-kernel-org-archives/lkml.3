Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaEBSyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 14:54:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50647 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaEBSyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 14:54:44 -0400
Date: Fri, 2 May 2014 11:54:30 -0700
From: tip-bot for Roland Dreier <tipbot@zytor.com>
Message-ID: <tip-c81c8a1eeede61e92a15103748c23d100880cc8a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        roland@purestorage.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        roland@purestorage.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1399054721-1331-1-git-send-email-roland@kernel.org>
References: <1399054721-1331-1-git-send-email-roland@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, ioremap: Speed up check for RAM pages
Git-Commit-ID: c81c8a1eeede61e92a15103748c23d100880cc8a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c81c8a1eeede61e92a15103748c23d100880cc8a
Gitweb:     http://git.kernel.org/tip/c81c8a1eeede61e92a15103748c23d100880cc8a
Author:     Roland Dreier <roland@purestorage.com>
AuthorDate: Fri, 2 May 2014 11:18:41 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 2 May 2014 11:52:26 -0700

x86, ioremap: Speed up check for RAM pages

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
