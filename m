Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaKYTqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:46:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaKYTqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:46:02 -0500
Date: Tue, 25 Nov 2014 20:45:05 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: zhanghailiang <zhang.zhanghailiang@huawei.com>,
        Robert Love <rlove@google.com>, Dave Hansen <dave@sr71.net>,
        Jan Kara <jack@suse.cz>, kvm-devel <kvm@vger.kernel.org>,
        Neil Brown <neilb@suse.de>, Stefan Hajnoczi <stefanha@gmail.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>, Taras Glek <tglek@mozilla.com>,
        Andrew Jones <drjones@redhat.com>, Juan Quintela <quintela@redhat.com>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Android Kernel Team <kernel-team@android.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Christopher Covington <cov@codeaurora.org>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Paolo Bonzini <pbonzini@redhat.com>, Keith Packard <keithp@keithp.com>,
        Wenchao Xia <wenchaoqemu@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Minchan Kim <minchan@kernel.org>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mike Hommey <mh@glandium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Feiner <pfeiner@google.com>
Subject: Re: [Qemu-devel] [PATCH 00/17] RFC: userfault v2
Message-ID: <20141125194505.GR4569@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <544E1143.1080905@huawei.com>
 <20141029174607.GK19606@redhat.com>
 <CAFEAcA9JNVsT57Zgy96+cfdWBABE4_g4yJG7Te8Oa8ReXZqeRQ@mail.gmail.com>
 <20141121201415.GK4569@redhat.com>
 <CAFEAcA9c7spP1wAqWFE4r=uZVyT2ZfZGZ2MJhjTCgfs5YiSONg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA9c7spP1wAqWFE4r=uZVyT2ZfZGZ2MJhjTCgfs5YiSONg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 11:05:45PM +0000, Peter Maydell wrote:
> If it's mapped and readable-but-not-writable then it should still
> fault on write accesses, though? These are cases we currently get
> SEGV for, anyway.

Yes then it'll work just fine.

> Ah, I guess we have a terminology difference. I was considering
> "page fault" to mean (roughly) "anything that causes the CPU to
> take an exception on an attempted load/store" and expected that
> userfaultfd would notify userspace of any of those. (Well, not
> alignment faults, maybe, but I'm definitely surprised that
> access permission issues don't get reported the same way as
> page-completely-missing issues. In other words I was expecting
> that this was "everything previously reported via SIGSEGV or
> SIGBUS now comes via userfaultfd".)

Just not PROT_NONE SIGSEGV faults, i.e. PROT_NONE would still SIGSEGV
currently. Because it's not a not-present fault (the page is present,
just not mapped readable) and it's neither a wrprotect fault (it is
trapped with the vma vm_flags permission bits instead before the
actual page fault handler is invoked). userfaultfd hooks into the
common code of the page fault handler.

> > Temporarily removing/moving the page with remap_anon_pages shall be
> > much better than using PROT_NONE for this (or alternative syscall name
> > to differentiate it further from remap_file_pages, or equivalent
> > userfaultfd command if we decide to hide the pte/pmd mangling as
> > userfaultfd commands instead of adding new standalone syscalls).
> 
> We don't use PROT_NONE for the linux-user situation, we just use
> mprotect() to remove the PAGE_WRITE permission so it's still
> readable.

Like said above it'll work just fine then.

> I suspect actually linux-user would be better off implementing
> something like "if this is a page which we've mapped read-only
> because we translated code out of it, then go ahead and remap
> it r/w and throw away the translation and retry the access,
> otherwise report SEGV to the guest", because taking SEGVs shouldn't
> be a fast path in the guest binary. That would let us work without
> architecture-specific junk and without requiring new kernel
> features either. So you can ignore this whole tangent thread :-)

You might get a significant boost if you use userfaultfd.

For postcopy live snapshot and postcopy live migration the main
benefit is the removal mprotect as a whole and the performance
improvement is a secondary benefit.

You can cap the max size of the JIT translated cache (and in turn the
maximal number of vmas generated by the mprotects) but we can't cap
the address space fragmentation. The faults may invoke way too many
mprotect and we may fragment the vma too much to the point we get
-ENOMEM.

Marking a page wrprotected however is always tricky, no matter if it's
fork doing it or KSM or something else. KSM just skips page that could
be under gup pins and retries them at the next pass. Fork simply won't
work right currently and it needs MADV_DONTFORK to avoid the
wrprotection entirely where you may use O_DIRECT mixed with threads
and fork.

For this new vma-less syscall (or ufd command) the best we could do is
to print a warning if any page marked wrprotected could be under GUP
pin (the warning could generate false positives as result of
speculative cache lookups that run lockless get_page_unless_zero() on
any pfn).

To avoid races the postcopy live snapshot feature I think it should be
enough to wait all in-flight I/O to complete before marking the guest
address space readonly (the KVM gup() side can be taken care of by
marking the shadow MMU readonly which is a must anyway, the mmu
notifier will take care of that part).

The postcopy live snapshot will have to copy the page so it's
effectively a COW in userland, and in turn it must ensure there's no
O_DIRECT in flight still writing to the page (despite we marked it
readonly) while the wrprotection syscall runs.

For your case probably there's no gup() in the equation unless you use
O_DIRECT (I don't think you use shadow-MMU in the kernel in
linux-user) so you don't have to worry about those races and it's just
simpler.
