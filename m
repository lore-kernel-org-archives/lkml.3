Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbaKSBoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 20:44:44 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43616 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbaKSBom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 20:44:42 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Vrabel <david.vrabel@citrix.com>, Wang Nan <wangnan0@huawei.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/3] x86, 64bit: add pfn_range_is_highmapped()
Date: Tue, 18 Nov 2014 17:44:15 -0800
Message-Id: <1416361456-11060-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1416361456-11060-1-git-send-email-yinghai@kernel.org>
References: <1416361456-11060-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need to use it to support holes in highmap when remove not
used range in highmap.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/pgtable_64.h |    2 ++
 arch/x86/mm/init_64.c             |   22 ++++++++++++++++++++++
 arch/x86/mm/pageattr.c            |   16 +---------------
 3 files changed, 25 insertions(+), 15 deletions(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -378,6 +378,23 @@ void __init init_extra_mapping_uc(unsign
 	__init_extra_mapping(phys, size, _PAGE_CACHE_MODE_UC);
 }
 
+/* three holes at most*/
+#define NR_RANGE 4
+static struct range pfn_highmapped[NR_RANGE];
+static int nr_pfn_highmapped;
+
+int pfn_range_is_highmapped(unsigned long start_pfn, unsigned long end_pfn)
+{
+	int i;
+
+	for (i = 0; i < nr_pfn_highmapped; i++)
+		if ((start_pfn >= pfn_highmapped[i].start) &&
+		    (end_pfn <= pfn_highmapped[i].end))
+			return 1;
+
+	return 0;
+}
+
 /*
  * The head.S code sets up the kernel high mapping:
  *
@@ -412,6 +429,11 @@ void __init cleanup_highmap(void)
 		if (vaddr < (unsigned long) _text || vaddr > end)
 			set_pmd(pmd, __pmd(0));
 	}
+
+	nr_pfn_highmapped = add_range(pfn_highmapped, NR_RANGE,
+			nr_pfn_highmapped,
+			__pa_symbol(_text) >> PAGE_SHIFT,
+			__pa_symbol(roundup(_brk_end, PMD_SIZE)) >> PAGE_SHIFT);
 }
 
 static unsigned long __meminit
Index: linux-2.6/arch/x86/mm/pageattr.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pageattr.c
+++ linux-2.6/arch/x86/mm/pageattr.c
@@ -91,20 +91,6 @@ void arch_report_meminfo(struct seq_file
 static inline void split_page_count(int level) { }
 #endif
 
-#ifdef CONFIG_X86_64
-
-static inline unsigned long highmap_start_pfn(void)
-{
-	return __pa_symbol(_text) >> PAGE_SHIFT;
-}
-
-static inline unsigned long highmap_end_pfn(void)
-{
-	return __pa_symbol(roundup(_brk_end, PMD_SIZE)) >> PAGE_SHIFT;
-}
-
-#endif
-
 #ifdef CONFIG_DEBUG_PAGEALLOC
 # define debug_pagealloc 1
 #else
@@ -1255,7 +1241,7 @@ static int cpa_process_alias(struct cpa_
 	 * to touch the high mapped kernel as well:
 	 */
 	if (!within(vaddr, (unsigned long)_text, _brk_end) &&
-	    within(cpa->pfn, highmap_start_pfn(), highmap_end_pfn())) {
+	    pfn_range_is_highmapped(cpa->pfn, 1)) {
 		unsigned long temp_cpa_vaddr = (cpa->pfn << PAGE_SHIFT) +
 					       __START_KERNEL_map - phys_base;
 		alias_cpa = *cpa;
Index: linux-2.6/arch/x86/include/asm/pgtable_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable_64.h
+++ linux-2.6/arch/x86/include/asm/pgtable_64.h
@@ -167,6 +167,8 @@ static inline int pgd_large(pgd_t pgd) {
 extern int kern_addr_valid(unsigned long addr);
 extern void cleanup_highmap(void);
 
+int pfn_range_is_highmapped(unsigned long start_pfn, unsigned long end_pfn);
+
 #define HAVE_ARCH_UNMAPPED_AREA
 #define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
 
