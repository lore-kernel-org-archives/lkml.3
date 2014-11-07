Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaKGTer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:34:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbaKGTeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:34:46 -0500
Message-ID: <1415388857.12094.2.camel@linux-t7sj.site>
Subject: [PATCH -next] mm/rmap: calculate page offset when needed
From: Davidlohr Bueso <dave@stgolabs.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>
Date: Fri, 07 Nov 2014 11:34:17 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call page_to_pgoff() to get the page offset once we are
sure we actually need it, and any very obvious initial
function checks have passed. Trivial micro-optimization,
and potentially save some cycles.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 mm/rmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index a5e9cc6..e3354b2 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1633,7 +1633,7 @@ static struct anon_vma *rmap_walk_anon_lock(struct page *page,
 static int rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct anon_vma *anon_vma;
-	pgoff_t pgoff = page_to_pgoff(page);
+	pgoff_t pgoff;
 	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
 
@@ -1641,6 +1641,7 @@ static int rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc)
 	if (!anon_vma)
 		return ret;
 
+	pgoff = page_to_pgoff(page);
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
@@ -1674,7 +1675,7 @@ static int rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc)
 static int rmap_walk_file(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff = page_to_pgoff(page);
+	pgoff_t pgoff;
 	struct vm_area_struct *vma;
 	int ret = SWAP_AGAIN;
 
@@ -1689,6 +1690,7 @@ static int rmap_walk_file(struct page *page, struct rmap_walk_control *rwc)
 	if (!mapping)
 		return ret;
 
+	pgoff = page_to_pgoff(page);
 	i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
-- 
1.8.4.5


