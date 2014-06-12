Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbaFLQCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:02:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19243 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbaFLQCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:02:33 -0400
Message-ID: <5399CF02.5050100@oracle.com>
Date: Thu, 12 Jun 2014 12:02:10 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, Ed Tomlinson <edt@aei.ca>
CC: jbacik@fb.com, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs: hang on boot due to tests
References: <5395CFE6.10804@oracle.com> <5395D9D6.3080101@fb.com> <5395DE2E.7080700@oracle.com> <3216820.JOp565CquS@grover> <5397078B.9040206@fb.com>
In-Reply-To: <5397078B.9040206@fb.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 09:26 AM, Chris Mason wrote:
> On 06/10/2014 07:14 AM, Ed Tomlinson wrote:
>> > On Monday 09 June 2014 12:17:50 Sasha Levin wrote:
>>> >> On 06/09/2014 11:59 AM, Chris Mason wrote:
>>>> >>> On 06/09/2014 11:16 AM, Sasha Levin wrote:
>>>>>> >>>>> Hi all,
>>>>>> >>>>>
>>>>>> >>>>> It seems that some recent changes to btrfs tests make it hang during boot:
>>>>>> >>>>>
>>>>>> >>>>> [   49.730033] NMI watchdog: BUG: soft lockup - CPU#34 stuck for 23s! [swapper/0:1]
>>>>>> >>>>> [   49.730033] Modules linked in:
>>>>>> >>>>> [   49.730033] hardirqs last enabled at (6389143): restore_args (arch/x86/kernel/entry_64.S:829)
>>>>>> >>>>> [   49.730033] hardirqs last disabled at (6389144): apic_timer_interrupt (arch/x86/kernel/entry_64.S:1021)
>>>>>> >>>>> [   49.730033] softirqs last enabled at (6389142): __do_softirq (./arch/x86/include/asm/preempt.h:22 kernel/softirq.c:296)
>>>>>> >>>>> [   49.730033] softirqs last disabled at (6389139): irq_exit (kernel/softirq.c:346 kernel/softirq.c:387)
>>>>>> >>>>> [   49.730033] CPU: 34 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc8-next-20140606-sasha-00021-ga9d3a0b-dirty #597
>>>> >>>
>>>> >>> This is 3.15-rc8 + linux-next?  I'll try to reproduce here, but the
>>>> >>> tests were working for me.
>>> >>
>>> >> Yes, it's the latest -next tree available.
>>> >>
>>> >> Also note that it doesn't happen every time, so might be some sort of a race?
>> > 
>> > I've noticed that with -rc8 and now .15 btrfs fails to automount (or mount) about 1 in 2 times requiring a reboot to get it to work.
>> > I have not seen anything in logs.  Might this be related?
> It shouldn't be, the lockup Sasha hit is only in the self testing code,
> and he's triggering it in the qgroups self tests.
> 
> Do you have CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y?

Yup.

> I'd love a sysrq-t or sysrq-w while you're stuck.

It's not a sysrq, but I've enabled softlockup_all_cpu_backtrace and got this:

