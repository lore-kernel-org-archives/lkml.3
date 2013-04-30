Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313Ab3D3Q6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:58:33 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:64503 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761271Ab3D3Q6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:58:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130430163817.GA27304@redhat.com>
References: <1367271946-7239-1-git-send-email-ccross@android.com>
	<1367271946-7239-10-git-send-email-ccross@android.com>
	<20130430163817.GA27304@redhat.com>
Date: Tue, 30 Apr 2013 09:58:29 -0700
X-Google-Sender-Auth: xlRvy-eYJo86Xoe3qP_GkVouqh8
Message-ID: <CAMbhsRTABgbWgFca03nVWVmVeK5Ci9BPon-zQwanM16LrN=fog@mail.gmail.com>
Subject: Re: [PATCH 09/10] sigtimedwait: use freezable blocking call
From: Colin Cross <ccross@android.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 9:38 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 04/29, Colin Cross wrote:
>>
>> Avoid waking up every thread sleeping in a sigtimedwait call during
>> suspend and resume by calling a freezable blocking call.
>
> This doesn't explain why do want this change...
>
> OK, probably to avoid -EAGAIN from sigtimedwait() if the freezer wakes
> up the caller.

See http://marc.info/?l=linux-pm&m=136727197819593&w=2 for the full
justification.  I will include a fuller description of the reason for
this patch in the next version.

>> --- a/kernel/signal.c
>> +++ b/kernel/signal.c
>> @@ -2845,7 +2845,7 @@ int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
>>               recalc_sigpending();
>>               spin_unlock_irq(&tsk->sighand->siglock);
>>
>> -             timeout = schedule_timeout_interruptible(timeout);
>> +             timeout = freezable_schedule_timeout_interruptible(timeout);
>
> And I guess freezable_schedule_timeout_interruptible() is added by
> http://marc.info/?l=linux-kernel&m=136727195719575 ...
>
>         +#define freezable_schedule_timeout_interruptible(timeout)              \
>         +({                                                                     \
>         +       long __retval;                                                  \
>         +       freezer_do_not_count();                                         \
>         +       __retval = schedule_timeout_interruptible(timeout);             \
>         +       freezer_count();                                                \
>         +       __retval;                                                       \
>         +})
>
> How this can help?
>
> The task will be interrupted anyway and the syscall will return
> -EAGAIN, this only changes the time when try_to_freeze() is called.
>
> For what? The task will call do_signal/try_to_freeze really "soon".

See http://marc.info/?l=linux-pm&m=136727204919622&w=2, which removes
the wakeup sent to skipped tasks, so schedule_timeout_interruptible()
will only return if the timeout finishes or another task (not the
freezer) calls wake_up on the task.  If that happens during freezing
or while frozen freezer_count() will freeze.  If another task does not
wake up this task while frozen, this task will not need to run at all
during suspend or resume, saving cpu cycles, context switches, and
power.

> Confused...
>
> Oleg.
>
