Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159Ab3EGEPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:15:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28906 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab3EGD6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:43 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=wG4Kujtt6lMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=7dxe5Eq-pa0A:10 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=_mDbFDWtq-LpH7uekGwA:9 a=jEp0ucaQiEUA:10 a=UTB_XpHje0EA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035842.623244562@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Stancek <jstancek@redhat.com>, David Rientjes <rientjes@google.com>,
        Hugh Dickins <hughd@google.com>
Subject: [010/126] mm: prevent mmap_cache race in find_vma()
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0010-mm-prevent-mmap_cache-race-in-find_vma.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jan Stancek <jstancek@redhat.com>

[ Upstream commit b6a9b7f6b1f21735a7456d534dc0e68e61359d2c ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/mmap.c  |    2 +-
 mm/nommu.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index ae18a48..cf6434e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1611,7 +1611,7 @@ struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 
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
1.7.10.4


