Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966273Ab3HHTvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:51:39 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:36919 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965572Ab3HHTvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:51:38 -0400
MIME-Version: 1.0
In-Reply-To: <20130808191749.GA12062@redhat.com>
References: <tencent_26310211398C21034BD3B2F9@qq.com>
	<CA+55aFwAnWZGkXbyLmL3RxQGW-dX_jjDBPfA5PjxeVWn==a6tA@mail.gmail.com>
	<20130808191749.GA12062@redhat.com>
Date: Thu, 8 Aug 2013 12:51:37 -0700
X-Google-Sender-Auth: 8dN-rePy7e5wFDdjdTScj1HVBpY
Message-ID: <CA+55aFw+vEp6+q+QUZm5rf+sKR9z76HWzEqWjoiLtataym5uwA@mail.gmail.com>
Subject: Re: Patch for lost wakeups
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Long Gao <gaolong@kylinos.com.cn>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 12:17 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
>>  - somebody setting TASK_SLEEPING -> __schedule() testing the
>> signal_pending_state()
>>
>> and as far as I can tell we have proper barriers for those (the
>> scheduler gets the rq lock
>
> Yes, but... ttwu() takse another lock, ->pi_lock to test ->state.

The lock is different, but for task_state, the main thing we need to
worry abotu is memory ordering, not locks. Because "task->state" is
not protected by any particular lock, it has some rather special rules
(namely that the thread is supposed to modify its own state, *except*
for waking things up, when we rely on memory ordering).

So the real issue is to make sure that before finally going to sleep,
any other CPU that races with waking things up needs to have the right
ordering. And that means that

 - the sleeper needs to have the proper barrier between setting the
task state to the sleeping state and testing the waking condition

   Normally this is the "smp_mb()" in set_task_state(), and then the
sleeper is supposed to check its wakeup criteria *after* doing
set_task_state().

   The case of signals is special, in that the "wakeup criteria" is
inside the scheduler itself, but conceptually the rule is the same.

 - the waker needs to have a memory barrier between setting the wakeup
condition and actually doing the wakeup.

   This is where the "try_to_wake_up()" smp_mb+spinlock *should* be
equivalent to a full memory barrier.

> This looks racy, even if wmb() actually acts as mb(), we don't
> have mb() on the other side and schedule() can miss SIGPENDING?

But we do have the mb, at least on x86. The "set_tsk_thread_flag()" is
a memory barrier there. But that's why I suggested adding a
smp_mb__after_clear_bit() to after setting the bit, in case that's the
problem on LoongSon. Because at least MIPS uses ll/sc for atomic, and
needs a sync instruction if the memory model is weak afterwards.

That said, even on MIPS I do not actually believe it should be
necessary, exactly *because* __schedule() already has a spinlock
before checking the signal state. And the spinlock already contains
sufficient serialization (much *more* than the required sync
instruction) that in practice we're already covered.

So there might be a theoretical race on some architecture, but not
afaik mips. I don't know the details about loongson, though.

                   Linus
