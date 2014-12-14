Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaLNU33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:29:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbaLNUZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:25:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        Michal Hocko <mhocko@suse.cz>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Tim Hartrick <tim@edgecast.com>, Hugh Dickins <hughd@google.com>,
        Michel Lespinasse <walken@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.17 06/47] mm: fix anon_vma_clone() error treatment
Date: Sun, 14 Dec 2014 12:20:41 -0800
Message-Id: <20141214201818.747811505@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201818.552715149@linuxfoundation.org>
References: <20141214201818.552715149@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mmap.c |   10 +++++++---
 mm/rmap.c |    6 ++++--
 2 files changed, 11 insertions(+), 5 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -752,8 +752,11 @@ again:			remove_next = 1 + (end > next->
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
@@ -2453,7 +2456,8 @@ static int __split_vma(struct mm_struct
 	if (err)
 		goto out_free_vma;
 
-	if (anon_vma_clone(new, vma))
+	err = anon_vma_clone(new, vma);
+	if (err)
 		goto out_free_mpol;
 
 	if (new->vm_file)
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -274,6 +274,7 @@ int anon_vma_fork(struct vm_area_struct
 {
 	struct anon_vma_chain *avc;
 	struct anon_vma *anon_vma;
+	int error;
 
 	/* Don't bother if the parent process has no anon_vma here. */
 	if (!pvma->anon_vma)
@@ -283,8 +284,9 @@ int anon_vma_fork(struct vm_area_struct
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


