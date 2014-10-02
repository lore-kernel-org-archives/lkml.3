Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaJBP5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:57:36 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:55730 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaJBP5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:57:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1410020142230.6383@eggly.anvils>
References: <20140930033327.GA14558@redhat.com>
	<CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>
	<20140930043309.GA16196@redhat.com>
	<CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>
	<CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>
	<20140930160510.GA15903@redhat.com>
	<CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com>
	<20140930162201.GC15903@redhat.com>
	<20140930164047.GA18354@redhat.com>
	<CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com>
	<20140930182059.GA24431@redhat.com>
	<CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com>
	<alpine.LSU.2.11.1410010031070.1902@eggly.anvils>
	<CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com>
	<alpine.LSU.2.11.1410020142230.6383@eggly.anvils>
Date: Thu, 2 Oct 2014 08:57:32 -0700
X-Google-Sender-Auth: xCmCAGuv4tJNgMQfu2g05Gh1WII
Message-ID: <CA+55aFwR_QXwRhPLU7rS4hWiXmB_Eu32dxAT2FNR_Kwm0hfG0w@mail.gmail.com>
Subject: Re: pipe/page fault oddness.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Sasha Levin <sasha.levin@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 1:47 AM, Hugh Dickins <hughd@google.com> wrote:
>
> I hesitate to admit, I still don't see it: please illuminate further.

No, your'e looking at what I was looking.

> We're talking about the loop in __split_huge_page_map(), where it does

Yes.

>                         entry = mk_pte(page + i, vma->vm_page_prot);
>                         entry = maybe_mkwrite(pte_mkdirty(entry), vma);
>                         if (!pmd_write(*pmd))
>                                 entry = pte_wrprotect(entry);
>                         if (!pmd_young(*pmd))
>                                 entry = pte_mkold(entry);
>                         if (pmd_numa(*pmd))
>                                 entry = pte_mknuma(entry);
>
> , right?  I only see that adding _PAGE_NUMA to _PAGE_PROTNONE if
> pmd_numa(*pmd): but that would mean we had already gone wrong, setting
> pmd_numa in a PROT_NONE vma, which task_numa_work takes care not to do;
> or have mprotected an area to PROT_NONE without doing the pmd_mknonnuma.

Fair enough. Except this code has no locking that I see, so if we
*ever* see that numa entry in the pmd while walking the page tables in
vmscan, we're basically screwed.

> Or are you noticing a deficiency in the pmd locking?  I have not
> worked my way through that, so cannot guarantee it, but please
> point me to the weakness where you see it.

So I don't see any locking at all wrt mprotect (or new mmap). That's
kind of the whole point for page-out - it bypasses all the normal VM
locks, and only uses the last pte locking.

So the whole use of vma->vm_page_prot here is a bit scary. That gets
modified outside of the page table locks. So how do you know it's not
already PROT_NONE, but mprotect just hasn't gotten to actually take
the page table locks yet?

I dunno. It all makes me just very nervous. The whole "numa bit is
separate from the protections, has different locking, and is just
oddly and subtly different" is really what I fundamentally object to.
And it seems so _unnecessary_. All this odd complexity for no actual
gain - just extra code, and extra room for subtle bugs. Which is
exactly why I hate that magic NUMA bit so much.

                  Linus
