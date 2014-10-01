Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaJAQS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:18:27 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:53579 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaJAQS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:18:26 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com>
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
Date: Wed, 1 Oct 2014 09:18:25 -0700
X-Google-Sender-Auth: 4SvYNXY1xSAaqN_Pssxfxz4cZWg
Message-ID: <CA+55aFzHgemAV7igyG=0pmctTaV7cZfO4fdqukhrCc8VXTrZuw@mail.gmail.com>
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

On Wed, Oct 1, 2014 at 9:01 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> We need to get rid of it, and just make it the same as pte_protnone().
> And then the real protnone is in the vma flags, and if you actually
> ever get to a pte that is marked protnone, you know it's a numa page.

So I'd really suggest we do exactly that. Get rid of "pte_numa()"
entirely, get rid of "_PAGE_[BIT_]NUMA" entirely, and instead add a
"pte_protnone()" helper to check for the "protnone" case (which on x86
is testing the _PAGE_PROTNONE bit, and on most other architectures is
just testing that the page has no access rights).

Then we throw away "pte_mknuma()" and "pte_mknonnuma()" entirely,
because they are brainless sh*t, and we just use

    ptent = ptep_modify_prot_start(mm, addr, pte);
    ptent = pte_modify(ptent, newprot);
    ptep_modify_prot_commit(mm, addr, pte, ptent);

reliably instead (where for the mknuma case "newprot" is PROT_NONE,
and for mknonnuma() it is vma->vm_page_prot. Yes, that means that you
have to pass in the vma to those functions, but that just makes sense
anyway.

And if that means that we lose the numa flag on mprotect etc, nobody sane cares.

Seriously, why can't we just do this, and throw away all the crap that
is "numa special case". This would make all the random games in
change_pte_range() just go away entirely, because the whole NUMA thing
really wouldn't be a special case for the pte AT ALL any more. All it
would be is that a pte could be marked PROT_NONE even if the
vma->vm_flags aren't.

Please, please, please? The current _PAGE_NUMA really is a horrible
horrible thing, and may well be the source of this bug.

The fact that it took DaveJ a long time to trigger his lockup would be
entirely consistent with "you have to split a PROTNONE large page due
to memory pressure", so the problem with our current pte_mknuma() that
Hugh points out looks entirely possible to me.

Now, there may be some reason why it can't happen, but even in the
absense of this bug, I really think that _PAGE_NUMA has been a huge
mistake from day one.

                  Linus
