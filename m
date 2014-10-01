Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaJAQBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:01:45 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:49834 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaJAQBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:01:43 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1410010031070.1902@eggly.anvils>
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
Date: Wed, 1 Oct 2014 09:01:41 -0700
X-Google-Sender-Auth: nQBwJYm3vmnDoaH28Mw2z3gyR6M
Message-ID: <CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com>
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

On Wed, Oct 1, 2014 at 1:19 AM, Hugh Dickins <hughd@google.com> wrote:
>
> Irrelevance follows...

Maybe not irrelevant.

> There *appears* to be a risk of hitting the VM_BUG_ON, or with no
> VM_BUG_ON (as in 3.17-rc) pte_mknuma proceeding to add _PAGE_NUMA
> to _PAGE_PROTNONE - making the pte then fail the pte_numa test,
> but pass the pte_special test, hence fail the vm_normal_page test:
> when coming from change_prot_numa serving MPOL_MF_LAZY for mbind.

Ugh, yes. The whole _PAGE_NUMA is still a f*cking mess. I hate it.
Hate it, hate it, hate it.

We need to get rid of it, and just make it the same as pte_protnone().
And then the real protnone is in the vma flags, and if you actually
ever get to a pte that is marked protnone, you know it's a numa page.

Seriously.

I never understood what the objection to that was, but every time I
tell people to do it, they go crazy and think _PAGE_NUMA makes sense.
It doesn't. There's no excuse. Rik, what was your broken excuse again?
Something to do with Powerpc, but it is obviously not true, since
powerpc supports protnone just fine.

Even our own comments are confused, with include/asm-generic/pgtable.h saying:

 * _PAGE_NUMA works identical to _PAGE_PROTNONE (it's actually the
 * same bit too).

but no, it's not the same bit.

Can we please just get rid of _PAGE_NUMA. There is no excuse for it.

> However, that would still not explain Dave's endless refaulting;

Why not? You start out with a PROTNONE, trigger shrink_page_list() on
a hugepage,.which calls add_to_swap(), which does
split_huge_page_to_list(), which in turn calls __split_huge_page(),
and that turns (_PAGE_PROTNONE) into (_PAGE_PROTNONE|_PAGE_NUMA),
which you will then fault on forever, because the kernel thinks the
page is present, but not a NUMA page.

IOW, it's *exactly* the same f*cking confusion between _PAGE_NUMA and
_PAGE_PROTNONE I've complained about before.

> Some time wasted on that, but I learnt a valuable debugging technique:
> #undef EINVAL
> #define EINVAL __LINE__

Wow. There's a certain beauty in the pure crazyness.

However, be careful: our IS_ERR() handling knows that error numbers
are < 4096. So on a big file, and error pointers, that doesn't work
reliably.

              Linus
