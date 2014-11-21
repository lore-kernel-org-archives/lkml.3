Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaKUXGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 18:06:10 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:32998 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaKUXGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 18:06:08 -0500
MIME-Version: 1.0
In-Reply-To: <20141121201415.GK4569@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <544E1143.1080905@huawei.com> <20141029174607.GK19606@redhat.com>
 <CAFEAcA9JNVsT57Zgy96+cfdWBABE4_g4yJG7Te8Oa8ReXZqeRQ@mail.gmail.com> <20141121201415.GK4569@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 21 Nov 2014 23:05:45 +0000
Message-ID: <CAFEAcA9c7spP1wAqWFE4r=uZVyT2ZfZGZ2MJhjTCgfs5YiSONg@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH 00/17] RFC: userfault v2
To: Andrea Arcangeli <aarcange@redhat.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2014 20:14, Andrea Arcangeli <aarcange@redhat.com> wrote:
> Hi Peter,
>
> On Wed, Oct 29, 2014 at 05:56:59PM +0000, Peter Maydell wrote:
>> On 29 October 2014 17:46, Andrea Arcangeli <aarcange@redhat.com> wrote:
>> > After some chat during the KVMForum I've been already thinking it
>> > could be beneficial for some usage to give userland the information
>> > about the fault being read or write
>>
>> ...I wonder if that would let us replace the current nasty
>> mess we use in linux-user to detect read vs write faults
>> (which uses a bunch of architecture-specific hacks including
>> in some cases "look at the insn that triggered this SEGV and
>> decode it to see if it was a load or a store"; see the
>> various cpu_signal_handler() implementations in user-exec.c).
>
> There's currently no plan to deliver to userland read access
> notifications of a present page, simply because the task of the
> userfaultfd is to handle the page fault in userland, but if the page
> is mapped and readable it won't fault in the first place :). I just
> mean it's not like gdb read watch.

If it's mapped and readable-but-not-writable then it should still
fault on write accesses, though? These are cases we currently get
SEGV for, anyway.

> Even if the region would be set to PROT_NONE it would still SEGV
> without triggering an userfault (after all pte_present would still
> true because the page is still mapped despite not being readable, so
> in any case it wouldn't be considered a not-present page fault).

Ah, I guess we have a terminology difference. I was considering
"page fault" to mean (roughly) "anything that causes the CPU to
take an exception on an attempted load/store" and expected that
userfaultfd would notify userspace of any of those. (Well, not
alignment faults, maybe, but I'm definitely surprised that
access permission issues don't get reported the same way as
page-completely-missing issues. In other words I was expecting
that this was "everything previously reported via SIGSEGV or
SIGBUS now comes via userfaultfd".)

> Temporarily removing/moving the page with remap_anon_pages shall be
> much better than using PROT_NONE for this (or alternative syscall name
> to differentiate it further from remap_file_pages, or equivalent
> userfaultfd command if we decide to hide the pte/pmd mangling as
> userfaultfd commands instead of adding new standalone syscalls).

We don't use PROT_NONE for the linux-user situation, we just use
mprotect() to remove the PAGE_WRITE permission so it's still
readable.

I suspect actually linux-user would be better off implementing
something like "if this is a page which we've mapped read-only
because we translated code out of it, then go ahead and remap
it r/w and throw away the translation and retry the access,
otherwise report SEGV to the guest", because taking SEGVs shouldn't
be a fast path in the guest binary. That would let us work without
architecture-specific junk and without requiring new kernel
features either. So you can ignore this whole tangent thread :-)

thanks
-- PMM
