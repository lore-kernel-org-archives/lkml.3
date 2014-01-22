Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaAVIuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 03:50:39 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:58444 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaAVIuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 03:50:37 -0500
Date: Wed, 22 Jan 2014 09:50:35 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: qemu hangs on current git
Message-ID: <20140122085035.GA390@x4>
References: <20140121215119.GA389@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121215119.GA389@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.01.21 at 22:51 +0100, Markus Trippelsdorf wrote:
> Running the current git tree (v3.13-3260-g03d11a0e458d) on the host,
> qemu sometimes hangs during test boots of the kernel (version of the guest
> kernel doesn't matter). This happens roughly every 4-6 runs and manifest
> itself in hangs during the guest boot. Perf shows:
> 
>     31.56%  qemu-system-x86  [kernel.kallsyms]        [k] __srcu_read_unlock
>     31.51%  qemu-system-x86  [kernel.kallsyms]        [k] __srcu_read_lock
>     20.95%  qemu-system-x86  [kernel.kallsyms]        [k] kvm_arch_vcpu_ioctl_run
>      4.72%  qemu-system-x86  [kernel.kallsyms]        [k] svm_complete_interrupts
>      3.28%  qemu-system-x86  [kernel.kallsyms]        [k] kvm_check_async_pf_completion
>      2.04%  qemu-system-x86  [kernel.kallsyms]        [k] apic_has_pending_timer
>      1.38%  qemu-system-x86  [kernel.kallsyms]        [k] svm_cancel_injection
>      1.29%  qemu-system-x86  [kernel.kallsyms]        [k] _cond_resched
>      1.04%  qemu-system-x86  [kernel.kallsyms]        [k] kvm_resched
>      0.66%  qemu-system-x86  [kernel.kallsyms]        [k] svm_prepare_guest_switch
>      0.16%  qemu-system-x86  qemu-system-x86_64       [.] phys_page_find
> 
> qemu command used:
>  % qemu-system-x86_64 -s -enable-kvm -net nic,vlan=0,model=virtio -net user -fsdev local,security_model=none,id=root,path=/ -device virtio-9p-pci,id=root,fsdev=root,mount_tag=/dev/root -m 512 -smp 2 -kernel /usr/src/linux/arch/x86/boot/bzImage -nographic -append "init=/bin/zsh root=/dev/root console=ttyS0 kgdboc=ttyS0 rootflags=rw,trans=virtio rootfstype=9p ip=dhcp earlyprintk=ttyS0"

Some more info:

[Jan22 09:45] INFO: rcu_sched self-detected stall on CPU
[  +0.000006]   0: (17999 ticks this GP) idle=def/140000000000001/0 softirq=2462/2462 
[  +0.000001]    (t=18000 jiffies g=991 c=990 q=6528)
[  +0.000002] sending NMI to all CPUs:
[  +0.000007] NMI backtrace for cpu 0
[  +0.000007] CPU: 0 PID: 705 Comm: qemu-system-x86 Not tainted 3.13.0-03477-gdf32e43a54d0 #98
[  +0.000001] Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
[  +0.000002] task: ffff8802106aed00 ti: ffff8800c8e24000 task.ti: ffff8800c8e24000
[  +0.000001] RIP: 0010:[<ffffffff811e9659>]  [<ffffffff811e9659>] __const_udelay+0x9/0x30
[  +0.000006] RSP: 0018:ffff8800dfc03e60  EFLAGS: 00000006
[  +0.000002] RAX: 0000000000000c00 RBX: 0000000000002710 RCX: 0000000000000007
[  +0.000001] RDX: 0000000000a3503e RSI: 0000000000000046 RDI: 0000000000418958
[  +0.000001] RBP: ffffffff81a1c4c0 R08: 00000000000002b0 R09: 0000000000000000
[  +0.000001] R10: 0000000000000000 R11: 00000000000002af R12: 0000000000000000
[  +0.000001] R13: ffffffff81a64fd8 R14: 0000000000001980 R15: ffffffff81a1c4c0
[  +0.000001] FS:  0000000000000000(0000) GS:ffff8800dfc00000(0000) knlGS:0000000000000000
[  +0.000001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  +0.000001] CR2: ffff880001ab0ff8 CR3: 000000021456c000 CR4: 00000000000007f0
[  +0.000001] Stack:
[  +0.000001]  ffffffff81053295 ffff8800dfc0d4c0 ffffffff810a0e17 0000000000000086
[  +0.000002]  ffffffff810a2976 0000000000011a00 0000000000000086 ffff8802106aed00
[  +0.000002]  0000000000000000 0000000000000000 0000000000000000 ffff8800dfc0ce78
[  +0.000002] Call Trace:
[  +0.000001]  <IRQ> 

[  +0.000004]  [<ffffffff81053295>] ? arch_trigger_all_cpu_backtrace+0x55/0x70
[  +0.000003]  [<ffffffff810a0e17>] ? rcu_check_callbacks+0x387/0x5e0
[  +0.000003]  [<ffffffff810a2976>] ? update_wall_time+0x276/0x660
[  +0.000003]  [<ffffffff8106d209>] ? update_process_times+0x49/0x80
[  +0.000002]  [<ffffffff810a9f92>] ? tick_sched_timer+0x42/0x70
[  +0.000003]  [<ffffffff8107f88d>] ? __run_hrtimer.isra.32+0x4d/0x110
[  +0.000002]  [<ffffffff810801a7>] ? hrtimer_interrupt+0xe7/0x230
[  +0.000002]  [<ffffffff81051e66>] ? smp_apic_timer_interrupt+0x36/0x50
[  +0.000003]  [<ffffffff8154d0c7>] ? apic_timer_interrupt+0x67/0x70
[  +0.000000]  <EOI> 

[  +0.000003]  [<ffffffff8109e7e8>] ? __srcu_read_lock+0x28/0x50
[  +0.000004]  [<ffffffff81010dbc>] ? kvm_arch_vcpu_ioctl_run+0xb2c/0x1090
[  +0.000003]  [<ffffffff8125b57c>] ? pty_write+0x5c/0x60
[  +0.000003]  [<ffffffff81093208>] ? remove_wait_queue+0x18/0x60
[  +0.000002]  [<ffffffff8100d7d7>] ? kvm_arch_vcpu_load+0x47/0x1d0
[  +0.000003]  [<ffffffff81002322>] ? kvm_vcpu_ioctl+0x2a2/0x530
[  +0.000003]  [<ffffffff81003d37>] ? kvm_vm_ioctl+0x5d7/0x730
[  +0.000002]  [<ffffffff8113858e>] ? fsnotify+0x27e/0x350
[  +0.000002]  [<ffffffff811114d0>] ? do_vfs_ioctl+0x2d0/0x490
[  +0.000003]  [<ffffffff81548074>] ? __schedule+0x2a4/0x750
[  +0.000002]  [<ffffffff811116dd>] ? SyS_ioctl+0x4d/0xa0
[  +0.000002]  [<ffffffff8154c5a2>] ? system_call_fastpath+0x16/0x1b
[  +0.000001] Code: 89 07 31 c0 f3 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 05 d9 b9 83 00 ff e0 0f 1f 80 00 00 00 00 65 48 8b 14 25 20 12 01 00 <48> 8d 0c 92 48 8d 04 bd
 00 00 00 00 48 89 ca 48 c1 e2 04 48 29 
[  +0.000023] NMI backtrace for cpu 3
[  +0.000010] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-03477-gdf32e43a54d0 #98
[  +0.000003] Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
[  +0.000005] task: ffff88021f88caf0 ti: ffff88021f8b4000 task.ti: ffff88021f8b4000
[  +0.000003] RIP: 0010:[<ffffffff810a0b69>]  [<ffffffff810a0b69>] rcu_check_callbacks+0xd9/0x5e0
[  +0.000014] RSP: 0018:ffff8800dfd83d90  EFLAGS: 00000006
[  +0.000003] RAX: ffffffff81a1c420 RBX: 000000000000d340 RCX: 00000000000003de
[  +0.000002] RDX: 00000000000003df RSI: ffff8800dfd8d4c0 RDI: ffffffff81a1c4c0
[  +0.000003] RBP: ffffffff81a1c180 R08: 000000000097181b R09: 000000001f0031e1
[  +0.000003] R10: 0000005dbec1ca60 R11: 0000000000000400 R12: 0000000000000003
[  +0.000003] R13: ffffffff81a64fd8 R14: ffff8800dfd8ce78 R15: ffffffff81a1c4c0
[  +0.000004] FS:  00007f64a02f8780(0000) GS:ffff8800dfd80000(0000) knlGS:0000000000000000
[  +0.000002] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  +0.000003] CR2: 00007f649fcc3000 CR3: 000000021450a000 CR4: 00000000000007e0
[  +0.000002] Stack:
[  +0.000002]  ffff8800dfd83e08 ffff88021ef41638 ffffffff8108aa70 ffff88021ef41500
[  +0.000005]  ffff88021f88caf0 0000000000000000 0000000000000003 0000000000000000
[  +0.000005]  ffff8800dfd8ce78 7fffffffffffffff ffffffff8106d209 ffff8800dfd8d880
[  +0.000005] Call Trace:
[  +0.000003]  <IRQ> 

