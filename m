Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbaFYRBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:01:05 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38916 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441AbaFYRBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:01:03 -0400
Message-ID: <53AAFFE3.3020205@linux.vnet.ibm.com>
Date: Wed, 25 Jun 2014 22:29:15 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, fweisbec@gmail.com,
        hch@infradead.org, mgorman@suse.de, riel@redhat.com, bp@suse.de,
        rostedt@goodmis.org, mgalbraith@suse.de, ego@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v7 2/2] CPU hotplug, smp: Flush any pending IPI callbacks
 before CPU offline
References: <20140526110743.16203.18186.stgit@srivatsabhat.in.ibm.com> <20140526110831.16203.25130.stgit@srivatsabhat.in.ibm.com> <53AAEDE7.8060300@oracle.com>
In-Reply-To: <53AAEDE7.8060300@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062517-0260-0000-0000-00000537F3CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 09:12 PM, Sasha Levin wrote:
> On 05/26/2014 07:08 AM, Srivatsa S. Bhat wrote:
>> During CPU offline, in stop-machine, we don't enforce any rule in the
>> _DISABLE_IRQ stage, regarding the order in which the outgoing CPU and the other
>> CPUs disable their local interrupts. Hence, we can encounter a scenario as
>> depicted below, in which IPIs are sent by the other CPUs to the CPU going
>> offline (while it is *still* online), but the outgoing CPU notices them only
>> *after* it has gone offline.
>>
[...]
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following spew:
> 

Thanks for the bug report. Please test if this patch fixes the problem
for you:

https://git.kernel.org/cgit/linux/kernel/git/peterz/queue.git/commit/?h=timers/nohz&id=921d8b81281ecdca686369f52165d04fa3505bd7

Regards,
Srivatsa S. Bhat

