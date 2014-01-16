Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaAPSyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:54:04 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38083 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaAPSyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:54:01 -0500
MIME-Version: 1.0
In-Reply-To: <20140116171824.748919700@goodmis.org>
References: <20140116171824.748919700@goodmis.org>
Date: Thu, 16 Jan 2014 19:53:59 +0100
X-Google-Sender-Auth: RKl_AA84EgYsjzFU9gHXHy3rSCU
Message-ID: <CAONaPpHVapqE0hJ9JpZHJivjf344Y-7Mj5V9j96Vq0p=94264Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/2] preempt: Track unmatched preempt_enable() to preempt_disable()
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Clark Williams <williams@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 6:18 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Back in the original real-time patch there was a nice debug feature
> that tracked where preemption was disabled and not matched by a preempt
> enable. This information made debugging scheduling while atomic much
> easier, especially when a function was buried in a function chain
> that happened just before the schedule. For example:
>
> bar() {
>   preempt_disable();
>   [...]
>   if (ret < 0)
>      return;
>   [...]
> }
>
> foo() {
>   [...]
>   bar();
>   [...]
> }
>
> foo();
> schedule();
>
> Getting the "scheduling while atomic" warning detects the bug, but it
> does not let you know where the bug happened. It may take several trials
> to figure out where the missing preempt_enable() was. Some times those
> functions are very deep and that makes it even more difficult to find.
>
> Although this bug does not happen often, this feature is extremely helpful
> when it does. I decided to take Ingo's code, which was just written for
> debugging the -rt patch, and clean it up for something that is suitable
> for mainline.
>
> I started with his code and modified it to be a bit simpler, as he never
> meant that code to be mainline. First, as preempt disabling is really more
> of a CPU state and not a process state, I made the stacks just per cpu
> arrays. This eliminates any changes needed by sched.h or the task_struct.
>
> The only times the preempt trace is needed is when scheduling while atomic
> or might sleep bugs are found. This information is only printed in those
> cases (not on all bug reports).
>
> I renamed the config option from PREEMPT_TRACE to PREEMPT_STACK to prevent
> confusion from the tracing facility PREEMPT_TRACER that traces the length
> that preemption is disabled.
>
> Using a struct to save the ip and parent ip together also keeps the code
> a bit cleaner than using two different arrays.
>
> Using a module that creates a kernel thread that calls a function
> bad_preempt_disable() that just calls preempt_disable() with no matching
> preempt_enable(), and then calls schedule, the output can be seen as the
> following:
>
> BUG: scheduling while atomic: task1/3889/0x00000002
> Modules linked in: sched_bug(O) [..]
> CPU: 7 PID: 3889 Comm: task1 Tainted: G           O 3.13.0-rc8-test+ #28
> Hardware name: Hewlett-Packard HP Compaq Pro 6300 SFF/339A, BIOS K01 v02.05 05/07/2012
>  0000000000000007 ffff8800c87a1dd8 ffffffff81627676 ffff88011ebcf5d0
>  ffff8800ca0eaf00 ffff8800c87a1df8 ffffffff81623825 0000000000000002
>  ffff88011ebd3600 ffff8800c87a1e78 ffffffff8162b0f5 ffff8800c87a1e28
> Call Trace:
>  [<ffffffff81627676>] dump_stack+0x4f/0x7c
>  [<ffffffff81623825>] __schedule_bug+0x59/0x6e
>  [<ffffffff8162b0f5>] __schedule+0x6b5/0x7e0
>  [<ffffffff816329f1>] ? preempt_count_sub+0xb1/0x100
>  [<ffffffffa06d9020>] ? bad_preempt_disable+0x20/0x20 [sched_bug]
>  [<ffffffff8162b339>] schedule+0x29/0x70
>  [<ffffffffa06d9038>] dead_thread+0x18/0x78 [sched_bug]
>  [<ffffffff81073559>] kthread+0xc9/0xe0
>  [<ffffffff81620000>] ? pci_add_new_bus+0x150/0x3b0
>  [<ffffffff81073490>] ? flush_kthread_worker+0xb0/0xb0
>  [<ffffffff8163676c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff81073490>] ? flush_kthread_worker+0xb0/0xb0
> ---------------------------
> | preempt count: 00000002 ]
> | 2-level deep critical section nesting:
> ----------------------------------------
> .. [<ffffffffa06d9013>] .... bad_preempt_disable+0x13/0x20 [sched_bug]
> .....[<ffffffffa06d9033>] ..   ( <= dead_thread+0x13/0x78 [sched_bug])
> .. [<ffffffff8162aa89>] .... __schedule+0x49/0x7e0
> .....[<ffffffff8162b339>] ..   ( <= schedule+0x29/0x70)
>
>
> Steven Rostedt (Red Hat) (2):
>       preempt: Add CONFIG_DEBUG_PREEMPT_COUNT to consolidate ifdef logic
>       preempt: Show preempt disable stack on schedule bugs
>
> ----
>  include/linux/preempt.h |  2 +-
>  kernel/sched/core.c     | 63 ++++++++++++++++++++++++++++++++++++++++++++++---
>  kernel/trace/Kconfig    |  1 +
>  lib/Kconfig.debug       | 20 ++++++++++++++++
>  4 files changed, 82 insertions(+), 4 deletions(-)
> --

fwiw - I have found this feature useful in the past, and would love to
see it mainstream.

Thanks

John Kacur
