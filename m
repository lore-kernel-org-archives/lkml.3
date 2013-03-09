Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263Ab3CITSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 14:18:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab3CITSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 14:18:36 -0500
Date: Sat, 9 Mar 2013 20:16:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, Neil Horman <nhorman@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] coredump: introduce dump_interrupted()
Message-ID: <20130309191643.GB778@redhat.com>
References: <20130308175852.GA26300@redhat.com> <20130308175915.GA26322@redhat.com> <20130308132046.02e2e6ac44a9fc4e63ed6604@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130308132046.02e2e6ac44a9fc4e63ed6604@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Andrew Morton wrote:
>
> On Fri, 8 Mar 2013 18:59:15 +0100 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Change dump_write(), dump_seek() and do_coredump() to check
> > signal_pending() and abort if it is true.
>
> hm, why.

Firstly. we need these changes to ensure that the coredump won't delay
suspend, and to ensure it reacts to SIGKILL "quickly enough". A core
dump can take a lot of time.

> I think we're missing some context here - this is to support freezing,
> yes?

No. This is to document that

	- currently we do not support freezing

	- why we do not support, and what should we do to support
	  (the comments in dump_interrupted/wait_for_dump_helpers)

If do_coredump() "races" with suspend/etc we simply abort, hopefully
this is fine in practice. And even if we decide to change this later,
I hope this series can be counted as a preparation.

> An example of why this is needed: the dump_interrupted() check which
> was added to dump_seek() is just weird.  An lseek is instantaneous,
                                                       ^^^^^^^^^^^^^
Oh, I simply do not know, this can depend on the filesystem?

> And if the file doesn't support lseek (do such files exist?  should we
> be returning 0 instead of -ENOMEM?),

(can't comment, I do not know)

> we just sit there in a loop
> extending the file with write().  This can take *ages*, but this part
> of dump_seek() *didn't* get the signal check!

The loop does dump_write() which checks dump_interrupted() at the start.

> > Ideally it should do try_to_freeze() but then we need the unpleasant
> > changes in dump_write() and wait_for_dump_helpers(). So far we simply
> > accept the fact that the freezer can truncate a core-dump but at least
> > you can reliably suspend.
>
> OK, so there is some connection between this and suspending.  Details,
> please...

It is not trivial to change dump_write() to restart if f_op->write()
fails because of freezing(). We need to handle the short writes, we need
to clear TIF_SIGPENDING (and we can't rely on recalc_sigpending() unless
we change it to check PF_DUMPCORE), and somehow we need to avoid the
races with freeze_task + __thaw_task.

Everything looks possible but imho doesn't worth a trouble, a coredump
truncated by freezer is tolerable. I hope. And again, even if we decide
to "fix" this problem we can do this on top of these changes.

Oleg.

