Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014AbaLOCqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 21:46:35 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:35551 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaLOCq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 21:46:27 -0500
MIME-Version: 1.0
In-Reply-To: <1418610272-21518-3-git-send-email-fweisbec@gmail.com>
References: <1418610272-21518-1-git-send-email-fweisbec@gmail.com>
	<1418610272-21518-3-git-send-email-fweisbec@gmail.com>
Date: Sun, 14 Dec 2014 18:46:27 -0800
X-Google-Sender-Auth: 25poN8VvU8a3kqhCmUe8uNZtP9Q
Message-ID: <CA+55aFwhEkBc899yMY3KugwF0QGF8r7iM_6+DoYa0RgtApv5aw@mail.gmail.com>
Subject: Re: [PATCH 2/2] sched: Pull resched loop to __schedule() callers
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 6:24 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> -need_resched:
>         preempt_disable();
>         cpu = smp_processor_id();
>         rq = cpu_rq(cpu);
> @@ -2821,8 +2824,6 @@ need_resched:
>         post_schedule(rq);
>
>         sched_preempt_enable_no_resched();
> -       if (need_resched())
> -               goto need_resched;


So my suggestion was to move the
"preempt_disable()/enable_no_resched()" into the callers too.

Everybody already does that - except for "schedule()" itself. So that
would involve adding it here too:

> @@ -2842,7 +2843,9 @@ asmlinkage __visible void __sched schedule(void)
>         struct task_struct *tsk = current;
>
>         sched_submit_work(tsk);
> -       __schedule();
> +       do {
preempt_disable();
> +               __schedule();
sched_preempt_enable_no_resched();
> +       } while (need_resched());
>  }

Hmm?

That would mean that we have one less preempt update in the
__sched_preempt() cases. If somebody cares about the preempt counter
value, we'd have to increemnt the preempt count add values too, ie do

    __preempt_count_add(PREEMPT_ACTIVE+1);

there, but I'm not convicned anybody cares about the exact count.

As it is, you end up doing the preempt count things twice in the
__sched_preempt() case: first the PREEMPT_ACTIVE count, and then the
count inside __schedule().

Hmm?

                     Linus
