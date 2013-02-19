Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995Ab3BSO2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:28:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932936Ab3BSO2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:28:48 -0500
Date: Tue, 19 Feb 2013 15:27:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ben Chan <benchan@chromium.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 5/5] coredump: ignore non-fatal signals when core
	dumping to a pipe
Message-ID: <20130219142721.GA5709@redhat.com>
References: <1361008406-2307-1-git-send-email-msb@chromium.org> <1361008406-2307-5-git-send-email-msb@chromium.org> <20130216171010.GE4910@redhat.com> <20130216194643.GA31569@redhat.com> <CACBanvpOVxdiM3FWMiZMM5sAkxXbguT1VhFMkyQv-ntVPE8Y=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACBanvpOVxdiM3FWMiZMM5sAkxXbguT1VhFMkyQv-ntVPE8Y=Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18, Mandeep Singh Baines wrote:
>
> On Sat, Feb 16, 2013 at 11:46 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> --- x/fs/coredump.c
> >> +++ x/fs/coredump.c
> >> @@ -416,17 +416,17 @@ static void wait_for_dump_helpers(struct
> >>       pipe_lock(pipe);
> >>       pipe->readers++;
> >>       pipe->writers--;
> >> +     // TODO: wake_up_interruptible_sync_poll ?
> >> +     wake_up_interruptible_sync(&pipe->wait);
> >> +     kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
> >> +     pipe_unlock(pipe);
> >>
> >> -     while ((pipe->readers > 1) && (!signal_pending(current))) {
> >> -             wake_up_interruptible_sync(&pipe->wait);
> >> -             kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
> >> -             pipe_wait(pipe);
> >> -     }
> >> +     wait_event_freezekillable(&pipe->wait, pipe->readers == 1);
> >
> > I tried to check (but didn't even try to test). I think this should
> > work. Assuming that we teach SIGKILL to actually kill the dumper, but
> > we need this in any case.
> >
> > But. Then we need to change pipe_release() to use wake_up_sync_poll()
> > (which we do not have). Probably we can do this... but otoh if we protect
> > the dumping thread from the non-fatal signals (and again, we need this
> > anyway ;) then we can simply do wait_event_freezable().
> >
>
> I like this patch.
>
> Could we ignore/drop signals when SIGNAL_GROUP_EXIT but allow SIGKILL.
>
> For SIGKILL, wake_up everybody (signal_complete sort of already does this).

Please look at 1-3 I sent. Btw, I slightly tested this series, seems
to work...

> You'd need to prevent the fake signal from freeezer from setting
> TIF_SIGPENDING. Maybe just add a SIGNAL_GROUP_EXIT check in freezer.c.

I am thinking about checking SIGNAL_GROUP_COREDUMP but I am not sure,
perhaps we can make a simpler solution. As for wait_for_dump_helper()
we do not need any check at all, but we should either fix
wait_event_freezable (it is actually not right) or change pipe_release()
to use TASK_NORMAL instead of TASK_INTERRUPTIBLE.



Mandeep, Andrew, I am really sorry.

I tried to do these changes many times, but _every_ time I had some
urgent and unexpected work. This time too. I'll try very much to return
on Friday.

Oleg.

