Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab3GXCYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 22:24:35 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:38593 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3GXCYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 22:24:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130723162835.GA20430@redhat.com>
References: <20130723162835.GA20430@redhat.com>
Date: Tue, 23 Jul 2013 19:24:31 -0700
X-Google-Sender-Auth: mCdVbDT5JSi9LWGuHQF8ADhFlnk
Message-ID: <CA+55aFw9Vo_vugB63kbjh6=jPDoJZP47Nw+hEgMCxFPiExYn5w@mail.gmail.com>
Subject: Re: spinlock lockup, rcu stalls etc.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Thomas and Ingo due to that timer/nmi thing. ]

On Tue, Jul 23, 2013 at 9:28 AM, Dave Jones <davej@redhat.com> wrote:
> Woke up to a box that I could log into, but would hang as soon as I tried to
> do any disk IO.  This is what hit the logs before that.
>
> [28853.503179] hrtimer: interrupt took 4847 ns

Ugh. There's some nasty timer congestion there..

> [28932.599607] BUG: spinlock lockup suspected on CPU#0, trinity-child2/6990
> [28932.600419]  lock: inode_sb_list_lock+0x0/0x80, .magic: dead4ead, .owner: trinity-child1/6763, .owner_cpu: 1

So the current owner of the lock is cpu 1. The other CPU's agree:

> [28932.606666] BUG: spinlock lockup suspected on CPU#2, trinity-child2/6764
> [28932.606669]  lock: inode_sb_list_lock+0x0/0x80, .magic: dead4ead, .owner: trinity-child1/6763, .owner_cpu: 1
> [28932.617231] sending NMI to all CPUs:
> [28932.635092] BUG: spinlock lockup suspected on CPU#3, trinity-child3/6975
> [28932.635095]  lock: inode_sb_list_lock+0x0/0x80, .magic: dead4ead, .owner: trinity-child1/6763, .owner_cpu: 1

.. and their backtrace all points to them trying to take that
spinlock. So that is all consistent.

And here's cpu1, edited down a bit:

> [28932.777623] NMI backtrace for cpu 1
> [28932.777625] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 91.230 msecs

Whee. 91 msec? We have something going on there too. irq entry locks?

> [28932.779440] CPU: 1 PID: 6763 Comm: trinity-child1 Not tainted 3.11.0-rc2+ #54
> [28932.782283] RIP: 0010:[<ffffffff81710385>]  [<ffffffff81710385>] add_preempt_count+0x25/0xf0
> [28932.797761] Call Trace:
> [28932.798737]  <IRQ>
> [28932.799715]  [<ffffffff81320851>] delay_tsc+0x61/0xe0
> [28932.800693]  [<ffffffff81320789>] __const_udelay+0x29/0x30
> [28932.801674]  [<ffffffff810816d4>] __rcu_read_unlock+0x54/0xa0
> [28932.802657]  [<ffffffff810af531>] cpuacct_account_field+0xf1/0x200
> [28932.804613]  [<ffffffff8109e430>] account_system_time+0xb0/0x1b0
> [28932.805561]  [<ffffffff8109e565>] __vtime_account_system+0x35/0x40
> [28932.806506]  [<ffffffff8109e59d>] vtime_account_system.part.2+0x2d/0x50
> [28932.807445]  [<ffffffff8109e8e5>] vtime_account_irq_enter+0x55/0x80
> [28932.808365]  [<ffffffff8105f42f>] irq_enter+0x4f/0x90
> [28932.809269]  [<ffffffff81716a15>] smp_apic_timer_interrupt+0x35/0x60
> [28932.810156]  [<ffffffff817156af>] apic_timer_interrupt+0x6f/0x80
> [28932.812756]  [<ffffffff8105f53d>] irq_exit+0xcd/0xe0
> [28932.813618]  [<ffffffff81716a25>] smp_apic_timer_interrupt+0x45/0x60
> [28932.814483]  [<ffffffff817156af>] apic_timer_interrupt+0x6f/0x80
> [28932.815345]  <EOI>
> [28932.816207]  [<ffffffff8170c6a0>] ? retint_restore_args+0xe/0xe
> [28932.817069]  [<ffffffff810c1275>] ? lock_acquired+0x105/0x3f0
> [28932.817924]  [<ffffffff811ec8e2>] ? sync_inodes_sb+0x1c2/0x2a0
> [28932.818767]  [<ffffffff8170b62c>] _raw_spin_lock+0x6c/0x80
> [28932.819616]  [<ffffffff811ec8e2>] ? sync_inodes_sb+0x1c2/0x2a0
> [28932.820468]  [<ffffffff811ec8e2>] sync_inodes_sb+0x1c2/0x2a0
> [28932.821310]  [<ffffffff81708c1f>] ? wait_for_completion+0xdf/0x110
> [28932.823819]  [<ffffffff811f2a49>] sync_inodes_one_sb+0x19/0x20
> [28932.824649]  [<ffffffff811c2b12>] iterate_supers+0xb2/0x110
> [28932.825477]  [<ffffffff811f2cb5>] sys_sync+0x35/0x90
> [28932.826300]  [<ffffffff81714c54>] tracesys+0xdd/0xe2
> [28932.827119]  [<ffffffffa0000000>] ? 0xffffffff9fffffff

.. and again, it actually looks like the time is not necessarily spent
inside the spinlock in sync_inodes_sb(), but in a timer interrupt that
just happened to go off during that. I wonder if this is the same
issue that caused that earlier hrtimer long delay.. I'm not
necessarily seeing 91 msecs worth, but..

You seem to have CONFIG_PROVE_RCU_DELAY enabled, which explains that
delay_tsc() call in there. I wonder how much things like that make it
worse. Together with the (crazy bad) back-off in __spin_lock_debug(),
there might be a *lot* of these delays.

That said, the fact that your machine is dead after all this implies
that there is something else wrong than just things being very slow.
But I suspect at least *part* of your problems may be due to these
kinds of debugging options that make things much much worse.

              Linus
