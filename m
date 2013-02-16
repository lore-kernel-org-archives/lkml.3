Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3BPTsK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 14:48:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab3BPTsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 14:48:08 -0500
Date: Sat, 16 Feb 2013 20:46:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ben Chan <benchan@chromium.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 5/5] coredump: ignore non-fatal signals when core
	dumping to a pipe
Message-ID: <20130216194643.GA31569@redhat.com>
References: <1361008406-2307-1-git-send-email-msb@chromium.org> <1361008406-2307-5-git-send-email-msb@chromium.org> <20130216171010.GE4910@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130216171010.GE4910@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Oleg Nesterov wrote:
>
> On 02/16, Mandeep Singh Baines wrote:
> >
> > +static int sigkill_pending(struct task_struct *tsk)
> > +{
> > +	return	signal_pending(tsk) &&
> > +		(sigismember(&tsk->pending.signal, SIGKILL) ||
> > +		 sigismember(&tsk->signal->shared_pending.signal, SIGKILL));
> > +}
>
> Why? __fatal_signal_pending() is enough, you do not need to check
> ->shared_pending. And once again, ignoring the freezer problems I
> do not think we need this check at all.
>
> IOW. Yes, we will probably need to do this change but only to be
> freezer-friendly.

And, forgot to mention, this logic is not right in the multi-
threaded case. I mean, you can't assume that 'kill -9 dumpingtask"
will wake the coredumping thread up. So this sigkill_pending() or
__fatal_signal_pending() check can only work in the single-threaded
case.

> --- x/fs/coredump.c
> +++ x/fs/coredump.c
> @@ -416,17 +416,17 @@ static void wait_for_dump_helpers(struct
>  	pipe_lock(pipe);
>  	pipe->readers++;
>  	pipe->writers--;
> +	// TODO: wake_up_interruptible_sync_poll ?
> +	wake_up_interruptible_sync(&pipe->wait);
> +	kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
> +	pipe_unlock(pipe);
>
> -	while ((pipe->readers > 1) && (!signal_pending(current))) {
> -		wake_up_interruptible_sync(&pipe->wait);
> -		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
> -		pipe_wait(pipe);
> -	}
> +	wait_event_freezekillable(&pipe->wait, pipe->readers == 1);

I tried to check (but didn't even try to test). I think this should
work. Assuming that we teach SIGKILL to actually kill the dumper, but
we need this in any case.

But. Then we need to change pipe_release() to use wake_up_sync_poll()
(which we do not have). Probably we can do this... but otoh if we protect
the dumping thread from the non-fatal signals (and again, we need this
anyway ;) then we can simply do wait_event_freezable().

Damn. I need to think more.

Oleg.

