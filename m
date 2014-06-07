Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaFGBh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:37:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36000 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752584AbaFGBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Anthony Iliopoulos" <anthony.iliopoulos@huawei.com>,
        "Shay Goikhman" <shay.goikhman@huawei.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.413887641@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 69/92] x86, mm, hugetlb: Add missing TLB page
 invalidation for hugetlb_cow()
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/hugetlb.h | 1 +
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

