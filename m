Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab3JUVqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 17:46:31 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:61925 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab3JUVq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 17:46:27 -0400
Date: Mon, 21 Oct 2013 14:46:22 -0700
From: Ning Qu <quning@google.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ning Qu <quning@google.com>, Ning Qu <quning@gmail.com>
Subject: [PATCHv2 02/13] mm, thp, tmpfs: add function to alloc huge page for
 tmpfs
Message-ID: <20131021214622.GC29870@hippobay.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function to alloc huge page for tmpfs when needed.

Signed-off-by: Ning Qu <quning@gmail.com>
---
 mm/shmem.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 8297623..a857ba8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -949,6 +949,28 @@ static struct page *shmem_alloc_page(gfp_t gfp,
 
 	return page;
 }
+
+static struct page *shmem_alloc_hugepage(gfp_t gfp,
+			struct shmem_inode_info *info, pgoff_t index)
+{
+	struct vm_area_struct pvma;
+	struct page *page;
+
+	/* Create a pseudo vma that just contains the policy */
+	pvma.vm_start = 0;
+	pvma.vm_pgoff = index;
+	pvma.vm_ops = NULL;
+	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
+	pvma.vm_flags = VM_HUGEPAGE;
+
+	page = alloc_hugepage_vma(transparent_hugepage_defrag(&pvma), &pvma,
+					0, numa_node_id(), gfp);
+
+	/* Drop reference taken by mpol_shared_policy_lookup() */
+	mpol_cond_put(pvma.vm_policy);
+
+	return page;
+}
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
 static inline void shmem_show_mpol(struct seq_file *seq, struct mempolicy *mpol)
@@ -967,6 +989,13 @@ static inline struct page *shmem_alloc_page(gfp_t gfp,
 {
 	return alloc_page(gfp);
 }
+
+static inline struct page *shmem_alloc_hugepage(gfp_t gfp,
+			struct shmem_inode_info *info, pgoff_t index)
+{
+	BUG();
+	return NULL;
+}
 #endif /* CONFIG_NUMA */
 
 #if !defined(CONFIG_NUMA) || !defined(CONFIG_TMPFS)
-- 
1.8.4

