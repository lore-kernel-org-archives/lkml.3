Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbaHVQxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:53:38 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:56934 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaHVQxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:53:35 -0400
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, cl@linux-foundation.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/15] percpu: remove @may_alloc from pcpu_get_pages()
Date: Fri, 22 Aug 2014 12:53:08 -0400
Message-Id: <1408726399-4436-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408726399-4436-1-git-send-email-tj@kernel.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcpu_get_pages() creates the temp pages array if not already allocated
and returns the pointer to it.  As the function is called from both
[de]population paths and depopulation can only happen after at least
one successful population, the param doesn't make any difference - the
allocation will always happen on the population path anyway.

Remove @may_alloc from pcpu_get_pages().  Also, add an lockdep
assertion pcpu_alloc_mutex instead of vaguely stating that the
exclusion is the caller's responsibility.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu-vm.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 47b47bf..d9e0b61 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -22,21 +22,22 @@ static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
 /**
  * pcpu_get_pages - get temp pages array
  * @chunk: chunk of interest
- * @may_alloc: may allocate the array
  *
  * Returns pointer to array of pointers to struct page which can be indexed
- * with pcpu_page_idx().  Note that there is only one array and access
- * exclusion is the caller's responsibility.
+ * with pcpu_page_idx().  Note that there is only one array and accesses
+ * should be serialized by pcpu_alloc_mutex.
  *
  * RETURNS:
  * Pointer to temp pages array on success.
  */
-static struct page **pcpu_get_pages(struct pcpu_chunk *chunk, bool may_alloc)
+static struct page **pcpu_get_pages(struct pcpu_chunk *chunk_alloc)
 {
 	static struct page **pages;
 	size_t pages_size = pcpu_nr_units * pcpu_unit_pages * sizeof(pages[0]);
 
-	if (!pages && may_alloc)
+	lockdep_assert_held(&pcpu_alloc_mutex);
+
+	if (!pages)
 		pages = pcpu_mem_zalloc(pages_size);
 	return pages;
 }
@@ -287,7 +288,7 @@ static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	/* need to allocate and map pages, this chunk can't be immutable */
 	WARN_ON(chunk->immutable);
 
-	pages = pcpu_get_pages(chunk, true);
+	pages = pcpu_get_pages(chunk);
 	if (!pages)
 		return -ENOMEM;
 
@@ -358,7 +359,7 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, int off, int size)
 	 * successful population attempt so the temp pages array must
 	 * be available now.
 	 */
-	pages = pcpu_get_pages(chunk, false);
+	pages = pcpu_get_pages(chunk);
 	BUG_ON(!pages);
 
 	/* unmap and free */
-- 
1.9.3

