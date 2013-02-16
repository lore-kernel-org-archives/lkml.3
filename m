Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3BPRGv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 12:06:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab3BPRGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 12:06:49 -0500
Date: Sat, 16 Feb 2013 18:05:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ben Chan <benchan@chromium.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 5/5] coredump: abort core dump piping only due to a
	fatal signal
Message-ID: <20130216170513.GA4910@redhat.com>
References: <1360885096-21207-1-git-send-email-msb@chromium.org> <1360885096-21207-5-git-send-email-msb@chromium.org> <20130215150117.GB30829@redhat.com> <CACBanvrdpJ=MZGgF1-562pJ4_7ZLFY5w83ZnY-NaS6E+AgyVPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACBanvrdpJ=MZGgF1-562pJ4_7ZLFY5w83ZnY-NaS6E+AgyVPg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, Mandeep Singh Baines wrote:
>
> On Fri, Feb 15, 2013 at 7:01 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > It is not enough and imho not good. Damn, I'll try very much to make the
> > patches on weekend...
> >
> >> -     while ((pipe->readers > 1) && (!signal_pending(current))) {
> >> +     while ((pipe->readers > 1) && (!fatal_signal_pending(current))) {
> >
> > This turns pipe_wait() belowe into the busy-wait loop if signal_pending().
>
> D'oh. Thanks for catching that.
>
> Fixed in v3 by blocking non-fatal signals.

Doesn't look correct...

> > Not good. And not enough, there are other reasons why coredump can fail
> > if the signal is pending.
>
> What other reasons did you have in mind?

Say, pipe_write() can fail if signal_pending() == T.

> Since applying an earlier version of this patch, truncated/missing
> coredumps are no longer any issue for us.

Sure, this "almost works". But this is doesn't really work.

And more importantly, we should fix another problem, SIGKILL should
really stop the coredumping, and I do not see a simple solution, the
main problem is the races with the exiting threads...

> Could the other reasons be addressed in another patch?

Well. Personally I believe we should fix the problems with signals
first, then add the freezer changes...

> >>               wake_up_interruptible_sync(&pipe->wait);
> >>               kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
> >>               pipe_wait(pipe);
> >> +             pipe_unlock(pipe);
> >> +             try_to_freeze();
> >
> > Oh, yes. One of the problems with coredump/signals is freezer. Not sure
> > what should we do...
> >
> > But if we add try_to_freeze() here, we need to add more try_to_freeze's,
> > think about dumping the huge core on the slow media.
> >
>
> We could add more try_to_freeze()s in the dump_write paths to work
> even better with freezer. Do you see any issues with just adding it
> here for a start. It fixes the non-slow media case.

The only issue is that, again, this change pretends to work but it doesn't ;)
IOW, imho you fix the symptom only.

Lets forget about the slow media, consider the piped coredump (the case
you are trying to fix). Suppose that try_to_freeze_tasks() is in progress,
the user-space coredump handler is already frozen, and the dumping thread
does pipe_write()->pipe_wait().

If only we could change pipe_wait() to do freezable_schedule()...

Oleg.

