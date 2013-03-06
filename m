Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3CFXKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:10:37 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:40689 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab3CFXKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:10:36 -0500
Subject: [PATCH] do not try to sync identity map for non-mapped pages
To: linux-kernel@vger.kernel.org
Cc: bp@alien8.de, hpa@linux.intel.com, penguin-kernel@i-love.sakura.ne.jp,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 06 Mar 2013 15:10:09 -0800
Message-Id: <20130306231009.D782087E@kernel.stglabs.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030623-4834-0000-0000-0000046418CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


kernel_map_sync_memtype() is called from a variety of contexts.  The
pat.c code that calls it seems to ensure that it is not called for
non-ram areas by checking via pat_pagerange_is_ram().  It is important
that it only be called on the actual identity map because there *IS*
no map to sync for highmem pages, or for memory holes.

The ioremap.c uses are not as careful as those from pat.c, and call
kernel_map_sync_memtype() on PCI space which is in the middle of the
kernel identity map _range_, but is not actually mapped.

This patch adds a check to kernel_map_sync_memtype() which probably
duplicates some of the checks already in pat.c.  But, it is necessary
for the ioremap.c uses and shouldn't hurt other callers.

I have reproduced this bug and this patch fixes it for me

	https://lkml.org/lkml/2013/2/5/396

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/mm/pat.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN arch/x86/mm/pat.c~dont-flush-map-for-non-ram-pages arch/x86/mm/pat.c
--- linux-2.6.git/arch/x86/mm/pat.c~dont-flush-map-for-non-ram-pages	2013-03-06 15:03:56.403628100 -0800
+++ linux-2.6.git-dave/arch/x86/mm/pat.c	2013-03-06 15:03:56.419628258 -0800
@@ -563,6 +563,13 @@ int kernel_map_sync_memtype(u64 base, un
 	if (base > __pa(high_memory-1))
 		return 0;
 
+	/*
+	 * some areas in the middle of the kernel identity range
+	 * are not mapped, like the PCI space.
+	 */
+	if (!page_is_ram(base >> PAGE_SHIFT))
+		return 0;
+
 	id_sz = (__pa(high_memory-1) <= base + size) ?
 				__pa(high_memory) - base :
 				size;
diff -puN arch/x86/mm/ioremap.c~dont-flush-map-for-non-ram-pages arch/x86/mm/ioremap.c
_

