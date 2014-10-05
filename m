Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaJEVyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 17:54:17 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34540 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaJEVyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 17:54:16 -0400
MIME-Version: 1.0
In-Reply-To: <20141005210614.GA28899@redhat.com>
References: <1412456799-32339-1-git-send-email-minipli@googlemail.com>
	<20141005210614.GA28899@redhat.com>
Date: Sun, 5 Oct 2014 23:54:14 +0200
Message-ID: <CA+rthh96tG+9ZjWa=9WyaWABbUyxJ2z6YVaX4ApL424c31yCRw@mail.gmail.com>
Subject: Re: [PATCH] posix-timers: fix stack info leak in timer_create()
From: Mathias Krause <minipli@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 October 2014 23:06, Oleg Nesterov <oleg@redhat.com> wrote:
> On 10/04, Mathias Krause wrote:
>>
>> If userland creates a timer without specifying a sigevent info, we'll
>> create one ourself, using a stack local variable. Particularly will we
>> use the timer ID as sival_int. But as sigev_value is a union containing
>> a pointer and an int, that assignment will only partially initialize
>> sigev_value on systems where the size of a pointer is bigger than the
>> size of an int. On such systems we'll copy the uninitialized stack bytes
>> from the timer_create() call to userland when the timer actually fires
>> and we're going to deliver the signal.
>
> So we have a minor information leak,
>

Yup.

>> Cc: <stable@vger.kernel.org>  # v2.6.28+
>
> not sure this is -stable material but I won't really argue.
>

This should fall into the class "security fixes". Info leaks like that
-- if flagged as such -- got backported regularly in the past. They
tend to get CVE IDs, even.

>> --- a/kernel/time/posix-timers.c
>> +++ b/kernel/time/posix-timers.c
>> @@ -636,6 +636,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
>>                       goto out;
>>               }
>>       } else {
>> +             memset(&event.sigev_value, 0, sizeof(event.sigev_value));
>>               event.sigev_notify = SIGEV_SIGNAL;
>>               event.sigev_signo = SIGALRM;
>>               event.sigev_value.sival_int = new_timer->it_id;
>
> How about
>
>         -       event.sigev_value.sival_int = new_timer->it_id;
>         +       event.sigev_value = (sigval_t) { .sival_int = new_timer_id };
>
> ?

Oh, well. It's a matter of taste, I guess. It won't fit mine ;) I
think it makes it slightly less readable.

Concerning optimizations, gcc is clever enough to optimize the
memset(0) without the structure cast and assignment trick. For me it
reduces the memset(0) to a single additional instruction: 'movq    $0,
-112(%rbp)'.

>
> (btw, new_timer->sigq->info.si_tid initialization can use new_timer_id too)
>
> this makes the initialization more explicit and can help gcc to optimize
> this assignment although this is minor.

True. Albeit not relevant for this patch.

>
> In any case this all looks confusing to me. sys_timer_create() does
>
>         new_timer->sigq->info.si_value = event.sigev_value;
>         new_timer->sigq->info.si_tid   = new_timer->it_id;
>
> later, this writes to the differents members (_rt and _timer) in the
> same union. But the comment in struct siginfo says that we should use
> _timer. And copy_siginfo_to_user() reports si_tid and si_ptr, this
> again reads _timer and _rt. This should actually work, _sigval should
> have the same offset in both struct's, still it looks confusing imho.
> Perhaps we should change
>
>         #define si_value        _sifields._rt._sigval
>         #define si_int          _sifields._rt._sigval.sival_int
>         #define si_ptr          _sifields._rt._sigval.sival_ptr
>
> to use _timer instead. Nevermind, this is off-topic.

Yeah, the _pad[] struct in _timer should ensure both _sigval members
should have the same offset. So I guess the _pad[] member is
intentionally there to solve the "aliasing" issue of si_value? But, in
fact, it's off-topic concerning the info leak fix.

Thanks,
Mathias

>
> Oleg.
>