[  +0.000008]  [<ffffffff8108aa70>] ? can_migrate_task+0x60/0x130
[  +0.000008]  [<ffffffff8106d209>] ? update_process_times+0x49/0x80
[  +0.000006]  [<ffffffff810a9f92>] ? tick_sched_timer+0x42/0x70
[  +0.000007]  [<ffffffff8107f88d>] ? __run_hrtimer.isra.32+0x4d/0x110
[  +0.000005]  [<ffffffff810801a7>] ? hrtimer_interrupt+0xe7/0x230
[  +0.000007]  [<ffffffff810a8fe3>] ? tick_do_broadcast.constprop.7+0x83/0x90
[  +0.000007]  [<ffffffff810a917c>] ? tick_handle_oneshot_broadcast+0x10c/0x180
[  +0.000007]  [<ffffffff81037a9c>] ? timer_interrupt+0xc/0x20
[  +0.000006]  [<ffffffff81099b81>] ? handle_irq_event_percpu+0x81/0x110
[  +0.000005]  [<ffffffff81099c46>] ? handle_irq_event+0x36/0x60
[  +0.000006]  [<ffffffff8109c8ae>] ? handle_edge_irq+0x5e/0x110
[  +0.000005]  [<ffffffff81037455>] ? handle_irq+0x15/0x30
[  +0.000005]  [<ffffffff81037267>] ? do_IRQ+0x57/0x100
[  +0.000005]  [<ffffffff8154bee7>] ? common_interrupt+0x67/0x67
[  +0.000002]  <EOI> 

