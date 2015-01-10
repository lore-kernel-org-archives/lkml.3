Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbbAJEjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 23:39:09 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:44452 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbbAJEjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 23:39:07 -0500
MIME-Version: 1.0
In-Reply-To: <54B09CA3.1060501@redhat.com>
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com>
	<54AE7D53.2020305@redhat.com>
	<20150109121348.GD12942@leverpostej>
	<CAPvkgC23LHhs7Tw4rdAPFooimonji8R7kEAbWYRKPJwouwUzBA@mail.gmail.com>
	<54AFE53A.4020004@redhat.com>
	<20150109175702.GA27787@leverpostej>
	<54B01FF0.3020900@arm.com>
	<20150109194333.GA23028@arm.com>
	<54B09CA3.1060501@redhat.com>
Date: Fri, 9 Jan 2015 20:39:05 -0800
X-Google-Sender-Auth: S2WQrN309QrhFMyv1qeT9DXcv4o
Message-ID: <CA+55aFw3aGeiWOiKxQaC23VVX_Q9B0cDeZc37vVfK+SJVjGwFw@mail.gmail.com>
Subject: Re: Linux 3.19-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Laszlo Ersek <lersek@redhat.com>
Cc: Mark Langsdorf <mlangsdo@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        "vishnu.ps@samsung.com" <vishnu.ps@samsung.com>,
        main kernel list <linux-kernel@vger.kernel.org>,
        arm kernel list <linux-arm-kernel@lists.infradead.org>,
        Kyle McMartin <kmcmarti@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 7:29 PM, Laszlo Ersek <lersek@redhat.com> wrote:
>
> I've bisected this issue to

.. commit f045bbb9fa1b ("mmu_gather: fix over-eager
tlb_flush_mmu_free() calling")

Hmm. That commit literally just undoes something that commit
fb7332a9fedf ("mmu_gather: move minimal range calculations into
generic code") changed, and that was very wrong on x86.

But arm64 did have very different TLB flushing logic, so there may be
some ARM64 reason that Will did that change originally, and then he
forgot that reason when he ack'ed commit f045bbb9fa1b that undid it.

Will?

Before your mmu_gather range calculations commit, we used to have

In tlb_flush_mmu_tlbonly():

     tlb->need_flush = 0;

and in tlb_flush_mmu():

    if (!tlb->need_flush)
                return;

and your commit changed the rule to be

    !tlb->need_flush == !tlb->end

so in the current tree we have

 In tlb_flush_mmu_tlbonly():

    __tlb_reset_range(tlb);   // replaces "tlb->need_flush = 0;"

and in tlb_flush_mmu():

    if (!tlb->end)    // replaces if (!tlb->need_flush)
        return;

so we seem to do exactly the same as 3.18.

But in your original patch, you moved that "if (!tlb->end) return;"
check from tlb_flush_mmu() into tlb_flush_mmu_tlbonly(), and that
apparently is actually needed on arm64. But *why*?

Also, looking at that commit fb7332a9fedf, I note that some of the
"need_flush" setting was simply removed. See for example
arch/powerpc/mm/hugetlbpage.c, and also in mm/memory.c:
tlb_remove_table(). Is there something non-obvious that sets tlb->end
there?

The other need_flush removals seem to all be paired with adding a
__tlb_adjust_range() call, which will set ->end.

I'm starting to suspect that you moved the need_flush test into
tlbonly exactly because you removed that

        tlb->need_flush = 1;

from mm/memory.c: tlb_remove_table().

x86 doesn't care, because x86 doesn't *use* tlb_remove_table(). But
arm64 does, at least with the RCU freeing.

Any ideas?

                         Linus