[   60.233443] NMI watchdog: BUG: soft lockup - CPU#10 stuck for 23s! [swapper/0:1]
[   60.233443] Modules linked in:
[   60.233443] irq event stamp: 7251604
[   60.233443] hardirqs last enabled at (7251603): restore_args (arch/x86/kernel/entry_64.S:829)
[   60.233443] hardirqs last disabled at (7251604): apic_timer_interrupt (arch/x86/kernel/entry_64.S:1021)
[   60.233443] softirqs last enabled at (7251602): __do_softirq (./arch/x86/include/asm/preempt.h:22 kernel/softirq.c:296)
[   60.233443] softirqs last disabled at (7251597): irq_exit (kernel/softirq.c:346 kernel/softirq.c:387)
[   60.233443] CPU: 10 PID: 1 Comm: swapper/0 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.233443] task: ffff8803d68c8000 ti: ffff880036220000 task.ti: ffff880036220000
[   60.233443] RIP: queue_write_lock_slowpath (./arch/x86/include/asm/processor.h:691 ./arch/x86/include/asm/processor.h:696 kernel/locking/qrwlock.c:128)
[   60.233443] RSP: 0000:ffff8800362239f0  EFLAGS: 00000206
[   60.233443] RAX: 0000000000000101 RBX: ffffffff90560c3b RCX: 00000000000000ff
[   60.233443] RDX: ffff88017c1680b8 RSI: 0000000000000101 RDI: ffff88017c1680bc
[   60.233443] RBP: ffff880036223a08 R08: 000000000000eb46 R09: ffffffff8d95b478
[   60.233443] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880036223968
[   60.233443] R13: 0000000000000001 R14: ffff880036220000 R15: ffff8803d68c8000
[   60.233443] FS:  0000000000000000(0000) GS:ffff880292e00000(0000) knlGS:0000000000000000
[   60.233443] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.233443] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.233443] Stack:
[   60.233443]  ffffffff8d1d1cc7 ffff880036223a68 ffff88017c1680b8 ffff880036223a38
[   60.233443]  ffffffff9055edf0 ffffffff8d95b93c ffffffff8db2d845 ffff88017c168000
[   60.233443]  ffff88017c168100 ffff880036223aa8 ffffffff8d95b93c ffff880036223a58
[   60.233443] Call Trace:
[   60.233443] ? do_raw_write_lock (kernel/locking/spinlock_debug.c:236 kernel/locking/spinlock_debug.c:280)
[   60.233443] _raw_write_lock (include/linux/rwlock_api_smp.h:211 kernel/locking/spinlock.c:295)
[   60.233443] ? btrfs_tree_lock (./arch/x86/include/asm/atomic.h:27 fs/btrfs/locking.c:219)
[   60.233443] ? delay_tsc (./arch/x86/include/asm/preempt.h:98 arch/x86/lib/delay.c:86)
[   60.233443] btrfs_tree_lock (./arch/x86/include/asm/atomic.h:27 fs/btrfs/locking.c:219)
[   60.233443] ? __const_udelay (arch/x86/lib/delay.c:126)
[   60.233443] ? __rcu_read_unlock (kernel/rcu/update.c:97)
[   60.233443] btrfs_lock_root_node (fs/btrfs/ctree.c:193)
[   60.233443] btrfs_search_slot (fs/btrfs/ctree.c:2768)
[   60.233443] btrfs_insert_empty_items (fs/btrfs/ctree.c:4836)
[   60.233443] ? dlm_init (fs/btrfs/super.c:1914)
[   60.233443] insert_normal_tree_ref.constprop.4 (fs/btrfs/tests/qgroup-tests.c:60)
[   60.233443] ? dlm_init (fs/btrfs/super.c:1914)
[   60.233443] test_no_shared_qgroup (fs/btrfs/tests/qgroup-tests.c:249)
[   60.233443] btrfs_test_qgroups (fs/btrfs/tests/qgroup-tests.c:462)
[   60.233443] init_btrfs_fs (fs/btrfs/super.c:1909 fs/btrfs/super.c:1969)
[   60.233443] ? dlm_init (fs/btrfs/super.c:1914)
[   60.233443] do_one_initcall (init/main.c:791)
[   60.233443] ? parse_args (kernel/params.c:101 kernel/params.c:205)
[   60.233443] ? rmi_driver_init (drivers/hid/hid-saitek.c:197)
[   60.233443] kernel_init_freeable (init/main.c:856 init/main.c:865 init/main.c:884 init/main.c:1005)
[   60.233443] ? loglevel (init/main.c:241)
[   60.233443] ? rest_init (init/main.c:932)
[   60.233443] kernel_init (init/main.c:937)
[   60.233443] ret_from_fork (arch/x86/kernel/entry_64.S:349)
[   60.233443] ? rest_init (init/main.c:932)
[ 60.233443] Code: 89 ce 89 c8 83 ce 01 f0 0f b1 32 39 c1 74 0b f3 90 eb e7 0f 1f 80 00 00 00 00 b9 ff 00 00 00 0f 1f 00 8b 02 83 f8 01 74 09 f3 90 <eb> f5 0f 1f 44 00 00 f0 0f b1 0a 83 f8 01 75 ee e9 1a 00 00 00
All code
========
   0:	89 ce                	mov    %ecx,%esi
   2:	89 c8                	mov    %ecx,%eax
   4:	83 ce 01             	or     $0x1,%esi
   7:	f0 0f b1 32          	lock cmpxchg %esi,(%rdx)
   b:	39 c1                	cmp    %eax,%ecx
   d:	74 0b                	je     0x1a
   f:	f3 90                	pause
  11:	eb e7                	jmp    0xfffffffffffffffa
  13:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  1a:	b9 ff 00 00 00       	mov    $0xff,%ecx
  1f:	0f 1f 00             	nopl   (%rax)
  22:	8b 02                	mov    (%rdx),%eax
  24:	83 f8 01             	cmp    $0x1,%eax
  27:	74 09                	je     0x32
  29:	f3 90                	pause
  2b:*	eb f5                	jmp    0x22		<-- trapping instruction
  2d:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  32:	f0 0f b1 0a          	lock cmpxchg %ecx,(%rdx)
  36:	83 f8 01             	cmp    $0x1,%eax
  39:	75 ee                	jne    0x29
  3b:	e9 1a 00 00 00       	jmpq   0x5a
	...

Code starting with the faulting instruction
===========================================
   0:	eb f5                	jmp    0xfffffffffffffff7
   2:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   7:	f0 0f b1 0a          	lock cmpxchg %ecx,(%rdx)
   b:	83 f8 01             	cmp    $0x1,%eax
   e:	75 ee                	jne    0xfffffffffffffffe
  10:	e9 1a 00 00 00       	jmpq   0x2f
	...
