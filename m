Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965050Ab3DJWvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:51:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937647Ab3DJWu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:50:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [ 17/19] x86-32, mm: Rip out x86_32 NUMA remapping code
Date: Wed, 10 Apr 2013 15:50:40 -0700
Message-Id: <20130410225028.591009147@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410225026.833809117@linuxfoundation.org>
References: <20130410225026.833809117@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave@linux.vnet.ibm.com>

commit f03574f2d5b2d6229dcdf2d322848065f72953c7 upstream.

This code was an optimization for 32-bit NUMA systems.

It has probably been the cause of a number of subtle bugs over
the years, although the conditions to excite them would have
been hard to trigger.  Essentially, we remap part of the kernel
linear mapping area, and then sometimes part of that area gets
freed back in to the bootmem allocator.  If those pages get
used by kernel data structures (say mem_map[] or a dentry),
there's no big deal.  But, if anyone ever tried to use the
linear mapping for these pages _and_ cared about their physical
address, bad things happen.

For instance, say you passed __GFP_ZERO to the page allocator
and then happened to get handed one of these pages, it zero the
remapped page, but it would make a pte to the _old_ page.
There are probably a hundred other ways that it could screw
with things.

We don't need to hang on to performance optimizations for
these old boxes any more.  All my 32-bit NUMA systems are long
dead and buried, and I probably had access to more than most
people.

This code is causing real things to break today:

	https://lkml.org/lkml/2013/1/9/376

I looked in to actually fixing this, but it requires surgery
to way too much brittle code, as well as stuff like
per_cpu_ptr_to_phys().

[ hpa: Cc: this for -stable, since it is a memory corruption issue.
  However, an alternative is to simply mark NUMA as depends BROKEN
  rather than EXPERIMENTAL in the X86_32 subclause... ]

Link: http://lkml.kernel.org/r/20130131005616.1C79F411@kernel.stglabs.ibm.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/Kconfig            |    4 ----
 arch/x86/mm/numa.c          |    3 ---
 arch/x86/mm/numa_internal.h |    6 ------
 3 files changed, 13 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1219,10 +1219,6 @@ config HAVE_ARCH_BOOTMEM
 	def_bool y
 	depends on X86_32 && NUMA
 
-config HAVE_ARCH_ALLOC_REMAP
-	def_bool y
-	depends on X86_32 && NUMA
-
 config ARCH_HAVE_MEMORY_PRESENT
 	def_bool y
 	depends on X86_32 && DISCONTIGMEM
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -207,9 +207,6 @@ static void __init setup_node_data(int n
 	if (end && (end - start) < NODE_MIN_SIZE)
 		return;
 
-	/* initialize remap allocator before aligning to ZONE_ALIGN */
-	init_alloc_remap(nid, start, end);
-
 	start = roundup(start, ZONE_ALIGN);
 
 	printk(KERN_INFO "Initmem setup node %d %016Lx-%016Lx\n",
--- a/arch/x86/mm/numa_internal.h
+++ b/arch/x86/mm/numa_internal.h
@@ -21,12 +21,6 @@ void __init numa_reset_distance(void);
 
 void __init x86_numa_init(void);
 
-#ifdef CONFIG_X86_64
-static inline void init_alloc_remap(int nid, u64 start, u64 end)	{ }
-#else
-void __init init_alloc_remap(int nid, u64 start, u64 end);
-#endif
-
 #ifdef CONFIG_NUMA_EMU
 void __init numa_emulation(struct numa_meminfo *numa_meminfo,
 			   int numa_dist_cnt);


