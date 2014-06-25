Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbaFYU1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:27:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57144 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbaFYU06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:26:58 -0400
Date: Wed, 25 Jun 2014 22:26:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: lkml <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org
Subject: Re: __schedule #DF splat
Message-ID: <20140625202650.GC13845@pd.tnic>
References: <20140625153227.GA13845@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140625153227.GA13845@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 05:32:28PM +0200, Borislav Petkov wrote:
> Hi guys,
> 
> so I'm looking at this splat below when booting current linus+tip/master
> in a kvm guest. Initially I thought this is something related to the
> PARAVIRT gunk but it happens with and without it.

Ok, here's a cleaner splat. I went and rebuilt qemu to latest master
from today to rule out some breakage there but it still fires.

Paolo, any ideas why would kvm+qemu trigger a #DF in the guest? I guess
I should dust off my old kvm/qemu #DF debugging patch I had somewhere...

I did try to avoid the invalid stack issue by doing:

---
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 1abcb50b48ae..dd8e0eec071e 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -286,7 +286,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
                }
                if (i && ((i % STACKSLOTS_PER_LINE) == 0))
                        pr_cont("\n");
-               pr_cont(" %016lx", *stack++);
+               pr_cont(" %016lx", (((unsigned long)stack <= 0x00007fffffffffffUL) ? -1 : *stack++));
                touch_nmi_watchdog();
        }
        preempt_enable();
---

but that didn't work either - see second splat at the end.

[    2.704184] PANIC: double fault, error_code: 0x0
[    2.708132] CPU: 1 PID: 959 Comm: vmmouse_detect Not tainted 3.15.0+ #7
[    2.708132] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[    2.708132] task: ffff880079c78000 ti: ffff880079c74000 task.ti: ffff880079c74000
[    2.708132] RIP: 0010:[<ffffffff8161130f>]  [<ffffffff8161130f>] __schedule+0x28f/0xab0
[    2.708132] RSP: 002b:00007fff99e51100  EFLAGS: 00013082
[    2.708132] RAX: 000000007b206000 RBX: ffff88007b526f80 RCX: 0000000000000028
[    2.708132] RDX: ffffffff816112fe RSI: 0000000000000001 RDI: ffff88007c5d3c58
[    2.708132] RBP: 00007fff99e511f0 R08: 0000000000000000 R09: 0000000000000000
[    2.708132] R10: 0000000000000001 R11: 0000000000000019 R12: ffff88007c5d3c40
[    2.708132] R13: ffff880079c84e40 R14: 0000000000000000 R15: ffff880079c78000
[    2.708132] FS:  00007ff252c6d700(0000) GS:ffff88007c400000(0000) knlGS:0000000000000000
[    2.708132] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.708132] CR2: 00007fff99e510f8 CR3: 000000007b206000 CR4: 00000000000006e0
[    2.708132] Stack:
[    2.708132] BUG: unable to handle kernel paging request at 00007fff99e51100
[    2.708132] IP: [<ffffffff81005bbc>] show_stack_log_lvl+0x11c/0x1d0
[    2.708132] PGD 7b20d067 PUD 0 
[    2.708132] Oops: 0000 [#1] PREEMPT SMP 
[    2.708132] Modules linked in:
[    2.708132] CPU: 1 PID: 959 Comm: vmmouse_detect Not tainted 3.15.0+ #7
[    2.708132] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[    2.708132] task: ffff880079c78000 ti: ffff880079c74000 task.ti: ffff880079c74000
[    2.708132] RIP: 0010:[<ffffffff81005bbc>]  [<ffffffff81005bbc>] show_stack_log_lvl+0x11c/0x1d0
[    2.708132] RSP: 002b:ffff88007c405e58  EFLAGS: 00013046
[    2.708132] RAX: 00007fff99e51108 RBX: 0000000000000000 RCX: ffff88007c403fc0
[    2.708132] RDX: 00007fff99e51100 RSI: ffff88007c400000 RDI: ffffffff81846aba
[    2.708132] RBP: ffff88007c405ea8 R08: ffff88007c3fffc0 R09: 0000000000000000
[    2.708132] R10: 000000007c400000 R11: 0000000000000000 R12: ffff88007c405f58
[    2.708132] R13: 0000000000000000 R14: ffffffff818136fc R15: 0000000000000000
[    2.708132] FS:  00007ff252c6d700(0000) GS:ffff88007c400000(0000) knlGS:0000000000000000
[    2.708132] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.708132] CR2: 00007fff99e51100 CR3: 000000007b206000 CR4: 00000000000006e0
[    2.708132] Stack:
[    2.708132]  0000000000000008 ffff88007c405eb8 ffff88007c405e70 000000007b206000
[    2.708132]  00007fff99e51100 ffff88007c405f58 00007fff99e51100 0000000000000040
[    2.708132]  0000000000000ac0 ffff880079c78000 ffff88007c405f08 ffffffff81005d10
[    2.708132] Call Trace:
[    2.708132]  <#DF> 
[    2.708132]  [<ffffffff81005d10>] show_regs+0xa0/0x280
[    2.708132]  [<ffffffff8103d143>] df_debug+0x23/0x40
[    2.708132]  [<ffffffff81003b6d>] do_double_fault+0x5d/0x80
[    2.708132]  [<ffffffff816194c7>] double_fault+0x27/0x30
[    2.708132]  [<ffffffff816112fe>] ? __schedule+0x27e/0xab0
[    2.708132]  [<ffffffff8161130f>] ? __schedule+0x28f/0xab0
[    2.708132]  <<EOE>> 
[    2.708132]  <UNK> Code: 7a ff ff ff 0f 1f 00 e8 93 80 00 00 eb a5 48 39 ca 0f 84 8d 00 00 00 45 85 ff 0f 1f 44 00 00 74 06 41 f6 c7 03 74 55 48 8d 42 08 <48> 8b 32 48 c7 c7 f4 36 81 81 4c 89 45 b8 48 89 4d c0 41 ff c7 
[    2.708132] RIP  [<ffffffff81005bbc>] show_stack_log_lvl+0x11c/0x1d0
[    2.708132]  RSP <ffff88007c405e58>
[    2.708132] CR2: 00007fff99e51100
[    2.708132] ---[ end trace 749cd02c31c493a0 ]---
[    2.708132] note: vmmouse_detect[959] exited with preempt_count 3





