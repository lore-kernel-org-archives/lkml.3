Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbaFYOv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:51:28 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:52820 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbaFYOvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:51:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140625135121.GB7892@redhat.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
	<1403642893-23107-6-git-send-email-keescook@chromium.org>
	<20140625135121.GB7892@redhat.com>
Date: Wed, 25 Jun 2014 07:51:25 -0700
X-Google-Sender-Auth: RCNeIVkYTQv2tceTvFHUOTo4kcM
Message-ID: <CAGXu5jJkFxh4K=40xuh6tu3kUf4oJM8Dry+4upBdRieW3FNLgw@mail.gmail.com>
Subject: Re: [PATCH v8 5/9] seccomp: split mode set routines
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

On Wed, Jun 25, 2014 at 6:51 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 06/24, Kees Cook wrote:
>>
>> +static inline void seccomp_assign_mode(struct task_struct *task,
>> +                                    unsigned long seccomp_mode)
>> +{
>> +     BUG_ON(!spin_is_locked(&task->sighand->siglock));
>> +
>> +     task->seccomp.mode = seccomp_mode;
>> +     set_tsk_thread_flag(task, TIF_SECCOMP);
>> +}
>
> OK, but unless task == current this can race with secure_computing().
> I think this needs smp_mb__before_atomic() and secure_computing() needs
> rmb() after test_bit(TIF_SECCOMP).
>
> Otherwise, can't __secure_computing() hit BUG() if it sees the old
> mode == SECCOMP_MODE_DISABLED ?
>
> Or seccomp_run_filters() can see ->filters == NULL and WARN(),
> smp_load_acquire() only serializes that LOAD with the subsequent memory
> operations.

Hm, actually, now I'm worried about smp_load_acquire() being too slow
in run_filters().

The ordering must be:
- task->seccomp.filter must be valid before
- task->seccomp.mode is set, which must be valid before
- TIF_SECCOMP is set

But I don't want to impact secure_computing(). What's the best way to
make sure this ordering is respected?

-Kees

-- 
Kees Cook
Chrome OS Security
