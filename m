Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966030Ab3HHST2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 14:19:28 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:62421 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab3HHST0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 14:19:26 -0400
MIME-Version: 1.0
In-Reply-To: <tencent_26310211398C21034BD3B2F9@qq.com>
References: <tencent_26310211398C21034BD3B2F9@qq.com>
Date: Thu, 8 Aug 2013 11:19:25 -0700
X-Google-Sender-Auth: RVIVcfiedn89Tn61obqQ6DLkMeE
Message-ID: <CA+55aFwAnWZGkXbyLmL3RxQGW-dX_jjDBPfA5PjxeVWn==a6tA@mail.gmail.com>
Subject: Re: Patch for lost wakeups
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Long Gao <gaolong@kylinos.com.cn>, Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Adding proper people, and the kernel mailing list ]

The patch is definitely incorrect, but the bug is interesting, so I'm
cc'ing more people in case anybody else has any input on this.

The reason I say that the patch is incorrect is because
"legacy_queue()" doesn't actually *do* anything to the signal state,
it just checks if a legacy signal is already queued, in which case we
return and do nothing.

As a result, doing a "recalc_sigpending_and_wake(()" is definitely
incorrect, because sigpending state cannot actually have changed.

Now that said, something is definitely wrong, as shown by your
/proc/2597/status data:

> Name:    Xorg
> State:    S (sleeping)
> SigPnd:    00000000000000000000000000000000
> ShdPnd:    00000000000000000000000000200000
> SigBlk:    00000000000000000000000000000000
> SigIgn:    80000000000000000000000006001000
> SigCgt:    000000000000000000000001e020eecf

because Xorg shouldn't be sleeping when there is clearly a pending
signal, and yes, the "legacy_queue()" thing will mean that _new_
incoming signals will not wake it up, since it should already *be*
awake.

However, the fact that this happens on LongSoon makes me suspect that
it's not a generic bug. It sounds like a race between Xorg going to
sleep, and getting a new signal. It could be related to subtle memory
ordering issues, though, and x86 tends to not show those as it's
pretty strictly ordered. So it _could_ be a generic bug that is just
triggered by your hardware. Thus the wider distribution in case
anybody else sees how we could get into this situation.

The particular memory barriers that should be relevant are:

 - recalc_sigpending setting the TIF_SIGPENDING flag ->
signal_wake_up() actually waking the task

 - somebody setting TASK_SLEEPING -> __schedule() testing the
signal_pending_state()

and as far as I can tell we have proper barriers for those (the
scheduler gets the rq lock and that sigpending test had better not
leak out of a spinlocked section, and try_to_wake_up() also ends up
having a spinlock between setting the TIF_SIGPENDING flag and testing
p->state)

That said, I'm a bit worried about the smp_wmb() and spinlock in
try_to_wake_up(). The signal delivery basically does

        set_tsk_thread_flag(t, TIF_SIGPENDING);
        if (!wake_up_state(t, state | TASK_INTERRUPTIBLE))

