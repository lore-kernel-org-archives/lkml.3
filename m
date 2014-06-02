Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbaFBVlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:41:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:47039 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbaFBVgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:36:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,959,1392192000"; 
   d="scan'208";a="550474663"
Subject: [PATCH 05/10] mm: mincore: clean up hugetlbfs handling (part 1)
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 02 Jun 2014 14:36:51 -0700
References: <20140602213644.925A26D0@viggo.jf.intel.com>
In-Reply-To: <20140602213644.925A26D0@viggo.jf.intel.com>
Message-Id: <20140602213651.1D4268DB@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

The page walker functions are only called _via_ the page
walker.  I don't see this changing any time soon.  The
page walker only calls walk->hugetlb_entry() under an
#ifdef CONFIG_HUGETLB_PAGE.

With this in place, I think putting BUG()s in the
->hugetlb_entry handlers is a bit like wearing a belt and
suspenders.

This axes the BUG() from the mincore ->hugetlb_entry along
with the #ifdef.  The compiler is more than smart enough
to do the right thing when it sees:

	if (1)
		return;
	// unreachable

The only downside here is that we now need some header stubs
for huge_pte_none() / huge_pte_get().

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/include/linux/hugetlb.h |   10 ++++++++++
 b/mm/mincore.c            |    9 +++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff -puN include/linux/hugetlb.h~cleanup-hugetlbfs-mincore-1 include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~cleanup-hugetlbfs-mincore-1	2014-06-02 14:20:20.144845525 -0700
+++ b/include/linux/hugetlb.h	2014-06-02 14:20:20.149845750 -0700
@@ -458,6 +458,16 @@ static inline spinlock_t *huge_pte_lockp
 {
 	return &mm->page_table_lock;
 }
+static inline int huge_pte_none(pte_t pte)
+{
+	WARN_ONCE(1, "%s() called when hugetlbfs disabled", __func__);
+	return 1;
+}
+static inline pte_t huge_ptep_get(pte_t *pte)
+{
+	WARN_ONCE(1, "%s() called when hugetlbfs disabled", __func__);
+	return __pte(0);
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
diff -puN mm/mincore.c~cleanup-hugetlbfs-mincore-1 mm/mincore.c
--- a/mm/mincore.c~cleanup-hugetlbfs-mincore-1	2014-06-02 14:20:20.146845615 -0700
+++ b/mm/mincore.c	2014-06-02 14:20:20.149845750 -0700
@@ -23,8 +23,12 @@ static int mincore_hugetlb_page_range(pt
 					unsigned long addr, unsigned long end,
 					struct mm_walk *walk)
 {
-#ifdef CONFIG_HUGETLB_PAGE
 	unsigned char *vec = walk->private;
+
+	/* This is as good as an explicit ifdef */
+	if (!is_vm_hugetlb_page(walk->vma))
+		return 0;
+
 	while (1) {
 		int present = !huge_pte_none(huge_ptep_get(ptep));
 		while (1) {
@@ -38,9 +42,6 @@ static int mincore_hugetlb_page_range(pt
 				break;
 		}
 	}
-#else
-	BUG();
-#endif
 	return 0;
 }
 
_
