Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaGaQK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:10:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbaGaQKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:10:19 -0400
Date: Thu, 31 Jul 2014 09:10:05 -0700
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-9dfa6dee5355f200cf19528ca7c678ef4007cec5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        riel@redhat.com, mgorman@suse.de, tglx@linutronix.de,
        dave.hansen@linux.intel.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        riel@redhat.com, mgorman@suse.de, tglx@linutronix.de,
        dave.hansen@linux.intel.com, hpa@linux.intel.com
In-Reply-To: <20140731154056.FF763B76@viggo.jf.intel.com>
References: <20140731154056.FF763B76@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm: Fix missed global TLB flush stat
Git-Commit-ID: 9dfa6dee5355f200cf19528ca7c678ef4007cec5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9dfa6dee5355f200cf19528ca7c678ef4007cec5
Gitweb:     http://git.kernel.org/tip/9dfa6dee5355f200cf19528ca7c678ef4007cec5
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Thu, 31 Jul 2014 08:40:56 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 31 Jul 2014 08:48:50 -0700

x86/mm: Fix missed global TLB flush stat

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
Link: http://lkml.kernel.org/r/20140731154056.FF763B76@viggo.jf.intel.com
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/tlb.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index dff6dde..ae584d0 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -164,8 +164,9 @@ unsigned long tlb_single_page_flush_ceiling = 1;
 void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned long vmflag)
 {
-	int need_flush_others_all = 1;
 	unsigned long addr;
+	/* do a global flush by default */
+	unsigned long base_pages_to_flush = TLB_FLUSH_ALL;
 
 	preempt_disable();
 	if (current->active_mm != mm)
@@ -176,16 +177,14 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
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
@@ -193,7 +192,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 		}
 	}
 out:
-	if (need_flush_others_all) {
+	if (base_pages_to_flush == TLB_FLUSH_ALL) {
 		start = 0UL;
 		end = TLB_FLUSH_ALL;
 	}
