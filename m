Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaFXTIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:08:22 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:48326 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaFXTIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:08:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140624183749.GC1258@redhat.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org>
	<1403560693-21809-8-git-send-email-keescook@chromium.org>
	<20140624172753.GA31435@redhat.com>
	<CAGXu5jKoDEXffJqFSjhO+D=5toJOA=KAomi+LQOahPDYKFbEdg@mail.gmail.com>
	<20140624183749.GC1258@redhat.com>
Date: Tue, 24 Jun 2014 12:08:16 -0700
X-Google-Sender-Auth: jtcyTBS-8hLg3tdrJqFc-3Cbong
Message-ID: <CAGXu5jKwF1cbc=4O5nXDKZT8HF7grCm+AaRz7v1VCdPVMRX-3A@mail.gmail.com>
Subject: Re: [PATCH v7 7/9] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
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

On Tue, Jun 24, 2014 at 11:37 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 06/24, Kees Cook wrote:
>>
>> On Tue, Jun 24, 2014 at 10:27 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> > On 06/23, Kees Cook wrote:
>> >>
>> >> +static pid_t seccomp_can_sync_threads(void)
>> >> +{
>> >> +     struct task_struct *thread, *caller;
>> >> +
>> >> +     BUG_ON(write_can_lock(&tasklist_lock));
>> >> +     BUG_ON(!spin_is_locked(&current->sighand->siglock));
>> >> +
>> >> +     if (current->seccomp.mode != SECCOMP_MODE_FILTER)
>> >> +             return -EACCES;
>> >> +
>> >> +     /* Validate all threads being eligible for synchronization. */
>> >> +     thread = caller = current;
>> >> +     for_each_thread(caller, thread) {
>> >> +             pid_t failed;
>> >> +
>> >> +             if (thread->seccomp.mode == SECCOMP_MODE_DISABLED ||
>> >> +                 (thread->seccomp.mode == SECCOMP_MODE_FILTER &&
>> >> +                  is_ancestor(thread->seccomp.filter,
>> >> +                              caller->seccomp.filter)))
>> >> +                     continue;
>> >> +
>> >> +             /* Return the first thread that cannot be synchronized. */
>> >> +             failed = task_pid_vnr(thread);
>> >> +             /* If the pid cannot be resolved, then return -ESRCH */
>> >> +             if (failed == 0)
>> >> +                     failed = -ESRCH;
>> >
>> > forgot to mention, task_pid_vnr() can't fail. sighand->siglock is held,
>> > for_each_thread() can't see a thread which has passed unhash_process().
>>
>> Certainly good to know, but I'd be much more comfortable leaving this
>> check as-is. Having "failed" return with "0" would be very very bad
>> (userspace would think the filter had been successfully applied, etc).
>> I'd rather stay highly defensive here.
>
> OK, agreed. Although in this case I'd suggest
>
>                 if (WARN_ON(failed == 0))
>                         failed = -ESRCH;
>
> but I won't insist.

Excellent idea, yes! I'll include this as well.

-Kees

-- 
Kees Cook
Chrome OS Security
