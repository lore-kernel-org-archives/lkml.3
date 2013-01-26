Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3AZBzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:55:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48772 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3AZBzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:55:08 -0500
Date: Fri, 25 Jan 2013 17:54:52 -0800
From: tip-bot for Dave Hansen <dave@linux.vnet.ibm.com>
Message-ID: <tip-d765653445129b7c476758040e3079480775f80a@git.kernel.org>
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dave@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        riel@redhat.com, dave@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20130122212433.4D1FCA62@kernel.stglabs.ibm.com>
References: <20130122212433.4D1FCA62@kernel.stglabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Create slow_virt_to_phys()
Git-Commit-ID: d765653445129b7c476758040e3079480775f80a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 17:54:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d765653445129b7c476758040e3079480775f80a
Gitweb:     http://git.kernel.org/tip/d765653445129b7c476758040e3079480775f80a
Author:     Dave Hansen <dave@linux.vnet.ibm.com>
AuthorDate: Tue, 22 Jan 2013 13:24:33 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 25 Jan 2013 16:33:23 -0800

x86, mm: Create slow_virt_to_phys()

This is necessary because __pa() does not work on some kinds of
memory, like vmalloc() or the alloc_remap() areas on 32-bit
NUMA systems.  We have some functions to do conversions _like_
this in the vmalloc() code (like vmalloc_to_page()), but they
do not work on sizes other than 4k pages.  We would potentially
need to be able to handle all the page sizes that we use for
the kernel linear mapping (4k, 2M, 1G).

In practice, on 32-bit NUMA systems, the percpu areas get stuck
in the alloc_remap() area.  Any __pa() call on them will break
and basically return garbage.

This patch introduces a new function slow_virt_to_phys(), which
walks the kernel page tables on x86 and should do precisely
the same logical thing as __pa(), but actually work on a wider
range of memory.  It should work on the normal linear mapping,
vmalloc(), kmap(), etc...

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20130122212433.4D1FCA62@kernel.stglabs.ibm.com
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/pgtable_types.h |  1 +
 arch/x86/mm/pageattr.c               | 31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 6c297e7..9f82690 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -352,6 +352,7 @@ static inline void update_page_count(int level, unsigned long pages) { }
  * as a pte too.
  */
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
+extern phys_addr_t slow_virt_to_phys(void *__address);
 
 #endif	/* !__ASSEMBLY__ */
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 2a5c9ab..6d13d2a 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -364,6 +364,37 @@ pte_t *lookup_address(unsigned long address, unsigned int *level)
 EXPORT_SYMBOL_GPL(lookup_address);
 
 /*
+ * This is necessary because __pa() does not work on some
+ * kinds of memory, like vmalloc() or the alloc_remap()
+ * areas on 32-bit NUMA systems.  The percpu areas can
+ * end up in this kind of memory, for instance.
+ *
+ * This could be optimized, but it is only intended to be
+ * used at inititalization time, and keeping it
+ * unoptimized should increase the testing coverage for
+ * the more obscure platforms.
+ */
+phys_addr_t slow_virt_to_phys(void *__virt_addr)
+{
+	unsigned long virt_addr = (unsigned long)__virt_addr;
+	phys_addr_t phys_addr;
+	unsigned long offset;
+	enum pg_level level;
+	unsigned long psize;
+	unsigned long pmask;
+	pte_t *pte;
+
+	pte = lookup_address(virt_addr, &level);
+	BUG_ON(!pte);
+	psize = page_level_size(level);
+	pmask = page_level_mask(level);
+	offset = virt_addr & ~pmask;
+	phys_addr = pte_pfn(*pte) << PAGE_SHIFT;
+	return (phys_addr | offset);
+}
+EXPORT_SYMBOL_GPL(slow_virt_to_phys);
+
+/*
  * Set the new pmd in all the pgds we know about:
  */
 static void __set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte)
