Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab3BTXan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 18:30:43 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:47842 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab3BTXal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:30:41 -0500
MIME-Version: 1.0
In-Reply-To: <CACBanvo6NqbG7mzD76rM-5kEZ3bOXKfGSbRghvuejSD5S_jnBQ@mail.gmail.com>
References: <1361008406-2307-1-git-send-email-msb@chromium.org>
	<1361008406-2307-5-git-send-email-msb@chromium.org>
	<20130216171010.GE4910@redhat.com>
	<20130216194643.GA31569@redhat.com>
	<CACBanvpOVxdiM3FWMiZMM5sAkxXbguT1VhFMkyQv-ntVPE8Y=Q@mail.gmail.com>
	<20130219142721.GA5709@redhat.com>
	<CACBanvq+Sdtv-tNXTmJyb3EvXGshC=D4NjR8aVOCjRXcTKp+Mw@mail.gmail.com>
	<20130219194517.GA9986@redhat.com>
	<CACBanvo6NqbG7mzD76rM-5kEZ3bOXKfGSbRghvuejSD5S_jnBQ@mail.gmail.com>
Date: Wed, 20 Feb 2013 15:30:41 -0800
X-Google-Sender-Auth: MXkMmyX-Ic2WZdtkdDgmDVVexVc
Message-ID: <CACBanvqF8GjPM0yfEy=7yHCQk5vct6G_T9MD4KJsDiCfwkCQnQ@mail.gmail.com>
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

On Tue, Feb 19, 2013 at 12:20 PM, Mandeep Singh Baines <msb@chromium.org> wrote:
> On Tue, Feb 19, 2013 at 11:45 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> On 02/19, Mandeep Singh Baines wrote:
>>>
>>> On Tue, Feb 19, 2013 at 6:27 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>> > Please look at 1-3 I sent. Btw, I slightly tested this series, seems
>>> > to work...
>>> >
>>>
>>> They look good to me. I plan on applying them to our tree since we
>>> need a fix ASAP.
>>
>> Great!
>>
>>> >> You'd need to prevent the fake signal from freeezer from setting
>>> >> TIF_SIGPENDING. Maybe just add a SIGNAL_GROUP_EXIT check in freezer.c.
>>> >
>>> > I am thinking about checking SIGNAL_GROUP_COREDUMP but I am not sure,
>>> > perhaps we can make a simpler solution. As for wait_for_dump_helper()
>>> > we do not need any check at all, but we should either fix
>>> > wait_event_freezable (it is actually not right) or change pipe_release()
>>>
>>> Is the bug that it will exit on the fake_signal.
>>
>> Yes, I understand, but
>>
>>> I don't think that bug will affects this patch though.  I think this
>>> should all work if we add a check to freezer.c (or something similar
>>> that is cleaner).
>>>
>>> If you add SIGNAL_GROUP_COREDUMP check to freezer.c:
>>>
>>> static void fake_signal_wake_up(struct task_struct *p)
>>> {
>>>         unsigned long flags;
>>>
>>>         if (lock_task_sighand(p, &flags)) {
>>> -                signal_wake_up(p, 0);
>>> +              if (!p->signal->flags & SIGNAL_GROUP_COREDUMP)
>>> +                              signal_wake_up(p, 0);
>>>                 unlock_task_sighand(p, &flags);
>>>         }
>>> }
>>>
>>> And change the wait_event_freezekillable() in this patch to just
>>> wait_event_freezable(), shouldn't that just work.
>>
>> I doubt,
>>
>>> The fake signal will never get sent.
>>
>> Yes but try_to_freeze_tasks() can fail.
>>
>
> Ah. Good point. How about this then:
>
> /* can't use wait_event_freezable since we suppress the fake signal on
> SIGNAL_GROUP_COREDUMP */
> freezer_do_not_count();
> wait_event_interruptible(pipe->wait, pipe->readers == 1);
> freezer_count();
>

No that won't work either. You can't block the fake signal. Since the
dump catcher can keep pipe_write blocked for unbounded time,
user-space can block suspend for unbounded time.

Even worse than bad core dumps is unreliable suspend/resume.

Here the patch I eventually applied to out tree:

{
        struct pipe_inode_info *pipe;

        pipe = file->f_path.dentry->d_inode->i_pipe;

        pipe_lock(pipe);
        pipe->readers++;
        pipe->writers--;

        while (pipe->readers > 1) {
                unsigned long flags;

                wake_up_interruptible_sync(&pipe->wait);
                kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
                pipe_wait(pipe);

                pipe_unlock(pipe);
                try_to_freeze();
                pipe_lock(pipe);

                if (fatal_signal_pending(current))
                        break;

                /* Clear fake signal from freeze_task(). */
                spin_lock_irqsave(&current->sighand->siglock, flags);
                recalc_sigpending();
                spin_unlock_irqrestore(&current->sighand->siglock, flags);
        }

        pipe->readers--;
        pipe->writers++;
        pipe_unlock(pipe);

}

On suspend, you might truncate a core-dump but at least you can
reliably suspend.

Regards,
Mandeep

> Regards,
> Mandeep
>
>> And once again, if wait_event_freezable() was correct we do not care
>> about the fake signal (in wait_for_dump_helper), so we do not need
>> to change fake_signal_wake_up. So perhaps we should fix it but this
>> needs some discussion.
>>
>> Sorry again for the terse reply (and perhaps I misunderstood you),
>> I'll try to return to this problem asap. In any case I still think
>> we should do the freezer fixes on top of signal fixes I sent, and
>> you seem to agree. Good ;)
>>
>> Oleg.
>>
