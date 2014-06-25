Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbaFYREH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:04:07 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:33519 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421AbaFYREE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:04:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+J11zJnuFR8bYKAXizAHhCx4R+uJE_QH6zC3q2udkpaQ@mail.gmail.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
 <1403642893-23107-6-git-send-email-keescook@chromium.org> <20140625135121.GB7892@redhat.com>
 <CAGXu5jJkFxh4K=40xuh6tu3kUf4oJM8Dry+4upBdRieW3FNLgw@mail.gmail.com>
 <CALCETrUBNmLnpa+LM91om2RSpR6SjupP-EdefzhU1Me4nv3Dfw@mail.gmail.com> <CAGXu5j+J11zJnuFR8bYKAXizAHhCx4R+uJE_QH6zC3q2udkpaQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 25 Jun 2014 10:03:42 -0700
Message-ID: <CALCETrVrs8sb19+UUqyFEpAFzTih5dkAwn-WpQjfgPcPJMpP5g@mail.gmail.com>
Subject: Re: [PATCH v8 5/9] seccomp: split mode set routines
To: Kees Cook <keescook@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 9:54 AM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Jun 25, 2014 at 9:10 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Wed, Jun 25, 2014 at 7:51 AM, Kees Cook <keescook@chromium.org> wrote:
>>> On Wed, Jun 25, 2014 at 6:51 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>>> On 06/24, Kees Cook wrote:
>>>>>
>>>>> +static inline void seccomp_assign_mode(struct task_struct *task,
>>>>> +                                    unsigned long seccomp_mode)
>>>>> +{
>>>>> +     BUG_ON(!spin_is_locked(&task->sighand->siglock));
>>>>> +
>>>>> +     task->seccomp.mode = seccomp_mode;
>>>>> +     set_tsk_thread_flag(task, TIF_SECCOMP);
>>>>> +}
>>>>
>>>> OK, but unless task == current this can race with secure_computing().
>>>> I think this needs smp_mb__before_atomic() and secure_computing() needs
>>>> rmb() after test_bit(TIF_SECCOMP).
>>>>
>>>> Otherwise, can't __secure_computing() hit BUG() if it sees the old
>>>> mode == SECCOMP_MODE_DISABLED ?
>>>>
>>>> Or seccomp_run_filters() can see ->filters == NULL and WARN(),
>>>> smp_load_acquire() only serializes that LOAD with the subsequent memory
>>>> operations.
>>>
>>> Hm, actually, now I'm worried about smp_load_acquire() being too slow
>>> in run_filters().
>>>
>>> The ordering must be:
>>> - task->seccomp.filter must be valid before
>>> - task->seccomp.mode is set, which must be valid before
>>> - TIF_SECCOMP is set
>>>
>>> But I don't want to impact secure_computing(). What's the best way to
>>> make sure this ordering is respected?
>>
>> Remove the ordering requirement, perhaps?
>>
>> What if you moved mode into seccomp.filter?  Then there would be
>> little reason to check TIF_SECCOMP from secure_computing; instead, you
>> could smp_load_acquire (or read_barrier_depends, maybe) seccomp.filter
>> from secure_computing and pass the result as a parameter to
>> __secure_computing.  Or you could even remove the distinction between
>> secure_computing and __secure_computing -- it's essentially useless
>> anyway to split entry hook approaches like my x86 fastpath prototype.
>
> The TIF_SECCOMP is needed for the syscall entry path. The check in
> secure_computing() is just because the "I am being traced" trigger
> includes a call to secure_computing, which filters out tracing
> reasons.

Right.  I'm suggesting just checking a single indication that seccomp
is on from the process in the seccomp code so that the order doesn't
matter.

IOW, TIF_SECCOMP causes __secure_computing to be invoked, but the race
only seems to matter because of the warning and the BUG.  I think that
both can be fixed if you merge mode into filter so that
__secure_computing atomically checks one condition.

>
> Your fast path work would clean a lot of that up, as you say. But it
> still doesn't change the ordering check here. TIF_SECCOMP indicates
> seccomp.mode must be checked, so that ordering will remain, and if
> mode == FILTER, seccomp.filter must be valid.
>
> Isn't there a way we can force the assignment ordering in seccomp_assign_mode()?

Write the filter, then smp_mb (or maybe a weaker barrier is okay),
then set the bit.

--Andy

>
> -Kees
>
> --
> Kees Cook
> Chrome OS Security



-- 
Andy Lutomirski
AMA Capital Management, LLC