[    1.730726] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[    1.737392] devtmpfs: mounted
[    1.748817] Freeing unused kernel memory: 2872K (ffffffff819a9000 - ffffffff81c77000)
[    2.249240] udevd[812]: starting version 175
[    2.563876] PANIC: double fault, error_code: 0x0
[    2.563885] 
[    2.564051] ======================================================
[    2.564051] [ INFO: possible circular locking dependency detected ]
[    2.575059] 3.15.0+ #8 Not tainted
[    2.575059] -------------------------------------------------------
[    2.575059] vmmouse_detect/960 is trying to acquire lock:
[    2.575059]  ((console_sem).lock){-.....}, at: [<ffffffff8109cfdd>] down_trylock+0x1d/0x50
[    2.575059] 
[    2.575059] but task is already holding lock:
[    2.575059]  (&rq->lock){-.-.-.}, at: [<ffffffff8161118f>] __schedule+0xdf/0xab0
[    2.575059] 
[    2.575059] which lock already depends on the new lock.
[    2.575059] 
[    2.575059] 
[    2.575059] the existing dependency chain (in reverse order) is:
[    2.575059] 
-> #2 (&rq->lock){-.-.-.}:
[    2.575059]        [<ffffffff810a62c9>] lock_acquire+0xb9/0x200
[    2.575059]        [<ffffffff816160e1>] _raw_spin_lock+0x41/0x80
[    2.575059]        [<ffffffff8108ab3b>] wake_up_new_task+0xbb/0x290
[    2.575059]        [<ffffffff8104e887>] do_fork+0x147/0x770
[    2.575059]        [<ffffffff8104eed6>] kernel_thread+0x26/0x30
[    2.575059]        [<ffffffff8160b572>] rest_init+0x22/0x140
[    2.575059]        [<ffffffff81b7ee3e>] start_kernel+0x408/0x415
[    2.575059]        [<ffffffff81b7e463>] x86_64_start_reservations+0x2a/0x2c
[    2.575059]        [<ffffffff81b7e55b>] x86_64_start_kernel+0xf6/0xf9
[    2.575059] 
-> #1 (&p->pi_lock){-.-.-.}:
[    2.575059]        [<ffffffff810a62c9>] lock_acquire+0xb9/0x200
[    2.575059]        [<ffffffff81616303>] _raw_spin_lock_irqsave+0x53/0x90
[    2.575059]        [<ffffffff8108a70c>] try_to_wake_up+0x3c/0x330
[    2.575059]        [<ffffffff8108aa23>] wake_up_process+0x23/0x40
[    2.575059]        [<ffffffff816151af>] __up.isra.0+0x1f/0x30
[    2.575059]        [<ffffffff8109d1d1>] up+0x41/0x50
[    2.575059]        [<ffffffff810b5608>] console_unlock+0x258/0x490
[    2.575059]        [<ffffffff810b5ad1>] vprintk_emit+0x291/0x610
[    2.575059]        [<ffffffff8160ebf7>] printk_emit+0x33/0x3b
[    2.575059]        [<ffffffff810b5fd4>] devkmsg_writev+0x154/0x1d0
[    2.575059]        [<ffffffff8116d77a>] do_sync_write+0x5a/0x90
[    2.575059]        [<ffffffff8116df25>] vfs_write+0x175/0x1c0
[    2.575059]        [<ffffffff8116e982>] SyS_write+0x52/0xc0
[    2.575059]        [<ffffffff81617ce6>] system_call_fastpath+0x1a/0x1f
[    2.575059] 
-> #0 ((console_sem).lock){-.....}:
[    2.575059]        [<ffffffff810a5754>] __lock_acquire+0x1f14/0x2290
[    2.575059]        [<ffffffff810a62c9>] lock_acquire+0xb9/0x200
[    2.575059]        [<ffffffff81616303>] _raw_spin_lock_irqsave+0x53/0x90
[    2.575059]        [<ffffffff8109cfdd>] down_trylock+0x1d/0x50
[    2.575059]        [<ffffffff810b50fe>] console_trylock+0x1e/0xb0
[    2.575059]        [<ffffffff810b5ab3>] vprintk_emit+0x273/0x610
[    2.575059]        [<ffffffff8160ec4e>] printk+0x4f/0x57
[    2.575059]        [<ffffffff8103d16b>] df_debug+0x1b/0x40
[    2.575059]        [<ffffffff81003b6d>] do_double_fault+0x5d/0x80
[    2.575059]        [<ffffffff81619507>] double_fault+0x27/0x30
[    2.575059] 
[    2.575059] other info that might help us debug this:
[    2.575059] 
[    2.575059] Chain exists of:
  (console_sem).lock --> &p->pi_lock --> &rq->lock

