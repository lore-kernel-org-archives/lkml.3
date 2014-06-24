Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaFXSTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:19:31 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:40677 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbaFXST1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:19:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140624170800.GA30480@redhat.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org>
	<1403560693-21809-8-git-send-email-keescook@chromium.org>
	<20140624170800.GA30480@redhat.com>
Date: Tue, 24 Jun 2014 11:19:27 -0700
X-Google-Sender-Auth: Vx3w-_bw-Aw9mDTILTb1K-gSch8
Message-ID: <CAGXu5jLaYq2wncbZ=UjuteFAh=jyVDNtE7pBpx52CbHn07De+Q@mail.gmail.com>
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

On Tue, Jun 24, 2014 at 10:08 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 06/23, Kees Cook wrote:
>>
>> +static pid_t seccomp_can_sync_threads(void)
>> +{
>> +     struct task_struct *thread, *caller;
>> +
>> +     BUG_ON(write_can_lock(&tasklist_lock));
>> +     BUG_ON(!spin_is_locked(&current->sighand->siglock));
>> +
>> +     if (current->seccomp.mode != SECCOMP_MODE_FILTER)
>> +             return -EACCES;
>> +
>> +     /* Validate all threads being eligible for synchronization. */
>> +     thread = caller = current;
>> +     for_each_thread(caller, thread) {
>
> You only need to initialize "caller" for for_each_thread(). Same for
> seccomp_sync_threads().

Thanks, I'll fix this up.

>> @@ -586,6 +701,17 @@ static long seccomp_set_mode_filter(unsigned int flags,
>>       if (IS_ERR(prepared))
>>               return PTR_ERR(prepared);
>>
>> +     /*
>> +      * If we're doing thread sync, we must hold tasklist_lock
>> +      * to make sure seccomp filter changes are stable on threads
>> +      * entering or leaving the task list. And we must take it
>> +      * before the sighand lock to avoid deadlocking.
>> +      */
>> +     if (flags & SECCOMP_FILTER_FLAG_TSYNC)
>> +             write_lock_irqsave(&tasklist_lock, taskflags);
>> +     else
>> +             __acquire(&tasklist_lock); /* keep sparse happy */
>> +
>
> Why? ->siglock should be enough, it seems.
>
> It obviously does not protect the global process list, but *sync_threads()
> only care about current's thread group list, no?

I think I was concerned about the exit case, but reading through those
paths again, I can't find a race. Calls to put_seccomp_filter() should
already be safe. Let me see what happens if I drop the tasklist_lock
usage...

-Kees


-- 
Kees Cook
Chrome OS Security