[   60.233443] sending NMI to other CPUs:
[   60.272505] NMI backtrace for cpu 0
[   60.272505] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.272505] task: ffffffff920354c0 ti: ffffffff92000000 task.ti: ffffffff92000000
[   60.272505] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.272505] RSP: 0000:ffffffff92003e38  EFLAGS: 00000282
[   60.272505] RAX: ffffffff920354c0 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.272505] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.272505] RBP: ffffffff92003e38 R08: 0000000000000000 R09: 0000000000000000
[   60.272505] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.272505] R13: 00000000ffffffed R14: ffffffff92000000 R15: 00000000000146e0
[   60.272505] FS:  0000000000000000(0000) GS:ffff880036e00000(0000) knlGS:0000000000000000
[   60.272505] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.272505] CR2: 0000000000000000 CR3: 000000001202e000 CR4: 00000000000006b0
[   60.272505] Stack:
[   60.272505]  ffffffff92003e58 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.272505]  ffffffff92003e68 ffffffff8d07e59f ffffffff92003ee8 ffffffff8d1bc7d9
[   60.272505]  0000000000000000 8dae92129a185908 ffffffff92003fd8 0000000000000002
[   60.272505] Call Trace:
[   60.272505] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.272505] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.272505] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.272505] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.272505] cpu_startup_entry (??:?)
[   60.272505] rest_init (init/main.c:419)
[   60.272505] ? rest_init (init/main.c:394)
[   60.272505] start_kernel (init/main.c:681)
[   60.272505] ? set_init_arg (init/main.c:281)
[   60.272505] ? early_idt_handlers (arch/x86/kernel/head_64.S:340)
[   60.272505] x86_64_start_reservations (arch/x86/kernel/head64.c:194)
[   60.272505] x86_64_start_kernel (arch/x86/kernel/head64.c:183)
[ 60.272505] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.268631] NMI backtrace for cpu 3
[   60.307779] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 34.316 msecs
[   60.268631] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.268631] task: ffff8800a6590000 ti: ffff880035e1c000 task.ti: ffff880035e1c000
[   60.268631] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.268631] RSP: 0000:ffff880035e1fe28  EFLAGS: 00000282
[   60.268631] RAX: ffff8800a6590000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.268631] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.268631] RBP: ffff880035e1fe28 R08: 0000000000000000 R09: 0000000000000000
[   60.268631] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.268631] R13: 00000000ffffffed R14: ffff880035e1c000 R15: 0000000000000000
[   60.268631] FS:  0000000000000000(0000) GS:ffff88010ce00000(0000) knlGS:0000000000000000
[   60.268631] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.268631] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.268631] Stack:
[   60.268631]  ffff880035e1fe48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.268631]  ffff880035e1fe58 ffffffff8d07e59f ffff880035e1fed8 ffffffff8d1bc7d9
[   60.268631]  0000000000000000 ca4cdd68daa1d2ae ffff880035e1ffd8 000000000000f000
[   60.268631] Call Trace:
[   60.268631] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.268631] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.268631] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.268631] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.268631] cpu_startup_entry (??:?)
[   60.268631] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.268631] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.268642] NMI backtrace for cpu 17
[   60.359741] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 86.152 msecs
[   60.268642] CPU: 17 PID: 0 Comm: swapper/17 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.268642] task: ffff8801b45a8000 ti: ffff880035e68000 task.ti: ffff880035e68000
[   60.268642] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.268642] RSP: 0000:ffff880035e6be28  EFLAGS: 00000282
[   60.268642] RAX: ffff8801b45a8000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.268642] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.268642] RBP: ffff880035e6be28 R08: 0000000000000000 R09: 0000000000000000
[   60.268642] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.268642] R13: 00000000ffffffed R14: ffff880035e68000 R15: 0000000000000000
[   60.268642] FS:  0000000000000000(0000) GS:ffff88040ce00000(0000) knlGS:0000000000000000
[   60.268642] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.268642] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.268642] Stack:
[   60.268642]  ffff880035e6be48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.268642]  ffff880035e6be58 ffffffff8d07e59f ffff880035e6bed8 ffffffff8d1bc7d9
[   60.268642]  0000000000000000 ea943b0e542482c0 ffff880035e6bfd8 000000000000f000
[   60.268642] Call Trace:
[   60.268642] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.268642] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.268642] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.268642] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.268642] cpu_startup_entry (??:?)
[   60.268642] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.268642] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.268642] NMI backtrace for cpu 14
[   60.403409] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 129.784 msecs
[   60.268642] CPU: 14 PID: 0 Comm: swapper/14 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.268642] task: ffff88036a5b0000 ti: ffff880035e58000 task.ti: ffff880035e58000
[   60.268642] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.268642] RSP: 0000:ffff880035e5be28  EFLAGS: 00000282
[   60.268642] RAX: ffff88036a5b0000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.268642] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.268642] RBP: ffff880035e5be28 R08: 0000000000000000 R09: 0000000000000000
[   60.268642] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.268642] R13: 00000000ffffffed R14: ffff880035e58000 R15: 0000000000000000
[   60.268642] FS:  0000000000000000(0000) GS:ffff88036ae00000(0000) knlGS:0000000000000000
[   60.268642] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.268642] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.268642] Stack:
[   60.268642]  ffff880035e5be48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.268642]  ffff880035e5be58 ffffffff8d07e59f ffff880035e5bed8 ffffffff8d1bc7d9
[   60.268642]  0000000000000000 99bf70d8d7246944 ffff880035e5bfd8 000000000000f000
[   60.268642] Call Trace:
[   60.268642] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.268642] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.268642] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.268642] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.268642] cpu_startup_entry (??:?)
[   60.268642] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.268642] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.268642] NMI backtrace for cpu 7
[   60.436531] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 162.898 msecs
[   60.268642] CPU: 7 PID: 0 Comm: swapper/7 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.268642] task: ffff8802925a8000 ti: ffff880035e30000 task.ti: ffff880035e30000
[   60.268642] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.268642] RSP: 0000:ffff880035e33e28  EFLAGS: 00000282
[   60.268642] RAX: ffff8802925a8000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.268642] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.268642] RBP: ffff880035e33e28 R08: 0000000000000000 R09: 0000000000000000
[   60.268642] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.268642] R13: 00000000ffffffed R14: ffff880035e30000 R15: 0000000000000000
[   60.268642] FS:  0000000000000000(0000) GS:ffff8801ece00000(0000) knlGS:0000000000000000
[   60.268642] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.268642] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.268642] Stack:
[   60.268642]  ffff880035e33e48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.268642]  ffff880035e33e58 ffffffff8d07e59f ffff880035e33ed8 ffffffff8d1bc7d9
[   60.268642]  0000000000000000 39ab99d7099f72a0 ffff880035e33fd8 000000000000f000
[   60.268642] Call Trace:
[   60.268642] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.268642] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.268642] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.268642] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.268642] cpu_startup_entry (??:?)
[   60.268642] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.268642] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.268642] NMI backtrace for cpu 23
[   60.472952] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 199.295 msecs
[   60.268642] CPU: 23 PID: 0 Comm: swapper/23 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.268642] task: ffff88025c5c0000 ti: ffff880035e80000 task.ti: ffff880035e80000
[   60.268642] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.268642] RSP: 0000:ffff880035e83e28  EFLAGS: 00000282
[   60.268642] RAX: ffff88025c5c0000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.268642] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.268642] RBP: ffff880035e83e28 R08: 0000000000000000 R09: 0000000000000000
[   60.268642] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.268642] R13: 00000000ffffffed R14: ffff880035e80000 R15: 0000000000000000
[   60.268642] FS:  0000000000000000(0000) GS:ffff880550e00000(0000) knlGS:0000000000000000
[   60.268642] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.268642] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.268642] Stack:
[   60.268642]  ffff880035e83e48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.268642]  ffff880035e83e58 ffffffff8d07e59f ffff880035e83ed8 ffffffff8d1bc7d9
[   60.268642]  0000000000000000 273c2f151685900e ffff880035e83fd8 000000000000f000
[   60.268642] Call Trace:
[   60.268642] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.268642] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.268642] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.268642] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.268642] cpu_startup_entry (??:?)
[   60.268642] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.268642] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.269373] NMI backtrace for cpu 1
[   60.502478] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 228.823 msecs
[   60.269373] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.269373] task: ffff880550588000 ti: ffff880035e10000 task.ti: ffff880035e10000
[   60.269373] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.269373] RSP: 0000:ffff880035e13e28  EFLAGS: 00000282
[   60.269373] RAX: ffff880550588000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.269373] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.269373] RBP: ffff880035e13e28 R08: 0000000000000000 R09: 0000000000000000
[   60.269373] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.269373] R13: 00000000ffffffed R14: ffff880035e10000 R15: 0000000000000000
[   60.269373] FS:  0000000000000000(0000) GS:ffff88006ee00000(0000) knlGS:0000000000000000
[   60.269373] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.269373] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.269373] Stack:
[   60.269373]  ffff880035e13e48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.269373]  ffff880035e13e58 ffffffff8d07e59f ffff880035e13ed8 ffffffff8d1bc7d9
[   60.269373]  0000000000000000 b57caad4e27916fc ffff880035e13fd8 000000000000f000
[   60.269373] Call Trace:
[   60.269373] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.269373] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.269373] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.269373] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.269373] cpu_startup_entry (??:?)
[   60.269373] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.269373] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.268642] NMI backtrace for cpu 18
[   60.535232] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 261.527 msecs
[   60.535725] CPU: 18 PID: 0 Comm: swapper/18 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.535725] task: ffff8802fe920000 ti: ffff880035e6c000 task.ti: ffff880035e6c000
[   60.535725] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.535725] RSP: 0000:ffff880035e6fe28  EFLAGS: 00000282
[   60.535725] RAX: ffff8802fe920000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.535725] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.535725] RBP: ffff880035e6fe28 R08: 0000000000000000 R09: 0000000000000000
[   60.535725] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.535725] R13: 00000000ffffffed R14: ffff880035e6c000 R15: 0000000000000000
[   60.535725] FS:  0000000000000000(0000) GS:ffff880442e00000(0000) knlGS:0000000000000000
[   60.535725] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.535725] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.535725] Stack:
[   60.535725]  ffff880035e6fe48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.535725]  ffff880035e6fe58 ffffffff8d07e59f ffff880035e6fed8 ffffffff8d1bc7d9
[   60.535725]  0000000000000000 3f9d843d2cfb1974 ffff880035e6ffd8 000000000000f000
[   60.535725] Call Trace:
[   60.535725] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.535725] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.535725] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.535725] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.535725] cpu_startup_entry (??:?)
[   60.535725] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.535725] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.535673] NMI backtrace for cpu 11
[   60.566960] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 293.259 msecs
[   60.567405] CPU: 11 PID: 0 Comm: swapper/11 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.567405] task: ffff880442588000 ti: ffff880035e44000 task.ti: ffff880035e44000
[   60.567405] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.567405] RSP: 0000:ffff880035e47e28  EFLAGS: 00000282
[   60.567405] RAX: ffff880442588000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.567405] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.567405] RBP: ffff880035e47e28 R08: 0000000000000000 R09: 0000000000000000
[   60.567405] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.567405] R13: 00000000ffffffed R14: ffff880035e44000 R15: 0000000000000000
[   60.567405] FS:  0000000000000000(0000) GS:ffff8802c8e00000(0000) knlGS:0000000000000000
[   60.567405] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.567405] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.567405] Stack:
[   60.567405]  ffff880035e47e48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.567405]  ffff880035e47e58 ffffffff8d07e59f ffff880035e47ed8 ffffffff8d1bc7d9
[   60.567405]  0000000000000000 474f47db85fac2c5 ffff880035e47fd8 000000000000f000
[   60.567405] Call Trace:
[   60.567405] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.567405] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.567405] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.567405] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.567405] cpu_startup_entry (??:?)
[   60.567405] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.567405] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.567405] NMI backtrace for cpu 21
[   60.594485] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 320.725 msecs
[   60.594943] CPU: 21 PID: 0 Comm: swapper/21 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.594943] task: ffff880694990000 ti: ffff880035e78000 task.ti: ffff880035e78000
[   60.594943] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.594943] RSP: 0000:ffff880035e7be28  EFLAGS: 00000282
[   60.594943] RAX: ffff880694990000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.594943] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.594943] RBP: ffff880035e7be28 R08: 0000000000000000 R09: 0000000000000000
[   60.594943] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.594943] R13: 00000000ffffffed R14: ffff880035e78000 R15: 0000000000000000
[   60.594943] FS:  0000000000000000(0000) GS:ffff8804e4e00000(0000) knlGS:0000000000000000
[   60.594943] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.594943] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.594943] Stack:
[   60.594943]  ffff880035e7be48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.594943]  ffff880035e7be58 ffffffff8d07e59f ffff880035e7bed8 ffffffff8d1bc7d9
[   60.594943]  0000000000000000 3fe10556820a9b9b ffff880035e7bfd8 000000000000f000
[   60.594943] Call Trace:
[   60.594943] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.594943] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.594943] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.594943] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.594943] cpu_startup_entry (??:?)
[   60.594943] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.594943] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.594943] NMI backtrace for cpu 4
[   60.626228] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 352.459 msecs
[   60.626914] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.626914] task: ffff8801b4588000 ti: ffff880035e20000 task.ti: ffff880035e20000
[   60.626914] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.626914] RSP: 0000:ffff880035e23e28  EFLAGS: 00000282
[   60.626914] RAX: ffff8801b4588000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.626914] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.626914] RBP: ffff880035e23e28 R08: 0000000000000000 R09: 0000000000000000
[   60.626914] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.626914] R13: 00000000ffffffed R14: ffff880035e20000 R15: 0000000000000000
[   60.626914] FS:  0000000000000000(0000) GS:ffff880144e00000(0000) knlGS:0000000000000000
[   60.626914] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.626914] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.626914] Stack:
[   60.626914]  ffff880035e23e48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.626914]  ffff880035e23e58 ffffffff8d07e59f ffff880035e23ed8 ffffffff8d1bc7d9
[   60.626914]  0000000000000000 7e2449b239d10efa ffff880035e23fd8 000000000000f000
[   60.626914] Call Trace:
[   60.626914] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.626914] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.626914] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.626914] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.626914] cpu_startup_entry (??:?)
[   60.626914] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.626914] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.626914] NMI backtrace for cpu 15
[   60.656449] CPU: 15 PID: 0 Comm: swapper/15 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.656449] task: ffff88051a5b0000 ti: ffff880035e5c000 task.ti: ffff880035e5c000
[   60.656449] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.656449] RSP: 0000:ffff880035e5fe28  EFLAGS: 00000282
[   60.656449] RAX: ffff88051a5b0000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.656449] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.656449] RBP: ffff880035e5fe28 R08: 0000000000000000 R09: 0000000000000000
[   60.656449] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.656449] R13: 00000000ffffffed R14: ffff880035e5c000 R15: 0000000000000000
[   60.656449] FS:  0000000000000000(0000) GS:ffff8803a0e00000(0000) knlGS:0000000000000000
[   60.656449] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.656449] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.656449] Stack:
[   60.656449]  ffff880035e5fe48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.656449]  ffff880035e5fe58 ffffffff8d07e59f ffff880035e5fed8 ffffffff8d1bc7d9
[   60.656449]  0000000000000000 b64a2bfca327b7ec ffff880035e5ffd8 000000000000f000
[   60.656449] Call Trace:
[   60.656449] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.656449] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.656449] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.656449] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.656449] cpu_startup_entry (??:?)
[   60.656449] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.656449] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.656449] NMI backtrace for cpu 22
[   60.656449] CPU: 22 PID: 0 Comm: swapper/22 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.688896] task: ffff88010c580000 ti: ffff880035e7c000 task.ti: ffff880035e7c000
[   60.688896] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.688896] RSP: 0000:ffff880035e7fe28  EFLAGS: 00000282
[   60.688896] RAX: ffff88010c580000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.688896] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.688896] RBP: ffff880035e7fe28 R08: 0000000000000000 R09: 0000000000000000
[   60.688896] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.688896] R13: 00000000ffffffed R14: ffff880035e7c000 R15: 0000000000000000
[   60.688896] FS:  0000000000000000(0000) GS:ffff88051ae00000(0000) knlGS:0000000000000000
[   60.688896] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.688896] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.688896] Stack:
[   60.688896]  ffff880035e7fe48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.688896]  ffff880035e7fe58 ffffffff8d07e59f ffff880035e7fed8 ffffffff8d1bc7d9
[   60.688896]  0000000000000000 31cf8a3f823c253f ffff880035e7ffd8 000000000000f000
[   60.688896] Call Trace:
[   60.688896] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.688896] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.688896] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.688896] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.688896] cpu_startup_entry (??:?)
[   60.688896] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.688896] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.688896] NMI backtrace for cpu 5
[   60.688896] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.720000] task: ffff88036a598000 ti: ffff880035e24000 task.ti: ffff880035e24000
[   60.720000] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.720000] RSP: 0000:ffff880035e27e28  EFLAGS: 00000282
[   60.720000] RAX: ffff88036a598000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.720000] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.720000] RBP: ffff880035e27e28 R08: 0000000000000000 R09: 0000000000000000
[   60.720000] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.720000] R13: 00000000ffffffed R14: ffff880035e24000 R15: 0000000000000000
[   60.720000] FS:  0000000000000000(0000) GS:ffff88017ce00000(0000) knlGS:0000000000000000
[   60.720000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.720000] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.720000] Stack:
[   60.720000]  ffff880035e27e48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.720000]  ffff880035e27e58 ffffffff8d07e59f ffff880035e27ed8 ffffffff8d1bc7d9
[   60.720000]  0000000000000000 cf5f6d6484a02f84 ffff880035e27fd8 000000000000f000
[   60.720000] Call Trace:
[   60.720000] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.720000] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.720000] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.720000] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.720000] cpu_startup_entry (??:?)
[   60.720000] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.720000] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.720000] NMI backtrace for cpu 20
[   60.747526] CPU: 20 PID: 0 Comm: swapper/20 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.747526] task: ffff880550590000 ti: ffff880035e74000 task.ti: ffff880035e74000
[   60.747526] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.747526] RSP: 0000:ffff880035e77e28  EFLAGS: 00000282
[   60.747526] RAX: ffff880550590000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.747526] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.747526] RBP: ffff880035e77e28 R08: 0000000000000000 R09: 0000000000000000
[   60.747526] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.747526] R13: 00000000ffffffed R14: ffff880035e74000 R15: 0000000000000000
[   60.747526] FS:  0000000000000000(0000) GS:ffff8804af000000(0000) knlGS:0000000000000000
[   60.747526] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.747526] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.747526] Stack:
[   60.747526]  ffff880035e77e48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.747526]  ffff880035e77e58 ffffffff8d07e59f ffff880035e77ed8 ffffffff8d1bc7d9
[   60.747526]  0000000000000000 bf85bc695f3528e6 ffff880035e77fd8 000000000000f000
[   60.747526] Call Trace:
[   60.747526] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.747526] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.747526] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.747526] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.747526] cpu_startup_entry (??:?)
[   60.747526] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.747526] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.747526] NMI backtrace for cpu 13
[   60.747526] CPU: 13 PID: 0 Comm: swapper/13 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.783369] task: ffff8801b45a0000 ti: ffff880035e4c000 task.ti: ffff880035e4c000
[   60.783369] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.783369] RSP: 0000:ffff880035e4fe28  EFLAGS: 00000282
[   60.783369] RAX: ffff8801b45a0000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.783369] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.783369] RBP: ffff880035e4fe28 R08: 0000000000000000 R09: 0000000000000000
[   60.783369] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.783369] R13: 00000000ffffffed R14: ffff880035e4c000 R15: 0000000000000000
[   60.783369] FS:  0000000000000000(0000) GS:ffff880334e00000(0000) knlGS:0000000000000000
[   60.783369] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.783369] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.783369] Stack:
[   60.783369]  ffff880035e4fe48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.783369]  ffff880035e4fe58 ffffffff8d07e59f ffff880035e4fed8 ffffffff8d1bc7d9
[   60.783369]  0000000000000000 e2f60941915f5a68 ffff880035e4ffd8 000000000000f000
[   60.783369] Call Trace:
[   60.783369] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.783369] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.783369] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.783369] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.783369] cpu_startup_entry (??:?)
[   60.783369] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.783369] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.783369] NMI backtrace for cpu 9
[   60.783369] CPU: 9 PID: 0 Comm: swapper/9 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.783369] task: ffff8800a65a0000 ti: ffff880035e3c000 task.ti: ffff880035e3c000
[   60.783369] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.783369] RSP: 0000:ffff880035e3fe28  EFLAGS: 00000282
[   60.783369] RAX: ffff8800a65a0000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.783369] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.783369] RBP: ffff880035e3fe28 R08: 0000000000000000 R09: 0000000000000000
[   60.783369] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.783369] R13: 00000000ffffffed R14: ffff880035e3c000 R15: 0000000000000000
[   60.783369] FS:  0000000000000000(0000) GS:ffff88025ce00000(0000) knlGS:0000000000000000
[   60.783369] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.783369] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.783369] Stack:
[   60.783369]  ffff880035e3fe48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.783369]  ffff880035e3fe58 ffffffff8d07e59f ffff880035e3fed8 ffffffff8d1bc7d9
[   60.783369]  0000000000000000 127cf1a0cc1cba84 ffff880035e3ffd8 000000000000f000
[   60.783369] Call Trace:
[   60.783369] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.783369] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.783369] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.783369] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.783369] cpu_startup_entry (??:?)
[   60.783369] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.783369] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.783369] NMI backtrace for cpu 8
[   60.783369] CPU: 8 PID: 0 Comm: swapper/8 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.857533] task: ffff88051a5a0000 ti: ffff880035e34000 task.ti: ffff880035e34000
[   60.857533] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.857533] RSP: 0000:ffff880035e37e28  EFLAGS: 00000282
[   60.857533] RAX: ffff88051a5a0000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.857533] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.857533] RBP: ffff880035e37e28 R08: 0000000000000000 R09: 0000000000000000
[   60.857533] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.857533] R13: 00000000ffffffed R14: ffff880035e34000 R15: 0000000000000000
[   60.857533] FS:  0000000000000000(0000) GS:ffff880224e00000(0000) knlGS:0000000000000000
[   60.857533] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.857533] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.857533] Stack:
[   60.857533]  ffff880035e37e48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.857533]  ffff880035e37e58 ffffffff8d07e59f ffff880035e37ed8 ffffffff8d1bc7d9
[   60.857533]  0000000000000000 eb8449bb992ae2a3 ffff880035e37fd8 000000000000f000
[   60.857533] Call Trace:
[   60.857533] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.857533] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.857533] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.857533] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.857533] cpu_startup_entry (??:?)
[   60.857533] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.857533] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.857533] NMI backtrace for cpu 19
[   60.857533] CPU: 19 PID: 0 Comm: swapper/19 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.895459] task: ffff880442598000 ti: ffff880035e70000 task.ti: ffff880035e70000
[   60.895459] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.895459] RSP: 0000:ffff880035e73e28  EFLAGS: 00000282
[   60.895459] RAX: ffff880442598000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.895459] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.895459] RBP: ffff880035e73e28 R08: 0000000000000000 R09: 0000000000000000
[   60.895459] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.895459] R13: 00000000ffffffed R14: ffff880035e70000 R15: 0000000000000000
[   60.895459] FS:  0000000000000000(0000) GS:ffff880478e00000(0000) knlGS:0000000000000000
[   60.895459] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.895459] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.895459] Stack:
[   60.895459]  ffff880035e73e48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.895459]  ffff880035e73e58 ffffffff8d07e59f ffff880035e73ed8 ffffffff8d1bc7d9
[   60.895459]  0000000000000000 5e9a969615b783f5 ffff880035e73fd8 000000000000f000
[   60.895459] Call Trace:
[   60.895459] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.895459] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.895459] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.895459] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.895459] cpu_startup_entry (??:?)
[   60.895459] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.895459] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.895459] NMI backtrace for cpu 16
[   60.895459] CPU: 16 PID: 0 Comm: swapper/16 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.928936] task: ffff8806ca9a8000 ti: ffff880035e60000 task.ti: ffff880035e60000
[   60.928936] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.928936] RSP: 0000:ffff880035e63e28  EFLAGS: 00000282
[   60.928936] RAX: ffff8806ca9a8000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.928936] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.928936] RBP: ffff880035e63e28 R08: 0000000000000000 R09: 0000000000000000
[   60.928936] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.928936] R13: 00000000ffffffed R14: ffff880035e60000 R15: 0000000000000000
[   60.928936] FS:  0000000000000000(0000) GS:ffff8803d7000000(0000) knlGS:0000000000000000
[   60.928936] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.928936] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.928936] Stack:
[   60.928936]  ffff880035e63e48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.928936]  ffff880035e63e58 ffffffff8d07e59f ffff880035e63ed8 ffffffff8d1bc7d9
[   60.928936]  0000000000000000 eb01a73bc8ea8b3b ffff880035e63fd8 000000000000f000
[   60.928936] Call Trace:
[   60.928936] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.928936] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.928936] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.928936] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.928936] cpu_startup_entry (??:?)
[   60.928936] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.928936] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.928901] NMI backtrace for cpu 2
[   60.928901] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.957846] task: ffff880694988000 ti: ffff880035e14000 task.ti: ffff880035e14000
[   60.957846] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.957846] RSP: 0000:ffff880035e17e28  EFLAGS: 00000282
[   60.957846] RAX: ffff880694988000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.957846] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.957846] RBP: ffff880035e17e28 R08: 0000000000000000 R09: 0000000000000000
[   60.957846] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.957846] R13: 00000000ffffffed R14: ffff880035e14000 R15: 0000000000000000
[   60.957846] FS:  0000000000000000(0000) GS:ffff8800a6e00000(0000) knlGS:0000000000000000
[   60.957846] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.957846] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.957846] Stack:
[   60.957846]  ffff880035e17e48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.957846]  ffff880035e17e58 ffffffff8d07e59f ffff880035e17ed8 ffffffff8d1bc7d9
[   60.957846]  0000000000000000 e58d5ef30e9dc64f ffff880035e17fd8 000000000000f000
[   60.957846] Call Trace:
[   60.957846] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.957846] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.957846] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.957846] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.957846] cpu_startup_entry (??:?)
[   60.957846] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.957846] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.957846] NMI backtrace for cpu 12
[   60.957846] CPU: 12 PID: 0 Comm: swapper/12 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.998842] task: ffff88065e920000 ti: ffff880035e48000 task.ti: ffff880035e48000
[   60.998842] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   60.998842] RSP: 0000:ffff880035e4be28  EFLAGS: 00000282
[   60.998842] RAX: ffff88065e920000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   60.998842] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   60.998842] RBP: ffff880035e4be28 R08: 0000000000000000 R09: 0000000000000000
[   60.998842] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   60.998842] R13: 00000000ffffffed R14: ffff880035e48000 R15: 0000000000000000
[   60.998842] FS:  0000000000000000(0000) GS:ffff8802ff000000(0000) knlGS:0000000000000000
[   60.998842] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.998842] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   60.998842] Stack:
[   60.998842]  ffff880035e4be48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   60.998842]  ffff880035e4be58 ffffffff8d07e59f ffff880035e4bed8 ffffffff8d1bc7d9
[   60.998842]  0000000000000000 9df861323f902cb6 ffff880035e4bfd8 000000000000f000
[   60.998842] Call Trace:
[   60.998842] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   60.998842] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   60.998842] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   60.998842] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   60.998842] cpu_startup_entry (??:?)
[   60.998842] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 60.998842] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.998842] NMI backtrace for cpu 6
[   60.998842] CPU: 6 PID: 0 Comm: swapper/6 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   61.027305] task: ffff88065e910000 ti: ffff880035e28000 task.ti: ffff880035e28000
[   61.027305] RIP: native_safe_halt (./arch/x86/include/asm/irqflags.h:50)
[   61.027305] RSP: 0000:ffff880035e2be28  EFLAGS: 00000282
[   61.027305] RAX: ffff88065e910000 RBX: ffffffff932c9540 RCX: 0000000000000000
[   61.027305] RDX: 0000000000000000 RSI: ffffffff91853194 RDI: ffffffff917eb45d
[   61.027305] RBP: ffff880035e2be28 R08: 0000000000000000 R09: 0000000000000000
[   61.027305] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[   61.027305] R13: 00000000ffffffed R14: ffff880035e28000 R15: 0000000000000000
[   61.027305] FS:  0000000000000000(0000) GS:ffff8801b4e00000(0000) knlGS:0000000000000000
[   61.027305] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   61.027305] CR2: 00000000ffffffff CR3: 000000001202e000 CR4: 00000000000006a0
[   61.027305] Stack:
[   61.027305]  ffff880035e2be48 ffffffff8d07d88d ffffffff932c9540 0000000000000000
[   61.027305]  ffff880035e2be58 ffffffff8d07e59f ffff880035e2bed8 ffffffff8d1bc7d9
[   61.027305]  0000000000000000 e4346704a8838ce9 ffff880035e2bfd8 000000000000f000
[   61.027305] Call Trace:
[   61.027305] default_idle (./arch/x86/include/asm/paravirt.h:111 arch/x86/kernel/process.c:310)
[   61.027305] arch_cpu_idle (arch/x86/kernel/process.c:302)
[   61.027305] cpu_idle_loop (kernel/sched/idle.c:120 kernel/sched/idle.c:224)
[   61.027305] ? cpu_startup_entry (./arch/x86/include/asm/msr.h:117 ./arch/x86/include/asm/stackprotector.h:73 kernel/sched/idle.c:269)
[   61.027305] cpu_startup_entry (??:?)
[   61.027305] start_secondary (arch/x86/kernel/smpboot.c:274)
[ 61.027305] Code: 00 00 00 00 00 55 48 89 e5 fa 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 fb f4 <5d> c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 f4 5d c3 66 0f 1f 84
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 55 48             	add    %dl,0x48(%rbp)
   7:	89 e5                	mov    %esp,%ebp
   9:	fa                   	cli
   a:	5d                   	pop    %rbp
   b:	c3                   	retq
   c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  13:	00 00
  15:	55                   	push   %rbp
  16:	48 89 e5             	mov    %rsp,%rbp
  19:	fb                   	sti
  1a:	5d                   	pop    %rbp
  1b:	c3                   	retq
  1c:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  23:	00 00
  25:	55                   	push   %rbp
  26:	48 89 e5             	mov    %rsp,%rbp
  29:	fb                   	sti
  2a:	f4                   	hlt
  2b:*	5d                   	pop    %rbp		<-- trapping instruction
  2c:	c3                   	retq
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00
  35:	55                   	push   %rbp
  36:	48 89 e5             	mov    %rsp,%rbp
  39:	f4                   	hlt
  3a:	5d                   	pop    %rbp
  3b:	c3                   	retq
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84 00                	test   %al,(%rax)

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	c3                   	retq
   2:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   9:	00
   a:	55                   	push   %rbp
   b:	48 89 e5             	mov    %rsp,%rbp
   e:	f4                   	hlt
   f:	5d                   	pop    %rbp
  10:	c3                   	retq
  11:	66                   	data16
  12:	0f                   	.byte 0xf
  13:	1f                   	(bad)
  14:	84 00                	test   %al,(%rax)
