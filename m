Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaDUSZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:25:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:49118 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbaDUSYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:24:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,897,1389772800"; 
   d="scan'208";a="421645834"
Subject: [PATCH 3/6] x86: mm: fix missed global TLB flush stat
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mgorman@suse.de, ak@linux.intel.com, riel@redhat.com,
        alex.shi@linaro.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Mon, 21 Apr 2014 11:24:22 -0700
References: <20140421182418.81CF7519@viggo.jf.intel.com>
In-Reply-To: <20140421182418.81CF7519@viggo.jf.intel.com>
Message-Id: <20140421182422.DE5E728F@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

If we take the

	if (end == TLB_FLUSH_ALL || vmflag & VM_HUGETLB) {
		local_flush_tlb();
		goto out;
	}

path out of flush_tlb_mm_range(), we will have flushed the tlb,
but not incremented NR_TLB_LOCAL_FLUSH_ALL.  This unifies the
way out of the function so that we always take a single path when
doing a full tlb flush.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/mm/tlb.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN arch/x86/mm/tlb.c~fix-missed-global-flush-stat arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~fix-missed-global-flush-stat	2014-04-21 11:10:35.176852256 -0700
+++ b/arch/x86/mm/tlb.c	2014-04-21 11:10:35.190852888 -0700
@@ -172,8 +172,9 @@ unsigned long tlb_single_page_flush_ceil
 void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned long vmflag)
 {
-	int need_flush_others_all = 1;
 	unsigned long addr;
+	/* do a global flush by default */
+	unsigned long base_pages_to_flush = TLB_FLUSH_ALL;
 
 	preempt_disable();
 	if (current->active_mm != mm)
@@ -184,16 +185,14 @@ void flush_tlb_mm_range(struct mm_struct
 		goto out;
 	}
 
-	if (end == TLB_FLUSH_ALL || vmflag & VM_HUGETLB) {
-		local_flush_tlb();
-		goto out;
-	}
+	if ((end != TLB_FLUSH_ALL) && !(vmflag & VM_HUGETLB))
+		base_pages_to_flush = (end - start) >> PAGE_SHIFT;
 
-	if ((end - start) > tlb_single_page_flush_ceiling * PAGE_SIZE) {
+	if (base_pages_to_flush > tlb_single_page_flush_ceiling) {
+		base_pages_to_flush = TLB_FLUSH_ALL;
 		count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 		local_flush_tlb();
 	} else {
-		need_flush_others_all = 0;
 		/* flush range by one by one 'invlpg' */
 		for (addr = start; addr < end;	addr += PAGE_SIZE) {
 			count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ONE);
@@ -201,7 +200,7 @@ void flush_tlb_mm_range(struct mm_struct
 		}
 	}
 out:
-	if (need_flush_others_all) {
+	if (base_pages_to_flush == TLB_FLUSH_ALL) {
 		start = 0UL;
 		end = TLB_FLUSH_ALL;
 	}
_
