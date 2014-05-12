Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbaELMrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 08:47:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50585 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202AbaELMrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 08:47:15 -0400
Message-ID: <5370C2B5.7020700@oracle.com>
Date: Mon, 12 May 2014 08:46:45 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: jlbec@evilplan.org
Subject: configfs: NULL ptr deref in configfs_lookup
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel I've stumbled on the following spew:

[  400.588117] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
[  400.590137] IP: configfs_lookup (fs/configfs/dir.c:467)
[  400.590137] PGD 1e5d5a067 PUD 1e5d5b067 PMD 0
[  400.590137] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  400.590137] Dumping ftrace buffer:
[  400.590137]    (ftrace buffer empty)
[  400.590137] Modules linked in:
[  400.590137] CPU: 30 PID: 10751 Comm: trinity-c387 Tainted: G        W     3.15.0-rc5-next-20140512-sasha-00019-ga20bc00-dirty #456
[  400.590137] task: ffff8801e5d7b000 ti: ffff8801e5d76000 task.ti: ffff8801e5d76000
[  400.590137] RIP: configfs_lookup (fs/configfs/dir.c:467)
[  400.590137] RSP: 0018:ffff8801e5d77cb8  EFLAGS: 00010282
[  400.590137] RAX: 0000000000000000 RBX: fffffffffffffff8 RCX: 0000005d44e90770
[  400.590137] RDX: 0000000000000001 RSI: ffffffff9c3a51c0 RDI: ffffffff9f58b685
[  400.590137] RBP: ffff8801e5d77ce8 R08: 000000000000c3e6 R09: 0000000000000000
[  400.590137] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880000094510
[  400.590137] R13: ffff8806ca053528 R14: 00000000ffffff9c R15: ffff8801e5d77e70
[  400.590137] FS:  00007fd417ee9700(0000) GS:ffff8806cae00000(0000) knlGS:0000000000000000
[  400.590137] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  400.590137] CR2: 0000000000000038 CR3: 00000001e5d59000 CR4: 00000000000006a0
[  400.614494] DR0: 00000000006df000 DR1: 0000000000000000 DR2: 0000000000000000
[  400.614494] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000602
[  400.614494] Stack:
[  400.614494]  ffff8800365625f8 ffff8801e5d77e80 ffff8801e5d77d18 ffff8806ca053528
[  400.614494]  ffff8800365625f8 ffff8800365625f8 ffff8801e5d77d18 ffffffff9c31e086
[  400.614494]  ffff8800365625f8 ffff8800365625f8 00000000ffffff9c 0000000000000001
[  400.614494] Call Trace:
[  400.614494] lookup_real (fs/namei.c:1331)
[  400.614494] __lookup_hash (fs/namei.c:1349)
[  400.614494] lookup_slow (fs/namei.c:1459)
[  400.614494] path_lookupat (fs/namei.c:1539 fs/namei.c:1909 fs/namei.c:1943)
[  400.614494] ? kmem_cache_alloc (include/linux/kmemleak.h:44 mm/slub.c:975 mm/slub.c:2481 mm/slub.c:2489 mm/slub.c:2494)
[  400.614494] ? getname_flags (fs/namei.c:145)
[  400.614494] ? getname_flags (fs/namei.c:145)
[  400.627077] ? vtime_account_user (kernel/sched/cputime.c:687)
[  400.627077] filename_lookup (fs/namei.c:1983)
[  400.627077] user_path_at_empty (fs/namei.c:2134)
[  400.627077] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[  400.627077] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2557 kernel/locking/lockdep.c:2599)
[  400.627077] ? trace_hardirqs_on (kernel/locking/lockdep.c:2607)
[  400.627077] user_path_at (fs/namei.c:2145)
[  400.627077] SyS_removexattr (fs/xattr.c:651 fs/xattr.c:644)
[  400.627077] ? tracesys (arch/x86/kernel/entry_64.S:735)
[  400.627077] tracesys (arch/x86/kernel/entry_64.S:746)
[  400.627077] Code: fa ff ff 89 c2 48 c7 c0 fe ff ff ff 85 d2 0f 84 57 01 00 00 49 8b 44 24 18 49 83 c4 18 48 8d 58 f8 49 39 c4 0f 84 29 01 00 00 90 <f6> 43 40 04 0f 84 de 00 00 00 48 89 df e8 8e d7 ff ff 49 8b 75
[  400.627077] RIP configfs_lookup (fs/configfs/dir.c:467)
[  400.627077]  RSP <ffff8801e5d77cb8>
[  400.627077] CR2: 0000000000000038


Thanks,
Sasha
