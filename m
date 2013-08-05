Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3HEVU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 17:20:28 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29096 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab3HEVU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 17:20:27 -0400
Message-ID: <520016D6.8010603@oracle.com>
Date: Mon, 05 Aug 2013 17:19:18 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, paulus@samba.org,
        Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        Tejun Heo <tj@kernel.org>, cl@linux-foundation.org
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, trinity@vger.kernel.org
Subject: perf, percpu: panic in account_event
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next kernel,
I've stumbled on the following spew.

It seems to happen on the following line in account_event():

	if (event->attr.freq)
		atomic_inc(&per_cpu(perf_freq_events, cpu));  <--- here

Which was recently introduced in commit ("perf: Account freq events per cpu"). Although
the commit is new, it's very simple and straightforward - I can't see anything wrong with
it so maybe the fault is in percpu?

[ 4299.619701] BUG: unable to handle kernel paging request at 0000000f001d1ed6
[ 4299.620150] IP: [<ffffffff8120afb4>] account_event+0xe4/0x100
[ 4299.620150] PGD 5f30f067 PUD 0
[ 4299.620150] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 4299.620150] Modules linked in:
[ 4299.620150] CPU: 14 PID: 15329 Comm: trinity-child56 Tainted: G        W 
3.11.0-rc4-next-20130805-sasha-00003-g07015f7 #3976
[ 4299.620150] task: ffff880176510000 ti: ffff8800c624a000 task.ti: ffff8800c624a000
[ 4299.620150] RIP: 0010:[<ffffffff8120afb4>]  [<ffffffff8120afb4>] account_event+0xe4/0x100
[ 4299.620150] RSP: 0018:ffff8800c624be68  EFLAGS: 00010212
[ 4299.620150] RAX: ffffffffffffffff RBX: 0000000000000000 RCX: 0000000000000000
[ 4299.627928] RDX: 0000000f001d1ed6 RSI: 00000000001dbbf8 RDI: ffff880179a437b0
[ 4299.627928] RBP: ffff8800c624be68 R08: 00000000e26ec8c5 R09: 0000000000000001
[ 4299.627928] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880176510000
[ 4299.627928] R13: ffff880179a437b0 R14: 0000000000000000 R15: 0000000000000000
[ 4299.627928] FS:  00007fe6a0bbb700(0000) GS:ffff880226200000(0000) knlGS:0000000000000000
[ 4299.627928] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4299.627928] CR2: 0000000f001d1ed6 CR3: 0000000059995000 CR4: 00000000000006e0
[ 4299.627928] Stack:
[ 4299.627928]  ffff8800c624bf68 ffffffff81215fe8 0000000000000000 ffff880176510610
[ 4299.627928]  0000000000000001 ffffffff81a37a00 ffff880176510610 0000000000000000
[ 4299.627928]  0000000000000000 0000014584098985 0000004000000001 0000000000000004
[ 4299.627928] Call Trace:
[ 4299.627928]  [<ffffffff81215fe8>] SYSC_perf_event_open+0x4e8/0x910
[ 4299.627928]  [<ffffffff81a37a00>] ? do_raw_spin_unlock+0xd0/0xe0
[ 4299.627928]  [<ffffffff81216419>] SyS_perf_event_open+0x9/0x10
[ 4299.627928]  [<ffffffff840a14ec>] tracesys+0xdd/0xe2
[ 4299.627928] Code: c7 c2 c0 1e 1d 00 48 03 14 cd 80 7b 60 86 f0 ff 02 f6 87 c9 00 00 00 04 74 1d 
48 98 48 c7 c2 c8 1e 1d 00 48 03 14 c5 80 7b 60 86 <f0> ff 02 66 0f 1f 84 00 00 00 00 00 c9 c3 66 66 
66 66 66 2e 0f
[ 4299.627928] RIP  [<ffffffff8120afb4>] account_event+0xe4/0x100
[ 4299.627928]  RSP <ffff8800c624be68>
[ 4299.627928] CR2: 0000000f001d1ed6


Thanks,
Sasha
