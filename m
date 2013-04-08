Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936030Ab3DHJxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:53:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43101 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936001Ab3DHJxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:53:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Stancek <jstancek@redhat.com>, Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 102/102] mm: prevent mmap_cache race in find_vma()
Date: Mon,  8 Apr 2013 10:50:57 +0100
Message-Id: <1365414657-29191-103-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Stancek <jstancek@redhat.com>

commit b6a9b7f6b1f21735a7456d534dc0e68e61359d2c upstream.

find_vma() can be called by multiple threads with read lock
held on mm->mmap_sem and any of them can update mm->mmap_cache.
Prevent compiler from re-fetching mm->mmap_cache, because other
readers could update it in the meantime:

               thread 1                             thread 2
                                        |
  find_vma()                            |  find_vma()
    struct vm_area_struct *vma = NULL;  |
    vma = mm->mmap_cache;               |
    if (!(vma && vma->vm_end > addr     |
        && vma->vm_start <= addr)) {    |
                                        |    mm->mmap_cache = vma;
    return vma;                         |
     ^^ compiler may optimize this      |
        local variable out and re-read  |
        mm->mmap_cache                  |

This issue can be reproduced with gcc-4.8.0-1 on s390x by running
mallocstress testcase from LTP, which triggers:

  kernel BUG at mm/rmap.c:1088!
    Call Trace:
     ([<000003d100c57000>] 0x3d100c57000)
      [<000000000023a1c0>] do_wp_page+0x2fc/0xa88
      [<000000000023baae>] handle_pte_fault+0x41a/0xac8
      [<000000000023d832>] handle_mm_fault+0x17a/0x268
      [<000000000060507a>] do_protection_exception+0x1e2/0x394
      [<0000000000603a04>] pgm_check_handler+0x138/0x13c
      [<000003fffcf1f07a>] 0x3fffcf1f07a
    Last Breaking-Event-Address:
      [<000000000024755e>] page_add_new_anon_rmap+0xc2/0x168

Thanks to Jakub Jelinek for his insight on gcc and helping to
track this down.

Signed-off-by: Jan Stancek <jstancek@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/mmap.c  | 2 +-
 mm/nommu.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index fa1f274..5603d88 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1610,7 +1610,7 @@ struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 
 	/* Check the cache first. */
 	/* (Cache hit rate is typically around 35%.) */
-	vma = mm->mmap_cache;
+	vma = ACCESS_ONCE(mm->mmap_cache);
 	if (!(vma && vma->vm_end > addr && vma->vm_start <= addr)) {
 		struct rb_node *rb_node;
 
diff --git a/mm/nommu.c b/mm/nommu.c
index d4b0c10..a60db99 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -807,7 +807,7 @@ struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 	struct vm_area_struct *vma;
 
 	/* check the cache first */
-	vma = mm->mmap_cache;
+	vma = ACCESS_ONCE(mm->mmap_cache);
 	if (vma && vma->vm_start <= addr && vma->vm_end > addr)
 		return vma;
 
-- 
1.8.1.2

