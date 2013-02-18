Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3BRCwG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 21:52:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49155 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab3BRCwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 21:52:04 -0500
Message-ID: <51219742.1000301@oracle.com>
Date: Sun, 17 Feb 2013 21:51:46 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: ebiederm@xmission.com
CC: Andrew Morton <akpm@linux-foundation.org>, serge.hallyn@canonical.com,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: BUG in find_pid_ns
References: <512117D5.3050602@oracle.com> <87ppzyqxu6.fsf@xmission.com>
In-Reply-To: <87ppzyqxu6.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2013 07:17 PM, ebiederm@xmission.com wrote:
> The bad pointer value is 0xfffffffffffffff0.  Hmm.
> 
> If you have the failure location correct it looks like a corrupted hash
> entry was found while following the hash chain.
> 
> It looks like the memory has been set to -16 -EBUSY? Weird.
> 
> It smells like something is stomping on the memory of a struct pid, with
> the same hash value and thus in the same hash chain as the current pid.
> 
> Can you reproduce this?

I've just reproduced it again:

[ 2404.518957] BUG: unable to handle kernel paging request at fffffffffffffff0
[ 2404.520024] IP: [<ffffffff81131d50>] find_pid_ns+0x110/0x1f0
[ 2404.520024] PGD 5429067 PUD 542b067 PMD 0
[ 2404.520024] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 2404.520024] Dumping ftrace buffer:
[ 2404.520024]    (ftrace buffer empty)
[ 2404.520024] Modules linked in:
[ 2404.520024] CPU 3
[ 2404.520024] Pid: 6890, comm: trinity Tainted: G        W    3.8.0-rc7-next-20130215-sasha-00027-gb399f44-dirty #288
[ 2404.520024] RIP: 0010:[<ffffffff81131d50>]  [<ffffffff81131d50>] find_pid_ns+0x110/0x1f0
[ 2404.520024] RSP: 0018:ffff8800af1dfe18  EFLAGS: 00010286
[ 2404.520024] RAX: 0000000000000001 RBX: 0000000000004b72 RCX: 0000000000000000
[ 2404.520024] RDX: 0000000000000001 RSI: ffffffff85466e40 RDI: 0000000000000286
[ 2404.520024] RBP: ffff8800af1dfe48 R08: 0000000000000001 R09: 0000000000000001
[ 2404.520024] R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff85466460
[ 2404.520024] R13: ffff8800bf8d3ef8 R14: fffffffffffffff0 R15: ffff8800a43d9a40
[ 2404.520024] FS:  00007f8300f79700(0000) GS:ffff8800bbc00000(0000) knlGS:0000000000000000
[ 2404.520024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2404.520024] CR2: fffffffffffffff0 CR3: 00000000af0b7000 CR4: 00000000000406e0
[ 2404.520024] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2404.520024] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2404.520024] Process trinity (pid: 6890, threadinfo ffff8800af1de000, task ffff8800b060b000)
[ 2404.520024] Stack:
[ 2404.520024]  ffffffff85466e40 0000000000004b72 ffff8800af1dfed8 0000000000000000
[ 2404.520024]  0000000000000003 20c49ba5e353f7cf ffff8800af1dfe58 ffffffff81131e5c
[ 2404.520024]  ffff8800af1dfec8 ffffffff8112400f ffffffff81123f9c 0000000000000000
[ 2404.520024] Call Trace:
[ 2404.520024]  [<ffffffff81131e5c>] find_vpid+0x2c/0x30
[ 2404.520024]  [<ffffffff8112400f>] kill_something_info+0x9f/0x270
[ 2404.673395]  [<ffffffff81123f9c>] ? kill_something_info+0x2c/0x270
[ 2404.673395]  [<ffffffff81125e38>] sys_kill+0x88/0xa0
[ 2404.673395]  [<ffffffff8107ad34>] ? syscall_trace_enter+0x24/0x2e0
[ 2404.694324]  [<ffffffff811813b8>] ? trace_hardirqs_on_caller+0x128/0x160
[ 2404.694324]  [<ffffffff83d96275>] ? tracesys+0x7e/0xe6
[ 2404.694324]  [<ffffffff83d962d8>] tracesys+0xe1/0xe6
[ 2404.694324] Code: 4d 8b 75 00 e8 b2 0e 00 00 85 c0 0f 84 d2 00 00 00 80 3d fa 17 d5 04 00 0f 85 c5 00 00 00 e9 93 00 00 00 0f
1f 84 00 00 00 00 00 <41> 39 1e 75 2b 4d 39 66 08 75 25 41 8b 84 24 20 08 00 00 48 c1
[ 2404.733487] RIP  [<ffffffff81131d50>] find_pid_ns+0x110/0x1f0
[ 2404.740299]  RSP <ffff8800af1dfe18>
[ 2404.740299] CR2: fffffffffffffff0
[ 2404.740299] ---[ end trace 9f8bc22bbe4fe990 ]---

I'm not sure what debug info I could throw in which will be helpful. Dump
the entire chain or table if 'pnr' happens to look odd?

> Memory corruption is hard to trace down with just a single data point.
> 
> Looking a little closer Sasha you have rewritten
> hlist_for_each_entry_rcu, and that seems to be the most recent patch
> dealing with pids, and we are failing in hlist_for_each_entry_rcu.
> 
> I haven't looked at your patch in enough detail to know if you have
> missed something or not, but a brand new patch and a brand new failure
> certainly look suspicious at first glance.

Agreed, I've also took a second look at it when this BUG popped up. What
surprises me about it is that if the new iteration is broken, the kernel
would spectacularly break in a bunch of places instead of failing in the
exact same place twice.

Not ignoring the possibility it's broken though.


Thanks,
Sasha
