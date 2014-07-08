Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbaGHT2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:28:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54205 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755712AbaGHTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "David Rientjes" <rientjes@google.com>,
        "Minchan Kim" <minchan@kernel.org>, "Christoph Lameter" <cl@linux.com>,
        "Johannes Weiner" <hannes@cmpxchg.org>, "Mel Gorman" <mgorman@suse.de>,
        "Vasiliy Kulikov" <segooon@gmail.com>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.82766641@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 098/125] mm: revert 0def08e3 ("mm/mempolicy.c: check
 return code of check_range")
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Minchan Kim <minchan@kernel.org>

commit 082708072a4250f5c4dbc62065e7af93f5e45646 upstream.

Revert commit 0def08e3acc2 because check_range can't fail in
migrate_to_node with considering current usecases.

Quote from Johannes

: I think it makes sense to revert.  Not because of the semantics, but I
: just don't see how check_range() could even fail for this callsite:
:
: 1. we pass mm->mmap->vm_start in there, so we should not fail due to
:    find_vma()
:
: 2. we pass MPOL_MF_DISCONTIG_OK, so the discontig checks do not apply
:    and so can not fail
:
: 3. we pass MPOL_MF_MOVE | MPOL_MF_MOVE_ALL, the page table loops will
:    continue until addr == end, so we never fail with -EIO

And I added a new VM_BUG_ON for checking migrate_to_node's future usecase
which might pass to MPOL_MF_STRICT.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vasiliy Kulikov <segooon@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/mempolicy.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -945,15 +945,18 @@ static int migrate_to_node(struct mm_str
 	nodemask_t nmask;
 	LIST_HEAD(pagelist);
 	int err = 0;
-	struct vm_area_struct *vma;
 
 	nodes_clear(nmask);
 	node_set(source, nmask);
 
-	vma = check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
+	/*
+	 * This does not "check" the range but isolates all pages that
+	 * need migration.  Between passing in the full user address
+	 * space range and MPOL_MF_DISCONTIG_OK, this call can not fail.
+	 */
+	VM_BUG_ON(!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)));
+	check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
-	if (IS_ERR(vma))
-		return PTR_ERR(vma);
 
 	if (!list_empty(&pagelist)) {
 		err = migrate_pages(&pagelist, new_node_page, dest,

