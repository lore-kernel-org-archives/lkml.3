Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750985AbaHVSxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 14:53:14 -0400
Received: from mout.gmx.net ([212.227.15.19]:61659 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbaHVSxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 14:53:12 -0400
Message-ID: <53F79194.1050300@gmx.de>
Date: Fri, 22 Aug 2014 20:53:08 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: UML devel <user-mode-linux-devel@lists.sourceforge.net>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: BUG: spinlock recursion on CPU#0, rngd/1219
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:I9ruLHkHdrLOyHr+FrA4DhxgoblzE/ELXdtRSwlxzmENkp+LBmu
 Tlb+BZg2DYZSEE5R6PaE1H0q25RUPZGnvcw0DPGwWxWbK8YDlxlWY50qXy12vrhFNa2KzQp
 Aj5/XmkWtezwOT3Eqv4OvoFD3IrC/9zx/6Xd+MbPJbkM+Fq2fHt64aMH1v6V/6/jmXBG5v3
 gt74SS2Z1/2oBKGsv1IIQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While fuzzying a 22 bit UML guest (stable Gentoo x86 Linux) with trinity I do sometimes get from the UML guest this :


Aug 22 19:59:40 trinity kernel: BUG: spinlock recursion on CPU#0, rngd/1219
Aug 22 19:59:40 trinity kernel: lock: 0x86f1548, .magic: dead4ead, .owner: rngd/1219, .owner_cpu: 0
Aug 22 19:59:40 trinity kernel: CPU: 0 PID: 1219 Comm: rngd Not tainted 3.17.0-rc1-00099-g5317821-dirty #11
Aug 22 19:59:40 trinity kernel: Stack:
Aug 22 19:59:40 trinity kernel: 085bfe10 085bfe10 00000003 086f0547 844d06c0 086f1548 00000006 8477f9a8
Aug 22 19:59:40 trinity kernel: 08501f40 00000000 8477f97c 8477f9d4 084fe7b9 085cc86c 086f1548 dead4ead
Aug 22 19:59:40 trinity kernel: 844d0908 000004c3 00000000 00000000 086f1548 085caae2 8477f9e4 084fe7db
Aug 22 19:59:40 trinity kernel: Call Trace:
Aug 22 19:59:40 trinity kernel: [<084fe7db>] ? spin_bug+0x1b/0x1f
Aug 22 19:59:40 trinity kernel: [<08501f40>] dump_stack+0x26/0x28
Aug 22 19:59:40 trinity kernel: [<084fe7b9>] spin_dump+0xa1/0xa8
Aug 22 19:59:40 trinity kernel: [<084fe7db>] spin_bug+0x1b/0x1f
Aug 22 19:59:40 trinity kernel: [<080a0ab3>] do_raw_spin_lock+0x43/0x100
Aug 22 19:59:40 trinity kernel: [<0834fbd2>] ? __blk_put_request+0x112/0x120
Aug 22 19:59:40 trinity kernel: [<085053f1>] _raw_spin_lock+0x11/0x20
Aug 22 19:59:40 trinity kernel: [<08060622>] sigio_lock+0x12/0x20
Aug 22 19:59:40 trinity kernel: [<08071261>] add_sigio_fd+0x11/0x100
Aug 22 19:59:40 trinity kernel: [<0805ec9a>] reactivate_fd+0x6a/0x80
Aug 22 19:59:40 trinity kernel: [<0806b6d5>] ubd_intr+0x95/0x110
Aug 22 19:59:40 trinity kernel: [<080a56cf>] handle_irq_event_percpu+0x2f/0x130
Aug 22 19:59:40 trinity kernel: [<080a5804>] handle_irq_event+0x34/0x50
Aug 22 19:59:40 trinity kernel: [<080a7e10>] handle_edge_irq+0xf0/0x120
Aug 22 19:59:40 trinity kernel: [<080a50db>] generic_handle_irq+0x2b/0x30
Aug 22 19:59:40 trinity kernel: [<0805eda5>] do_IRQ+0x25/0x40
Aug 22 19:59:40 trinity kernel: [<0805ee25>] sigio_handler+0x65/0x90
Aug 22 19:59:40 trinity kernel: [<08071ade>] sig_handler_common+0xae/0xd0
Aug 22 19:59:40 trinity kernel: [<08071c2e>] ? set_signals+0x1e/0x40
Aug 22 19:59:40 trinity kernel: [<080d6a87>] ? get_page_from_freelist+0x327/0x5b0
Aug 22 19:59:40 trinity kernel: [<080d74d7>] ? __alloc_pages_nodemask+0xe7/0x7e0
Aug 22 19:59:40 trinity kernel: [<08104eb9>] ? check_bytes_and_report+0x29/0x100
Aug 22 19:59:40 trinity kernel: [<08062a23>] ? copy_chunk_from_user+0x23/0x30
Aug 22 19:59:40 trinity kernel: [<0811f3d0>] ? pollwake+0x0/0x70
Aug 22 19:59:40 trinity kernel: [<0811f3d0>] ? pollwake+0x0/0x70
Aug 22 19:59:40 trinity kernel: [<0809baec>] ? __enqueue_entity+0x6c/0x80
Aug 22 19:59:40 trinity kernel: [<0809bd64>] ? check_preempt_wakeup+0x174/0x210
Aug 22 19:59:40 trinity kernel: [<08062a23>] ? copy_chunk_from_user+0x23/0x30
Aug 22 19:59:40 trinity kernel: [<085054bc>] ? _raw_spin_unlock_irqrestore+0x1c/0x20
Aug 22 19:59:40 trinity kernel: [<08097a5f>] ? try_to_wake_up+0xff/0x110
Aug 22 19:59:40 trinity kernel: [<084c06ac>] ? ptrace+0x2c/0x70
Aug 22 19:59:40 trinity kernel: [<08098334>] ? default_wake_function+0x14/0x20
Aug 22 19:59:40 trinity kernel: [<0811f43e>] ? pollwake+0x6e/0x70
Aug 22 19:59:40 trinity kernel: [<080799f6>] ? os_set_thread_area+0x26/0x40
Aug 22 19:59:40 trinity kernel: [<08078a0c>] ? do_set_thread_area+0x1c/0x50
Aug 22 19:59:40 trinity kernel: [<08078b88>] ? arch_switch_tls+0xb8/0x100
Aug 22 19:59:40 trinity kernel: [<08071a0b>] unblock_signals+0x4b/0x70
Aug 22 19:59:40 trinity kernel: [<08071c2e>] set_signals+0x1e/0x40
Aug 22 19:59:40 trinity kernel: [<08070ef4>] update_thread+0x134/0x140
Aug 22 19:59:40 trinity kernel: [<080713dd>] ignore_sigio_fd+0x8d/0x100
Aug 22 19:59:40 trinity kernel: [<0806e4ad>] rng_dev_read+0x20d/0x260
Aug 22 19:59:40 trinity kernel: [<08098320>] ? default_wake_function+0x0/0x20
Aug 22 19:59:40 trinity kernel: [<0810d483>] vfs_read+0x93/0x190
Aug 22 19:59:40 trinity kernel: [<0810da71>] SyS_read+0x51/0xa0
Aug 22 19:59:40 trinity kernel: [<080629e0>] handle_syscall+0x60/0x80
Aug 22 19:59:40 trinity kernel: [<0804d120>] ? pidmap_init+0x8b/0xaf
Aug 22 19:59:40 trinity kernel: [<084c06ac>] ? ptrace+0x2c/0x70
Aug 22 19:59:40 trinity kernel: [<080794a2>] ? get_fp_registers+0x22/0x40
Aug 22 19:59:40 trinity kernel: [<080745ac>] userspace+0x46c/0x5e0
Aug 22 19:59:40 trinity kernel: [<080799f6>] ? os_set_thread_area+0x26/0x40
Aug 22 19:59:40 trinity kernel: [<08078a0c>] ? do_set_thread_area+0x1c/0x50
Aug 22 19:59:40 trinity kernel: [<08078b88>] ? arch_switch_tls+0xb8/0x100
Aug 22 19:59:40 trinity kernel: [<0805f720>] fork_handler+0x60/0x70
Aug 22 19:59:40 trinity kernel: 
Aug 22 19:59:40 trinity kernel: BUG: spinlock lockup suspected on CPU#0, rngd/1219
Aug 22 19:59:40 trinity kernel: lock: 0x86f1548, .magic: dead4ead, .owner: rngd/1219, .owner_cpu: 0
Aug 22 19:59:40 trinity kernel: CPU: 0 PID: 1219 Comm: rngd Not tainted 3.17.0-rc1-00099-g5317821-dirty #11
Aug 22 19:59:40 trinity kernel: Stack:
Aug 22 19:59:40 trinity kernel: 085bfe10 085bfe10 00000003 086f0547 844d06c0 086f1548 00000000 8477f9b8
Aug 22 19:59:40 trinity kernel: 08501f40 00000000 8477f98c 8477f9e4 084fe7b9 085cc86c 086f1548 dead4ead
Aug 22 19:59:40 trinity kernel: 844d0908 000004c3 00000000 084fe7ce 086f1548 2fb48000 8477fa08 080a0afd
Aug 22 19:59:40 trinity kernel: Call Trace:
Aug 22 19:59:40 trinity kernel: [<080a0afd>] ? do_raw_spin_lock+0x8d/0x100
Aug 22 19:59:40 trinity kernel: [<08501f40>] dump_stack+0x26/0x28
Aug 22 19:59:40 trinity kernel: [<084fe7b9>] spin_dump+0xa1/0xa8
Aug 22 19:59:40 trinity kernel: [<084fe7ce>] ? spin_bug+0xe/0x1f
Aug 22 19:59:40 trinity kernel: [<080a0afd>] do_raw_spin_lock+0x8d/0x100
Aug 22 19:59:40 trinity kernel: [<0834fbd2>] ? __blk_put_request+0x112/0x120
Aug 22 19:59:40 trinity kernel: [<085053f1>] _raw_spin_lock+0x11/0x20
Aug 22 19:59:40 trinity kernel: [<08060622>] sigio_lock+0x12/0x20
Aug 22 19:59:40 trinity kernel: [<08071261>] add_sigio_fd+0x11/0x100
Aug 22 19:59:40 trinity kernel: [<0805ec9a>] reactivate_fd+0x6a/0x80
Aug 22 19:59:40 trinity kernel: [<0806b6d5>] ubd_intr+0x95/0x110
Aug 22 19:59:40 trinity kernel: [<080a56cf>] handle_irq_event_percpu+0x2f/0x130
Aug 22 19:59:40 trinity kernel: [<080a5804>] handle_irq_event+0x34/0x50
Aug 22 19:59:40 trinity kernel: [<080a7e10>] handle_edge_irq+0xf0/0x120
Aug 22 19:59:40 trinity kernel: [<080a50db>] generic_handle_irq+0x2b/0x30
Aug 22 19:59:40 trinity kernel: [<0805eda5>] do_IRQ+0x25/0x40
Aug 22 19:59:40 trinity kernel: [<0805ee25>] sigio_handler+0x65/0x90
Aug 22 19:59:40 trinity kernel: [<08071ade>] sig_handler_common+0xae/0xd0
Aug 22 19:59:40 trinity kernel: [<08071c2e>] ? set_signals+0x1e/0x40
Aug 22 19:59:40 trinity kernel: [<080d6a87>] ? get_page_from_freelist+0x327/0x5b0
Aug 22 19:59:40 trinity kernel: [<080d74d7>] ? __alloc_pages_nodemask+0xe7/0x7e0
Aug 22 19:59:40 trinity kernel: [<08104eb9>] ? check_bytes_and_report+0x29/0x100
Aug 22 19:59:40 trinity kernel: [<08062a23>] ? copy_chunk_from_user+0x23/0x30
Aug 22 19:59:40 trinity kernel: [<0811f3d0>] ? pollwake+0x0/0x70
Aug 22 19:59:40 trinity kernel: [<0811f3d0>] ? pollwake+0x0/0x70
Aug 22 19:59:40 trinity kernel: [<0809baec>] ? __enqueue_entity+0x6c/0x80
Aug 22 19:59:40 trinity kernel: [<0809bd64>] ? check_preempt_wakeup+0x174/0x210
Aug 22 19:59:40 trinity kernel: [<08062a23>] ? copy_chunk_from_user+0x23/0x30
Aug 22 19:59:40 trinity kernel: [<085054bc>] ? _raw_spin_unlock_irqrestore+0x1c/0x20
Aug 22 19:59:40 trinity kernel: [<08097a5f>] ? try_to_wake_up+0xff/0x110
Aug 22 19:59:40 trinity kernel: [<084c06ac>] ? ptrace+0x2c/0x70
Aug 22 19:59:40 trinity kernel: [<08098334>] ? default_wake_function+0x14/0x20
Aug 22 19:59:40 trinity kernel: [<0811f43e>] ? pollwake+0x6e/0x70
Aug 22 19:59:40 trinity kernel: [<080799f6>] ? os_set_thread_area+0x26/0x40
Aug 22 19:59:40 trinity kernel: [<08078a0c>] ? do_set_thread_area+0x1c/0x50
Aug 22 19:59:40 trinity kernel: [<08078b88>] ? arch_switch_tls+0xb8/0x100
Aug 22 19:59:40 trinity kernel: [<08071a0b>] unblock_signals+0x4b/0x70
Aug 22 19:59:40 trinity kernel: [<08071c2e>] set_signals+0x1e/0x40
Aug 22 19:59:40 trinity kernel: [<08070ef4>] update_thread+0x134/0x140
Aug 22 19:59:40 trinity kernel: [<080713dd>] ignore_sigio_fd+0x8d/0x100
Aug 22 19:59:40 trinity kernel: [<0806e4ad>] rng_dev_read+0x20d/0x260
Aug 22 19:59:40 trinity kernel: [<08098320>] ? default_wake_function+0x0/0x20
Aug 22 19:59:40 trinity kernel: [<0810d483>] vfs_read+0x93/0x190
Aug 22 19:59:40 trinity kernel: [<0810da71>] SyS_read+0x51/0xa0
Aug 22 19:59:40 trinity kernel: [<080629e0>] handle_syscall+0x60/0x80
Aug 22 19:59:40 trinity kernel: [<0804d120>] ? pidmap_init+0x8b/0xaf
Aug 22 19:59:40 trinity kernel: [<084c06ac>] ? ptrace+0x2c/0x70
Aug 22 19:59:40 trinity kernel: [<080794a2>] ? get_fp_registers+0x22/0x40
Aug 22 19:59:40 trinity kernel: [<080745ac>] userspace+0x46c/0x5e0
Aug 22 19:59:40 trinity kernel: [<080799f6>] ? os_set_thread_area+0x26/0x40
Aug 22 19:59:40 trinity kernel: [<08078a0c>] ? do_set_thread_area+0x1c/0x50
Aug 22 19:59:40 trinity kernel: [<08078b88>] ? arch_switch_tls+0xb8/0x100
Aug 22 19:59:40 trinity kernel: [<0805f720>] fork_handler+0x60/0x70
Aug 22 19:59:40 trinity kernel: 
Aug 22 20:00:01 trinity crond[3792]: pam_unix(crond:session): session opened for user root by (uid=0)
Aug 22 20:00:01 trinity CROND[3793]: (root) CMD (test -x /usr/sbin/run-crons && /usr/sbin/run-crons )
Aug 22 20:00:02 trinity CROND[3792]: pam_unix(crond:session): session closed for user root
Aug 22 20:10:01 trinity crond[3908]: pam_unix(crond:session): session opened for user root by (uid=0)
Aug 22 20:10:01 trinity CROND[3909]: (root) CMD (test -x /usr/sbin/run-crons && /usr/sbin/run-crons )
Aug 22 20:10:01 trinity CROND[3908]: pam_unix(crond:session): session closed for user root
Aug 22 20:20:01 trinity crond[4035]: pam_unix(crond:session): session opened for user root by (uid=0)
Aug 22 20:20:01 trinity CROND[4036]: (root) CMD (test -x /usr/sbin/run-crons && /usr/sbin/run-crons )
Aug 22 20:20:01 trinity CROND[4035]: pam_unix(crond:session): session closed for user root
Aug 22 20:25:47 trinity kernel: BUG: spinlock lockup suspected on CPU#0, rngd/1219
Aug 22 20:25:47 trinity kernel: lock: 0x86f1548, .magic: dead4ead, .owner: rngd/1219, .owner_cpu: 0
Aug 22 20:25:47 trinity kernel: CPU: 0 PID: 1219 Comm: rngd Not tainted 3.17.0-rc1-00099-g5317821-dirty #11
Aug 22 20:25:47 trinity kernel: Stack:
Aug 22 20:25:47 trinity kernel: 085bfe10 085bfe10 00000003 086f0547 844d06c0 086f1548 00000000 8477f9a0
Aug 22 20:25:47 trinity kernel: 08501f40 00000000 8477f974 8477f9cc 084fe7b9 085cc86c 086f1548 dead4ead
Aug 22 20:25:47 trinity kernel: 844d0908 000004c3 00000000 084fe7ce 086f1548 2fb48000 8477f9f0 080a0afd
Aug 22 20:25:47 trinity kernel: Call Trace:
Aug 22 20:25:47 trinity kernel: [<080a0afd>] ? do_raw_spin_lock+0x8d/0x100
Aug 22 20:25:47 trinity kernel: [<08501f40>] dump_stack+0x26/0x28
Aug 22 20:25:47 trinity kernel: [<084fe7b9>] spin_dump+0xa1/0xa8
Aug 22 20:25:47 trinity kernel: [<084fe7ce>] ? spin_bug+0xe/0x1f
Aug 22 20:25:47 trinity kernel: [<080a0afd>] do_raw_spin_lock+0x8d/0x100
Aug 22 20:25:47 trinity kernel: [<080975bc>] ? finish_task_switch.constprop.53+0x3c/0x90
Aug 22 20:25:47 trinity kernel: [<085053f1>] _raw_spin_lock+0x11/0x20
Aug 22 20:25:47 trinity kernel: [<08060622>] sigio_lock+0x12/0x20
Aug 22 20:25:47 trinity kernel: [<08071261>] add_sigio_fd+0x11/0x100
Aug 22 20:25:47 trinity kernel: [<0805ec9a>] reactivate_fd+0x6a/0x80
Aug 22 20:25:47 trinity kernel: [<08060597>] sigio_interrupt+0x37/0x40
Aug 22 20:25:47 trinity kernel: [<080a56cf>] handle_irq_event_percpu+0x2f/0x130
Aug 22 20:25:47 trinity kernel: [<080a5804>] handle_irq_event+0x34/0x50
Aug 22 20:25:47 trinity kernel: [<080a7e10>] handle_edge_irq+0xf0/0x120
Aug 22 20:25:47 trinity kernel: [<080a50db>] generic_handle_irq+0x2b/0x30
Aug 22 20:25:47 trinity kernel: [<0805eda5>] do_IRQ+0x25/0x40
Aug 22 20:25:47 trinity kernel: [<0805ee25>] sigio_handler+0x65/0x90
Aug 22 20:25:47 trinity kernel: [<08071ade>] sig_handler_common+0xae/0xd0
Aug 22 20:25:47 trinity kernel: [<08060c8e>] ? timer_handler+0x2e/0x40
Aug 22 20:25:47 trinity kernel: [<08071b44>] ? real_alarm_handler+0x44/0x50
Aug 22 20:25:47 trinity kernel: [<08071c2e>] ? set_signals+0x1e/0x40
Aug 22 20:25:47 trinity kernel: [<080d6a87>] ? get_page_from_freelist+0x327/0x5b0
Aug 22 20:25:47 trinity kernel: [<080d74d7>] ? __alloc_pages_nodemask+0xe7/0x7e0
Aug 22 20:25:47 trinity kernel: [<08104eb9>] ? check_bytes_and_report+0x29/0x100
Aug 22 20:25:47 trinity kernel: [<08062a23>] ? copy_chunk_from_user+0x23/0x30
Aug 22 20:25:47 trinity kernel: [<0811f3d0>] ? pollwake+0x0/0x70
Aug 22 20:25:47 trinity kernel: [<0811f3d0>] ? pollwake+0x0/0x70
Aug 22 20:25:47 trinity kernel: [<0809baec>] ? __enqueue_entity+0x6c/0x80
Aug 22 20:25:47 trinity kernel: [<0809bd64>] ? check_preempt_wakeup+0x174/0x210
Aug 22 20:25:47 trinity kernel: [<08062a23>] ? copy_chunk_from_user+0x23/0x30
Aug 22 20:25:47 trinity kernel: [<085054bc>] ? _raw_spin_unlock_irqrestore+0x1c/0x20
Aug 22 20:25:47 trinity kernel: [<08097a5f>] ? try_to_wake_up+0xff/0x110
Aug 22 20:25:47 trinity kernel: [<084c06ac>] ? ptrace+0x2c/0x70
Aug 22 20:25:47 trinity kernel: [<08098334>] ? default_wake_function+0x14/0x20
Aug 22 20:25:47 trinity kernel: [<0811f43e>] ? pollwake+0x6e/0x70
Aug 22 20:25:47 trinity kernel: [<08062a53>] ? copy_chunk_to_user+0x23/0x30
Aug 22 20:25:47 trinity kernel: [<08062ce7>] ? do_op_one_page+0x187/0x1a0
Aug 22 20:25:47 trinity kernel: [<08071a0b>] unblock_signals+0x4b/0x70
Aug 22 20:25:47 trinity kernel: [<08071c2e>] set_signals+0x1e/0x40
Aug 22 20:25:47 trinity kernel: [<08070ef4>] update_thread+0x134/0x140
Aug 22 20:25:47 trinity kernel: [<0807132d>] add_sigio_fd+0xdd/0x100
Aug 22 20:25:47 trinity kernel: [<0805ec9a>] reactivate_fd+0x6a/0x80
Aug 22 20:25:47 trinity kernel: [<0806e3e9>] rng_dev_read+0x149/0x260
Aug 22 20:25:47 trinity kernel: [<08098320>] ? default_wake_function+0x0/0x20
Aug 22 20:25:47 trinity kernel: [<0810d483>] vfs_read+0x93/0x190
Aug 22 20:25:47 trinity kernel: [<0810da71>] SyS_read+0x51/0xa0
Aug 22 20:25:47 trinity kernel: [<080629e0>] handle_syscall+0x60/0x80
Aug 22 20:25:47 trinity kernel: [<0804d120>] ? pidmap_init+0x8b/0xaf
Aug 22 20:25:47 trinity kernel: [<084c06ac>] ? ptrace+0x2c/0x70
Aug 22 20:25:47 trinity kernel: [<080794a2>] ? get_fp_registers+0x22/0x40
Aug 22 20:25:47 trinity kernel: [<080745ac>] userspace+0x46c/0x5e0
Aug 22 20:25:47 trinity kernel: [<080799f6>] ? os_set_thread_area+0x26/0x40
Aug 22 20:25:47 trinity kernel: [<08078a0c>] ? do_set_thread_area+0x1c/0x50
Aug 22 20:25:47 trinity kernel: [<08078b88>] ? arch_switch_tls+0xb8/0x100
Aug 22 20:25:47 trinity kernel: [<0805f720>] fork_handler+0x60/0x70
Aug 22 20:25:47 trinity kernel: 
Aug 22 20:25:47 trinity kernel: BUG: spinlock lockup suspected on CPU#0, rngd/1219
Aug 22 20:25:47 trinity kernel: lock: 0x86f1548, .magic: dead4ead, .owner: rngd/1219, .owner_cpu: 0
Aug 22 20:25:47 trinity kernel: CPU: 0 PID: 1219 Comm: rngd Not tainted 3.17.0-rc1-00099-g5317821-dirty #11
Aug 22 20:25:47 trinity kernel: Stack:
Aug 22 20:25:47 trinity kernel: 085bfe10 085bfe10 00000003 086f0547 844d06c0 086f1548 00000000 8477f9bc
Aug 22 20:25:47 trinity kernel: 08501f40 00000000 8477f990 8477f9e8 084fe7b9 085cc86c 086f1548 dead4ead
Aug 22 20:25:47 trinity kernel: 844d0908 000004c3 00000000 084fe7ce 086f1548 2fb48000 8477fa0c 080a0afd
Aug 22 20:25:47 trinity kernel: Call Trace:
Aug 22 20:25:47 trinity kernel: [<080a0afd>] ? do_raw_spin_lock+0x8d/0x100
Aug 22 20:25:47 trinity kernel: [<08501f40>] dump_stack+0x26/0x28
Aug 22 20:25:47 trinity kernel: [<084fe7b9>] spin_dump+0xa1/0xa8
Aug 22 20:25:47 trinity kernel: [<084fe7ce>] ? spin_bug+0xe/0x1f
Aug 22 20:25:47 trinity kernel: [<080a0afd>] do_raw_spin_lock+0x8d/0x100
Aug 22 20:25:47 trinity kernel: [<085053f1>] _raw_spin_lock+0x11/0x20
Aug 22 20:25:47 trinity kernel: [<08060622>] sigio_lock+0x12/0x20
Aug 22 20:25:47 trinity kernel: [<08071261>] add_sigio_fd+0x11/0x100
Aug 22 20:25:47 trinity kernel: [<0805ec9a>] reactivate_fd+0x6a/0x80
Aug 22 20:25:47 trinity kernel: [<08060597>] sigio_interrupt+0x37/0x40
Aug 22 20:25:47 trinity kernel: [<080a56cf>] handle_irq_event_percpu+0x2f/0x130
Aug 22 20:25:47 trinity kernel: [<080a580e>] ? handle_irq_event+0x3e/0x50
Aug 22 20:25:47 trinity kernel: [<080a5804>] handle_irq_event+0x34/0x50
Aug 22 20:25:47 trinity kernel: [<080a7e10>] handle_edge_irq+0xf0/0x120
Aug 22 20:25:47 trinity kernel: [<080a50db>] generic_handle_irq+0x2b/0x30
Aug 22 20:25:47 trinity kernel: [<0805eda5>] do_IRQ+0x25/0x40
Aug 22 20:25:47 trinity kernel: [<0805ee25>] sigio_handler+0x65/0x90
Aug 22 20:25:47 trinity kernel: [<08071ade>] sig_handler_common+0xae/0xd0
Aug 22 20:25:47 trinity kernel: [<08071b44>] ? real_alarm_handler+0x44/0x50
Aug 22 20:25:47 trinity kernel: [<08071c2e>] ? set_signals+0x1e/0x40
Aug 22 20:25:47 trinity kernel: [<080d6a87>] ? get_page_from_freelist+0x327/0x5b0
Aug 22 20:25:47 trinity kernel: [<080d74d7>] ? __alloc_pages_nodemask+0xe7/0x7e0
Aug 22 20:25:47 trinity kernel: [<08104eb9>] ? check_bytes_and_report+0x29/0x100
Aug 22 20:25:47 trinity kernel: [<08062a23>] ? copy_chunk_from_user+0x23/0x30
Aug 22 20:25:47 trinity kernel: [<0811f3d0>] ? pollwake+0x0/0x70
Aug 22 20:25:47 trinity kernel: [<0811f3d0>] ? pollwake+0x0/0x70
Aug 22 20:25:47 trinity kernel: [<0809baec>] ? __enqueue_entity+0x6c/0x80
Aug 22 20:25:47 trinity kernel: [<0809bd64>] ? check_preempt_wakeup+0x174/0x210
Aug 22 20:25:47 trinity kernel: [<08062a23>] ? copy_chunk_from_user+0x23/0x30
Aug 22 20:25:47 trinity kernel: [<085054bc>] ? _raw_spin_unlock_irqrestore+0x1c/0x20
Aug 22 20:25:47 trinity kernel: [<08097a5f>] ? try_to_wake_up+0xff/0x110
Aug 22 20:25:47 trinity kernel: [<084c06ac>] ? ptrace+0x2c/0x70
Aug 22 20:25:47 trinity kernel: [<08098334>] ? default_wake_function+0x14/0x20
Aug 22 20:25:47 trinity kernel: [<0811f43e>] ? pollwake+0x6e/0x70
Aug 22 20:25:47 trinity kernel: [<08062a53>] ? copy_chunk_to_user+0x23/0x30
Aug 22 20:25:47 trinity kernel: [<08062ce7>] ? do_op_one_page+0x187/0x1a0
Aug 22 20:25:47 trinity kernel: [<084fe7ce>] ? spin_bug+0xe/0x1f
Aug 22 20:25:47 trinity kernel: [<08071a0b>] unblock_signals+0x4b/0x70
Aug 22 20:25:47 trinity kernel: [<08071c2e>] set_signals+0x1e/0x40
Aug 22 20:25:47 trinity kernel: [<08070ef4>] update_thread+0x134/0x140
Aug 22 20:25:47 trinity kernel: [<0807132d>] add_sigio_fd+0xdd/0x100
Aug 22 20:25:47 trinity kernel: [<0806e3f6>] rng_dev_read+0x156/0x260
Aug 22 20:25:47 trinity kernel: [<08098320>] ? default_wake_function+0x0/0x20
Aug 22 20:25:47 trinity kernel: [<0810d483>] vfs_read+0x93/0x190
Aug 22 20:25:47 trinity kernel: [<0810da71>] SyS_read+0x51/0xa0
Aug 22 20:25:47 trinity kernel: [<080629e0>] handle_syscall+0x60/0x80
Aug 22 20:25:47 trinity kernel: [<0804d120>] ? pidmap_init+0x8b/0xaf
Aug 22 20:25:47 trinity kernel: [<084c06ac>] ? ptrace+0x2c/0x70
Aug 22 20:25:47 trinity kernel: [<080794a2>] ? get_fp_registers+0x22/0x40
Aug 22 20:25:47 trinity kernel: [<080745ac>] userspace+0x46c/0x5e0
Aug 22 20:25:47 trinity kernel: [<080799f6>] ? os_set_thread_area+0x26/0x40
Aug 22 20:25:47 trinity kernel: [<08078a0c>] ? do_set_thread_area+0x1c/0x50
Aug 22 20:25:47 trinity kernel: [<08078b88>] ? arch_switch_tls+0xb8/0x100
Aug 22 20:25:47 trinity kernel: [<0805f720>] fork_handler+0x60/0x70
Aug 22 20:25:47 trinity kernel:


-- 
Toralf

