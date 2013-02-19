Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647Ab3BSTqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:46:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823Ab3BSTql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:46:41 -0500
Date: Tue, 19 Feb 2013 20:45:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ben Chan <benchan@chromium.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 5/5] coredump: ignore non-fatal signals when core
	dumping to a pipe
Message-ID: <20130219194517.GA9986@redhat.com>
References: <1361008406-2307-1-git-send-email-msb@chromium.org> <1361008406-2307-5-git-send-email-msb@chromium.org> <20130216171010.GE4910@redhat.com> <20130216194643.GA31569@redhat.com> <CACBanvpOVxdiM3FWMiZMM5sAkxXbguT1VhFMkyQv-ntVPE8Y=Q@mail.gmail.com> <20130219142721.GA5709@redhat.com> <CACBanvq+Sdtv-tNXTmJyb3EvXGshC=D4NjR8aVOCjRXcTKp+Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACBanvq+Sdtv-tNXTmJyb3EvXGshC=D4NjR8aVOCjRXcTKp+Mw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, Mandeep Singh Baines wrote:
>
> On Tue, Feb 19, 2013 at 6:27 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > Please look at 1-3 I sent. Btw, I slightly tested this series, seems
> > to work...
> >
>
> They look good to me. I plan on applying them to our tree since we
> need a fix ASAP.

Great!

> >> You'd need to prevent the fake signal from freeezer from setting
> >> TIF_SIGPENDING. Maybe just add a SIGNAL_GROUP_EXIT check in freezer.c.
> >
> > I am thinking about checking SIGNAL_GROUP_COREDUMP but I am not sure,
> > perhaps we can make a simpler solution. As for wait_for_dump_helper()
> > we do not need any check at all, but we should either fix
> > wait_event_freezable (it is actually not right) or change pipe_release()
>
> Is the bug that it will exit on the fake_signal.

Yes, I understand, but

> I don't think that bug will affects this patch though.  I think this
> should all work if we add a check to freezer.c (or something similar
> that is cleaner).
>
> If you add SIGNAL_GROUP_COREDUMP check to freezer.c:
>
> static void fake_signal_wake_up(struct task_struct *p)
> {
>         unsigned long flags;
>
>         if (lock_task_sighand(p, &flags)) {
> -                signal_wake_up(p, 0);
> +              if (!p->signal->flags & SIGNAL_GROUP_COREDUMP)
> +                              signal_wake_up(p, 0);
>                 unlock_task_sighand(p, &flags);
>         }
> }
>
> And change the wait_event_freezekillable() in this patch to just
> wait_event_freezable(), shouldn't that just work.

I doubt,

> The fake signal will never get sent.

Yes but try_to_freeze_tasks() can fail.

And once again, if wait_event_freezable() was correct we do not care
about the fake signal (in wait_for_dump_helper), so we do not need
to change fake_signal_wake_up. So perhaps we should fix it but this
needs some discussion.

Sorry again for the terse reply (and perhaps I misunderstood you),
I'll try to return to this problem asap. In any case I still think
we should do the freezer fixes on top of signal fixes I sent, and
you seem to agree. Good ;)

Oleg.

