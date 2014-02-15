Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaBOXdF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 18:33:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32466 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaBOXdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 18:33:03 -0500
Message-ID: <52FFF910.2030308@oracle.com>
Date: Sat, 15 Feb 2014 18:32:32 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
CC: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: fair: NULL ptr deref in check_preempt_wakeup
References: <52FFF7F8.2070801@oracle.com>
In-Reply-To: <52FFF7F8.2070801@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2014 06:27 PM, Sasha Levin wrote:
> Hi folks,
>
> While fuzzing with trinity inside a KVM tools guest running latest -next kernel, I've
> stumbled on the following:

As soon as I've finished writing that mail I've hit it again, with a different (but similar) stack 
trace.

[  770.993016] BUG: unable to handle kernel NULL pointer dereference at 0000000000000150
[  770.993865] IP: [<ffffffff8118ef99>] pick_next_task_fair+0x109/0x290
[  770.994531] PGD 1addee067 PUD 1addef067 PMD 0
[  770.995018] Oops: 0000 [#1] PREEMPT SMP
[  770.995573] Dumping ftrace buffer:
[  770.995928]    (ftrace buffer empty)
[  770.996304] Modules linked in:
[  770.996661] CPU: 0 PID: 13754 Comm: trinity-c155 Not tainted 3.14.0-rc2-next-20140214
[  770.997646] task: ffff88021151b000 ti: ffff88016b9f4000 task.ti: ffff88016b9f4000
[  770.998384] RIP: 0010:[<ffffffff8118ef99>]  [<ffffffff8118ef99>] pick_next_task_fair+
[  770.999254] RSP: 0018:ffff88016b9f5bc8  EFLAGS: 00010097
[  770.999787] RAX: 000000004caed01b RBX: ffff880226fd79c0 RCX: 000000000004ccca
[  771.000035] RDX: 0000000000a7076b RSI: ffff880060ff8028 RDI: ffff88008b998078
[  771.000035] RBP: ffff88016b9f5c08 R08: 0000000000000000 R09: 0000000000000001
[  771.000035] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88008b998000
[  771.000035] R13: 0000000000000000 R14: ffff880226fd7a88 R15: ffff880060ffb7c8
[  771.000035] FS:  00007f6e01002700(0000) GS:ffff880226e00000(0000) knlGS:0000000000000
[  771.000035] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  771.000035] CR2: 0000000000000150 CR3: 00000001feeef000 CR4: 00000000000006f0
[  771.000035] DR0: 00007f6e009b2000 DR1: 0000000000000000 DR2: 0000000000000000
[  771.000035] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000600
[  771.000035] Stack:
[  771.000035]  ffff880100000001 ffffffff00000001 ffff88016b9f5c08 ffff880226fd79c0
[  771.000035]  0000000000000000 ffff88021151b990 0000000000000282 00000000ffffffff
[  771.000035]  ffff88016b9f5c88 ffffffff8438ef35 ffff88016b9f5c78 ffffffff811a19a5
[  771.000035] Call Trace:
[  771.000035]  [<ffffffff8438ef35>] __schedule+0x2a5/0x840
[  771.000035]  [<ffffffff811a19a5>] ? __lock_contended+0x205/0x240
[  771.000035]  [<ffffffff8438f795>] schedule+0x65/0x70
[  771.000035]  [<ffffffff8438fb73>] schedule_preempt_disabled+0x13/0x20
[  771.000035]  [<ffffffff8439105d>] mutex_lock_nested+0x2ad/0x510
[  771.000035]  [<ffffffff812ed326>] ? lookup_slow+0x46/0xd0
[  771.000035]  [<ffffffff812ed70d>] ? unlazy_walk+0x16d/0x1e0
[  771.000035]  [<ffffffff812ed326>] ? lookup_slow+0x46/0xd0
[  771.000035]  [<ffffffff812ed326>] lookup_slow+0x46/0xd0
[  771.000035]  [<ffffffff812efbe5>] path_lookupat+0xe5/0x660
[  771.000035]  [<ffffffff812b97ea>] ? kmem_cache_alloc+0x1fa/0x300
[  771.000035]  [<ffffffff812eb497>] ? getname_flags+0x57/0x1c0
[  771.000035]  [<ffffffff812f018f>] filename_lookup+0x2f/0xd0
[  771.000035]  [<ffffffff812f155c>] user_path_at_empty+0x6c/0xb0
[  771.000035]  [<ffffffff812510b5>] ? context_tracking_user_exit+0x185/0x1c0
[  771.000035]  [<ffffffff811a3ccd>] ? trace_hardirqs_on+0xd/0x10
[  771.000035]  [<ffffffff812f15ac>] user_path_at+0xc/0x10
[  771.000035]  [<ffffffff812de913>] do_sys_truncate+0x43/0xc0
[  771.000035]  [<ffffffff812de9a9>] SyS_truncate+0x9/0x10
[  771.000035]  [<ffffffff8439f0e0>] tracesys+0xdd/0xe2
[  771.000035] Code: 4d 8b ad 48 01 00 00 39 c2 7c 19 4d 8b b7 50 01 00 00 4c 89 fe 4c 89 f7 e8 55 
98 ff ff 4d 8b bf 48 01 00 00 4d 8b b7 50 01 00 00 <49> 8b bd 50 01 00 00 49 39 fe 75 a3 4d 85 f6 74 
9e 4c 89 ee 4c
[  771.000035] RIP  [<ffffffff8118ef99>] pick_next_task_fair+0x109/0x290
[  771.000035]  RSP <ffff88016b9f5bc8>
[  771.000035] CR2: 0000000000000150
[  771.000035] ---[ end trace 408e14968ec7dd7a ]---


Thanks,
Sasha
