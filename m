Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaEBQPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:15:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29904 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbaEBQPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:15:34 -0400
Message-ID: <5363C49F.9030305@oracle.com>
Date: Fri, 02 May 2014 12:15:27 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>
Subject: mm: invalid memory access in alloc_vmap_area
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel I've stumbled on the following:

[  194.505728] BUG: unable to handle kernel paging request at ffffffffffffffd0
[  194.508364] IP: alloc_vmap_area (mm/vmalloc.c:427)
[  194.509482] PGD 3be30067 PUD 3be32067 PMD 0
[  194.510158] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  194.510158] Dumping ftrace buffer:
[  194.512198]    (ftrace buffer empty)
[  194.512198] Modules linked in:
[  194.512198] CPU: 7 PID: 9950 Comm: trinity-c319 Tainted: G        W     3.15.0-rc3-next-20140430-sasha-00016-g4e281fa-dirty #429
[  194.512198] task: ffff88000c270000 ti: ffff88000c26c000 task.ti: ffff88000c26c000
[  194.512198] RIP: alloc_vmap_area (mm/vmalloc.c:427)
[  194.512198] RSP: 0018:ffff88000c26dd78  EFLAGS: 00010203
[  194.512198] RAX: 0000000000000000 RBX: ffffffffffffffff RCX: 000000000000e000
[  194.512198] RDX: 0000000000000000 RSI: ffffffffffffffd0 RDI: 0000000000001000
[  194.512198] RBP: ffff88000c26ddd8 R08: 000036fffb628000 R09: 0000000000000000
[  194.512198] R10: 0000000000000001 R11: 0000000000000000 R12: ffffe8ffffffffff
[  194.512198] R13: ffffc90000000000 R14: 0000000000000001 R15: 000000000000e000
[  194.512198] FS:  00007fc5908c1700(0000) GS:ffff8801ecc00000(0000) knlGS:0000000000000000
[  194.512198] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  194.512198] CR2: ffffffffffffffd0 CR3: 000000000c259000 CR4: 00000000000006a0
[  194.512198] DR0: 00000000006de000 DR1: 0000000000000000 DR2: 0000000000000000
[  194.512198] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000602
[  194.512198] Stack:
[  194.512198]  ffff8805bbf73ac8 0000000000000000 ffff8805bbf73ae0 0000000000000086
[  194.512198]  ffffc9000000e000 ffffc90000000000 ffff88000c26ddb8 0000000000000022
[  194.512198]  0000000000000001 ffffc90000000000 ffffe8ffffffffff ffff8801ebcca1b0
[  194.512198] Call Trace:
[  194.512198] __get_vm_area_node (mm/vmalloc.c:1337)
[  194.512198] ? vtime_account_user (kernel/sched/cputime.c:687)
[  194.512198] __vmalloc_node_range (mm/vmalloc.c:1647)
[  194.512198] ? SyS_init_module (kernel/module.c:2505 kernel/module.c:3348 kernel/module.c:3336)
[  194.512198] ? vtime_account_user (kernel/sched/cputime.c:687)
[  194.512198] ? context_tracking_user_exit (include/linux/vtime.h:89 include/linux/jump_label.h:105 include/trace/events/context_tracking.h:47 kernel/context_tracking.c:178)
[  194.512198] __vmalloc_node (mm/vmalloc.c:1696)
[  194.512198] ? SyS_init_module (kernel/module.c:2505 kernel/module.c:3348 kernel/module.c:3336)
[  194.512198] vmalloc (mm/vmalloc.c:1725)
[  194.512198] SyS_init_module (kernel/module.c:2505 kernel/module.c:3348 kernel/module.c:3336)
[  194.512198] tracesys (arch/x86/kernel/entry_64.S:746)
[  194.554072] Code: 39 d1 49 0f 42 f8 49 8d 44 06 ff 48 21 d8 48 89 c1 4c 01 f9 0f 82 9f 00 00 00 48 8b 56 30 48 81 fa c0 e4 ad bc 74 22 48 8d 72 d0 <48> 8b 52 d0 48 39 ca 73 15 0f 1f 44 00 00 49 39 cc 73 b3 eb 79
[  194.554072] RIP alloc_vmap_area (mm/vmalloc.c:427)
[  194.554072]  RSP <ffff88000c26dd78>
[  194.554072] CR2: ffffffffffffffd0


Thanks,
Sasha
