Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbaHDRJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:09:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56503 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854AbaHDQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Konstantin Khlebnikov" <koct9i@gmail.com>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        "Hugh Dickins" <hughd@google.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Lukas Czerner" <lczerner@redhat.com>,
        "Vlastimil Babka" <vbabka@suse.cz>, "Dave Jones" <davej@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Sasha Levin" <sasha.levin@oracle.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.326616654@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 72/94] shmem: fix splicing from a hole while it's punched
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit b1a366500bd537b50c3aad26dc7df083ec03a448 upstream.

shmem_fault() is the actual culprit in trinity's hole-punch starvation,
and the most significant cause of such problems: since a page faulted is
one that then appears page_mapped(), needing unmap_mapping_range() and
i_mmap_mutex to be unmapped again.

But it is not the only way in which a page can be brought into a hole in
the radix_tree while that hole is being punched; and Vlastimil's testing
implies that if enough other processors are busy filling in the hole,
then shmem_undo_range() can be kept from completing indefinitely.

shmem_file_splice_read() is the main other user of SGP_CACHE, which can
instantiate shmem pagecache pages in the read-only case (without holding
i_mutex, so perhaps concurrently with a hole-punch).  Probably it's
silly not to use SGP_READ already (using the ZERO_PAGE for holes): which
ought to be safe, but might bring surprises - not a change to be rushed.

shmem_read_mapping_page_gfp() is an internal interface used by
drivers/gpu/drm GEM (and next by uprobes): it should be okay.  And
shmem_file_read_iter() uses the SGP_DIRTY variant of SGP_CACHE, when
called internally by the kernel (perhaps for a stacking filesystem,
which might rely on holes to be reserved): it's unclear whether it could
be provoked to keep hole-punch busy or not.

We could apply the same umbrella as now used in shmem_fault() to
shmem_file_splice_read() and the others; but it looks ugly, and use over
a range raises questions - should it actually be per page? can these get
starved themselves?

The origin of this part of the problem is my v3.1 commit d0823576bf4b
("mm: pincer in truncate_inode_pages_range"), once it was duplicated
into shmem.c.  It seemed like a nice idea at the time, to ensure
(barring RCU lookup fuzziness) that there's an instant when the entire
hole is empty; but the indefinitely repeated scans to ensure that make
it vulnerable.

Revert that "enhancement" to hole-punch from shmem_undo_range(), but
retain the unproblematic rescanning when it's truncating; add a couple
of comments there.

Remove the "indices[0] >= end" test: that is now handled satisfactorily
by the inner loop, and mem_cgroup_uncharge_start()/end() are too light
to be worth avoiding here.

But if we do not always loop indefinitely, we do need to handle the case
of swap swizzled back to page before shmem_free_swap() gets it: add a
retry for that case, as suggested by Konstantin Khlebnikov; and for the
case of page swizzled back to swap, as suggested by Johannes Weiner.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/shmem.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 04d11f9..4bb5a80 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -499,22 +499,19 @@ void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
 	}
 
 	index = start;
-	for ( ; ; ) {
+	while (index <= end) {
 		cond_resched();
 		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1,
 							pvec.pages, indices);
 		if (!pvec.nr) {
-			if (index == start)
+			/* If all gone or hole-punch, we're done */
+			if (index == start || end != -1)
 				break;
+			/* But if truncating, restart to make sure all gone */
 			index = start;
 			continue;
 		}
-		if (index == start && indices[0] > end) {
-			shmem_deswap_pagevec(&pvec);
-			pagevec_release(&pvec);
-			break;
-		}
 		mem_cgroup_uncharge_start();
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
@@ -524,8 +521,12 @@ void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
 				break;
 
 			if (radix_tree_exceptional_entry(page)) {
-				nr_swaps_freed += !shmem_free_swap(mapping,
-								index, page);
+				if (shmem_free_swap(mapping, index, page)) {
+					/* Swap was replaced by page: retry */
+					index--;
+					break;
+				}
+				nr_swaps_freed++;
 				continue;
 			}
 
@@ -533,6 +534,11 @@ void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
 			if (page->mapping == mapping) {
 				VM_BUG_ON(PageWriteback(page));
 				truncate_inode_page(mapping, page);
+			} else {
+				/* Page was replaced by swap: retry */
+				unlock_page(page);
+				index--;
+				break;
 			}
 			unlock_page(page);
 		}