[    2.575059]  Possible unsafe locking scenario:
[    2.575059] 
[    2.575059]        CPU0                    CPU1
[    2.575059]        ----                    ----
[    2.575059]   lock(&rq->lock);
[    2.575059]                                lock(&p->pi_lock);
[    2.575059]                                lock(&rq->lock);
[    2.575059]   lock((console_sem).lock);
[    2.575059] 
[    2.575059]  *** DEADLOCK ***
[    2.575059] 
[    2.575059] 1 lock held by vmmouse_detect/960:
[    2.575059]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff8161118f>] __schedule+0xdf/0xab0
[    2.575059] 
[    2.575059] stack backtrace:
[    2.575059] CPU: 0 PID: 960 Comm: vmmouse_detect Not tainted 3.15.0+ #8
[    2.575059] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[    2.575059]  ffffffff823ef810 ffff88007c205c50 ffffffff8160f461 ffffffff823f22b0
[    2.575059]  ffff88007c205c90 ffffffff8109fd2b ffffffff82802180 ffff880079ca2e48
[    2.575059]  ffff880079ca2718 ffff880079ca26e0 0000000000000001 ffff880079ca2e10
[    2.575059] Call Trace:
[    2.575059]  <#DF>  [<ffffffff8160f461>] dump_stack+0x4e/0x7a
[    2.575059]  [<ffffffff8109fd2b>] print_circular_bug+0x1fb/0x330
[    2.575059]  [<ffffffff810a5754>] __lock_acquire+0x1f14/0x2290
[    2.575059]  [<ffffffff810a62c9>] lock_acquire+0xb9/0x200
[    2.575059]  [<ffffffff8109cfdd>] ? down_trylock+0x1d/0x50
[    2.575059]  [<ffffffff81616303>] _raw_spin_lock_irqsave+0x53/0x90
[    2.575059]  [<ffffffff8109cfdd>] ? down_trylock+0x1d/0x50
[    2.575059]  [<ffffffff810b5ab3>] ? vprintk_emit+0x273/0x610
[    2.575059]  [<ffffffff8109cfdd>] down_trylock+0x1d/0x50
[    2.575059]  [<ffffffff810b5ab3>] ? vprintk_emit+0x273/0x610
[    2.575059]  [<ffffffff810b50fe>] console_trylock+0x1e/0xb0
[    2.575059]  [<ffffffff810b5ab3>] vprintk_emit+0x273/0x610
[    2.575059]  [<ffffffff8160ec4e>] printk+0x4f/0x57
[    2.575059]  [<ffffffff8103d16b>] df_debug+0x1b/0x40
[    2.575059]  [<ffffffff81003b6d>] do_double_fault+0x5d/0x80
[    2.575059]  [<ffffffff81619507>] double_fault+0x27/0x30
[    2.575059]  [<ffffffff8161132e>] ? __schedule+0x27e/0xab0
[    2.575059]  [<ffffffff8161133f>] ? __schedule+0x28f/0xab0
[    2.575059]  <<EOE>>  <UNK> 
[    2.575059] CPU: 0 PID: 960 Comm: vmmouse_detect Not tainted 3.15.0+ #8
[    2.575059] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[    2.575059] task: ffff880079ca26e0 ti: ffff880079d04000 task.ti: ffff880079d04000
[    2.575059] RIP: 0010:[<ffffffff8161133f>]  [<ffffffff8161133f>] __schedule+0x28f/0xab0
[    2.575059] RSP: 002b:00007fff70516420  EFLAGS: 00013086
[    2.575059] RAX: 000000007ae81000 RBX: ffff88007be67900 RCX: 0000000000000028
[    2.575059] RDX: ffffffff8161132e RSI: 0000000000000001 RDI: ffff88007c3d3c58
[    2.575059] RBP: 00007fff70516510 R08: 0000000000000000 R09: 0000000000005c00
[    2.575059] R10: 0000000000000001 R11: 0000000000000019 R12: ffff88007c3d3c40
[    2.575059] R13: ffff88007b634000 R14: 0000000000000000 R15: ffff880079ca26e0
[    2.575059] FS:  00007f77c13d6700(0000) GS:ffff88007c200000(0000) knlGS:0000000000000000
[    2.575059] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.575059] CR2: 00007fff70516418 CR3: 000000007ae81000 CR4: 00000000000006f0
[    2.575059] Stack:
[    2.575059]  ffffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffff
[    2.575059]  ffffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffff
[    2.575059]  ffffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffff
[    2.575059] Call Trace:
[    2.575059]  <UNK> 
[    2.575059] Code: 39 b5 80 03 00 00 0f 85 38 06 00 00 49 83 bf 88 02 00 00 00 0f 84 9a 03 00 00 49 8d 7c 24 18 48 c7 c2 2e 13 61 81 be 01 00 00 00 <e8> 4c 4b a9 ff 48 8b 74 24 18 4c 89 ff 9c 55 48 89 f5 48 89 a7 
[    2.575059] Kernel panic - not syncing: Machine halted.
[    2.575059] CPU: 0 PID: 960 Comm: vmmouse_detect Not tainted 3.15.0+ #8
[    2.575059] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[    2.575059]  ffff88007c205f18 ffff88007c205e88 ffffffff8160f461 ffffffff81817b42
[    2.575059]  ffff88007c205f08 ffffffff8160ded3 0000000000000008 ffff88007c205f18
[    2.575059]  ffff88007c205eb0 ffffffff81005cfb ffffffff81616531 0000000080000002
[    2.575059] Call Trace:
[    2.575059]  <#DF>  [<ffffffff8160f461>] dump_stack+0x4e/0x7a
[    2.575059]  [<ffffffff8160ded3>] panic+0xc5/0x1e1
[    2.575059]  [<ffffffff81005cfb>] ? show_regs+0x5b/0x280
[    2.575059]  [<ffffffff81616531>] ? _raw_spin_unlock_irqrestore+0x41/0x90
[    2.575059]  [<ffffffff8103d181>] df_debug+0x31/0x40
[    2.575059]  [<ffffffff81003b6d>] do_double_fault+0x5d/0x80
[    2.575059]  [<ffffffff81619507>] double_fault+0x27/0x30
[    2.575059]  [<ffffffff8161132e>] ? __schedule+0x27e/0xab0
[    2.575059]  [<ffffffff8161133f>] ? __schedule+0x28f/0xab0
[    2.575059]  <<EOE>>  <UNK> 
[    2.575059] Shutting down cpus with NMI
[    2.575059] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[    2.575059] ---[ end Kernel panic - not syncing: Machine halted.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
