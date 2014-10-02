Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaJBMpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:45:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbaJBMpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:45:42 -0400
Date: Thu, 2 Oct 2014 13:45:37 +0100
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: pipe/page fault oddness.
Message-ID: <20141002124537.GL17501@suse.de>
References: <20140930160510.GA15903@redhat.com>
 <CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com>
 <20140930162201.GC15903@redhat.com>
 <20140930164047.GA18354@redhat.com>
 <CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com>
 <20140930182059.GA24431@redhat.com>
 <CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com>
 <alpine.LSU.2.11.1410010031070.1902@eggly.anvils>
 <CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com>
 <CA+55aFzHgemAV7igyG=0pmctTaV7cZfO4fdqukhrCc8VXTrZuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CA+55aFzHgemAV7igyG=0pmctTaV7cZfO4fdqukhrCc8VXTrZuw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 09:18:25AM -0700, Linus Torvalds wrote:
> On Wed, Oct 1, 2014 at 9:01 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > We need to get rid of it, and just make it the same as pte_protnone().
> > And then the real protnone is in the vma flags, and if you actually
> > ever get to a pte that is marked protnone, you know it's a numa page.
> 
> So I'd really suggest we do exactly that. Get rid of "pte_numa()"
> entirely, get rid of "_PAGE_[BIT_]NUMA" entirely, and instead add a
> "pte_protnone()" helper to check for the "protnone" case (which on x86
> is testing the _PAGE_PROTNONE bit, and on most other architectures is
> just testing that the page has no access rights).
> 

Do not interpret the following as being against the idea of taking the
pte_protnone approach. This is intended to give background.

At the time the changes were made to the _PAGE_NUMA bits it was acknowledged
that a full move to prot_none was an option but it was not the preferred
solution at the time. It replaced one set of corner cases with another and
the last time like this time, there was considerable time pressure. The
VMA would be required to distinguish between a NUMA hinting fault and a
real prot_none bit. In most cases, we have the VMA now with the exception
of GUP. GUP would have to unconditionally go into the slow path to do the
VMA lookup. That is not likely to be a big of a problem but it was a concern.

In early implementations based on prot_none there were some VMA-based
protection checks that had higher overhead. At the time, there were severe
problems with overhead due to NUMA balancing and adding more was not
desirable. This has been addressed since with changes in multiple other
areas so it's much less of a concern now than it was. In the current shape,
these probably is not as much a problem as long as any check on pte_numa
was first guarded by a VMA check. One way of handling the corner cases
where would be to pass in the VMA where available and have a VM_BUG_ON that
fires if its a PROT_NONE VMA. That would catch problems during debugging
without adding overhead in the !debug case.

Going back to the start, the PTE bit was used as the approach due to
concerns that a pte_protnone helper would not work on all architectures,
ppc64 in particular.  There was no PROT_NONE bit there and instead prot_none
protections rely on PAGE_USER not being set so it's inaccessible from
userspace. There was discussion at the time that this could conceivably be
broken from some sub-architectures but I don't recall the details. Looking
at the current shape and your patch, it's conceivable that the pte_protnone
could be implemented as a _PAGE_PRESENT && !_PAGE_USER check as long
as it was guarded by a VMA check which x86 requires anyway. Not sure
if that would work for PMDs as I'm not familiar with with ppc64 to tell
offhand. Alternatively, ppc64 would potentially use the bit currently used
for _PAGE_NUMA as a _PROT_NONE bit.

I finished a small series that cleans up a number of issues discovered
recently due to Sasha's testing. It passed light testing and NUMA balancing
works but I cannot comment if they help Dave or Sasha's bugs as I never
managed to reproduce them. I'll post it shortly after I sent this mail.

Again, I'm not opposed to the pte_protnone issue as many of the concerns
I had before have been addressed since or rendered redundant. However,
I won't be able to digest and/or finish your patch in a reasonable time
frame. I'm only partially in work at the moment due to sick (going back
to bed after this mail) and out for a good chunk of next week and the week
after. Minor comments from the patch though

1. ppc64 needs work. Added Aneesh to the cc so he's at least aware
2. That check in pte_offset_kernel can probably go away
3. Ideally, VM_BUG_ON checks should be added to the pte_protnone check to
   ensure the VMA checks have already completed to avoid confusion between
   NUMA hints and real prot_none protections
4. GUP on prot_none now always hits the slow path but can't think of a
   case where that really matters.
5. SWP_OFFSET_SHIFT should be readjusted back if _PAGE_BIT_NUMA is
   removed.
6. It probably should at least be rebased on top of "mm: remove
   misleading ARCH_USES_NUMA_PROT_NONE" simply on the grounds that
   it cleans up some cruft
7. At the risk of pissing you off, pte_protnone_numa might be cleared
   at indicating why protnone is being checked at all

> Then we throw away "pte_mknuma()" and "pte_mknonnuma()" entirely,
> because they are brainless sh*t, and we just use
> 
>     ptent = ptep_modify_prot_start(mm, addr, pte);
>     ptent = pte_modify(ptent, newprot);
>     ptep_modify_prot_commit(mm, addr, pte, ptent);
> 
> reliably instead (where for the mknuma case "newprot" is PROT_NONE,
> and for mknonnuma() it is vma->vm_page_prot. Yes, that means that you
> have to pass in the vma to those functions, but that just makes sense
> anyway.
> 
> And if that means that we lose the numa flag on mprotect etc, nobody sane cares.
> 

Losing a NUMA hinting fault due to operations like mprotect is not a concern.

-- 
Mel Gorman
SUSE Labs
