Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab3LKWKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:10:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab3LKWKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:10:17 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
        Cliff Wickman <cpw@sgi.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Rik van Riel <riel@redhat.com>,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] pagewalk: add walk_page_vma()
Date: Wed, 11 Dec 2013 17:08:58 -0500
Message-Id: <1386799747-31069-3-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1386799747-31069-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1386799747-31069-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduces walk_page_vma(), which is useful for the callers which
want to walk over a given vma. It's used by later patches.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 include/linux/mm.h |  1 +
 mm/pagewalk.c      | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git v3.13-rc3-mmots-2013-12-10-16-38.orig/include/linux/mm.h v3.13-rc3-mmots-2013-12-10-16-38/include/linux/mm.h
index 1cb9944c4feb..8d1a3659419d 100644
--- v3.13-rc3-mmots-2013-12-10-16-38.orig/include/linux/mm.h
+++ v3.13-rc3-mmots-2013-12-10-16-38/include/linux/mm.h
@@ -1101,6 +1101,7 @@ struct mm_walk {
 
 int walk_page_range(unsigned long addr, unsigned long end,
 		struct mm_walk *walk);
+int walk_page_vma(struct vm_area_struct *vma, struct mm_walk *walk);
 void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int copy_page_range(struct mm_struct *dst, struct mm_struct *src,
diff --git v3.13-rc3-mmots-2013-12-10-16-38.orig/mm/pagewalk.c v3.13-rc3-mmots-2013-12-10-16-38/mm/pagewalk.c
index b0cada41b80c..f4ba2c212330 100644
--- v3.13-rc3-mmots-2013-12-10-16-38.orig/mm/pagewalk.c
+++ v3.13-rc3-mmots-2013-12-10-16-38/mm/pagewalk.c
@@ -326,3 +326,21 @@ int walk_page_range(unsigned long start, unsigned long end,
 	} while (start = next, start < end);
 	return err;
 }
+
+int walk_page_vma(struct vm_area_struct *vma, struct mm_walk *walk)
+{
+	int err;
+
+	if (!walk->mm)
+		return -EINVAL;
+
+	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
+	VM_BUG_ON(!vma);
+	walk->vma = vma;
+	err = walk_page_test(vma->vm_start, vma->vm_end, walk);
+	if (skip_check(walk))
+		return 0;
+	if (err)
+		return err;
+	return __walk_page_range(vma->vm_start, vma->vm_end, walk);
+}
-- 
1.8.3.1

