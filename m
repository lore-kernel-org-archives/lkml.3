Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaJBItj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:49:39 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:60715 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaJBItg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:49:36 -0400
Date: Thu, 2 Oct 2014 01:47:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Sasha Levin <sasha.levin@oracle.com>
Subject: Re: pipe/page fault oddness.
In-Reply-To: <CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com>
Message-ID: <alpine.LSU.2.11.1410020142230.6383@eggly.anvils>
References: <20140930033327.GA14558@redhat.com> <CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com> <20140930043309.GA16196@redhat.com> <CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com> <CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>
 <20140930160510.GA15903@redhat.com> <CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com> <20140930162201.GC15903@redhat.com> <20140930164047.GA18354@redhat.com> <CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com>
 <20140930182059.GA24431@redhat.com> <CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com> <alpine.LSU.2.11.1410010031070.1902@eggly.anvils> <CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2014, Linus Torvalds wrote:
> On Wed, Oct 1, 2014 at 1:19 AM, Hugh Dickins <hughd@google.com> wrote:
> 
> Can we please just get rid of _PAGE_NUMA. There is no excuse for it.

I'm no lover of _PAGE_NUMA, and hope that it can be simplified away
as you outline.  What we have in 3.16+3.17 is already an attempt to
improve on what you hated before, but not obviously an improvement.

Mel is the one who knows these issues inside out: maybe he's been
blinkered, but I wouldn't dare to pull it apart without his input.
Myself, I'm not looking beyond fixing whatever is the bug for 3.17.

> > However, that would still not explain Dave's endless refaulting;
> 
> Why not? You start out with a PROTNONE, trigger shrink_page_list() on
> a hugepage,.which calls add_to_swap(), which does
> split_huge_page_to_list(), which in turn calls __split_huge_page(),
> and that turns (_PAGE_PROTNONE) into (_PAGE_PROTNONE|_PAGE_NUMA),
> which you will then fault on forever, because the kernel thinks the
> page is present, but not a NUMA page.

I hesitate to admit, I still don't see it: please illuminate further.

We're talking about the loop in __split_huge_page_map(), where it does

			entry = mk_pte(page + i, vma->vm_page_prot);
			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
			if (!pmd_write(*pmd))
				entry = pte_wrprotect(entry);
			if (!pmd_young(*pmd))
				entry = pte_mkold(entry);
			if (pmd_numa(*pmd))
				entry = pte_mknuma(entry);

, right?  I only see that adding _PAGE_NUMA to _PAGE_PROTNONE if
pmd_numa(*pmd): but that would mean we had already gone wrong, setting
pmd_numa in a PROT_NONE vma, which task_numa_work takes care not to do;
or have mprotected an area to PROT_NONE without doing the pmd_mknonnuma.

Ah, we won't have mmap_sem in the add_to_swap case; so we could be
racing with an mprotect which already updated vm_flags and vm_page_prot,
but has not yet reached this pmd: is that a part of how you see it?

Or are you noticing a deficiency in the pmd locking?  I have not
worked my way through that, so cannot guarantee it, but please
point me to the weakness where you see it.

But when you convince me on that, then I still don't see how we get to
doing the repeated write fault, instead of hitting access_error(), as
you pointed out originally.  That still seems to require a PROTNONE
pte to be left behind in a VM_WRITE vma, which I do not see happening
here.  pte_modify leaves _PAGE_NUMA alone, but updates _PAGE_PROTNONE.
The pte_numa<->pte_special confusion is messy, but I don't yet get
how it would manifest in the manner observed.

But certainly, a bug in the THP splitting feels just right to
match the frequency of the sightings: I hope you've got it.

Hugh
