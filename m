Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbaBAMa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 07:30:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59346 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbaBAMaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 07:30:25 -0500
Date: Sat, 1 Feb 2014 13:30:19 +0100
From: Petr Tesarik <ptesarik@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org
Subject: [PATCHv2] x86: fix the initialization of physnode_map
Message-ID: <20140201133019.32e56f86@hananiah.suse.cz>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With DISCONTIGMEM, the mapping between a pfn and its owning node is
initialized using data provided by the BIOS. However, the initialization
may fail if the extents are not aligned to section boundary (64M).

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
 arch/x86/mm/numa_32.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 0342d27..8c62ec6 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -52,6 +52,8 @@ void memory_present(int nid, unsigned long start, unsigned long end)
 			nid, start, end);
 	printk(KERN_DEBUG "  Setting physnode_map array to node %d for pfns:\n", nid);
 	printk(KERN_DEBUG "  ");
+	pfn = round_down(pfn, PAGES_PER_SECTION);
+	end = round_up(end, PAGES_PER_SECTION);
 	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
 		physnode_map[pfn / PAGES_PER_SECTION] = nid;
 		printk(KERN_CONT "%lx ", pfn);
-- 
1.8.4.5
