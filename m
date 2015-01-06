Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbbAFJ5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 04:57:25 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:33077 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbbAFJ5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 04:57:20 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUUcgP=nUPCOfEJrbO9OAAPLgQd8RWO-BJe+W0wi3fWiOw@mail.gmail.com>
References: <CA+icZUU4ALYvEq7SkUewnZytf62R0d9x+MVPvMrR0zzFf+-f3Q@mail.gmail.com>
	<20150106094039.GI29390@twins.programming.kicks-ass.net>
	<CA+icZUUcgP=nUPCOfEJrbO9OAAPLgQd8RWO-BJe+W0wi3fWiOw@mail.gmail.com>
Date: Tue, 6 Jan 2015 10:57:19 +0100
Message-ID: <CA+icZUUThdtXkRztRxk+zEqvMwUmEQeSoR3WD3qqXW9QspBoVw@mail.gmail.com>
Subject: Re: Linux 3.19-rc3
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 10:42 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Jan 6, 2015 at 10:40 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, Jan 06, 2015 at 05:49:11AM +0100, Sedat Dilek wrote:
>>> This has been there since just before rc1. Is there a fix for this
>>> stalled in someones git tree maybe ?
>>>
>>> [    7.952588] WARNING: CPU: 0 PID: 299 at kernel/sched/core.c:7303
>>> __might_sleep+0x8d/0xa0()
>>> [    7.952592] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff910a0f7a>] prepare_to_wait+0x2a/0x90
>>> [    7.952595] CPU: 0 PID: 299 Comm: systemd-readahe Not tainted 3.19.0-rc3+ #100
>>
>>> [    7.952620]  [<ffffffff911a63e0>] fanotify_read+0xe0/0x5b0
>>
>>
>> http://marc.info/?l=linux-kernel&m=141874374029791
>
> Hehe, I created same fix... did not help here.
>

>From my call-trace...

[   88.028739]  [<ffffffff8124433f>] aio_read_events+0x4f/0x2d0

...and having a quick look at read_events() in...

"
         * But aio_read_events() can block, and if it blocks it's going to flip
         * the task state back to TASK_RUNNING.
"

[ fs/aio.c ]
...
static long read_events(struct kioctx *ctx, long min_nr, long nr,
                        struct io_event __user *event,
                        struct timespec __user *timeout)
{
        ktime_t until = { .tv64 = KTIME_MAX };
        long ret = 0;

        if (timeout) {
                struct timespec ts;

                if (unlikely(copy_from_user(&ts, timeout, sizeof(ts))))
                        return -EFAULT;

                until = timespec_to_ktime(ts);
        }

        /*
         * Note that aio_read_events() is being called as the conditional - i.e.
         * we're calling it after prepare_to_wait() has set task state to
         * TASK_INTERRUPTIBLE.
         *
         * But aio_read_events() can block, and if it blocks it's going to flip
         * the task state back to TASK_RUNNING.
         *
         * This should be ok, provided it doesn't flip the state back to
         * TASK_RUNNING and return 0 too much - that causes us to spin. That
         * will only happen if the mutex_lock() call blocks, and we then find
         * the ringbuffer empty. So in practice we should be ok, but it's
         * something to be aware of when touching this code.
         */
        if (until.tv64 == 0)
                aio_read_events(ctx, min_nr, nr, event, &ret);
        else
                wait_event_interruptible_hrtimeout(ctx->wait,
                                aio_read_events(ctx, min_nr, nr, event, &ret),
                                until);

        if (!ret && signal_pending(current))
                ret = -EINTR;

        return ret;
}
...

I have not the right skillz to look at this deeper.

- Sedat -