[   60.233443] Kernel panic - not syncing: softlockup: hung tasks
[   60.233443] CPU: 10 PID: 1 Comm: swapper/0 Not tainted 3.15.0-next-20140612-sasha-00022-g5e4db85-dirty #645
[   60.233443]  ffff8803d68c8000 ffff880292e03dd8 ffffffff90512768 0000000000000001
[   60.233443]  ffffffff916fa8f7 ffff880292e03e58 ffffffff9050433f ffff880292e03e18
[   60.233443]  ffffffff00000008 ffff880292e03e68 ffff880292e03e08 000000000000001a
[   60.233443] Call Trace:
[   60.233443] <IRQ> dump_stack (lib/dump_stack.c:52)
[   60.233443] panic (kernel/panic.c:119)
[   60.233443] watchdog_timer_fn (kernel/watchdog.c:372)
[   60.233443] __run_hrtimer (kernel/hrtimer.c:1268 (discriminator 2))
[   60.233443] ? watchdog (kernel/hung_task.c:191 kernel/hung_task.c:232)
[   60.233443] hrtimer_interrupt (kernel/hrtimer.c:1915)
[   60.233443] local_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:921)
[   60.233443] ? btrfs_tree_read_lock (./arch/x86/include/asm/atomic.h:27 fs/btrfs/locking.c:103)
[   60.233443] smp_apic_timer_interrupt (./arch/x86/include/asm/apic.h:696 arch/x86/kernel/apic/apic.c:945)
[   60.233443] apic_timer_interrupt (arch/x86/kernel/entry_64.S:1021)
[   60.233443] <EOI> ? retint_restore_args (arch/x86/kernel/entry_64.S:829)
[   60.233443] ? btrfs_tree_read_lock (./arch/x86/include/asm/atomic.h:27 fs/btrfs/locking.c:103)
[   60.233443] ? queue_write_lock_slowpath (./arch/x86/include/asm/processor.h:691 ./arch/x86/include/asm/processor.h:696 kernel/locking/qrwlock.c:128)
[   60.233443] ? do_raw_write_lock (kernel/locking/spinlock_debug.c:236 kernel/locking/spinlock_debug.c:280)
[   60.233443] _raw_write_lock (include/linux/rwlock_api_smp.h:211 kernel/locking/spinlock.c:295)
[   60.233443] ? btrfs_tree_lock (./arch/x86/include/asm/atomic.h:27 fs/btrfs/locking.c:219)
[   60.233443] ? delay_tsc (./arch/x86/include/asm/preempt.h:98 arch/x86/lib/delay.c:86)
[   60.233443] btrfs_tree_lock (./arch/x86/include/asm/atomic.h:27 fs/btrfs/locking.c:219)
[   60.233443] ? __const_udelay (arch/x86/lib/delay.c:126)
[   60.233443] ? __rcu_read_unlock (kernel/rcu/update.c:97)
[   60.233443] btrfs_lock_root_node (fs/btrfs/ctree.c:193)
[   60.233443] btrfs_search_slot (fs/btrfs/ctree.c:2768)
[   60.233443] btrfs_insert_empty_items (fs/btrfs/ctree.c:4836)
[   60.233443] ? dlm_init (fs/btrfs/super.c:1914)
[   60.233443] insert_normal_tree_ref.constprop.4 (fs/btrfs/tests/qgroup-tests.c:60)
[   60.233443] ? dlm_init (fs/btrfs/super.c:1914)
[   60.233443] test_no_shared_qgroup (fs/btrfs/tests/qgroup-tests.c:249)
[   60.233443] btrfs_test_qgroups (fs/btrfs/tests/qgroup-tests.c:462)
[   60.233443] init_btrfs_fs (fs/btrfs/super.c:1909 fs/btrfs/super.c:1969)
[   60.233443] ? dlm_init (fs/btrfs/super.c:1914)
[   60.233443] do_one_initcall (init/main.c:791)
[   60.233443] ? parse_args (kernel/params.c:101 kernel/params.c:205)
[   60.233443] ? rmi_driver_init (drivers/hid/hid-saitek.c:197)
[   60.233443] kernel_init_freeable (init/main.c:856 init/main.c:865 init/main.c:884 init/main.c:1005)
[   60.233443] ? loglevel (init/main.c:241)
[   60.233443] ? rest_init (init/main.c:932)
[   60.233443] kernel_init (init/main.c:937)
[   60.233443] ret_from_fork (arch/x86/kernel/entry_64.S:349)
[   60.233443] ? rest_init (init/main.c:932)
[   60.233443] Dumping ftrace buffer:
[   60.233443]    (ftrace buffer empty)
[   60.233443] Kernel Offset: 0xc000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   60.233443] Rebooting in 1 seconds..


Thanks,
Sasha
