Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937660Ab3DJWwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:52:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937554Ab3DJWu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:50:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Stancek <jstancek@redhat.com>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 16/19] mm: prevent mmap_cache race in find_vma()
Date: Wed, 10 Apr 2013 15:50:39 -0700
Message-Id: <20130410225028.488611137@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410225026.833809117@linuxfoundation.org>
References: <20130410225026.833809117@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mmap.c  |    2 +-
 mm/nommu.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1581,7 +1581,7 @@ struct vm_area_struct *find_vma(struct m
 	if (mm) {
 		/* Check the cache first. */
 		/* (Cache hit rate is typically around 35%.) */
-		vma = mm->mmap_cache;
+		vma = ACCESS_ONCE(mm->mmap_cache);
 		if (!(vma && vma->vm_end > addr && vma->vm_start <= addr)) {
 			struct rb_node * rb_node;
 
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -808,7 +808,7 @@ struct vm_area_struct *find_vma(struct m
 	struct vm_area_struct *vma;
 
 	/* check the cache first */
-	vma = mm->mmap_cache;
+	vma = ACCESS_ONCE(mm->mmap_cache);
 	if (vma && vma->vm_start <= addr && vma->vm_end > addr)
 		return vma;
 