> [ 1982.600053] kernel BUG at kernel/irq_work.c:175!
> [ 1982.600053] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [ 1982.600053] Dumping ftrace buffer:
> [ 1982.600053]    (ftrace buffer empty)
> [ 1982.600053] Modules linked in:
> [ 1982.600053] CPU: 14 PID: 168 Comm: migration/14 Not tainted 3.16.0-rc2-next-20140624-sasha-00024-g332b58d #726
> [ 1982.600053] task: ffff88036a5a3000 ti: ffff88036a5ac000 task.ti: ffff88036a5ac000
> [ 1982.600053] RIP: irq_work_run (kernel/irq_work.c:175 (discriminator 1))
> [ 1982.600053] RSP: 0000:ffff88036a5afbe0  EFLAGS: 00010046
> [ 1982.600053] RAX: 0000000080000001 RBX: 0000000000000000 RCX: 0000000000000008
> [ 1982.600053] RDX: 000000000000000e RSI: ffffffffaf9185fb RDI: 0000000000000000
> [ 1982.600053] RBP: ffff88036a5afc08 R08: 0000000000099224 R09: 0000000000000000
> [ 1982.600053] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88036afd8400
> [ 1982.600053] R13: 0000000000000000 R14: ffffffffb0cf8120 R15: ffffffffb0cce5d0
> [ 1982.600053] FS:  0000000000000000(0000) GS:ffff88036ae00000(0000) knlGS:0000000000000000
> [ 1982.600053] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1982.600053] CR2: 00000000019485d0 CR3: 00000002c7c8f000 CR4: 00000000000006a0
> [ 1982.600053] Stack:
> [ 1982.600053]  ffffffffab20fbb5 0000000000000082 ffff88036afd8440 0000000000000000
> [ 1982.600053]  0000000000000001 ffff88036a5afc28 ffffffffab20fca7 0000000000000000
> [ 1982.600053]  00000000ffffffef ffff88036a5afc78 ffffffffab19c58e 000000000000000e
> [ 1982.600053] Call Trace:
> [ 1982.600053] ? flush_smp_call_function_queue (kernel/smp.c:263)
> [ 1982.600053] hotplug_cfd (kernel/smp.c:81)
> [ 1982.600053] notifier_call_chain (kernel/notifier.c:95)
> [ 1982.600053] __raw_notifier_call_chain (kernel/notifier.c:395)
> [ 1982.600053] __cpu_notify (kernel/cpu.c:202)
> [ 1982.600053] cpu_notify (kernel/cpu.c:211)
> [ 1982.600053] take_cpu_down (./arch/x86/include/asm/current.h:14 kernel/cpu.c:312)
> [ 1982.600053] multi_cpu_stop (kernel/stop_machine.c:201)
> [ 1982.600053] ? __stop_cpus (kernel/stop_machine.c:170)
> [ 1982.600053] cpu_stopper_thread (kernel/stop_machine.c:474)
> [ 1982.600053] ? put_lock_stats.isra.12 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
> [ 1982.600053] ? _raw_spin_unlock_irqrestore (./arch/x86/include/asm/paravirt.h:809 include/linux/spinlock_api_smp.h:160 kernel/locking/spinlock.c:191)
> [ 1982.600053] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> [ 1982.600053] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2557 kernel/locking/lockdep.c:2599)
> [ 1982.600053] smpboot_thread_fn (kernel/smpboot.c:160)
> [ 1982.600053] ? __smpboot_create_thread (kernel/smpboot.c:105)
> [ 1982.600053] kthread (kernel/kthread.c:210)
> [ 1982.600053] ? wait_for_completion (kernel/sched/completion.c:77 kernel/sched/completion.c:93 kernel/sched/completion.c:101 kernel/sched/completion.c:122)
> [ 1982.600053] ? kthread_create_on_node (kernel/kthread.c:176)
> [ 1982.600053] ret_from_fork (arch/x86/kernel/entry_64.S:349)
> [ 1982.600053] ? kthread_create_on_node (kernel/kthread.c:176)
> [ 1982.600053] Code: 00 00 00 00 e8 63 ff ff ff 48 83 c4 08 b8 01 00 00 00 5b 5d c3 b8 01 00 00 00 c3 90 65 8b 04 25 a0 da 00 00 a9 00 00 0f 00 75 09 <0f> 0b 0f 1f 80 00 00 00 00 55 48 89 e5 e8 2f ff ff ff 5d c3 66
> All code
> ========
>    0:	00 00                	add    %al,(%rax)
>    2:	00 00                	add    %al,(%rax)
>    4:	e8 63 ff ff ff       	callq  0xffffffffffffff6c
>    9:	48 83 c4 08          	add    $0x8,%rsp
>    d:	b8 01 00 00 00       	mov    $0x1,%eax
>   12:	5b                   	pop    %rbx
>   13:	5d                   	pop    %rbp
>   14:	c3                   	retq
>   15:	b8 01 00 00 00       	mov    $0x1,%eax
>   1a:	c3                   	retq
>   1b:	90                   	nop
>   1c:	65 8b 04 25 a0 da 00 	mov    %gs:0xdaa0,%eax
>   23:	00
>   24:	a9 00 00 0f 00       	test   $0xf0000,%eax
>   29:	75 09                	jne    0x34
>   2b:*	0f 0b                	ud2    		<-- trapping instruction
>   2d:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
>   34:	55                   	push   %rbp
>   35:	48 89 e5             	mov    %rsp,%rbp
>   38:	e8 2f ff ff ff       	callq  0xffffffffffffff6c
>   3d:	5d                   	pop    %rbp
>   3e:	c3                   	retq
>   3f:	66                   	data16
> 	...
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	0f 0b                	ud2
>    2:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
>    9:	55                   	push   %rbp
>    a:	48 89 e5             	mov    %rsp,%rbp
>    d:	e8 2f ff ff ff       	callq  0xffffffffffffff41
>   12:	5d                   	pop    %rbp
>   13:	c3                   	retq
>   14:	66                   	data16
> 	...
> [ 1982.600053] RIP irq_work_run (kernel/irq_work.c:175 (discriminator 1))
> [ 1982.600053]  RSP <ffff88036a5afbe0>
> 
> 
> Thanks,
> Sasha
> 

