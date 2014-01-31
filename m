Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbaAaKFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:05:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072AbaAaKFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:05:22 -0500
Date: Fri, 31 Jan 2014 11:05:17 +0100
From: Petr Tesarik <ptesarik@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix the initialization of physnode_map
Message-ID: <20140131110517.4b7e86d6@hananiah.suse.cz>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With DISCONTIGMEM, the mapping between a pfn and its owning node is
initialized using data provided by the BIOS or from the command line.
However, the initialization may fail if the extents are not aligned
to section boundary (64M).

The symptom of this bug is an early boot failure in pfn_to_page(),
as it tries to access NODE_DATA(__nid) using index from an unitialized
element of the physnode_map[] array.

While the bug is always present, it is more likely to be hit in kdump
kernels on large machines, because:

1. The memory map for a kdump kernel is specified as exactmap, and
   exactmap is more likely to be unaligned.

2. Large reservations are more likely to span across a 64M boundary.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/mm/numa_32.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 0342d27..f278b04 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -46,15 +46,16 @@ EXPORT_SYMBOL(physnode_map);
 
 void memory_present(int nid, unsigned long start, unsigned long end)
 {
-	unsigned long pfn;
+	unsigned long sect, endsect;
 
 	printk(KERN_INFO "Node: %d, start_pfn: %lx, end_pfn: %lx\n",
 			nid, start, end);
 	printk(KERN_DEBUG "  Setting physnode_map array to node %d for pfns:\n", nid);
 	printk(KERN_DEBUG "  ");
-	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
-		physnode_map[pfn / PAGES_PER_SECTION] = nid;
-		printk(KERN_CONT "%lx ", pfn);
+	endsect = (end - 1) / PAGES_PER_SECTION;
+	for (sect = start / PAGES_PER_SECTION; sect <= endsect; ++sect) {
+		physnode_map[sect] = nid;
+		printk(KERN_CONT "%lx ", sect * PAGES_PER_SECTION);
 	}
 	printk(KERN_CONT "\n");
 }
-- 
1.8.4.5
