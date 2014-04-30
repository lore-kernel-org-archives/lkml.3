Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbaD3Pse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:48:34 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:45935 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759371AbaD3Psa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:48:30 -0400
Date: Wed, 30 Apr 2014 18:42:30 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Sasha Levin <sasha.levin@oracle.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mm: hangs in collapse_huge_page
Message-ID: <20140430154230.GA23371@node.dhcp.inet.fi>
References: <534DE5C0.2000408@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534DE5C0.2000408@oracle.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 10:06:56PM -0400, Sasha Levin wrote:
> Hi all,
> 
> I often see hung task triggering in khugepaged within collapse_huge_page().
> 
> I've initially assumed the case may be that the guests are too loaded and
> the warning occurs because of load, but after increasing the timeout to
> 1200 sec I still see the warning.

I suspect it's race (although I didn't track down exact scenario) with
__khugepaged_exit().

Comment in __khugepaged_exit() says that khugepaged_test_exit() always
called under mmap_sem:

2045 void __khugepaged_exit(struct mm_struct *mm)
...
2063         } else if (mm_slot) {
2064                 /*
2065                  * This is required to serialize against
2066                  * khugepaged_test_exit() (which is guaranteed to run
2067                  * under mmap sem read mode). Stop here (after we
2068                  * return all pagetables will be destroyed) until
2069                  * khugepaged has finished working on the pagetables
2070                  * under the mmap_sem.
2071                  */
2072                 down_write(&mm->mmap_sem);
2073                 up_write(&mm->mmap_sem);
2074         }
2075 }

But this is not true. At least khugepaged_scan_mm_slot() calls it without
the sem:

2566 static unsigned int khugepaged_scan_mm_slot(unsigned int pages,
2567                                             struct page **hpage)
...
2046 {
2047         struct mm_slot *mm_slot;
2048         int free = 0;
2049 
2050         spin_lock(&khugepaged_mm_lock);
2051         mm_slot = get_mm_slot(mm);
2052         if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
2053                 hash_del(&mm_slot->hash);
2054                 list_del(&mm_slot->mm_node);
2055                 free = 1;
2056         }
2057         spin_unlock(&khugepaged_mm_lock);
2058 
2059         if (free) {
2060                 clear_bit(MMF_VM_HUGEPAGE, &mm->flags);
2061                 free_mm_slot(mm_slot);
2062                 mmdrop(mm);

Not sure yet if it's a real problem or not. Andrea, could you comment on
this?

Sasha, please try patch below.

Not-Yet-Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b4b1feba6472..1c6ace5207b9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1986,6 +1986,8 @@ static void insert_to_mm_slots_hash(struct mm_struct *mm,
 
 static inline int khugepaged_test_exit(struct mm_struct *mm)
 {
+       VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem) &&
+                       !spin_is_locked(&khugepaged_mm_lock));
        return atomic_read(&mm->mm_users) == 0;
 }
 
@@ -2062,14 +2064,16 @@ void __khugepaged_exit(struct mm_struct *mm)
                mmdrop(mm);
        } else if (mm_slot) {
                /*
-                * This is required to serialize against
-                * khugepaged_test_exit() (which is guaranteed to run
-                * under mmap sem read mode). Stop here (after we
-                * return all pagetables will be destroyed) until
-                * khugepaged has finished working on the pagetables
+                * This is required to serialize against khugepaged_test_exit()
+                * (which is guaranteed to run under mmap sem read mode or
+                * khugepaged_mm_lock).
+                * Stop here (after we return all pagetables will be destroyed)
+                * until khugepaged has finished working on the pagetables
                 * under the mmap_sem.
                 */
                down_write(&mm->mmap_sem);
+               spin_lock(&khugepaged_mm_lock);
+               spin_unlock(&khugepaged_mm_lock);
                up_write(&mm->mmap_sem);
        }
 }
-- 
 Kirill A. Shutemov
