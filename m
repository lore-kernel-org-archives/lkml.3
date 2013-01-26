Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab3AZBvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:51:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48718 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab3AZBvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:51:38 -0500
Date: Fri, 25 Jan 2013 17:51:23 -0800
From: tip-bot for Dave Hansen <dave@linux.vnet.ibm.com>
Message-ID: <tip-a25b9316841c5afa226f8f70a457861b35276a92@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dave@linux.vnet.ibm.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dave@linux.vnet.ibm.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20130122212430.F46F8159@kernel.stglabs.ibm.com>
References: <20130122212430.F46F8159@kernel.stglabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Make DEBUG_VIRTUAL work earlier in boot
Git-Commit-ID: a25b9316841c5afa226f8f70a457861b35276a92
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 17:51:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a25b9316841c5afa226f8f70a457861b35276a92
Gitweb:     http://git.kernel.org/tip/a25b9316841c5afa226f8f70a457861b35276a92
Author:     Dave Hansen <dave@linux.vnet.ibm.com>
AuthorDate: Tue, 22 Jan 2013 13:24:30 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 25 Jan 2013 16:33:22 -0800

x86, mm: Make DEBUG_VIRTUAL work earlier in boot

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
Link: http://lkml.kernel.org/r/20130122212430.F46F8159@kernel.stglabs.ibm.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa.c     | 2 +-
 arch/x86/mm/pat.c      | 4 ++--
 arch/x86/mm/physaddr.c | 9 ++++++++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 2d125be..76604eb 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -219,7 +219,7 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 	 */
 	nd = alloc_remap(nid, nd_size);
 	if (nd) {
-		nd_pa = __pa(nd);
+		nd_pa = __phys_addr_nodebug(nd);
 		remapped = true;
 	} else {
 		nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 0eb572e..2610bd9 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -560,10 +560,10 @@ int kernel_map_sync_memtype(u64 base, unsigned long size, unsigned long flags)
 {
 	unsigned long id_sz;
 
-	if (base >= __pa(high_memory))
+	if (base > __pa(high_memory-1))
 		return 0;
 
-	id_sz = (__pa(high_memory) < base + size) ?
+	id_sz = (__pa(high_memory-1) <= base + size) ?
 				__pa(high_memory) - base :
 				size;
 
diff --git a/arch/x86/mm/physaddr.c b/arch/x86/mm/physaddr.c
index c73fedd..e666cbb 100644
--- a/arch/x86/mm/physaddr.c
+++ b/arch/x86/mm/physaddr.c
@@ -1,3 +1,4 @@
+#include <linux/bootmem.h>
 #include <linux/mmdebug.h>
 #include <linux/module.h>
 #include <linux/mm.h>
@@ -68,10 +69,16 @@ EXPORT_SYMBOL(__virt_addr_valid);
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
