Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaKUUPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:15:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbaKUUP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:15:27 -0500
Date: Fri, 21 Nov 2014 21:14:15 +0100
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
Message-ID: <20141121201415.GK4569@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <544E1143.1080905@huawei.com>
 <20141029174607.GK19606@redhat.com>
 <CAFEAcA9JNVsT57Zgy96+cfdWBABE4_g4yJG7Te8Oa8ReXZqeRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA9JNVsT57Zgy96+cfdWBABE4_g4yJG7Te8Oa8ReXZqeRQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, Oct 29, 2014 at 05:56:59PM +0000, Peter Maydell wrote:
> On 29 October 2014 17:46, Andrea Arcangeli <aarcange@redhat.com> wrote:
> > After some chat during the KVMForum I've been already thinking it
> > could be beneficial for some usage to give userland the information
> > about the fault being read or write
> 
> ...I wonder if that would let us replace the current nasty
> mess we use in linux-user to detect read vs write faults
> (which uses a bunch of architecture-specific hacks including
> in some cases "look at the insn that triggered this SEGV and
> decode it to see if it was a load or a store"; see the
> various cpu_signal_handler() implementations in user-exec.c).

There's currently no plan to deliver to userland read access
notifications of a present page, simply because the task of the
userfaultfd is to handle the page fault in userland, but if the page
is mapped and readable it won't fault in the first place :). I just
mean it's not like gdb read watch.

Even if the region would be set to PROT_NONE it would still SEGV
without triggering an userfault (after all pte_present would still
true because the page is still mapped despite not being readable, so
in any case it wouldn't be considered a not-present page fault).

If you temporarily remove the page (which requires an unavoidable TLB
flush also considering if the page was previously mapped the TLB could
still resolve it for reads) it would work then, because the plan is to
provide read/write fault information through the userfaultfd.

In theory it would be possible to deliver PROT_NONE faults through
userfault too but it doesn't make much sense because PROT_NONE still
requires a TLB flush, in addition to the vma
modifications/splitting/rbtree-rebalance and the mmap_sem for writing
as well.

Temporarily removing/moving the page with remap_anon_pages shall be
much better than using PROT_NONE for this (or alternative syscall name
to differentiate it further from remap_file_pages, or equivalent
userfaultfd command if we decide to hide the pte/pmd mangling as
userfaultfd commands instead of adding new standalone syscalls). It
would have the only constraint that you must mark the region
MADV_DONTFORK if you intend linux-user to ever fork or it won't work
reliably (that constraint is to eliminate the need of additional rmap
complexity, precisely so that it doesn't turn into something more
intrusive like remap_file_pages). I assume that would be a fine
constraint for linux-user.

Thanks,
Andrea
