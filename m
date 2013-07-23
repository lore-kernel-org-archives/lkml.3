Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496Ab3GWQ2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:28:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932595Ab3GWQ2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:28:53 -0400
Date: Tue, 23 Jul 2013 12:28:35 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, paulmck@linux.vnet.ibm.com
Subject: spinlock lockup, rcu stalls etc.
Message-ID: <20130723162835.GA20430@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Woke up to a box that I could log into, but would hang as soon as I tried to
do any disk IO.  This is what hit the logs before that.

[28853.503179] hrtimer: interrupt took 4847 ns
[28918.966734] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=6502 jiffies, g=655835, c=655834, q=0)
[28918.968079] INFO: Stall ended before state dump start
[28932.599607] BUG: spinlock lockup suspected on CPU#0, trinity-child2/6990
[28932.600419]  lock: inode_sb_list_lock+0x0/0x80, .magic: dead4ead, .owner: trinity-child1/6763, .owner_cpu: 1
[28932.601597] CPU: 0 PID: 6990 Comm: trinity-child2 Not tainted 3.11.0-rc2+ #54 
[28932.604385]  0000000088c64840 ffff88022a567eb0 ffffffff81701c14 ffff8801f6cd5500
[28932.605322]  ffff88022a567ed0 ffffffff81701cd4 ffffffff81c04640 0000000088c64840
[28932.606666] BUG: spinlock lockup suspected on CPU#2, trinity-child2/6764
[28932.606669]  lock: inode_sb_list_lock+0x0/0x80, .magic: dead4ead, .owner: trinity-child1/6763, .owner_cpu: 1
[28932.606259]  ffff88022a567ef8 ffffffff81328e07 ffffffff81c04640 ffffffff81c04658
[28932.609238] Call Trace:
[28932.609545]  [<ffffffff81701c14>] dump_stack+0x4e/0x82
[28932.610167]  [<ffffffff81701cd4>] spin_dump+0x8c/0x91
[28932.610781]  [<ffffffff81328e07>] do_raw_spin_lock+0x67/0x130
[28932.611476]  [<ffffffff811f2a70>] ? fdatawait_one_bdev+0x20/0x20
[28932.612202]  [<ffffffff8170b620>] _raw_spin_lock+0x60/0x80
[28932.612866]  [<ffffffff811fe5fc>] ? iterate_bdevs+0x2c/0x120
[28932.613550]  [<ffffffff811fe5fc>] iterate_bdevs+0x2c/0x120
[28932.614213]  [<ffffffff811f2ce3>] sys_sync+0x63/0x90
[28932.615727]  [<ffffffff81714c54>] tracesys+0xdd/0xe2
[28932.617231] sending NMI to all CPUs:
[28932.617235] CPU: 2 PID: 6764 Comm: trinity-child2 Not tainted 3.11.0-rc2+ #54 
[28932.617238]  0000000088c64840 ffff88021b703d68 ffffffff81701c14 ffff8801f6cd5500
[28932.617239]  ffff88021b703d88 ffffffff81701cd4 ffffffff81c04640 0000000088c64840
[28932.617241]  ffff88021b703db0 ffffffff81328e07 ffffffff81c04640 ffffffff81c04658
[28932.617241] Call Trace:
[28932.617244]  [<ffffffff81701c14>] dump_stack+0x4e/0x82
[28932.617245]  [<ffffffff81701cd4>] spin_dump+0x8c/0x91
[28932.617247]  [<ffffffff81328e07>] do_raw_spin_lock+0x67/0x130
[28932.617249]  [<ffffffff8170b620>] _raw_spin_lock+0x60/0x80
[28932.617251]  [<ffffffff811ec948>] ? sync_inodes_sb+0x228/0x2a0
[28932.617253]  [<ffffffff811ec948>] sync_inodes_sb+0x228/0x2a0
[28932.617255]  [<ffffffff81708c1f>] ? wait_for_completion+0xdf/0x110
[28932.617258]  [<ffffffff8109837d>] ? get_parent_ip+0xd/0x50
[28932.617259]  [<ffffffff811f2a30>] ? generic_write_sync+0x70/0x70
[28932.617260]  [<ffffffff811f2a49>] sync_inodes_one_sb+0x19/0x20
[28932.617263]  [<ffffffff811c2b12>] iterate_supers+0xb2/0x110
[28932.617265]  [<ffffffff811f2cb5>] sys_sync+0x35/0x90
[28932.617266]  [<ffffffff81714c54>] tracesys+0xdd/0xe2
[28932.635092] BUG: spinlock lockup suspected on CPU#3, trinity-child3/6975
[28932.635095]  lock: inode_sb_list_lock+0x0/0x80, .magic: dead4ead, .owner: trinity-child1/6763, .owner_cpu: 1
[28932.635098] CPU: 3 PID: 6975 Comm: trinity-child3 Not tainted 3.11.0-rc2+ #54 
[28932.635101]  0000000088c64840 ffff88022dd43d68 ffffffff81701c14 ffff8801f6cd5500
[28932.635102]  ffff88022dd43d88 ffffffff81701cd4 ffffffff81c04640 0000000088c64840
[28932.635104]  ffff88022dd43db0 ffffffff81328e07 ffffffff81c04640 ffffffff81c04658
[28932.635104] Call Trace:
[28932.635106]  [<ffffffff81701c14>] dump_stack+0x4e/0x82
[28932.635108]  [<ffffffff81701cd4>] spin_dump+0x8c/0x91
[28932.635109]  [<ffffffff81328e07>] do_raw_spin_lock+0x67/0x130
[28932.635110]  [<ffffffff8170b620>] _raw_spin_lock+0x60/0x80
[28932.635112]  [<ffffffff811ec948>] ? sync_inodes_sb+0x228/0x2a0
[28932.635114]  [<ffffffff811ec948>] sync_inodes_sb+0x228/0x2a0
[28932.635117]  [<ffffffff81708c1f>] ? wait_for_completion+0xdf/0x110
[28932.635118]  [<ffffffff8109837d>] ? get_parent_ip+0xd/0x50
[28932.635120]  [<ffffffff811f2a30>] ? generic_write_sync+0x70/0x70
[28932.635121]  [<ffffffff811f2a49>] sync_inodes_one_sb+0x19/0x20
[28932.635123]  [<ffffffff811c2b12>] iterate_supers+0xb2/0x110
[28932.635124]  [<ffffffff811f2cb5>] sys_sync+0x35/0x90
[28932.635126]  [<ffffffff81714c54>] tracesys+0xdd/0xe2
[28932.686393] NMI backtrace for cpu 0
[28932.687256] CPU: 0 PID: 6990 Comm: trinity-child2 Not tainted 3.11.0-rc2+ #54 
[28932.689034] task: ffff8801f6cd3fc0 ti: ffff88022a566000 task.ti: ffff88022a566000
[28932.689926] RIP: 0010:[<ffffffff81326097>]  [<ffffffff81326097>] find_next_bit+0xa7/0xe0
[28932.690819] RSP: 0018:ffff88022a567e48  EFLAGS: 00000002
[28932.691693] RAX: ffffffffffffffff RBX: 0000000000000001 RCX: 0000000000000001
[28932.692555] RDX: 0000000000000001 RSI: 0000000000000004 RDI: 0000000000000000
[28932.693396] RBP: ffff88022a567e48 R08: ffff8802437ec540 R09: 0000000000000001
[28932.694236] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8802437ec540
[28932.695071] R13: ffff8802437eda40 R14: 0000000000080000 R15: 000000000000d010
[28932.695893] FS:  00007f7aeb601740(0000) GS:ffff880244800000(0000) knlGS:0000000000000000
[28932.696709] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[28932.697530] CR2: 00000000020491c8 CR3: 000000021c3c3000 CR4: 00000000001407f0
[28932.698358] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[28932.699193] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[28932.700019] Stack:
[28932.700838]  ffff88022a567ea8 ffffffff81033b96 0000000000000292 000000000000d008
[28932.701678]  0000000000000002 0000000000000000 0000000000000000 0000000000002710
[28932.702526]  0000000088c64840 0000000088c64840 0000000000000510 0000000000000002
[28932.703371] Call Trace:
[28932.704204]  [<ffffffff81033b96>] __x2apic_send_IPI_mask+0x96/0x1c0
[28932.705055]  [<ffffffff81033cdc>] x2apic_send_IPI_all+0x1c/0x20
[28932.705908]  [<ffffffff81030115>] arch_trigger_all_cpu_backtrace+0x65/0xa0
[28932.706752]  [<ffffffff81328e0c>] do_raw_spin_lock+0x6c/0x130
[28932.707583]  [<ffffffff811f2a70>] ? fdatawait_one_bdev+0x20/0x20
[28932.708392]  [<ffffffff8170b620>] _raw_spin_lock+0x60/0x80
[28932.709197]  [<ffffffff811fe5fc>] ? iterate_bdevs+0x2c/0x120
[28932.710004]  [<ffffffff811fe5fc>] iterate_bdevs+0x2c/0x120
[28932.710799]  [<ffffffff811f2ce3>] sys_sync+0x63/0x90
[28932.711600]  [<ffffffff81714c54>] tracesys+0xdd/0xe2
[28932.712399] Code: 00 00 48 c7 c2 ff ff ff ff 29 f1 48 d3 ea 48 21 d0 74 41 f3 48 0f bc c0 48 01 f8 5d c3 0f 1f 80 00 00 00 00 48 c7 c0 ff ff ff ff <48> d3 e0 49 23 00 48 83 fe 3f 76 c6 48 85 c0 75 d7 49 83 c0 08 
[28932.714185] NMI backtrace for cpu 3
[28932.714188] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 27.792 msecs
[28932.715902] CPU: 3 PID: 6975 Comm: trinity-child3 Not tainted 3.11.0-rc2+ #54 
[28932.717707] task: ffff8801f3553fc0 ti: ffff88022dd42000 task.ti: ffff88022dd42000
[28932.718623] RIP: 0010:[<ffffffff81328e22>]  [<ffffffff81328e22>] do_raw_spin_lock+0x82/0x130
[28932.719554] RSP: 0000:ffff88022dd43d98  EFLAGS: 00000202
[28932.720483] RAX: 00000000000000ed RBX: ffffffff81c04640 RCX: 0000000000000000
[28932.721423] RDX: 00000000000000ef RSI: 0000000000000001 RDI: 0000000000000001
[28932.722363] RBP: ffff88022dd43db0 R08: 0000000000000002 R09: 0000000000000000
[28932.723293] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000088c64840
[28932.724219] R13: 0000000088c64840 R14: ffff88023b57f648 R15: ffff88023b57f858
[28932.725130] FS:  00007fe3310bf740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
[28932.726043] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[28932.726928] CR2: 0000000001bbadf8 CR3: 000000022ad51000 CR4: 00000000001407e0
[28932.727827] DR0: 0000000002297000 DR1: 0000000000000000 DR2: 0000000000000000
[28932.728727] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[28932.729613] Stack:
[28932.730491]  ffffffff81c04640 ffffffff81c04658 ffff88023d0e8110 ffff88022dd43dd8
[28932.731400]  ffffffff8170b620 ffffffff811ec948 ffff88023b57f648 ffff88023b57f6d0
[28932.732310]  ffff88022dd43f18 ffffffff811ec948 7fffffffffffffff ffff88023d0e8000
[28932.733225] Call Trace:
[28932.734130]  [<ffffffff8170b620>] _raw_spin_lock+0x60/0x80
[28932.735042]  [<ffffffff811ec948>] ? sync_inodes_sb+0x228/0x2a0
[28932.735958]  [<ffffffff811ec948>] sync_inodes_sb+0x228/0x2a0
[28932.736871]  [<ffffffff81708c1f>] ? wait_for_completion+0xdf/0x110
[28932.737788]  [<ffffffff8109837d>] ? get_parent_ip+0xd/0x50
[28932.738705]  [<ffffffff811f2a30>] ? generic_write_sync+0x70/0x70
[28932.739622]  [<ffffffff811f2a49>] sync_inodes_one_sb+0x19/0x20
[28932.740541]  [<ffffffff811c2b12>] iterate_supers+0xb2/0x110
[28932.741461]  [<ffffffff811f2cb5>] sys_sync+0x35/0x90
[28932.742376]  [<ffffffff81714c54>] tracesys+0xdd/0xe2
[28932.743274] Code: 00 48 c7 c6 ac c1 a4 81 48 89 df e8 41 8e 3d 00 e8 a4 72 d0 ff b8 00 01 00 00 f0 66 0f c1 03 0f b6 d4 38 c2 74 09 f3 90 0f b6 03 <38> c2 75 f7 eb 1a 0f 1f 84 00 00 00 00 00 8d 8a 00 01 00 00 89 
[28932.745205] NMI backtrace for cpu 2
[28932.745207] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 58.812 msecs
[28932.747019] CPU: 2 PID: 6764 Comm: trinity-child2 Not tainted 3.11.0-rc2+ #54 
[28932.748893] task: ffff880242d63fc0 ti: ffff88021b702000 task.ti: ffff88021b702000
[28932.749849] RIP: 0010:[<ffffffff81328e1f>]  [<ffffffff81328e1f>] do_raw_spin_lock+0x7f/0x130
[28932.750818] RSP: 0018:ffff88021b703d98  EFLAGS: 00000202
[28932.751778] RAX: 00000000000000ed RBX: ffffffff81c04640 RCX: 0000000000000000
[28932.752740] RDX: 00000000000000ee RSI: 0000000000000001 RDI: 0000000000000001
[28932.753699] RBP: ffff88021b703db0 R08: 0000000000000002 R09: 0000000000000000
[28932.754645] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000088c64840
[28932.755592] R13: 0000000088c64840 R14: ffff8802328e5548 R15: ffff8802328e5758
[28932.756547] FS:  00007fbbe649e740(0000) GS:ffff880244c00000(0000) knlGS:0000000000000000
[28932.757512] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[28932.758469] CR2: 00007fcd8f15d000 CR3: 00000001cc9cd000 CR4: 00000000001407e0
[28932.759438] DR0: 000000000232b000 DR1: 0000000000000000 DR2: 0000000000000000
[28932.760405] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[28932.761363] Stack:
[28932.762312]  ffffffff81c04640 ffffffff81c04658 ffff88023c33e8c0 ffff88021b703dd8
[28932.763289]  ffffffff8170b620 ffffffff811ec948 ffff8802328e5548 ffff8802328e55d0
[28932.764261]  ffff88021b703f18 ffffffff811ec948 7fffffffffffffff ffff88023c33e7b0
[28932.765229] Call Trace:
[28932.766189]  [<ffffffff8170b620>] _raw_spin_lock+0x60/0x80
[28932.767157]  [<ffffffff811ec948>] ? sync_inodes_sb+0x228/0x2a0
[28932.768125]  [<ffffffff811ec948>] sync_inodes_sb+0x228/0x2a0
[28932.769093]  [<ffffffff81708c1f>] ? wait_for_completion+0xdf/0x110
[28932.770068]  [<ffffffff8109837d>] ? get_parent_ip+0xd/0x50
[28932.771045]  [<ffffffff811f2a30>] ? generic_write_sync+0x70/0x70
[28932.772003]  [<ffffffff811f2a49>] sync_inodes_one_sb+0x19/0x20
[28932.772939]  [<ffffffff811c2b12>] iterate_supers+0xb2/0x110
[28932.773871]  [<ffffffff811f2cb5>] sys_sync+0x35/0x90
[28932.774790]  [<ffffffff81714c54>] tracesys+0xdd/0xe2
[28932.775691] Code: 92 00 00 00 48 c7 c6 ac c1 a4 81 48 89 df e8 41 8e 3d 00 e8 a4 72 d0 ff b8 00 01 00 00 f0 66 0f c1 03 0f b6 d4 38 c2 74 09 f3 90 <0f> b6 03 38 c2 75 f7 eb 1a 0f 1f 84 00 00 00 00 00 8d 8a 00 01 
[28932.777623] NMI backtrace for cpu 1
[28932.777625] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 91.230 msecs
[28932.779440] CPU: 1 PID: 6763 Comm: trinity-child1 Not tainted 3.11.0-rc2+ #54 
[28932.781322] task: ffff8801f6cd5500 ti: ffff8801f37f0000 task.ti: ffff8801f37f0000
[28932.782283] RIP: 0010:[<ffffffff81710385>]  [<ffffffff81710385>] add_preempt_count+0x25/0xf0
[28932.783258] RSP: 0018:ffff880244a03d18  EFLAGS: 00000046
[28932.784226] RAX: ffff8801f37f1fd8 RBX: 0000000000000001 RCX: 0000000000000000
[28932.785198] RDX: 0000000000000103 RSI: 0000000000000103 RDI: 0000000000000001
[28932.786164] RBP: ffff880244a03d20 R08: 0000000000000000 R09: 0000000000000000
[28932.787125] R10: 0000000000000001 R11: 0000000000000001 R12: 00000000000059a4
[28932.788078] R13: 0000000000000001 R14: 00000000bb2c46dc R15: ffff8801f37f1fd8
[28932.789040] FS:  00007fe3310bf740(0000) GS:ffff880244a00000(0000) knlGS:0000000000000000
[28932.790007] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[28932.790964] CR2: 00007fc75af18070 CR3: 00000001ebf1f000 CR4: 00000000001407e0
[28932.791934] DR0: 0000000001ef0000 DR1: 0000000000000000 DR2: 0000000000000000
[28932.792903] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[28932.793859] Stack:
[28932.794811]  00000000bb2c1760 ffff880244a03d58 ffffffff81320851 ffff8801f6cd5500
[28932.795786]  ffff8802360d9860 0000000000000020 0000000000002cbb ffff8801f0e75c78
[28932.796770]  ffff880244a03d68 ffffffff81320789 ffff880244a03d80 ffffffff810816d4
[28932.797761] Call Trace:
[28932.798737]  <IRQ> 
[28932.799715]  [<ffffffff81320851>] delay_tsc+0x61/0xe0
[28932.800693]  [<ffffffff81320789>] __const_udelay+0x29/0x30
[28932.801674]  [<ffffffff810816d4>] __rcu_read_unlock+0x54/0xa0
[28932.802657]  [<ffffffff810af531>] cpuacct_account_field+0xf1/0x200
[28932.803645]  [<ffffffff810af445>] ? cpuacct_account_field+0x5/0x200
[28932.804613]  [<ffffffff8109e430>] account_system_time+0xb0/0x1b0
[28932.805561]  [<ffffffff8109e565>] __vtime_account_system+0x35/0x40
[28932.806506]  [<ffffffff8109e59d>] vtime_account_system.part.2+0x2d/0x50
[28932.807445]  [<ffffffff8109e8e5>] vtime_account_irq_enter+0x55/0x80
[28932.808365]  [<ffffffff8105f42f>] irq_enter+0x4f/0x90
[28932.809269]  [<ffffffff81716a15>] smp_apic_timer_interrupt+0x35/0x60
[28932.810156]  [<ffffffff817156af>] apic_timer_interrupt+0x6f/0x80
[28932.811030]  [<ffffffff8170c6a0>] ? retint_restore_args+0xe/0xe
[28932.811895]  [<ffffffff8105eff1>] ? __do_softirq+0xb1/0x440
[28932.812756]  [<ffffffff8105f53d>] irq_exit+0xcd/0xe0
[28932.813618]  [<ffffffff81716a25>] smp_apic_timer_interrupt+0x45/0x60
[28932.814483]  [<ffffffff817156af>] apic_timer_interrupt+0x6f/0x80
[28932.815345]  <EOI> 
[28932.816207]  [<ffffffff8170c6a0>] ? retint_restore_args+0xe/0xe
[28932.817069]  [<ffffffff810c1275>] ? lock_acquired+0x105/0x3f0
[28932.817924]  [<ffffffff811ec8e2>] ? sync_inodes_sb+0x1c2/0x2a0
[28932.818767]  [<ffffffff8170b62c>] _raw_spin_lock+0x6c/0x80
[28932.819616]  [<ffffffff811ec8e2>] ? sync_inodes_sb+0x1c2/0x2a0
[28932.820468]  [<ffffffff811ec8e2>] sync_inodes_sb+0x1c2/0x2a0
[28932.821310]  [<ffffffff81708c1f>] ? wait_for_completion+0xdf/0x110
[28932.822147]  [<ffffffff8109837d>] ? get_parent_ip+0xd/0x50
[28932.822984]  [<ffffffff811f2a30>] ? generic_write_sync+0x70/0x70
[28932.823819]  [<ffffffff811f2a49>] sync_inodes_one_sb+0x19/0x20
[28932.824649]  [<ffffffff811c2b12>] iterate_supers+0xb2/0x110
[28932.825477]  [<ffffffff811f2cb5>] sys_sync+0x35/0x90
[28932.826300]  [<ffffffff81714c54>] tracesys+0xdd/0xe2
[28932.827119]  [<ffffffffa0000000>] ? 0xffffffff9fffffff
[28932.827938] Code: c2 fe ff ff c9 c3 0f 1f 44 00 00 8b 0d 0d 3c 9b 00 55 65 48 8b 04 25 f0 b9 00 00 48 89 e5 53 89 fb 85 c9 75 59 8b 90 44 e0 ff ff <85> d2 0f 88 87 00 00 00 01 b8 44 e0 ff ff 80 b8 44 e0 ff ff f4 
[28932.829761] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 143.366 msecs
[29113.907186] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=26007 jiffies, g=655835, c=655834, q=0)
[29113.909408] INFO: Stall ended before state dump start
[29308.847645] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=45512 jiffies, g=655835, c=655834, q=0)
[29308.849897] INFO: Stall ended before state dump start
[29503.788103] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=65017 jiffies, g=655835, c=655834, q=0)
[29503.790346] INFO: Stall ended before state dump start
[29698.728562] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=84522 jiffies, g=655835, c=655834, q=0)
[29698.730820] INFO: Stall ended before state dump start
[29893.669020] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=104027 jiffies, g=655835, c=655834, q=0)
[29893.671281] INFO: Stall ended before state dump start
[30088.609477] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=123532 jiffies, g=655835, c=655834, q=0)
[30088.611737] INFO: Stall ended before state dump start
[30283.549935] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=143037 jiffies, g=655835, c=655834, q=0)
[30283.552212] INFO: Stall ended before state dump start
[30478.490392] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=162542 jiffies, g=655835, c=655834, q=0)
[30478.492697] INFO: Stall ended before state dump start
[30673.430849] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=182047 jiffies, g=655835, c=655834, q=0)
[30673.433188] INFO: Stall ended before state dump start
[30868.371305] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=201552 jiffies, g=655835, c=655834, q=0)
[30868.373659] INFO: Stall ended before state dump start
[31063.311762] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=221057 jiffies, g=655835, c=655834, q=0)
[31063.314138] INFO: Stall ended before state dump start
[31258.252218] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=240562 jiffies, g=655835, c=655834, q=0)
[31258.254620] INFO: Stall ended before state dump start
[31453.192674] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=260067 jiffies, g=655835, c=655834, q=0)
[31453.195094] INFO: Stall ended before state dump start
[31648.133129] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=279572 jiffies, g=655835, c=655834, q=0)
[31648.135568] INFO: Stall ended before state dump start
[31843.073585] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=299077 jiffies, g=655835, c=655834, q=0)
[31843.076054] INFO: Stall ended before state dump start
[32038.014040] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=318582 jiffies, g=655835, c=655834, q=0)
[32038.016541] INFO: Stall ended before state dump start
[32232.954496] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=338087 jiffies, g=655835, c=655834, q=0)
[32232.957026] INFO: Stall ended before state dump start
[32427.894950] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=357592 jiffies, g=655835, c=655834, q=0)
[32427.897513] INFO: Stall ended before state dump start
[32622.835405] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=377097 jiffies, g=655835, c=655834, q=0)
[32622.837989] INFO: Stall ended before state dump start
[32817.775860] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=396602 jiffies, g=655835, c=655834, q=0)
[32817.778470] INFO: Stall ended before state dump start
[33012.716315] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=416107 jiffies, g=655835, c=655834, q=0)
[33012.718960] INFO: Stall ended before state dump start
[33207.656769] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=435612 jiffies, g=655835, c=655834, q=0)
[33207.659440] INFO: Stall ended before state dump start
[33402.597223] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=455117 jiffies, g=655835, c=655834, q=0)
[33402.599928] INFO: Stall ended before state dump start
[33597.537677] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=474622 jiffies, g=655835, c=655834, q=0)
[33597.540406] INFO: Stall ended before state dump start
[33792.478131] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=494127 jiffies, g=655835, c=655834, q=0)
[33792.480884] INFO: Stall ended before state dump start
[33987.418585] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=513632 jiffies, g=655835, c=655834, q=0)
[33987.421377] INFO: Stall ended before state dump start
[34182.359039] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=533137 jiffies, g=655835, c=655834, q=0)
[34182.361850] INFO: Stall ended before state dump start
[34377.299493] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=552642 jiffies, g=655835, c=655834, q=0)
[34377.302337] INFO: Stall ended before state dump start
[34572.239946] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=572147 jiffies, g=655835, c=655834, q=0)
[34572.242822] INFO: Stall ended before state dump start
[34767.180400] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=591652 jiffies, g=655835, c=655834, q=0)
[34767.183313] INFO: Stall ended before state dump start
[34962.120853] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=611157 jiffies, g=655835, c=655834, q=0)
[34962.123764] INFO: Stall ended before state dump start
[35157.061306] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=630662 jiffies, g=655835, c=655834, q=0)
[35157.064221] INFO: Stall ended before state dump start
[35352.001759] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=650167 jiffies, g=655835, c=655834, q=0)
[35352.004664] INFO: Stall ended before state dump start
[35546.942213] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=669672 jiffies, g=655835, c=655834, q=0)
[35546.945120] INFO: Stall ended before state dump start
[35741.882666] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=689177 jiffies, g=655835, c=655834, q=0)
[35741.885579] INFO: Stall ended before state dump start
[35936.823119] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=708682 jiffies, g=655835, c=655834, q=0)
[35936.826030] INFO: Stall ended before state dump start
[36131.763572] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=728187 jiffies, g=655835, c=655834, q=0)
[36131.766484] INFO: Stall ended before state dump start
[36326.704024] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=747692 jiffies, g=655835, c=655834, q=0)
[36326.706939] INFO: Stall ended before state dump start
[36521.644477] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=767197 jiffies, g=655835, c=655834, q=0)
[36521.647383] INFO: Stall ended before state dump start
[36716.584930] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=786702 jiffies, g=655835, c=655834, q=0)
[36716.587836] INFO: Stall ended before state dump start
[36911.525383] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=806207 jiffies, g=655835, c=655834, q=0)
[36911.528300] INFO: Stall ended before state dump startd
[37106.465835] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=825712 jiffies, g=655835, c=655834, q=0)
[37106.468753] INFO: Stall ended before state dump start
[37301.406288] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=845217 jiffies, g=655835, c=655834, q=0)
[37301.409196] INFO: Stall ended before state dump start
[37496.346740] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=864722 jiffies, g=655835, c=655834, q=0)
[37496.349658] INFO: Stall ended before state dump start
[37691.287193] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=884227 jiffies, g=655835, c=655834, q=0)
[37691.290111] INFO: Stall ended before state dump start
[37886.227645] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=903732 jiffies, g=655835, c=655834, q=0)
[37886.230560] INFO: Stall ended before state dump start
[38081.168097] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=923237 jiffies, g=655835, c=655834, q=0)
[38081.171016] INFO: Stall ended before state dump start
[38276.108550] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=942742 jiffies, g=655835, c=655834, q=0)
[38276.111471] INFO: Stall ended before state dump start
[38471.049002] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=962247 jiffies, g=655835, c=655834, q=0)
[38471.051911] INFO: Stall ended before state dump start
[38665.989454] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=981752 jiffies, g=655835, c=655834, q=0)
[38665.992372] INFO: Stall ended before state dump start
[38860.929906] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 1, t=1001257 jiffies, g=655835, c=655834, q=0)
[38860.932839] INFO: Stall ended before state dump start
[38946.631742] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 2, t=6502 jiffies, g=655989, c=655988, q=0)
[38946.634633] INFO: Stall ended before state dump start