[  +0.000007]  [<ffffffff810a8ef6>] ? tick_broadcast_set_event+0x46/0xb0
[  +0.000006]  [<ffffffff8103db3e>] ? amd_e400_idle+0x3e/0xe0
[  +0.000004]  [<ffffffff8103db3c>] ? amd_e400_idle+0x3c/0xe0
[  +0.000005]  [<ffffffff81099161>] ? cpu_startup_entry+0x81/0x160
[  +0.000002] Code: 81 48 c7 c0 40 d3 00 00 c6 44 10 10 01 48 81 f9 60 c1 a1 81 0f 84 f1 01 00 00 4c 8b 2d 81 e7 56 00 4c 63 e7 48 8b 9d e0 00 00 00 <8b> 0d f1 44 9c 00 4a 03
 1c e5 80 4d a6 81 48 ff 83 e0 00 00 00 
[  +0.000055] NMI backtrace for cpu 1
[  +0.000010] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.13.0-03477-gdf32e43a54d0 #98
[  +0.000004] Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
[  +0.000004] task: ffff88021f88bd50 ti: ffff88021f8b0000 task.ti: ffff88021f8b0000
[  +0.000004] RIP: 0010:[<ffffffff8103db3e>]  [<ffffffff8103db3e>] amd_e400_idle+0x3e/0xe0
[  +0.000014] RSP: 0018:ffff88021f8b1f08  EFLAGS: 00000286
[  +0.000003] RAX: ffffffff81a17940 RBX: ffff88021f8b1f0c RCX: 0000000000000000
[  +0.000003] RDX: 000000198379f032 RSI: 0000000000000086 RDI: ffffffff81b9bf50
[  +0.000009] RBP: ffffffff81a64fd0 R08: 0000000000000000 R09: 000000001f0031e1
[  +0.000010] R10: 0000005dbe1e7ab9 R11: 0000000000000400 R12: ffff88021f8b1fd8
[  +0.000010] R13: ffff88021f8b1fd8 R14: ffff88021f8b1fd8 R15: ffff88021f8b1fd8
[  +0.000011] FS:  00007fa0be450700(0000) GS:ffff8800dfc80000(0000) knlGS:0000000000000000
[  +0.000009] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  +0.000009] CR2: 00007fa0be484000 CR3: 00000000d2b4c000 CR4: 00000000000007e0
[  +0.000009] Stack:
[  +0.000007]  000000011f8b1fd8 ffff88021f8b1fd8 ffffffff81099161 0000000010001b76
[  +0.000032]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  +0.000030]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  +0.000030] Call Trace:
[  +0.000020]  [<ffffffff81099161>] ? cpu_startup_entry+0x81/0x160
[  +0.000007] Code: b0 00 00 89 44 24 04 89 c0 48 0f a3 05 ac dd ae 00 19 d2 85 d2 74 44 48 8d 5c 24 04 48 89 de bf 04 00 00 00 e8 a4 a9 06 00 fb f4 <fa> 48 8d 74 24 04 bf 05
 00 00 00 e8 92 a9 06 00 fb 48 83 c4 08 
