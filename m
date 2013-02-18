Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab3BRXzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 18:55:46 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:56333 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550Ab3BRXzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 18:55:45 -0500
MIME-Version: 1.0
In-Reply-To: <20130216194643.GA31569@redhat.com>
References: <1361008406-2307-1-git-send-email-msb@chromium.org>
	<1361008406-2307-5-git-send-email-msb@chromium.org>
	<20130216171010.GE4910@redhat.com>
	<20130216194643.GA31569@redhat.com>
Date: Mon, 18 Feb 2013 15:55:44 -0800
X-Google-Sender-Auth: WpmQGWC2ywt9HiI8qYO8m1kRDm8
Message-ID: <CACBanvqTmrQX2a885MjtjW02-+JE9ERBW8z1LL=aYObir+2Dwg@mail.gmail.com>
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

On Sat, Feb 16, 2013 at 11:46 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/16, Oleg Nesterov wrote:
>>
>> On 02/16, Mandeep Singh Baines wrote:
>> >
>> > +static int sigkill_pending(struct task_struct *tsk)
>> > +{
>> > +   return  signal_pending(tsk) &&
>> > +           (sigismember(&tsk->pending.signal, SIGKILL) ||
>> > +            sigismember(&tsk->signal->shared_pending.signal, SIGKILL));
>> > +}
>>
>> Why? __fatal_signal_pending() is enough, you do not need to check
>> ->shared_pending. And once again, ignoring the freezer problems I
>> do not think we need this check at all.
>>

The problem is that the kill signal remains in shared pending since
it'll never get dequeued.

localhost ~ # kill -KILL $!
localhost ~ # cat /proc/$!/status | grep -A4 SigPnd
SigPnd: 0000000000000000
ShdPnd: 0000000000000100
SigBlk: 0000000000000000
SigIgn: 0000000000000000
SigCgt: 0000000000000000

Normally a fatal signal will get propagated to the whole group but
that doesn't happen here because GROUP_EXIT is set:

        /*
         * Found a killable thread.  If the signal will be fatal,
         * then start taking the whole group down immediately.
         */
        if (sig_fatal(p, sig) &&
            !(signal->flags & (SIGNAL_UNKILLABLE | SIGNAL_GROUP_EXIT)) &&
            !sigismember(&t->real_blocked, sig) &&
            (sig == SIGKILL || !t->ptrace)) {
                /*
                 * This signal will be fatal to the whole group.
                 */


GROUP_EXIT is set in do_coredump->coredump_wait->zap_threads->zap_process.

What if complete_signal was changed to propagate KILL even if
SIGNAL_GROUP_EXIT is set?

Regards,
Mandeep

>> IOW. Yes, we will probably need to do this change but only to be
>> freezer-friendly.
>
> And, forgot to mention, this logic is not right in the multi-
> threaded case. I mean, you can't assume that 'kill -9 dumpingtask"
> will wake the coredumping thread up. So this sigkill_pending() or
> __fatal_signal_pending() check can only work in the single-threaded
> case.
>
>> --- x/fs/coredump.c
>> +++ x/fs/coredump.c
>> @@ -416,17 +416,17 @@ static void wait_for_dump_helpers(struct
>>       pipe_lock(pipe);
>>       pipe->readers++;
>>       pipe->writers--;
>> +     // TODO: wake_up_interruptible_sync_poll ?
>> +     wake_up_interruptible_sync(&pipe->wait);
>> +     kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>> +     pipe_unlock(pipe);
>>
>> -     while ((pipe->readers > 1) && (!signal_pending(current))) {
>> -             wake_up_interruptible_sync(&pipe->wait);
>> -             kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>> -             pipe_wait(pipe);
>> -     }
>> +     wait_event_freezekillable(&pipe->wait, pipe->readers == 1);
>
> I tried to check (but didn't even try to test). I think this should
> work. Assuming that we teach SIGKILL to actually kill the dumper, but
> we need this in any case.
>
> But. Then we need to change pipe_release() to use wake_up_sync_poll()
> (which we do not have). Probably we can do this... but otoh if we protect
> the dumping thread from the non-fatal signals (and again, we need this
> anyway ;) then we can simply do wait_event_freezable().
>
> Damn. I need to think more.
>
> Oleg.
>
