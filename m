Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbaH2TQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:16:53 -0400
Received: from relay1.sgi.com ([192.48.180.66]:56448 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbaH2TQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:16:50 -0400
Message-Id: <20140829191647.744730085@asylum.americas.sgi.com>
References: <20140829191647.364032240@asylum.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Aug 2014 14:16:49 -0500
From: Mike Travis <travis@sgi.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
Cc: akpm@linux-foundation.org, msalter@redhat.com, dyoung@redhat.com,
        riel@redhat.com, peterz@infradead.org, mgorman@suse.de,
        linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        Alex Thorlton <athorlton@sgi.com>
Subject: [PATCH 2/2] x86: Use optimized ioresource lookup in ioremap function
Content-Disposition: inline; filename=use-get-resource-type
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the optimized ioresource lookup, "region_is_ram", for
the ioremap function.  If the region is not found, it falls back to the
"page_is_ram" function.  If it is found and it is RAM, then the usual
warning message is issued, and the ioremap operation is aborted.
Otherwise, the ioremap operation continues.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Alex Thorlton <athorlton@sgi.com>
Reviewed-by: Cliff Wickman <cpw@sgi.com>
---
v2: slight rearrangement of code
---
 arch/x86/mm/ioremap.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- linux.orig/arch/x86/mm/ioremap.c
+++ linux/arch/x86/mm/ioremap.c
@@ -86,6 +86,7 @@ static void __iomem *__ioremap_caller(re
 	pgprot_t prot;
 	int retval;
 	void __iomem *ret_addr;
+	int ram_region;
 
 	/* Don't allow wraparound or zero size */
 	last_addr = phys_addr + size - 1;
@@ -108,12 +109,23 @@ static void __iomem *__ioremap_caller(re
 	/*
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
-	pfn      = phys_addr >> PAGE_SHIFT;
-	last_pfn = last_addr >> PAGE_SHIFT;
-	if (walk_system_ram_range(pfn, last_pfn - pfn + 1, NULL,
-				  __ioremap_check_ram) == 1)
+	/* First check if whole region can be identified as RAM or not */
+	ram_region = region_is_ram(phys_addr, size);
+	if (ram_region > 0) {
+		WARN_ONCE(1, "ioremap on RAM at 0x%lx - 0x%lx\n",
+				(unsigned long int)phys_addr,
+				(unsigned long int)last_addr);
 		return NULL;
+	}
 
+	/* If could not be identified(-1), check page by page */
+	if (ram_region < 0) {
+		pfn      = phys_addr >> PAGE_SHIFT;
+		last_pfn = last_addr >> PAGE_SHIFT;
+		if (walk_system_ram_range(pfn, last_pfn - pfn + 1, NULL,
+					  __ioremap_check_ram) == 1)
+			return NULL;
+	}
 	/*
 	 * Mappings have to be page-aligned
 	 */

-- 
