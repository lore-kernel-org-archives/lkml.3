Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbaHZOfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:35:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610AbaHZOfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:35:19 -0400
Date: Tue, 26 Aug 2014 16:32:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ipc/shm: fix the historical/wrong mm->start_stack
	check
Message-ID: <20140826143227.GA30900@redhat.com>
References: <20140823144246.GA6281@redhat.com> <20140825191207.GA26106@redhat.com> <alpine.LSU.2.11.1408251303220.25799@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1408251303220.25799@eggly.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25, Hugh Dickins wrote:
>
> On Mon, 25 Aug 2014, Oleg Nesterov wrote:
>
> >    As Hugh pointed out, we actually need to require the additional
> >    guard page, but this code was written before linux had it.
> >
> > 3. This wrongly assumes that the stack can only grown down.
> >
> > Personally I think we should simply kill this check, but I did not
> > dare to do this. So the patch only fixes the 1st problem (mostly to
> > avoid the usage of mm->start_stack) and ignores the VM_GROWSUP case.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Sorry, I cannot ack this,

Hugh, I appreciate you nack even more. Thanks!

> because your comment below "at least 4 pages
> plus a guard page enforced by check_stack_guard_page()" makes no sense
> to me as an explanation for the 5.  The guard page (gap) enforced by
> check_stack_guard_page() is already at vma->vm_start
                              ^^^^^^^^^^^^^^^^^^^^^^^^
Ahh. Yes I misunderstood this logic. And yes, you tried to explain it
twice but I was too stupid.

> I did come across 2.6.34's 128k stack_expand inherited from 2.6.11's
> 20 page EXTRA_STACK_VM_PAGES.  With Linus's guard page enforcing a
> page gap since 2.6.36.

OK, and setup_arg_pages() still does expand_stack() although stack_expand
depends on RLIMIT_STACK. But I think this doesn't matter. The room was
already reserved, in general mm->start_stack points into the middle of
the stack.

So that check in do_shmat() can only help if the stack was not expanded
due to the low RLIMIT_STACK, then this application raises RLIMIT_STACK,
then does do_shmat(). But in this case it should likely crash when exec
returns to usermode.

> and our difficulty
> in communicating a sensible way of updating and describing the test,

I like your polite interpretation of my ignorance and inability to listen ;)

> now drives me to agree with you.  Please just rip out the start_stack
> test and the comment defending it.

Great. Will do.

Oleg.

