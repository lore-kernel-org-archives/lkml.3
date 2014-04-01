Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaDAMEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:04:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42307 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaDALRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vlastimil Babka <vbabka@suse.cz>, Daniel Borkmann <dborkman@redhat.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        John David Anglin <dave.anglin@bell.net>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Carsten Otte <cotte@de.ibm.com>, Jared Hulbert <jaredeh@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 039/144] mm: include VM_MIXEDMAP flag in the VM_SPECIAL list to avoid m(un)locking
Date: Tue,  1 Apr 2014 12:14:03 +0100
Message-Id: <1396350948-29910-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka <vbabka@suse.cz>

commit 9050d7eba40b3d79551668f54e68fd6f51945ef3 upstream.

Daniel Borkmann reported a VM_BUG_ON assertion failing:

  ------------[ cut here ]------------
  kernel BUG at mm/mlock.c:528!
  invalid opcode: 0000 [#1] SMP
  Modules linked in: ccm arc4 iwldvm [...]
   video
  CPU: 3 PID: 2266 Comm: netsniff-ng Not tainted 3.14.0-rc2+ #8
  Hardware name: LENOVO 2429BP3/2429BP3, BIOS G4ET37WW (1.12 ) 05/29/2012
  task: ffff8801f87f9820 ti: ffff88002cb44000 task.ti: ffff88002cb44000
  RIP: 0010:[<ffffffff81171ad0>]  [<ffffffff81171ad0>] munlock_vma_pages_range+0x2e0/0x2f0
  Call Trace:
    do_munmap+0x18f/0x3b0
    vm_munmap+0x41/0x60
    SyS_munmap+0x22/0x30
    system_call_fastpath+0x1a/0x1f
  RIP   munlock_vma_pages_range+0x2e0/0x2f0
  ---[ end trace a0088dcf07ae10f2 ]---

because munlock_vma_pages_range() thinks it's unexpectedly in the middle
of a THP page.  This can be reproduced with default config since 3.11
kernels.  A reproducer can be found in the kernel's selftest directory
for networking by running ./psock_tpacket.

The problem is that an order=2 compound page (allocated by
alloc_one_pg_vec_page() is part of the munlocked VM_MIXEDMAP vma (mapped
by packet_mmap()) and mistaken for a THP page and assumed to be order=9.

The checks for THP in munlock came with commit ff6a6da60b89 ("mm:
accelerate munlock() treatment of THP pages"), i.e.  since 3.9, but did
not trigger a bug.  It just makes munlock_vma_pages_range() skip such
compound pages until the next 512-pages-aligned page, when it encounters
a head page.  This is however not a problem for vma's where mlocking has
no effect anyway, but it can distort the accounting.

Since commit 7225522bb429 ("mm: munlock: batch non-THP page isolation
and munlock+putback using pagevec") this can trigger a VM_BUG_ON in
PageTransHuge() check.

This patch fixes the issue by adding VM_MIXEDMAP flag to VM_SPECIAL, a
list of flags that make vma's non-mlockable and non-mergeable.  The
reasoning is that VM_MIXEDMAP vma's are similar to VM_PFNMAP, which is
already on the VM_SPECIAL list, and both are intended for non-LRU pages
where mlocking makes no sense anyway.  Related Lkml discussion can be
found in [2].

 [1] tools/testing/selftests/net/psock_tpacket
 [2] https://lkml.org/lkml/2014/1/10/427

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Reported-by: Daniel Borkmann <dborkman@redhat.com>
Tested-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: John David Anglin <dave.anglin@bell.net>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Jared Hulbert <jaredeh@gmail.com>
Tested-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/mm.h | 2 +-
 mm/huge_memory.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a6154b1..e99f9fb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -155,7 +155,7 @@ extern unsigned int kobjsize(const void *objp);
  * Special vmas that are non-mergable, non-mlock()able.
  * Note: mm/huge_memory.c VM_NO_THP depends on this definition.
  */
-#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP)
+#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
 
 /*
  * mapping from the currently active vm_flags protection bits (the
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 46a02bf..2eb6e38 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1919,7 +1919,7 @@ out:
 	return ret;
 }
 
-#define VM_NO_THP (VM_SPECIAL|VM_MIXEDMAP|VM_HUGETLB|VM_SHARED|VM_MAYSHARE)
+#define VM_NO_THP (VM_SPECIAL | VM_HUGETLB | VM_SHARED | VM_MAYSHARE)
 
 int hugepage_madvise(struct vm_area_struct *vma,
 		     unsigned long *vm_flags, int advice)
-- 
1.9.1

