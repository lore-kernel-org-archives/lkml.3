Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab3BSA41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 19:56:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24670 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346Ab3BSA40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 19:56:26 -0500
Message-ID: <5122CD9C.9070702@oracle.com>
Date: Mon, 18 Feb 2013 19:55:56 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: sched: BUG in load_balance
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest, running today's -next,
I've stumbled on the following spew.

I've cc'ed Steven Rostedt since the culprit looks like "sched: Enable
interrupts in idle_balance()".

[  119.938711] ------------[ cut here ]------------
[  119.940026] kernel BUG at kernel/sched/fair.c:5032!
[  119.940026] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  119.945222] Dumping ftrace buffer:
[  119.945222]    (ftrace buffer empty)
[  119.945222] Modules linked in:
[  119.945222] CPU 2
[  119.945222] Pid: 11768, comm: trinity Tainted: G        W    3.8.0-rc7-next-20130218-sasha-00028-gc234b2b #289
[  119.945222] RIP: 0010:[<ffffffff8115d0c6>]  [<ffffffff8115d0c6>] load_balance+0x176/0x700
[  119.945222] RSP: 0000:ffff8800a5041db8  EFLAGS: 00010246
[  119.945222] RAX: ffff8800bb7d7180 RBX: ffff8800bb7d7180 RCX: 000000000000003b
[  119.945222] RDX: 000000000000001f RSI: 0000000000000005 RDI: 0000000000000005
[  119.945222] RBP: ffff8800a5041e98 R08: ffff8800b9e91018 R09: 0000000000000000
[  119.945222] R10: 0000000000100000 R11: ffff8800b9e92800 R12: ffff8800a5041e18
[  119.945222] R13: 00000000ffffba0d R14: 0000000000000001 R15: 0000000000000000
[  119.945222] FS:  00007fd2cf680700(0000) GS:ffff8800bba00000(0000) knlGS:0000000000000000
[  119.945222] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  119.945222] CR2: 00007fd2cf56f064 CR3: 00000000a660a000 CR4: 00000000000406e0
[  119.945222] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  119.945222] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  119.945222] Process trinity (pid: 11768, threadinfo ffff8800a5040000, task ffff8800a66d8000)
[  119.945222] Stack:
[  119.945222]  ffffffff83d93b85 0000000000000286 ffff8800bbbd79a8 ffff8800a66d8910
[  119.945222]  ffff8800a5041ed4 ffff8800bb0084a0 0000000200000002 ffff8800b9e92400
[  119.945222]  00000000001d7180 0000000000000002 00000000001d7180 0000000000000286
[  119.945222] Call Trace:
[  119.945222]  [<ffffffff83d93b85>] ? _raw_spin_unlock_irqrestore+0x55/0xa0
[  119.945222]  [<ffffffff8115de26>] idle_balance+0x306/0x400
[  119.945222]  [<ffffffff8115dcd3>] ? idle_balance+0x1b3/0x400
[  119.945222]  [<ffffffff811552ab>] post_schedule_idle+0x1b/0x30
[  119.945222]  [<ffffffff8114e769>] schedule_tail+0x59/0xb0
[  119.945222]  [<ffffffff83d9c48f>] ret_from_fork+0xf/0xb0
[  119.945222] Code: 48 85 c0 48 89 c3 75 1d 4c 8b b5 58 ff ff ff 48 8b 95 68 ff ff ff 41 83 84 96 c4 00 00 00 01 e9 20 05 00 00
90 48 3b 45 98 75 0a <0f> 0b 0f 1f 84 00 00 00 00 00 48 8b 45 b0 48 8b 8d 68 ff ff ff
[  119.945222] RIP  [<ffffffff8115d0c6>] load_balance+0x176/0x700
[  119.945222]  RSP <ffff8800a5041db8>
[  120.050138] ---[ end trace cece54224dce81b2 ]---


Thanks,
Sasha
