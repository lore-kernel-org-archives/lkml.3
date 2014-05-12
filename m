Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaELTdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 15:33:21 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:16456 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaELTdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 15:33:19 -0400
Message-ID: <537121DE.9030408@oracle.com>
Date: Mon, 12 May 2014 15:32:46 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: perf: NULL ptr deref in perf_event_mmap
References: <5370EDC7.3000603@oracle.com> <20140512172531.GE13467@laptop.programming.kicks-ass.net>
In-Reply-To: <20140512172531.GE13467@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 01:25 PM, Peter Zijlstra wrote:
> On Mon, May 12, 2014 at 11:50:31AM -0400, Sasha Levin wrote:
>> Hi all,
>>
>> While fuzzing with trinity inside a KVM tools guest running the latest -next
>> kernel I've stumbled on the following spew:
>>
>> [ 1269.713185] BUG: unable to handle kernel NULL pointer dereference at 00000000000000e0
>> [ 1269.714984] IP: d_path (fs/dcache.c:2947)
>> [ 1269.716054] PGD 2a460b067 PUD 2b3e44067 PMD 0
>> [ 1269.716929] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>> [ 1269.718188] Dumping ftrace buffer:
>> [ 1269.719440]    (ftrace buffer empty)
>> [ 1269.720043] Modules linked in:
>> [ 1269.720043] CPU: 27 PID: 41680 Comm: trinity-c243 Tainted: G        W     3.15.0-rc5-next-20140512-sasha-00019-ga20bc00-dirty #456
>> [ 1269.722525] task: ffff880100a90000 ti: ffff8801362f8000 task.ti: ffff8801362f8000
>> [ 1269.722525] RIP: d_path (fs/dcache.c:2947)
>> [ 1269.722525] RSP: 0018:ffff8801362f9d58  EFLAGS: 00010296
>> [ 1269.722525] RAX: ffff88062855e660 RBX: ffff8803d5120e10 RCX: 00000000000000d0
>> [ 1269.722525] RDX: 0000000000000ff8 RSI: ffff88062855d668 RDI: 0000000000000000
>> [ 1269.722525] RBP: ffff8801362f9db8 R08: 0000000000000000 R09: 0000000000000000
>> [ 1269.722525] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88062855d668
>> [ 1269.722525] R13: ffff8803d5120e00 R14: 00007fbd5e7e9000 R15: ffff880627b61600
>> [ 1269.722525] FS:  00007fbd5e7da700(0000) GS:ffff880628e00000(0000) knlGS:0000000000000000
>> [ 1269.722525] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [ 1269.722525] CR2: 00000000000000e0 CR3: 00000002b3fd7000 CR4: 00000000000006a0
>> [ 1269.722525] DR0: 00000000006df000 DR1: 0000000000000000 DR2: 0000000000000000
>> [ 1269.722525] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000030602
>> [ 1269.722525] Stack:
>> [ 1269.722525]  ffff8802c70ee798 ffffffff8f27dc2e 000000000000001b 00000ff800001000
>> [ 1269.722525]  0000000000000000 ffff88062855e660 00007fbd5e7e9000 ffff8801362f9dd8
>> [ 1269.722525]  ffff8801362f9dd8 ffff88062855d668 ffff8803d5120e00 00007fbd5e7e9000
>> [ 1269.722525] Call Trace:
>> [ 1269.722525] ? perf_event_mmap (kernel/events/core.c:5206 kernel/events/core.c:5308)
>> [ 1269.722525] perf_event_mmap (kernel/events/core.c:5216 kernel/events/core.c:5308)
>> [ 1269.722525] mprotect_fixup (mm/mprotect.c:337)
>> [ 1269.722525] ? SyS_mprotect (mm/mprotect.c:377 mm/mprotect.c:345)
>> [ 1269.722525] SyS_mprotect (mm/mprotect.c:424 mm/mprotect.c:345)
>> [ 1269.722525] tracesys (arch/x86/kernel/entry_64.S:746)
>> [ 1269.722525] Code: 48 63 c2 48 89 e5 48 83 ec 60 48 01 f0 48 89 5d e0 48 89 fb 4c 89 65 e8 4c 89 6d f0 4c 89 75 f8 48 8b 7f 08 89 55 bc 48 89 45 c8 <48> 8b 8f e0 00 00 00 48 85 c9 74 23 48 8b 49 40 48 85 c9 74 1a
>> [ 1269.722525] RIP d_path (fs/dcache.c:2947)
>> [ 1269.722525]  RSP <ffff8801362f9d58>
>> [ 1269.722525] CR2: 00000000000000e0
> 
> Al, any clues? We're calling d_path() on whatever VMA just got changed,
> and I was under the impression that our usage in perf_event_mmap_event()
> was good -- its certainly not changed recently.
> 

