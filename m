Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab3AVVZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:25:14 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:49936 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab3AVVZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:25:01 -0500
Subject: [PATCH 1/5] make DEBUG_VIRTUAL work earlier in boot
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Gleb Natapov <gleb@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 22 Jan 2013 13:24:30 -0800
References: <20130122212428.8DF70119@kernel.stglabs.ibm.com>
In-Reply-To: <20130122212428.8DF70119@kernel.stglabs.ibm.com>
Message-Id: <20130122212430.F46F8159@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012221-2876-0000-0000-000004652042
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The KVM code has some repeated bugs in it around use of __pa() on
per-cpu data.  Those data are not in an area on which using
__pa() is valid.  However, they are also called early enough in
boot that __vmalloc_start_set is not set, and thus the
CONFIG_DEBUG_VIRTUAL debugging does not catch them.

This adds a check to also verify __pa() calls against max_low_pfn,
which we can use earler in boot than is_vmalloc_addr().  However,
if we are super-early in boot, max_low_pfn=0 and this will trip
on every call, so also make sure that max_low_pfn is set before
we try to use it.

With this patch applied, CONFIG_DEBUG_VIRTUAL will actually
catch the bug I was chasing (and fix later in this series).

I'd love to find a generic way so that any __pa() call on percpu
areas could do a BUG_ON(), but there don't appear to be any nice
and easy ways to check if an address is a percpu one.  Anybody
have ideas on a way to do this?

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/mm/numa.c     |    2 +-
 linux-2.6.git-dave/arch/x86/mm/pat.c      |    4 ++--
 linux-2.6.git-dave/arch/x86/mm/physaddr.c |    9 ++++++++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/numa.c~make-DEBUG_VIRTUAL-work-earlier-in-boot arch/x86/mm/numa.c
--- linux-2.6.git/arch/x86/mm/numa.c~make-DEBUG_VIRTUAL-work-earlier-in-boot	2013-01-22 13:17:15.128306679 -0800
+++ linux-2.6.git-dave/arch/x86/mm/numa.c	2013-01-22 13:17:15.136306745 -0800
@@ -219,7 +219,7 @@ static void __init setup_node_data(int n
 	 */
 	nd = alloc_remap(nid, nd_size);
 	if (nd) {
-		nd_pa = __pa(nd);
+		nd_pa = __phys_addr_nodebug(nd);
 		remapped = true;
 	} else {
 		nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
diff -puN arch/x86/mm/pat.c~make-DEBUG_VIRTUAL-work-earlier-in-boot arch/x86/mm/pat.c
--- linux-2.6.git/arch/x86/mm/pat.c~make-DEBUG_VIRTUAL-work-earlier-in-boot	2013-01-22 13:17:15.128306679 -0800
+++ linux-2.6.git-dave/arch/x86/mm/pat.c	2013-01-22 13:17:15.136306745 -0800
@@ -560,10 +560,10 @@ int kernel_map_sync_memtype(u64 base, un
 {
 	unsigned long id_sz;
 
-	if (base >= __pa(high_memory))
+	if (base > __pa(high_memory-1))
 		return 0;
 
-	id_sz = (__pa(high_memory) < base + size) ?
+	id_sz = (__pa(high_memory-1) <= base + size) ?
 				__pa(high_memory) - base :
 				size;
 
diff -puN arch/x86/mm/physaddr.c~make-DEBUG_VIRTUAL-work-earlier-in-boot arch/x86/mm/physaddr.c
--- linux-2.6.git/arch/x86/mm/physaddr.c~make-DEBUG_VIRTUAL-work-earlier-in-boot	2013-01-22 13:17:15.132306712 -0800
+++ linux-2.6.git-dave/arch/x86/mm/physaddr.c	2013-01-22 13:17:15.136306745 -0800
@@ -1,3 +1,4 @@
+#include <linux/bootmem.h>
 #include <linux/mmdebug.h>
 #include <linux/module.h>
 #include <linux/mm.h>
@@ -47,10 +48,16 @@ EXPORT_SYMBOL(__virt_addr_valid);
 #ifdef CONFIG_DEBUG_VIRTUAL
 unsigned long __phys_addr(unsigned long x)
 {
+	unsigned long phys_addr = x - PAGE_OFFSET;
 	/* VMALLOC_* aren't constants  */
 	VIRTUAL_BUG_ON(x < PAGE_OFFSET);
 	VIRTUAL_BUG_ON(__vmalloc_start_set && is_vmalloc_addr((void *) x));
-	return x - PAGE_OFFSET;
+	/* max_low_pfn is set early, but not _that_ early */
+	if (max_low_pfn) {
+		VIRTUAL_BUG_ON((phys_addr >> PAGE_SHIFT) > max_low_pfn);
+		BUG_ON(slow_virt_to_phys((void *)x) != phys_addr);
+	}
+	return phys_addr;
 }
 EXPORT_SYMBOL(__phys_addr);
 #endif
_

