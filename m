Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbaGANDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:03:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757611AbaGANDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:03:07 -0400
From: "Jerome Marchand" <jmarchan@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
Subject: [PATCH 2/5] mm, shmem: Add shmem_locate function
Date: Tue,  1 Jul 2014 15:01:58 +0200
Message-Id: <1404219721-32241-3-git-send-email-jmarchan@redhat.com>
In-Reply-To: <1404219721-32241-1-git-send-email-jmarchan@redhat.com>
References: <1404219721-32241-1-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shmem subsytem is kind of a black box: the generic mm code can't
always know where a specific page physically is. This patch adds the
shmem_locate() function to find out the physical location of shmem
pages (resident, in swap or swapcache). If the optional argument count
isn't NULL and the page is resident, it also returns the mapcount value
of this page.
This is intended to allow finer accounting of shmem/tmpfs pages.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 include/linux/mm.h |  7 +++++++
 mm/shmem.c         | 29 +++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e69ee9d..34099fa 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1066,6 +1066,13 @@ extern bool skip_free_areas_node(unsigned int flags, int nid);
 
 int shmem_zero_setup(struct vm_area_struct *);
 #ifdef CONFIG_SHMEM
+
+#define SHMEM_NOTPRESENT	1 /* page is not present in memory */
+#define SHMEM_RESIDENT		2 /* page is resident in RAM */
+#define SHMEM_SWAPCACHE		3 /* page is in swap cache */
+#define SHMEM_SWAP		4 /* page is paged out */
+
+extern int shmem_locate(struct vm_area_struct *vma, pgoff_t pgoff, int *count);
 bool shmem_mapping(struct address_space *mapping);
 #else
 static inline bool shmem_mapping(struct address_space *mapping)
diff --git a/mm/shmem.c b/mm/shmem.c
index 5e5d860..11b37a7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1305,6 +1305,35 @@ static int shmem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	return ret;
 }
 
+int shmem_locate(struct vm_area_struct *vma, pgoff_t pgoff, int *count)
+{
+	struct address_space *mapping = file_inode(vma->vm_file)->i_mapping;
+	struct page *page;
+	swp_entry_t swap;
+	int ret;
+
+	page = find_get_entry(mapping, pgoff);
+	if (!page) /* Not yet initialised? */
+		return SHMEM_NOTPRESENT;
+
+	if (!radix_tree_exceptional_entry(page)) {
+		ret = SHMEM_RESIDENT;
+		if (count)
+			*count = page_mapcount(page);
+		goto out;
+	}
+
+	swap = radix_to_swp_entry(page);
+	page = find_get_page(swap_address_space(swap), swap.val);
+	if (!page)
+		return SHMEM_SWAP;
+	ret = SHMEM_SWAPCACHE;
+
+out:
+	page_cache_release(page);
+	return ret;
+}
+
 #ifdef CONFIG_NUMA
 static int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy *mpol)
 {
-- 
1.9.3

