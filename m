Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaLSTPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 14:15:24 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:62047 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaLSTPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 14:15:22 -0500
MIME-Version: 1.0
In-Reply-To: <20141219145528.GC13404@redhat.com>
References: <CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
	<CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
	<20141218051327.GA31988@redhat.com>
	<1418918059.17358.6@mail.thefacebook.com>
	<20141218161230.GA6042@redhat.com>
	<20141219024549.GB1671@redhat.com>
	<CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com>
	<20141219035859.GA20022@redhat.com>
	<20141219040308.GB20022@redhat.com>
	<CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com>
	<20141219145528.GC13404@redhat.com>
Date: Fri, 19 Dec 2014 11:15:21 -0800
X-Google-Sender-Auth: 48fW6xzea2s1vbangDn6HNCwFKg
Message-ID: <CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 6:55 AM, Dave Jones <davej@redhat.com> wrote:
>
> Wish DEBUG_SPINLOCK disabled, I see the same behaviour.
> Lots of traces spewed, but it seems to run and run (at least so far).

Ok, so it's not spinlock debugging.

There are some interesting patters here, once again. Lookie:

     RIP: 0010:   generic_exec_single+0xea/0x1b0
     RIP: 0010:   generic_exec_single+0xee/0x1b0
     RIP: 0010:   generic_exec_single+0xea/0x1b0
     RIP: 0010:   generic_exec_single+0xea/0x1b0
     RIP: 0010:   generic_exec_single+0xee/0x1b0
     RIP: 0010:   generic_exec_single+0xee/0x1b0
     RIP: 0010:   generic_exec_single+0xea/0x1b0
     sched: RT throttling activated
     RIP: 0010:   __slab_alloc+0x4e5/0x53b
     RIP: 0010:   copy_user_enhanced_fast_string+0x5/0x10
     RIP: 0033:   0x412fc8
     RIP: 0010:   clear_page_c_e+0x7/0x10
     RIP: 0010:   cpuidle_enter_state+0x79/0x190
     RIP: 0010:   __slab_alloc+0x4e5/0x53b
     RIP: 0010:   find_get_pid+0x1e/0x30

so now copy_page_range() is gone, but every single case before the RT
throttling is activated is that zap_page_range() followed by the TLB
invalidate that we saw last time.

And after RT throttling, it's random (not even always trinity), but
that's probably because the watchdog thread doesn't run reliably any
more.

Another pattern in this one: it's CPU#1 that is stuck. Every single
time. There are stack traces from other CPU's, but they are all the
NMI broadcast *due* to the soft lockup on CPU#1.

And that is true even after the RT throttling thing.

And let's take another look at your previous one (with lock debugging,
but that config detail is clearly not that important - it hasn't
really changed anything major except make that lock very visible):

     RIP: 0010:   lock_acquire+0xb4/0x120
     RIP: 0010:   lock_acquire+0xb4/0x120
     RIP: 0010:   generic_exec_single+0xee/0x1b0
     RIP: 0010:   lock_acquire+0xb4/0x120
     RIP: 0010:   lock_acquire+0xb4/0x120
     RIP: 0010:   lock_acquire+0xb4/0x120
     RIP: 0010:   lock_acquire+0xb4/0x120
     RIP: 0010:   lock_acquire+0xb4/0x120
     RIP: 0010:   lock_acquire+0xb4/0x120
     sched: RT throttling activated
     RIP: 0010:   shmem_write_end+0x65/0xf0
     RIP: 0010:   _raw_spin_unlock_irqrestore+0x38/0x60
     RIP: 0010:   copy_user_enhanced_fast_string+0x5/0x10
     RIP: 0010:   copy_user_enhanced_fast_string+0x5/0x10
     RIP: 0010:   __slab_alloc+0x52f/0x58f
     RIP: 0010:   map_id_up+0x9/0x80
     RIP: 0010:   cpuidle_enter_state+0x79/0x190
     RIP: 0010:   unmap_single_vma+0x7d9/0x900
     RIP: 0010:   cpuidle_enter_state+0x79/0x190

same pattern: after the RT throttling, it's random because the
watchdog is no longer sane, before that it's always reliably either
the lock_acquire as part of copy_page_range(), or it's that TLB flush
as part of zap_page_range().