[  +0.000056] NMI backtrace for cpu 2
[  +0.000010] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-03477-gdf32e43a54d0 #98
[  +0.000003] Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
[  +0.000005] task: ffff88021f88c420 ti: ffff88021f8b2000 task.ti: ffff88021f8b2000
[  +0.000004] RIP: 0010:[<ffffffff8103db3e>]  [<ffffffff8103db3e>] amd_e400_idle+0x3e/0xe0
[  +0.000012] RSP: 0018:ffff88021f8b3f08  EFLAGS: 00000286
[  +0.000003] RAX: ffffffff81a17940 RBX: ffff88021f8b3f0c RCX: 0000000000000000
[  +0.000003] RDX: 000000198379f032 RSI: 0000000000000086 RDI: ffffffff81b9bf50
[  +0.000003] RBP: ffffffff81a64fd0 R08: 0000000000000000 R09: 000000001f0031e1
[  +0.000003] R10: 0000005dbe1e7ab9 R11: 0000000000000400 R12: ffff88021f8b3fd8
[  +0.000002] R13: ffff88021f8b3fd8 R14: ffff88021f8b3fd8 R15: ffff88021f8b3fd8
[  +0.000004] FS:  00007f9d83f2c700(0000) GS:ffff8800dfd00000(0000) knlGS:0000000000000000
[  +0.000003] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  +0.000003] CR2: 00007f9d83ff3000 CR3: 00000000d2a1c000 CR4: 00000000000007e0
[  +0.000001] Stack:
[  +0.000002]  000000021f8b3fd8 ffff88021f8b3fd8 ffffffff81099161 0000000010001b76
[  +0.000006]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  +0.000005]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  +0.000004] Call Trace:
[  +0.000009]  [<ffffffff81099161>] ? cpu_startup_entry+0x81/0x160
[  +0.000004] Code: b0 00 00 89 44 24 04 89 c0 48 0f a3 05 ac dd ae 00 19 d2 85 d2 74 44 48 8d 5c 24 04 48 89 de bf 04 00 00 00 e8 a4 a9 06 00 fb f4 <fa> 48 8d 74 24 04 bf 05
 00 00 00 e8 92 a9 06 00 fb 48 83 c4 08 

-- 
Markus
