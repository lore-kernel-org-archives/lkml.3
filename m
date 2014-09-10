Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100AbaIJMrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 08:47:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbaIJMri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 08:47:38 -0400
Date: Wed, 10 Sep 2014 13:47:32 +0100
From: Mel Gorman <mgorman@suse.de>
To: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: mm: BUG in unmap_page_range
Message-ID: <20140910124732.GT17501@suse.de>
References: <53E989FB.5000904@oracle.com>
 <53FD4D9F.6050500@oracle.com>
 <20140827152622.GC12424@suse.de>
 <540127AC.4040804@oracle.com>
 <54082B25.9090600@oracle.com>
 <20140908171853.GN17501@suse.de>
 <540DEDE7.4020300@oracle.com>
 <20140909213309.GQ17501@suse.de>
 <540F7D42.1020402@oracle.com>
 <alpine.LSU.2.11.1409091903390.10989@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1409091903390.10989@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 07:45:26PM -0700, Hugh Dickins wrote:
> On Tue, 9 Sep 2014, Sasha Levin wrote:
> > On 09/09/2014 05:33 PM, Mel Gorman wrote:
> > > On Mon, Sep 08, 2014 at 01:56:55PM -0400, Sasha Levin wrote:
> > >> On 09/08/2014 01:18 PM, Mel Gorman wrote:
> > >>> A worse possibility is that somehow the lock is getting corrupted but
> > >>> that's also a tough sell considering that the locks should be allocated
> > >>> from a dedicated cache. I guess I could try breaking that to allocate
> > >>> one page per lock so DEBUG_PAGEALLOC triggers but I'm not very
> > >>> optimistic.
> > >>
> > >> I did see ptl corruption couple days ago:
> > >>
> > >> 	https://lkml.org/lkml/2014/9/4/599
> > >>
> > >> Could this be related?
> > >>
> > > 
> > > Possibly although the likely explanation then would be that there is
> > > just general corruption coming from somewhere. Even using your config
> > > and applying a patch to make linux-next boot (already in Tejun's tree)
> > > I was unable to reproduce the problem after running for several hours. I
> > > had to run trinity on tmpfs as ext4 and xfs blew up almost immediately
> > > so I have a few questions.
> > 
> > I agree it could be a case of random corruption somewhere else, it's just
> > that the amount of times this exact issue reproduced
> 
> Yes, I doubt it's random corruption; but I've been no more successful
> than Mel in working it out (I share responsibility for that VM_BUG_ON).
> 
> Sasha, you say you're getting plenty of these now, but I've only seen
> the dump for one of them, on Aug26: please post a few more dumps, so
> that we can look for commonality.
> 

It's also worth knowing that this is a test running in KVM and fake NUMA. The
hint was that the filesystem used was virtio-9p. I haven't formulated a
theory on how KVM could cause any damage here but it's interesting.

> And please attach a disassembly of change_protection_range() (noting
> which of the dumps it corresponds to, in case it has changed around):
> "Code" just shows a cluster of ud2s for the unlikely bugs at end of the
> function, we cannot tell at all what should be in the registers by then.
> 
> I've been rather assuming that the 9d340902 seen in many of the
> registers in that Aug26 dump is the pte val in question: that's
> SOFT_DIRTY|PROTNONE|RW.
> 
> I think RW on PROTNONE is unusual but not impossible (migration entry
> replacement racing with mprotect setting PROT_NONE, after it's updated
> vm_page_prot, before it's reached the page table). 

At the risk of sounding thick, I need to spell this out because I'm
having trouble seeing exactly what race you are thinking of. 

Migration entry replacement is protected against parallel NUMA hinting
updates by the page table lock (either PMD or PTE level). It's taken by
remove_migration_pte on one side and lock_pte_protection on the other.

For the mprotect case racing again migration, migration entries are not
present so change_pte_range() should ignore it. On migration completion
the VMA flags determine the permissions of the new PTE. Parallel faults
wait on the migration entry and see the correct value afterwards.

When creating migration entries, try_to_unmap calls page_check_address
which takes the PTL before doing anything. On the mprotect side,
lock_pte_protection will block before seeing PROTNONE.

I think the race you are thinking of is a migration entry created for write,
parallel mprotect(PROTNONE) and migration completion. The migration entry
was created for write but remove_migration_pte does not double check the VMA
protections and mmap_sem is not taken for write across a full migration to
protect against changes to vm_page_prot. However, change_pte_range checks
for migration entries marked for write under the PTL and marks them read if
one is encountered. The consequence is that we potentially take a spurious
fault to mark the PTE write again after migration completes but I can't
see how that causes a problem as such.

I'm missing some part of your reasoning that leads to the RW|PROTNONE :(

> But exciting though
> that line of thought is, I cannot actually bring it to a pte_mknuma bug,
> or any bug at all.
> 

On x86, PROTNONE|RW translates as GLOBAL|RW which would be unexpected. It
wouldn't cause this bug but it's sufficiently suspicious to be worth
correcting. In case this is the race you're thinking of, the patch is below.
Unfortunately, I cannot see how it would affect this problem but worth
giving a whirl anyway.

> Mel, no way can it be the cause of this bug - unless Sasha's later
> traces actually show a different stack - but I don't see the call
> to change_prot_numa() from queue_pages_range() sharing the same
> avoidance of PROT_NONE that task_numa_work() has (though it does
> have an outdated comment about PROT_NONE which should be removed).
> So I think that site probably does need PROT_NONE checking added.
> 

That site should have checked PROT_NONE but it can't be the same bug
that trinity is seeing. Minimally trinity is unaware of MPOL_MF_LAZY
according to git grep of the trinity source.

Worth adding this to the debugging mix? It should warn if it encounters
the problem but avoid adding the problematic RW bit.

---8<---
migrate: debug patch to try identify race between migration completion and mprotect

A migration entry is marked as write if pte_write was true at the
time the entry was created. The VMA protections are not double checked
when migration entries are being removed but mprotect itself will mark
write-migration-entries as read to avoid problems. It means we potentially
take a spurious fault to mark these ptes write again but otherwise it's
harmless.  Still, one dump indicates that this situation can actually
happen so this debugging patch spits out a warning if the situation occurs
and hopefully the resulting warning will contain a clue as to how exactly
it happens

Not-signed-off
---
 mm/migrate.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 09d489c..631725c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -146,8 +146,16 @@ static int remove_migration_pte(struct page *new, struct vm_area_struct *vma,
 	pte = pte_mkold(mk_pte(new, vma->vm_page_prot));
 	if (pte_swp_soft_dirty(*ptep))
 		pte = pte_mksoft_dirty(pte);
-	if (is_write_migration_entry(entry))
-		pte = pte_mkwrite(pte);
+	if (is_write_migration_entry(entry)) {
+		/*
+		 * This WARN_ON_ONCE is temporary for the purposes of seeing if
+		 * it's a case encountered by trinity in Sasha's testing
+		 */
+		if (!(vma->vm_flags & (VM_WRITE)))
+			WARN_ON_ONCE(1);
+		else
+			pte = pte_mkwrite(pte);
+	}
 #ifdef CONFIG_HUGETLB_PAGE
 	if (PageHuge(new)) {
 		pte = pte_mkhuge(pte);
