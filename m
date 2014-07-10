Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaGJQD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:03:56 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:60633 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaGJQDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:03:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140710150832.GA20861@redhat.com>
References: <1403911380-27787-1-git-send-email-keescook@chromium.org>
	<1403911380-27787-12-git-send-email-keescook@chromium.org>
	<20140709180520.GA2560@redhat.com>
	<CAGXu5jLUqz-T1tRBCpPLkzWijyAF-Vjw_7PnQ1EvUh4urwyaUg@mail.gmail.com>
	<20140710150832.GA20861@redhat.com>
Date: Thu, 10 Jul 2014 09:03:50 -0700
X-Google-Sender-Auth: nVp9CbmgbGU1uPKFt_FQNOnvRqs
Message-ID: <CAGXu5jK_BBAexok1G1vbxL6764n+7h1kLRSu074MMFzF0QrafQ@mail.gmail.com>
Subject: Re: [PATCH v9 11/11] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>,
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

On Thu, Jul 10, 2014 at 8:08 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 07/10, Kees Cook wrote:
>>
>> On Wed, Jul 9, 2014 at 11:05 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >
>> >> +     /*
>> >> +      * Make sure we cannot change seccomp or nnp state via TSYNC
>> >> +      * while another thread is in the middle of calling exec.
>> >> +      */
>> >> +     if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
>> >> +         mutex_lock_killable(&current->signal->cred_guard_mutex))
>> >> +             goto out_free;
>> >
>> > -EINVAL looks a bit confusing in this case, but this is cosemtic because
>> > userspace won't see this error-code anyway.
>>
>> Happy to use whatever since, as you say, it's cosmetic. Perhaps -EAGAIN?
>
> Or -EINTR. I do not really mind, I only mentioned this because I had another
> nit.
>
>> >>       spin_lock_irq(&current->sighand->siglock);
>> >> +     if (unlikely(signal_group_exit(current->signal))) {
>> >> +             /* If thread is dying, return to process the signal. */
>> >
>> > OK, this doesn't hurt, but why?
>> >
>> > You could check __fatal_signal_pending() with the same effect. And since
>> > we hold this mutex, exec (de_thread) can be the source of that SIGKILL.
>> > We take this mutex specially to avoid the race with exec.
>> >
>> > So why do we need to abort if we race with kill() or exit_grouo() ?
>>
>> In my initial code inspection that we could block waiting for the
>> cred_guard mutex, with exec holding it, exec would schedule death in
>> de_thread, and then once it released, the tsync thread would try to
>> keep running.
>>
>> However, in looking at this again, now I'm concerned this produces a
>> dead-lock in de_thread, since it waits for all threads to actually
>> die, but tsync will be waiting with the killable mutex.
>
> That is why you should always use _killable (or _interruptible) if you
> want to take ->cred_guard_mutex.
>
> If this thread races with de_thread() which holds this mutex, it will
> be killed and mutex_lock_killable() will fail.
>
> (to clarify; this deadlock is not "fatal", de_thread() can be killed too,
>  but this doesn't really matter).
>
>> So I think I got too defensive when I read the top of de_thread where
>> it checks for pending signals itself.
>>
>> It seems like I can just safely remove the singal_group_exit checks?
>> The other paths (non-tsync seccomp_set_mode_filter, and
>> seccomp_set_mode_strict)
>
> Yes, I missed another signal_group_exit() in seccomp_set_mode_strict().
> It looks equally unneeded.
>
>> I can't decide which feels cleaner: just letting stuff
>> clean up naturally on death or to short-circuit after taking
>> sighand->siglock.
>
> I'd prefer to simply remove the singal_group_exit checks.
>
> I won't argue if you prefer to keep them, but then please add a comment
> to explain that this is not needed for correctness.
>
> Because otherwise the code looks confusing, as if there is a subtle reason
> why we must not do this if killed.

Sounds good! I'll clean it all up for v10.

-Kees

-- 
Kees Cook
Chrome OS Security