And the CPU patterns are interesting too:

   NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c195:20128]
   NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c195:20128]
   NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [trinity-c154:22823]
   NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c195:20128]
   NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c195:20128]
   NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c195:20128]
   NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c195:20128]
   NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c195:20128]
   NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c195:20128]

CPU#1 again, *except* for the third lockup, which happens to match the
exact same pattern of copy_page_range() (CPU#1) vs zap_page_range()
(CPU#2).

It's also the case that before the RT throttling, it really does seem
to be one particular thread (ie trinity-c195.20128 does the
copy_page_range on your previous one, and in the newer one it's
trinity-c205:636 that does the zap_page_range(). So those threads
really seem to be stuck for real. The fact that they *eventually* go
away at all is interesting in itself.

And that "generic_exec_single()" place where it is stuck is the
instruction after the "pause" (aka "cpu_relax()") in the final
"csd_lock_wait()" once more. So it's waiting on some CPU to pick up
the IPI, and that never happens.

Here's another pattern. In your latest thing, every single time that
CPU1 is waiting for some other CPU to pick up the IPI, we have CPU0
doing this:

[24998.060963] NMI backtrace for cpu 0
[24998.061989] CPU: 0 PID: 2940 Comm: trinity-c150 Not tainted 3.18.0+ #108
[24998.064073] task: ffff8801bf3536b0 ti: ffff880197e0c000 task.ti:
ffff880197e0c000
[24998.065137] RIP: 0010:[<ffffffff8103e006>]  [<ffffffff8103e006>]
read_hpet+0x16/0x20
[24998.083577]  [<ffffffff810e0d3e>] ktime_get+0x3e/0xa0
[24998.084450]  [<ffffffff810e9cd3>] tick_sched_timer+0x23/0x160
[24998.085315]  [<ffffffff810daf96>] __run_hrtimer+0x76/0x1f0
[24998.086173]  [<ffffffff810e9cb0>] ? tick_init_highres+0x20/0x20
[24998.087025]  [<ffffffff810db2e7>] hrtimer_interrupt+0x107/0x260
[24998.087877]  [<ffffffff81031a4b>] local_apic_timer_interrupt+0x3b/0x70
[24998.088732]  [<ffffffff8179bca5>] smp_apic_timer_interrupt+0x45/0x60
[24998.089583]  [<ffffffff8179a0df>] apic_timer_interrupt+0x6f/0x80
[24998.090435]  <EOI>
[24998.091279]  [<ffffffff810da66e>] ? __remove_hrtimer+0x4e/0xa0
[24998.092118]  [<ffffffff812c7c7a>] ? ipcget+0x8a/0x1e0
[24998.092951]  [<ffffffff812c7c6c>] ? ipcget+0x7c/0x1e0
[24998.093779]  [<ffffffff812c8d6d>] SyS_msgget+0x4d/0x70

and I think that's the smoking gun. The reason CPU0 isn't picking up
any IPI's is because it is in some endless loop around read_hpet().

There is even time information in the register dump:

 RAX: 0000000061fece8a RBX: 0000000000510792 RCX: 0000000000000000
 RAX: 0000000079e588fc RBX: 0000000000511d6e RCX: 0000000000000000
 RAX: 0000000091ca7f65 RBX: 0000000000513346 RCX: 0000000000000000
 RAX: 00000000a9afbd0d RBX: 000000000051491e RCX: 0000000000000000
 RAX: 00000000cbd1340c RBX: 000000000051684a RCX: 0000000000000000
 RAX: 00000000fb9d303f RBX: 00000000005193fc RCX: 0000000000000000
 RAX: 000000002b67efe4 RBX: 000000000051c224 RCX: 0000000000000004

That RAX value is the value we just read from the HPET, and RBX seems
to be monotonically increasing too, so it's likely the sequence
counter in ktime_get().

So it's not stuck *inside* read_hpet(), and it's almost certainly not
the loop over the sequence counter in ktime_get() either (it's not
increasing *that* quickly). But some basically infinite __run_hrtimer
thing or something?

In your earlier trace (with spinlock debugging), the softlockup
detection was in lock_acquire for copy_page_range(), but CPU2 was
always in that "generic_exec_single" due to a TLB flush from that
zap_page_range thing again. But there are no timer traces from that
one, so I dunno.

Anyway, I do think we're getting somewhere. Your traces are
interesting and have real patterns in them. Which is very different
from the mess it used to be.

                            Linus
