Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab3FDPsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:48:35 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:64500 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3FDPsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:48:33 -0400
Date: Tue, 4 Jun 2013 11:45:01 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Frank Mehnert <frank.mehnert@oracle.com>
Cc: Robin Holt <holt@sgi.com>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: Handling NUMA page migration
Message-ID: <20130604154500.GA5664@gmail.com>
References: <201306040922.10235.frank.mehnert@oracle.com>
 <20130604115807.GF3672@sgi.com>
 <201306041414.52237.frank.mehnert@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <201306041414.52237.frank.mehnert@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 04, 2013 at 02:14:45PM +0200, Frank Mehnert wrote:
> On Tuesday 04 June 2013 13:58:07 Robin Holt wrote:
> > This is probably more appropriate to be directed at the linux-mm
> > mailing list.
> > 
> > On Tue, Jun 04, 2013 at 09:22:10AM +0200, Frank Mehnert wrote:
> > > Hi,
> > > 
> > > our memory management on Linux hosts conflicts with NUMA page migration.
> > > I assume this problem existed for a longer time but Linux 3.8 introduced
> > > automatic NUMA page balancing which makes the problem visible on
> > > multi-node hosts leading to kernel oopses.
> > > 
> > > NUMA page migration means that the physical address of a page changes.
> > > This is fatal if the application assumes that this never happens for
> > > that page as it was supposed to be pinned.
> > > 
> > > We have two kind of pinned memory:
> > > 
> > > A) 1. allocate memory in userland with mmap()
> > > 
> > >    2. madvise(MADV_DONTFORK)
> > >    3. pin with get_user_pages().
> > >    4. flush dcache_page()
> > >    5. vm_flags |= (VM_DONTCOPY | VM_LOCKED)
> > >    
> > >       (resulting flags are VM_MIXEDMAP | VM_DONTDUMP | VM_DONTEXPAND |
> > >       
> > >        VM_DONTCOPY | VM_LOCKED | 0xff)
> > 
> > I don't think this type of allocation should be affected.  The
> > get_user_pages() call should elevate the pages reference count which
> > should prevent migration from completing.  I would, however, wait for
> > a more definitive answer.
> 
> Thanks Robin! Actually case B) is more important for us so I'm waiting
> for more feedback :)
> 
> Frank
> 
> > > B) 1. allocate memory with alloc_pages()
> > > 
> > >    2. SetPageReserved()
> > >    3. vm_mmap() to allocate a userspace mapping
> > >    4. vm_insert_page()
> > >    5. vm_flags |= (VM_DONTEXPAND | VM_DONTDUMP)
> > >    
> > >       (resulting flags are VM_MIXEDMAP | VM_DONTDUMP | VM_DONTEXPAND |
> > >       0xff)
> > > 
> > > At least the memory allocated like B) is affected by automatic NUMA page
> > > migration. I'm not sure about A).
> > > 
> > > 1. How can I prevent automatic NUMA page migration on this memory?
> > > 2. Can NUMA page migration also be handled on such kind of memory without
> > > 
> > >    preventing migration?
> > > 
> > > Thanks,
> > > 
> > > Frank

I was looking at migration code lately, and while i am not an expert at all
in this area. I think there is a bug in the way handle_mm_fault deals, or
rather not deals, with migration entry.

When huge page is migrated its pmd is replace with a special swp entry pmd,
which is a non zero pmd but that does not have any of the huge pmd flag set
so none of the handle_mm_fault path detect it as swap entry. Then believe
its a valid pmd and try to allocate pte under it which should oops.

Attached patch is what i believe should be done (not even compile tested).

Again i might be missing a subtelty somewhere else and just missed where
huge migration entry are dealt with.

Cheers,
Jerome

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-mm-properly-handle-fault-on-huge-page-migration.patch"

>From 22d00055bdd4d88eb01958828e4c0121231a9e01 Mon Sep 17 00:00:00 2001
From: Jerome Glisse <jglisse@redhat.com>
Date: Tue, 4 Jun 2013 11:34:14 -0400
Subject: [PATCH] mm: properly handle fault on huge page migration

When huge page is being migrated it's pmd is non zero but does not have
any of the huge pmd flags set. It's a swap entry pmd. The handle_mm_fault
never check for this case and thus if a fault happen in the huge page
range while it's being migrated handle_mm_fault will interpret badly the
pmd.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 mm/memory.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 6dc1882..e2a039c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3793,6 +3793,7 @@ retry:
 							  pmd, flags);
 	} else {
 		pmd_t orig_pmd = *pmd;
+		swp_entry_t entry;
 		int ret;
 
 		barrier();
@@ -3829,6 +3830,20 @@ retry:
 
 			return 0;
 		}
+
+		swp_entry_t entry = pte_to_swp_entry((pte_t)orig_pmd);
+		if (unlikely(non_swap_entry(entry))) {
+			if (is_migration_entry(entry)) {
+				migration_entry_wait(mm, pmd, address);
+				/* Retry the fault */
+				return 0;
+			} else if (is_hwpoison_entry(entry)) {
+				return VM_FAULT_HWPOISON;
+			} else {
+				/* Something else is wrong invalid pmd print it ? */
+				return VM_FAULT_SIGBUS;
+			}
+		}
 	}
 
 	if (pmd_numa(*pmd))
-- 
1.7.11.7


--KsGdsel6WgEHnImy--
