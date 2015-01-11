Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbbAKNyO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 08:54:14 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58507 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbbAKNyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 08:54:11 -0500
Subject: [PATCH] mm: fix corner case in anon_vma endless growing prevention
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@redhat.com>, "Elifaz, Dana" <Dana.Elifaz@amd.com>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        Chris Clayton <chris2553@googlemail.com>,
        Oded Gabbay <oded.gabbay@amd.com>, Michal Hocko <mhocko@suse.cz>
Date: Sun, 11 Jan 2015 16:54:06 +0300
Message-ID: <20150111135406.13266.42007.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for BUG_ON(anon_vma->degree) splashes in unlink_anon_vmas()
("kernel BUG at mm/rmap.c:399!").

Anon_vma_clone() is usually called for a copy of source vma in destination
argument. If source vma has anon_vma it should be already in dst->anon_vma.
NULL in dst->anon_vma is used as a sign that it's called from anon_vma_fork().
In this case anon_vma_clone() finds anon_vma for reusing.

Vma_adjust() calls it differently and this breaks anon_vma reusing logic:
anon_vma_clone() links vma to old anon_vma and updates degree counters but
vma_adjust() overrides vma->anon_vma right after that. As a result final
unlink_anon_vmas() decrements degree for wrong anon_vma.

This patch assigns ->anon_vma before calling anon_vma_clone().

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Fixes: 7a3ef208e662 ("mm: prevent endless growth of anon_vma hierarchy")
Tested-by: Chris Clayton <chris2553@googlemail.com>
Tested-by: Oded Gabbay <oded.gabbay@amd.com>
Cc: Daniel Forrest <dan.forrest@ssec.wisc.edu>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
---
 mm/mmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 7b36aa7..12616c5 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -778,10 +778,12 @@ again:			remove_next = 1 + (end > next->vm_end);
 		if (exporter && exporter->anon_vma && !importer->anon_vma) {
 			int error;
 
+			importer->anon_vma = exporter->anon_vma;
 			error = anon_vma_clone(importer, exporter);
-			if (error)
+			if (error) {
+				importer->anon_vma = NULL;
 				return error;
-			importer->anon_vma = exporter->anon_vma;
+			}
 		}
 	}
 