Something tells me that this is related:

[ 5163.461367] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 5163.463245] Dumping ftrace buffer:
[ 5163.464523]    (ftrace buffer empty)
[ 5163.465129] Modules linked in:
[ 5163.465760] CPU: 25 PID: 12379 Comm: trinity-c25 Tainted: G    B         3.15.0-rc5-next-20140512-sasha-00019-ga20bc00-dirty #456
[ 5163.467903] task: ffff88006ad58000 ti: ffff88002c578000 task.ti: ffff88002c578000
[ 5163.469089] RIP: get_unmapped_area (mm/mmap.c:1975 (discriminator 1))
[ 5163.470052] RSP: 0018:ffff88002c579ee8  EFLAGS: 00010282
[ 5163.470052] RAX: 6b6b6b6b6b6b6b6b RBX: 0000000000001000 RCX: 0000000000000001
[ 5163.470052] RDX: ffffffff8d078540 RSI: 0000000000100000 RDI: ffff8805bbb56c80
[ 5163.470052] RBP: ffff88002c579ef8 R08: 0000000000000011 R09: 0000000000000000
[ 5163.470052] R10: ffff88059103ea00 R11: 0000000000000246 R12: 00007f0cc4eb0000
[ 5163.475185] R13: 0000000000001000 R14: 0000000000001000 R15: 0000000000000003
[ 5163.475185] FS:  00007f0cc4ea4700(0000) GS:ffff8805bce00000(0000) knlGS:0000000000000000
[ 5163.475185] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5163.475185] CR2: 0000000000000001 CR3: 000000000b0c9000 CR4: 00000000000006a0
[ 5163.475185] Stack:
[ 5163.475185]  0000000000001000 00007f0cc4eb0000 ffff88002c579f78 ffffffff8d2c75ec
[ 5163.475185]  ffff88002c579f58 ffff88006ad58000 ffff88059103ea00 0000000000100000
[ 5163.475185]  00007f0cc4eb0000 00007f0cc4ec3898 0000000000000000 0000000000000000
[ 5163.475185] Call Trace:
[ 5163.475185] SyS_mremap (mm/mremap.c:442 mm/mremap.c:508 mm/mremap.c:477)
[ 5163.475185] tracesys (arch/x86/kernel/entry_64.S:746)
[ 5163.475185] Code: 73 0c 48 c7 c0 f4 ff ff ff e9 b8 00 00 00 65 48 8b 04 25 c0 da 00 00 48 8b 80 a8 07 00 00 48 85 ff 48 8b 50 18 74 17 48 8b 47 28 <48> 8b 80 a8 00 00 00 48 85 c0 48 0f 44 c2 eb 0b 0f 1f 00 48 89
[ 5163.475185] RIP get_unmapped_area (mm/mmap.c:1975 (discriminator 1))
[ 5163.475185]  RSP <ffff88002c579ee8>

        get_area = current->mm->get_unmapped_area;
        if (file && file->f_op->get_unmapped_area) <=== HERE
                get_area = file->f_op->get_unmapped_area;
        addr = get_area(file, addr, len, pgoff, flags);
        if (IS_ERR_VALUE(addr))
                return addr;

'file' was freed underneath mremap (notice the poison), and I don't see any recent change
in the mm/ code that could cause that.


Thanks,
Sasha
