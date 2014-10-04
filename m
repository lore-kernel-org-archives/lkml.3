Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940AbaJDABs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:01:48 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:43869 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbaJDABq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 20:01:46 -0400
MIME-Version: 1.0
In-Reply-To: <20141003232631.GA3439@redhat.com>
References: <20140921184153.GA23727@redhat.com>
	<tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org>
	<542E2B05.5080607@oracle.com>
	<20141003232631.GA3439@redhat.com>
Date: Fri, 3 Oct 2014 17:01:45 -0700
X-Google-Sender-Auth: tLbHENuM_o966ogDnRKhtsvHWC8
Message-ID: <CA+55aFwT3KFkGMgWz9Gag+xMHD=5X3RNz-iMswGD88_wnUT-Eg@mail.gmail.com>
Subject: Re: [tip:x86/asm] x86: Speed up ___preempt_schedule*() by using THUNK helpers
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2014 at 4:26 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> And I _think_ that preempt_schedule_context() should be fixed anyway,
> although I am not sure there is no something else. It does:
>
>
>         preempt_disable_notrace();
>         prev_ctx = exception_enter();
>         preempt_enable_no_resched_notrace();
>
>         preempt_schedule();
>
>         preempt_disable_notrace();
>         exception_exit(prev_ctx);
>         preempt_enable_notrace();
>
> but exception_exit() is heavy, it is quite possible that TIF_NEED_RESCHED
> and thus set_preempt_need_resched() can be set again when we call
> preempt_enable_notrace(). And in this case preempt_schedule_context()
> will be called recursively.

Why the hell is it using "preempt_enable_notrace()" in the first
place? Shouldn't it use "preempt_enable_no_resched_notrace()", since
we do *not* want it to schedule, since the whole *point* is that any
scheduling should be called within "exception" context.

> Frederic, how about the patch below?

Why do it multiple times? The whole concept is fundamentally racy
anyway, in it doesn't guarantee that any *new* "need_resched()" would
be reacted to (since they could happen *after* the test), so there's
no point in trying to fix the "race", since it always remains at the
last iteration anyway.  So adding the loop looks like just voodoo
programming, not actually fixing anything.

The real fix would appear to be to use
"preempt_enable_no_resched_notrace()", which your patch did, but
without the loop.

Yes?

             Linus
