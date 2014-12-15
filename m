Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaLOTdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:33:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40973 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaLOTdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:33:35 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Tim Hartrick <tim@edgecast.com>, Hugh Dickins <hughd@google.com>,
        Michel Lespinasse <walken@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 82/96] mm: fix anon_vma_clone() error treatment
Date: Mon, 15 Dec 2014 11:26:42 -0800
Message-Id: <1418671616-25482-83-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Forrest <dan.forrest@ssec.wisc.edu>

commit c4ea95d7cd08d9ffd7fa75e6c5e0332d596dd11e upstream.

Andrew Morton noticed that the error return from anon_vma_clone() was
being dropped and replaced with -ENOMEM (which is not itself a bug
because the only error return value from anon_vma_clone() is -ENOMEM).

I did an audit of callers of anon_vma_clone() and discovered an actual
bug where the error return was being lost.  In __split_vma(), between
Linux 3.11 and 3.12 the code was changed so the err variable is used
before the call to anon_vma_clone() and the default initial value of
-ENOMEM is overwritten.  So a failure of anon_vma_clone() will return
success since err at this point is now zero.

Below is a patch which fixes this bug and also propagates the error
return value from anon_vma_clone() in all cases.

Fixes: ef0855d334e1 ("mm: mempolicy: turn vma_set_policy() into vma_dup_policy()")
Signed-off-by: Daniel Forrest <dan.forrest@ssec.wisc.edu>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tim Hartrick <tim@edgecast.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/mmap.c | 10 +++++++---
 mm/rmap.c |  6 ++++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 32dbf6d..d407dcd 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -742,8 +742,11 @@ again:			remove_next = 1 + (end > next->vm_end);
 		 * shrinking vma had, to cover any anon pages imported.
 		 */
 		if (exporter && exporter->anon_vma && !importer->anon_vma) {
-			if (anon_vma_clone(importer, exporter))
-				return -ENOMEM;
+			int error;
+
+			error = anon_vma_clone(importer, exporter);
+			if (error)
+				return error;
 			importer->anon_vma = exporter->anon_vma;
 		}
 	}
@@ -2414,7 +2417,8 @@ static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 	if (err)
 		goto out_free_vma;
 
-	if (anon_vma_clone(new, vma))
+	err = anon_vma_clone(new, vma);
+	if (err)
 		goto out_free_mpol;
 
 	if (new->vm_file)
diff --git a/mm/rmap.c b/mm/rmap.c
index cd6b576..ac0506d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -274,6 +274,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 {
 	struct anon_vma_chain *avc;
 	struct anon_vma *anon_vma;
+	int error;
 
 	/* Don't bother if the parent process has no anon_vma here. */
 	if (!pvma->anon_vma)
@@ -283,8 +284,9 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	 * First, attach the new VMA to the parent VMA's anon_vmas,
 	 * so rmap can find non-COWed pages in child processes.
 	 */
-	if (anon_vma_clone(vma, pvma))
-		return -ENOMEM;
+	error = anon_vma_clone(vma, pvma);
+	if (error)
+		return error;
 
 	/* Then add our own anon_vma. */
 	anon_vma = anon_vma_alloc();
-- 
1.9.1