and on x86, the set_tsk_thread_flag() is a full memory barrier
(because it's a locked operation), but that's not necessarily true
elsewhere. And wake_up_state() (through that try_to_wake_up() logic)
does have a

        smp_wmb();
        raw_spin_lock_irqsave(&p->pi_lock, flags);
        if (!(p->state & state))

before it tests the task state. And the wmb() *together* with the
spinlock really should be a full memory barrier (nothing can get out
from the spinlock, and any writes before this had better be serialized
by the wmb and the write inherent in the spinlock itself). But this is
definitely some subtle stuff.

I wonder if set_tsk_thread_flag() should have a
smp_mb__after_clear_bit() after the set-bit (there is no
"smp_mb__after_set_bit", so we have to fake it). Just to make sure.

Does anybody see any situation that can cause this kind of "pending
signal, but sleeping process"? I *do* think it's triggered by hardware
issues, so I'd suggest the LongSoon people look very hard at memory
barriers and cache coherency stuff, but let's bring other people in
just in case the generic code is fraglie somewhere..

Whole email quoted below.

            Linus

On Thu, Aug 8, 2013 at 8:55 AM, Long Gao <gaolong@kylinos.com.cn> wrote:
>
>
>   Hi,
>       In a recent kernel debugging, I thought I have detected a "Lost Wakeup" of the kernel signal.
> I found that when the current process(Xorg) is sleeping and already has a pending non-real-time
> signal(SIGIO), kernel might forget to wake up the current process, and this sleeping process
> never get the chance to be waked up. That is to say, before the kernel returned after
> legacy_queue(), the current process might already have a pending signal and be SLEEPING.
>
> Thus any following same signals never had the chance to wakeup the process(succeeding
> same signals returned after legacy_queue(), and never reached signal_wake_up() in
> complete_signal() ). I have observed this case once in 667238 times of SIGIO, as
> /var/log/messages in attachment recorded, which makes the Xorg hang up, and the mouse
> and keyboard die. Until Xorg got something other than SIGIO to wake it up.
>
> Patch is as follow, if the current process has a pending signal, try to wake it up immediately:
>
> --- linux-loongson-all/kernel/signal.c  2012-06-15 10:54:01.000000000 +0800
> +++ linux-loongson-all-signal/kernel/signal.c   2013-07-24 18:47:15.775415042 +0800
> @@ -900,8 +900,10 @@
>          * exactly one non-rt signal, so that we can get more
>          * detailed information about the cause of the signal.
>          */
> -       if (legacy_queue(pending, sig))
> +       if (legacy_queue(pending, sig)){
> +               recalc_sigpending_and_wake(t);
>                 return 0;
> +       }
>         /*
>          * fast-pathed signals for kernel-internal things like SIGSTOP
>          * or SIGKILL.
>
>
>  Every time Xorg hangs up,  the status of Xorg is read as following(cat /proc/2597/status):
>
> Name:    Xorg
> State:    S (sleeping)
> Tgid:    2597
> Pid:    2597
> PPid:    2595
> TracerPid:    0
> Uid:    0    0    0    0
> Gid:    0    0    0    0
> FDSize:    64
> Groups:
> VmPeak:       44640 kB
> VmSize:       31232 kB
> VmLck:           0 kB
> VmHWM:       20560 kB
> VmRSS:       20016 kB
> VmData:        5728 kB
> VmStk:         160 kB
> VmExe:        1952 kB
> VmLib:       11296 kB
> VmPTE:         128 kB
> VmSwap:           0 kB
> Threads:    1
> SigQ:    1/15809
> SigPnd:    00000000000000000000000000000000
> ShdPnd:    00000000000000000000000000200000
> SigBlk:    00000000000000000000000000000000
> SigIgn:    80000000000000000000000006001000
> SigCgt:    000000000000000000000001e020eecf
> CapInh:    0000000000000000
> CapPrm:    ffffffffffffffff
> CapEff:    ffffffffffffffff
> CapBnd:    ffffffffffffffff
> Cpus_allowed:    f
> Cpus_allowed_list:    0-3
> voluntary_ctxt_switches:    33327
> nonvoluntary_ctxt_switches:    1308959
>
>   We can see, the shared pending signal(ShdPnd) has SIGIO(22, 0x200000) pending. At this
> moment, Xorg can not be waked up by any SIGIO(kill -s SIGIO xxxx never wake up Xorg,
> because kernel returned after legacy_queue(), and never reach signal_wake_up() ), but
> Xorg can be waked up and back to normal operation immediately when received other
> signals(kill -s SIGALRM xxxx). I could conclude that the lost wakeup only happen whenever
> the process is sleeping and at the same time it hold a pending signal.
>
>   I guess that kernel code might not be completely protected by siglock, and was interrupted
> by a coming SIGIO signal handling, that is how a SLEEPING Xorg got a pending signal.
> It is hard to find where the bug is, but I thought I could easily break the deadlock by waking
> up the current sleeping process whenever I found such a situation. So I made the patch and
> TESTED the patch on the same machine for about several weeks, and no Lost Wakeup
> occurred. Before patching, the same machine can have a hangup every one hour, by people
> keep moving the mouse. I was using a MIPS-based loongson CPU, and some other people
> I know also reported similar hangups on Power PC and SPARC, and X86 as reported in bug
> 60520,  https://bugzilla.kernel.org/show_bug.cgi?id=60520 .
>
>   Even on the MIPS-based Loongson, the occurrence of this bug is very rare,  I used
> another machine to detect the occurrence of the condition of this bug. In about 83
> minutes,  I logged 667238 times of SIGIO, and only one of them satisfy the lost
> wakeup condition, which Xorg is sleeping and Xorg has already a pending SIGIO
> at the same time. On X86, this might be even harder to observe, unless some other
> thing help it, for example video card in bug 60520.
>
>   I want to have your advises. Do you think that this could probably be a common
> bug, or just restricted to some rare hardwares?
