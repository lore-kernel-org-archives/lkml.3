Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3LJSkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:40:47 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:62668 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab3LJSke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:40:34 -0500
MIME-Version: 1.0
In-Reply-To: <20131210154724.GA30020@redhat.com>
References: <20131210154724.GA30020@redhat.com>
Date: Tue, 10 Dec 2013 10:40:33 -0800
X-Google-Sender-Auth: KOhbwTNIobrr-o15VfwxcdH1l40
Message-ID: <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
Subject: Re: process 'stuck' at exit.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. Looks like the futex code is somehow stuck in a loop, calling
get_user_pages_fast().

The futex code itself is apparently so low-overhead that it doesn't
show up in your 'perf top' report (which is dominated by all the
expensive debug things that get_user_pages_fast() etc ends up doing),
but that's the only looping I can see. Perhaps the "goto again" case
for transparent huge pages in get_futex_key()? Or the
"retry[_private]" cases in futex_requeue()? Some error condition that
causes us to retry forever, rather than returning the error code?

Added a few more people to the cc.. Ideas?

              Linus


On Tue, Dec 10, 2013 at 7:47 AM, Dave Jones <davej@redhat.com> wrote:
> I woke up to find my fuzzer in a curious state.
>
>  1121 pts/5    SN+    0:00  |       \_ ../trinity -q -l off -N 999999 -C 42
>  1130 pts/5    SN+    0:01  |           \_ ../trinity -q -l off -N 999999 -C 42
>  1131 pts/5    SN+    0:17  |           \_ ../trinity -q -l off -N 999999 -C 42
> 10818 ?        RNs  21115152:53  |               \_ ../trinity -q -l off -N 999999 -C 42
>
> (ignore the first 3 pids, they're waiting on 10818, which is the interesting one)
>
> It's completed its run of 999999 syscalls, and looking at tmux, it tried to exit.
>
> /proc/10818/stack just shows
>
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> Top reports a core is spinning in the kernel 100%, so I ran perf top -a
> and saw..
>
>   8.63%  [kernel]                [k] trace_hardirqs_off_caller
>   7.68%  [kernel]                [k] __lock_acquire
>   5.35%  [kernel]                [k] gup_huge_pmd
>   5.31%  [kernel]                [k] put_compound_page
>   4.93%  [kernel]                [k] gup_pud_range
>   4.76%  [kernel]                [k] trace_hardirqs_on_caller
>   4.58%  [kernel]                [k] get_user_pages_fast
>   4.00%  [kernel]                [k] debug_smp_processor_id
>   4.00%  [kernel]                [k] lock_is_held
>   3.73%  [kernel]                [k] lock_acquired
>   3.67%  [kernel]                [k] lock_release
>
>
> sysrq-t shows..
>
> trinity-child27 R  running task     5520 10818   1131 0x00080004
>  0000000000000000 ffff8801b0ef4170 000000000000032c ffff8801b609e108
>  0000000000000000 ffff880160d21c30 ffffffff810ad895 ffffffff817587a0
>  ffff8801b0ef4170 ffff8801b609e0a8 ffff8801b609e000 ffff880160d21d50
> Call Trace:
>  [<ffffffff817587a0>] ? retint_restore_args+0xe/0xe
>  [<ffffffff8132af0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8100b184>] ? native_sched_clock+0x24/0x80
>  [<ffffffff8109624f>] ? local_clock+0xf/0x50
>  [<ffffffff810aa27e>] ? put_lock_stats.isra.28+0xe/0x30
>  [<ffffffff8103edd0>] ? gup_pud_range+0x170/0x190
>  [<ffffffff8103f0d5>] ? get_user_pages_fast+0x1a5/0x1c0
>  [<ffffffff810ad1f5>] ? trace_hardirqs_on_caller+0x115/0x1e0
>  [<ffffffff810a8a2f>] ? up_read+0x1f/0x40
>  [<ffffffff8103f0d5>] ? get_user_pages_fast+0x1a5/0x1c0
>  [<ffffffff8115f76c>] ? put_page+0x3c/0x50
>  [<ffffffff810dd525>] ? get_futex_key+0xd5/0x2c0
>  [<ffffffff810df18a>] ? futex_requeue+0xfa/0x9c0
>  [<ffffffff810e019e>] ? do_futex+0xae/0xc80
>  [<ffffffff810aa27e>] ? put_lock_stats.isra.28+0xe/0x30
>  [<ffffffff810aa7de>] ? lock_release_holdtime.part.29+0xee/0x170
>  [<ffffffff8114f16e>] ? context_tracking_user_exit+0x4e/0x190
>  [<ffffffff810ad1f5>] ? trace_hardirqs_on_caller+0x115/0x1e0
>  [<ffffffff810e0de1>] ? SyS_futex+0x71/0x150
>  [<ffffffff81010a45>] ? syscall_trace_enter+0x145/0x2a0
>  [<ffffffff81760be4>] ? tracesys+0xdd/0xe2
>
>
> any ideas ?
>
>         Dave
>
