Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793Ab3BZTns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 14:43:48 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:61286 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab3BZTnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 14:43:47 -0500
MIME-Version: 1.0
In-Reply-To: <CACBanvoOdfZr1x5kU1+fmtex1Cuoas_LwBKwZ_giiLE511E-jg@mail.gmail.com>
References: <20130224173144.GA32179@redhat.com>
	<20130224173206.GA32206@redhat.com>
	<20130224183656.GA8903@redhat.com>
	<CACBanvoOdfZr1x5kU1+fmtex1Cuoas_LwBKwZ_giiLE511E-jg@mail.gmail.com>
Date: Tue, 26 Feb 2013 11:43:46 -0800
X-Google-Sender-Auth: 7FzdY-7GR_t3FPxyb0Vq6EwV_HY
Message-ID: <CACBanvr5vbkH1J+waRHMBq8hRuKqJtF0sD0+95v6Qmnd=3Zd_w@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] freezer: do not send a fake signal to a
 PF_DUMPCORE thread
From: Mandeep Singh Baines <msb@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Neil Horman <nhorman@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 8:37 AM, Mandeep Singh Baines <msb@chromium.org> wrote:
> On Sun, Feb 24, 2013 at 10:36 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> A coredumping thread can't be frozen anyway but the fake signal sent
>> by freeze_task() can confuse dump_write/wait_for_dump_helpers/etc
>> and interrupt the coredump.
>>
>> We are going to make the do_coredump() paths freezable but the fake
>> TIF_SIGPENDING doesn't help, it only makes sense when we assume that
>> the target can return to user-mode and call get_signal_to_deliver().
>>
>> Change freeze_task() to check PF_DUMPCORE along with PF_KTHREAD. We
>> need to recheck PF_DUMPCORE under ->siglock to avoid the race with
>> zap_threads() which can set this flag right before we take the lock.
>>
>
> Won't this prevent suspend?
>
> If there is a wait_event_interruptible in the coredump path, you'll
> wake it up but it will simply go back to sleep. So try_to_freeze_tasks
> will fail waiting for the coredump thread to enter the freezer.
>

You'd rather have reliable suspend than coredumps that aren't
truncated so you need to set TIF_SIGPENDING to break waits in the
dump_write path.

But it would be nice to have both so you'd like to avoid terminating
on a signal. I think you'll need to fix each wait independent by
making it freezable or adding try_to_freeze?

To fix wait_for_dump_helpers:

static void wait_for_dump_helpers(struct file *file)
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

What do you think? That would fix most cases. You'll still get a
truncated core if you were to receive the signal during pipe_write or
something.

Regards,
Mandeep

> Regards,
> Mandeep
>
>> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>> ---
>>  kernel/freezer.c |   19 ++++++++++++-------
>>  1 files changed, 12 insertions(+), 7 deletions(-)
>>
>> diff --git a/kernel/freezer.c b/kernel/freezer.c
>> index c38893b..595afab 100644
>> --- a/kernel/freezer.c
>> +++ b/kernel/freezer.c
>> @@ -85,14 +85,21 @@ bool __refrigerator(bool check_kthr_stop)
>>  }
>>  EXPORT_SYMBOL(__refrigerator);
>>
>> -static void fake_signal_wake_up(struct task_struct *p)
>> +static bool fake_signal_wake_up(struct task_struct *p)
>>  {
>>         unsigned long flags;
>> +       bool ret = false;
>> +
>> +       if (p->flags & (PF_KTHREAD | PF_DUMPCORE))
>> +               return ret;
>>
>>         if (lock_task_sighand(p, &flags)) {
>> -               signal_wake_up(p, 0);
>> +               ret = !(p->flags & PF_DUMPCORE);
>> +               if (ret)
>> +                       signal_wake_up(p, 0);
>>                 unlock_task_sighand(p, &flags);
>>         }
>> +       return ret;
>>  }
>>
>>  /**
>> @@ -100,8 +107,8 @@ static void fake_signal_wake_up(struct task_struct *p)
>>   * @p: task to send the request to
>>   *
>>   * If @p is freezing, the freeze request is sent either by sending a fake
>> - * signal (if it's not a kernel thread) or waking it up (if it's a kernel
>> - * thread).
>> + * signal (if it's not a kernel thread or a coredumping thread) or waking
>> + * it up otherwise.
>>   *
>>   * RETURNS:
>>   * %false, if @p is not freezing or already frozen; %true, otherwise
>> @@ -116,9 +123,7 @@ bool freeze_task(struct task_struct *p)
>>                 return false;
>>         }
>>
>> -       if (!(p->flags & PF_KTHREAD))
>> -               fake_signal_wake_up(p);
>> -       else
>> +       if (!fake_signal_wake_up(p))
>>                 wake_up_state(p, TASK_INTERRUPTIBLE);
>>
>>         spin_unlock_irqrestore(&freezer_lock, flags);
>> --
>> 1.5.5.1
>>
>>
