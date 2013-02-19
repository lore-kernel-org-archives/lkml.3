Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895Ab3BSTdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:33:50 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:58676 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933179Ab3BSTds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:33:48 -0500
MIME-Version: 1.0
In-Reply-To: <20130219142721.GA5709@redhat.com>
References: <1361008406-2307-1-git-send-email-msb@chromium.org>
	<1361008406-2307-5-git-send-email-msb@chromium.org>
	<20130216171010.GE4910@redhat.com>
	<20130216194643.GA31569@redhat.com>
	<CACBanvpOVxdiM3FWMiZMM5sAkxXbguT1VhFMkyQv-ntVPE8Y=Q@mail.gmail.com>
	<20130219142721.GA5709@redhat.com>
Date: Tue, 19 Feb 2013 11:33:47 -0800
X-Google-Sender-Auth: r_mmkxdwc2F_c6o3Jk38dfM0GFo
Message-ID: <CACBanvq+Sdtv-tNXTmJyb3EvXGshC=D4NjR8aVOCjRXcTKp+Mw@mail.gmail.com>
Subject: Re: [PATCH 5/5] coredump: ignore non-fatal signals when core dumping
 to a pipe
From: Mandeep Singh Baines <msb@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ben Chan <benchan@chromium.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 6:27 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/18, Mandeep Singh Baines wrote:
>>
>> On Sat, Feb 16, 2013 at 11:46 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >> --- x/fs/coredump.c
>> >> +++ x/fs/coredump.c
>> >> @@ -416,17 +416,17 @@ static void wait_for_dump_helpers(struct
>> >>       pipe_lock(pipe);
>> >>       pipe->readers++;
>> >>       pipe->writers--;
>> >> +     // TODO: wake_up_interruptible_sync_poll ?
>> >> +     wake_up_interruptible_sync(&pipe->wait);
>> >> +     kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>> >> +     pipe_unlock(pipe);
>> >>
>> >> -     while ((pipe->readers > 1) && (!signal_pending(current))) {
>> >> -             wake_up_interruptible_sync(&pipe->wait);
>> >> -             kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>> >> -             pipe_wait(pipe);
>> >> -     }
>> >> +     wait_event_freezekillable(&pipe->wait, pipe->readers == 1);
>> >
>> > I tried to check (but didn't even try to test). I think this should
>> > work. Assuming that we teach SIGKILL to actually kill the dumper, but
>> > we need this in any case.
>> >
>> > But. Then we need to change pipe_release() to use wake_up_sync_poll()
>> > (which we do not have). Probably we can do this... but otoh if we protect
>> > the dumping thread from the non-fatal signals (and again, we need this
>> > anyway ;) then we can simply do wait_event_freezable().
>> >
>>
>> I like this patch.
>>
>> Could we ignore/drop signals when SIGNAL_GROUP_EXIT but allow SIGKILL.
>>
>> For SIGKILL, wake_up everybody (signal_complete sort of already does this).
>
> Please look at 1-3 I sent. Btw, I slightly tested this series, seems
> to work...
>

They look good to me. I plan on applying them to our tree since we
need a fix ASAP.

>> You'd need to prevent the fake signal from freeezer from setting
>> TIF_SIGPENDING. Maybe just add a SIGNAL_GROUP_EXIT check in freezer.c.
>
> I am thinking about checking SIGNAL_GROUP_COREDUMP but I am not sure,
> perhaps we can make a simpler solution. As for wait_for_dump_helper()
> we do not need any check at all, but we should either fix
> wait_event_freezable (it is actually not right) or change pipe_release()

Is the bug that it will exit on the fake_signal.

> to use TASK_NORMAL instead of TASK_INTERRUPTIBLE.
>

I don't think that bug will affects this patch though.  I think this
should all work if we add a check to freezer.c (or something similar
that is cleaner).

If you add SIGNAL_GROUP_COREDUMP check to freezer.c:

static void fake_signal_wake_up(struct task_struct *p)
{
        unsigned long flags;

        if (lock_task_sighand(p, &flags)) {
-                signal_wake_up(p, 0);
+              if (!p->signal->flags & SIGNAL_GROUP_COREDUMP)
+                              signal_wake_up(p, 0);
                unlock_task_sighand(p, &flags);
        }
}

And change the wait_event_freezekillable() in this patch to just
wait_event_freezable(), shouldn't that just work.

The fake signal will never get sent.

Regards,
Mandeep

>
>
> Mandeep, Andrew, I am really sorry.
>
> I tried to do these changes many times, but _every_ time I had some
> urgent and unexpected work. This time too. I'll try very much to return
> on Friday.
>
> Oleg.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
