Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaFEEUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:20:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaFEEUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anthony Iliopoulos <anthony.iliopoulos@huawei.com>,
        Shay Goikhman <shay.goikhman@huawei.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3.4 042/214] x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()
Date: Wed,  4 Jun 2014 21:16:45 -0700
Message-Id: <20140605041645.243855252@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Iliopoulos <anthony.iliopoulos@huawei.com>

commit 9844f5462392b53824e8b86726e7c33b5ecbb676 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/hugetlb.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/include/asm/hugetlb.h
+++ b/arch/x86/include/asm/hugetlb.h
@@ -51,6 +51,7 @@ static inline pte_t huge_ptep_get_and_cl
 static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
 					 unsigned long addr, pte_t *ptep)
 {
+	ptep_clear_flush(vma, addr, ptep);
 }
 
 static inline int huge_pte_none(pte_t pte)


