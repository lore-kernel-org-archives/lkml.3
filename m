Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbaBEUvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:51:42 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48241 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbaBEUF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:59 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 099/213] hugetlb: fix resv_map leak in error path
Date: Wed, 5 Feb 2014 15:00:54 -0500
Message-ID: <1391630568-49251-100-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave@linux.vnet.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c50ac050811d6485616a193eb0f37bfbd191cc89 upstream.

When called for anonymous (non-shared) mappings, hugetlb_reserve_pages()
does a resv_map_alloc().  It depends on code in hugetlbfs's
vm_ops->close() to release that allocation.

However, in the mmap() failure path, we do a plain unmap_region() without
the remove_vma() which actually calls vm_ops->close().

This is a decent fix.  This leak could get reintroduced if new code (say,
after hugetlb_reserve_pages() in hugetlbfs_file_mmap()) decides to return
an error.  But, I think it would have to unroll the reservation anyway.

Christoph's test case:

	http://marc.info/?l=linux-mm&m=133728900729735

This patch applies to 3.4 and later.  A version for earlier kernels is at
https://lkml.org/lkml/2012/5/22/418.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reported-by: Christoph Lameter <cl@linux.com>
Tested-by: Christoph Lameter <cl@linux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/hugetlb.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ca9ce49d71e3..f7b80540ba95 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2030,6 +2030,15 @@ static void hugetlb_vm_op_open(struct vm_area_struct *vma)
 		kref_get(&reservations->refs);
 }
 
+static void resv_map_put(struct vm_area_struct *vma)
+{
+	struct resv_map *reservations = vma_resv_map(vma);
+
+	if (!reservations)
+		return;
+	kref_put(&reservations->refs, resv_map_release);
+}
+
 static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 {
 	struct hstate *h = hstate_vma(vma);
@@ -2045,7 +2054,7 @@ static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 		reserve = (end - start) -
 			region_count(&reservations->regions, start, end);
 
-		kref_put(&reservations->refs, resv_map_release);
+		resv_map_put(vma);
 
 		if (reserve) {
 			hugetlb_acct_memory(h, -reserve);
@@ -2744,12 +2753,16 @@ int hugetlb_reserve_pages(struct inode *inode,
 		set_vma_resv_flags(vma, HPAGE_RESV_OWNER);
 	}
 
-	if (chg < 0)
-		return chg;
+	if (chg < 0) {
+		ret = chg;
+		goto out_err;
+	}
 
 	/* There must be enough filesystem quota for the mapping */
-	if (hugetlb_get_quota(inode->i_mapping, chg))
-		return -ENOSPC;
+	if (hugetlb_get_quota(inode->i_mapping, chg)) {
+		ret = -ENOSPC;
+		goto out_err;
+	}
 
 	/*
 	 * Check enough hugepages are available for the reservation.
@@ -2758,7 +2771,7 @@ int hugetlb_reserve_pages(struct inode *inode,
 	ret = hugetlb_acct_memory(h, chg);
 	if (ret < 0) {
 		hugetlb_put_quota(inode->i_mapping, chg);
-		return ret;
+		goto out_err;
 	}
 
 	/*
@@ -2775,6 +2788,9 @@ int hugetlb_reserve_pages(struct inode *inode,
 	if (!vma || vma->vm_flags & VM_MAYSHARE)
 		region_add(&inode->i_mapping->private_list, from, to);
 	return 0;
+out_err:
+	resv_map_put(vma);
+	return ret;
 }
 
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
-- 
1.8.5.2

