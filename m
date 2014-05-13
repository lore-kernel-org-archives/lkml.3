Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbaEMXhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 19:37:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48055 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbaEMXhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 19:37:06 -0400
Date: Tue, 13 May 2014 16:36:39 -0700
From: tip-bot for Anthony Iliopoulos <tipbot@zytor.com>
Message-ID: <tip-9844f5462392b53824e8b86726e7c33b5ecbb676@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dave.hansen@intel.com, shay.goikhman@huawei.com, tglx@linutronix.de,
        anthony.iliopoulos@huawei.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dave.hansen@intel.com, shay.goikhman@huawei.com, tglx@linutronix.de,
        anthony.iliopoulos@huawei.com, hpa@linux.intel.com
In-Reply-To: <20140514092948.GA17391@server-36.huawei.corp>
References: <20140514092948.GA17391@server-36.huawei.corp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mm, hugetlb:
  Add missing TLB page invalidation for hugetlb_cow()
Git-Commit-ID: 9844f5462392b53824e8b86726e7c33b5ecbb676
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

Commit-ID:  9844f5462392b53824e8b86726e7c33b5ecbb676
Gitweb:     http://git.kernel.org/tip/9844f5462392b53824e8b86726e7c33b5ecbb676
Author:     Anthony Iliopoulos <anthony.iliopoulos@huawei.com>
AuthorDate: Wed, 14 May 2014 11:29:48 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 13 May 2014 16:34:09 -0700

x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()

The invalidation is required in order to maintain proper semantics
under CoW conditions. In scenarios where a process clones several
threads, a thread operating on a core whose DTLB entry for a
particular hugepage has not been invalidated, will be reading from
the hugepage that belongs to the forked child process, even after
hugetlb_cow().

The thread will not see the updated page as long as the stale DTLB
entry remains cached, the thread attempts to write into the page,
the child process exits, or the thread gets migrated to a different
processor.

Signed-off-by: Anthony Iliopoulos <anthony.iliopoulos@huawei.com>
Link: http://lkml.kernel.org/r/20140514092948.GA17391@server-36.huawei.corp
Suggested-by: Shay Goikhman <shay.goikhman@huawei.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org> # v2.6.16+ (!)
---
 arch/x86/include/asm/hugetlb.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/hugetlb.h b/arch/x86/include/asm/hugetlb.h
index a809121..68c0539 100644
--- a/arch/x86/include/asm/hugetlb.h
+++ b/arch/x86/include/asm/hugetlb.h
@@ -52,6 +52,7 @@ static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
 					 unsigned long addr, pte_t *ptep)
 {
+	ptep_clear_flush(vma, addr, ptep);
 }
 
 static inline int huge_pte_none(pte_t pte)
