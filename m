Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422712Ab3BGWPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:15:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422655Ab3BGWPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:15:04 -0500
Date: Thu, 7 Feb 2013 14:15:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Odd ENOMEM being returned in 3.8-rcX
Message-Id: <20130207141502.04625ea0.akpm@linux-foundation.org>
In-Reply-To: <20130207215742.GB31684@hansolo.jdub.homelinux.org>
References: <20130207215742.GB31684@hansolo.jdub.homelinux.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2013 16:57:42 -0500
Josh Boyer <jwboyer@redhat.com> wrote:

> Hi All,
> 
> We've hit a weird error in Fedora using the 3.8-rcX kernels.  It seems
> the mock tool is getting back ENOMEM when doing very simple things that
> normally just work.  The 3.7 kernels on the same userspace work just
> fine.  It seems just running 'mock init -v' is enough to cause the
> failure.

I assume you're not seeing the "page allocation failure" message and
backtrace.  This means that either

a) it's a __GFP_NOWARN callsite.  This is rare.  Or

b) it's actually a different error but someone went and overwrote a
   callee's return value with -ENOMEM.  We do this a lot and it sucks.

> Because this is the rawhide kernel, we have some debug options enabled.
> This happens to trigger this error:
> 
> [   89.143660] BUG: sleeping function called from invalid context at kernel/nsproxy.c:217
> [   89.143729] in_atomic(): 0, irqs_disabled(): 1, pid: 1329, name: mock
> [   89.143776] no locks held by mock/1329.
> [   89.143778] irq event stamp: 324562
> [   89.143781] hardirqs last  enabled at (324561): [<ffffffff81163a8d>] get_page_from_freelist+0x51d/0x990
> [   89.143791] hardirqs last disabled at (324562): [<ffffffff816daa9d>] _raw_spin_lock_irq+0x1d/0x60
> [   89.143798] softirqs last  enabled at (323936): [<ffffffff81070438>] __do_softirq+0x168/0x3d0
> [   89.143804] softirqs last disabled at (323931): [<ffffffff816e587c>] call_softirq+0x1c/0x30
> [   89.143811] Pid: 1329, comm: mock Not tainted 3.8.0-0.rc6.git1.1.fc19.x86_64 #1
> [   89.143814] Call Trace:
> [   89.143823]  [<ffffffff8109f8d9>] __might_sleep+0x179/0x230
> [   89.143828]  [<ffffffff81097887>] switch_task_namespaces+0x27/0x60
> [   89.143833]  [<ffffffff810978d0>] exit_task_namespaces+0x10/0x20
> [   89.143839]  [<ffffffff81064692>] copy_process.part.22+0xe32/0x1640
> [   89.143844]  [<ffffffff81064f95>] do_fork+0xa5/0x450
> [   89.143849]  [<ffffffff816db718>] ? retint_swapgs+0x13/0x1b
> [   89.143854]  [<ffffffff810653c6>] sys_clone+0x16/0x20
> [   89.143859]  [<ffffffff816e48b9>] stub_clone+0x69/0x90
> [   89.143864]  [<ffffffff816e44d9>] ? system_call_fastpath+0x16/0x1b
> 
> At first glance it seems copy_io is failing (possibly because
> get_task_io_context fails), and then the above fallout is printed.  The
> warning seems fairly valid, but I don't think that is the root of the
> problem.

yes, get_task_io_context() might be the place.  Tried adding a few
error-path printks in there to see what's happening?

I can't see anything around there which leaves interrupts disabled
though.  It's quite likely that there's some code with is forgetting to
reenable interrupts on a rarely-tested error path, and that ENOMEM is
tickling the bug.

> We've seen this as far back as Linux v3.8-rc2-116-g5f243b9 so far.  I
> can still hit it with 3.8-rc6 as well.
> 
> I'm still trying to see if the ENOMEM hits without the debug options set,
> and exactly which commit caused it.  I just wanted to see if anyone else
> had seen odd python issues or other things failing with ENOMEM when they
> shouldn't while I'm off debugging.
> 
> Thoughts/tips would be appreciated.


