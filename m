Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab3JNRxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 13:53:07 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:48106 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068Ab3JNRxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 13:53:05 -0400
MIME-Version: 1.0
In-Reply-To: <525BD08C.2080101@t-online.de>
References: <525BD08C.2080101@t-online.de>
Date: Mon, 14 Oct 2013 10:53:03 -0700
X-Google-Sender-Auth: hiAPBpegXquLIETawHo-CfVKXkw
Message-ID: <CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Knut Petersen <Knut_Petersen@t-online.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. No obvious ideas come to mind, but I'm adding more people to the cc.

Clearly the wait_event_interruptible_timeout() in the RCU grace-period
thread causes this, but I'm not seeing why shutdown would trigger it.

The code disassembles to

   0: 85 db                 test   %ebx,%ebx
   2: 79 0c                 jns    0x10
   4: 81 e6 ff 00 00 00     and    $0xff,%esi
   a: 8d 44 f0 30           lea    0x30(%eax,%esi,8),%eax
   e: eb 0a                 jmp    0x1a
  10: c1 e9 1a             shr    $0x1a,%ecx
  13: 8d 84 c8 30 0e 00 00 lea    0xe30(%eax,%ecx,8),%eax
  1a: 8b 48 04             mov    0x4(%eax),%ecx
  1d: 89 50 04             mov    %edx,0x4(%eax)
  20: 89 02                 mov    %eax,(%edx)
  22: 89 4a 04             mov    %ecx,0x4(%edx)
  25:* 89 11                 mov    %edx,(%ecx) <-- trapping instruction
  27: 5b                   pop    %ebx
  28: 5e                   pop    %esi
  29: 5d                   pop    %ebp
  2a: c3                   ret

so the oops is in the final

        list_add_tail(&timer->entry, vec);

where "%ecx" is "vec->prev" (f8c551f4). That looks like it might be a
perfectly valid pointer, but clearly it isn't (it's about 115M off the
top of virtual memory, I think that might be in the vmalloc area).

So I'm *guessing* that something did a vfree() on some data structure
that contained active timers - and then later on the RCU thread ended
up being the next thing that tried to add a timer after the
now-non-existing one.

And your other oopses do seem to have a similar pattern, even if their
actual oops is elsewhere. They oops in run_timer_softirq, also taking
a page fault in the 0xf9...... range, so it might well be a vmalloc
address there too.

But I sure as hell can't start to guess what that would be.

I'm wondering it CONFIG_DEBUG_OBJECTS (and then
CONFIG_DEBUG_OBJECTS_FREE=y and CONFIG_DEBUG_OBJECTS_TIMERS=y) might
help catch this...

                Linus

On Mon, Oct 14, 2013 at 4:07 AM, Knut Petersen
<Knut_Petersen@t-online.de> wrote:
>
> It愀 the third time in four months that I have to report a kernel Oops during
> shutdown.
> All of these Oopses seem somehow related to the timer subsystem, but they
> are
> not easily reproducible. As all this happens on two different machines, it愀
> unlikely
> that this mess is related to bad hardware.
>
> I clearly would appreciate any idea how to track this down.
>
> For the last two reports see:
>
> http://www.gossamer-threads.com/lists/linux/kernel/1782575?#1782575
>
> http://www.gossamer-threads.com/lists/linux/kernel/1744892?#1744892
>
> This time the kernel oopsed after systemd reported that target shutdown
> had been reached - see attached pdf for the full trace. To make it easier
> to find this problem a shortened call trace:
>
>
> Call Trace:
>     internal_add_timer
>     schedule_timeout
>     ? call_timer_fn
>     rcu_gp_kthread
>     __init_waitqueue_head
>     ? rcu_gp_fqs
>     kthread
>     ret_from_kernel_thread
>     ? __init_kthread_worker
>
> EIP: __internal_add_timer
>
> Hardware: AOpen i915GMm-hfs mobo with a Pentium-M Dothan and 2GB of RAM.
> Distribution: openSuSE 12.3
> Kernel: local 3.12.0-rc4-00127-g45877c4 is  kernel 9d05746 with my
> "Enforce 1 as lower limit for perf_event_max_sample_rate"
> patch applied.
>
> cu,
>  knut
