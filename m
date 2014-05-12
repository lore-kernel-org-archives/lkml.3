Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016AbaELRZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:25:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:36532 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaELRZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:25:40 -0400
Date: Mon, 12 May 2014 19:25:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: perf: NULL ptr deref in perf_event_mmap
Message-ID: <20140512172531.GE13467@laptop.programming.kicks-ass.net>
References: <5370EDC7.3000603@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5370EDC7.3000603@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 11:50:31AM -0400, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following spew:
> 
> [ 1269.713185] BUG: unable to handle kernel NULL pointer dereference at 00000000000000e0
> [ 1269.714984] IP: d_path (fs/dcache.c:2947)
> [ 1269.716054] PGD 2a460b067 PUD 2b3e44067 PMD 0
> [ 1269.716929] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [ 1269.718188] Dumping ftrace buffer:
> [ 1269.719440]    (ftrace buffer empty)
> [ 1269.720043] Modules linked in:
> [ 1269.720043] CPU: 27 PID: 41680 Comm: trinity-c243 Tainted: G        W     3.15.0-rc5-next-20140512-sasha-00019-ga20bc00-dirty #456
> [ 1269.722525] task: ffff880100a90000 ti: ffff8801362f8000 task.ti: ffff8801362f8000
> [ 1269.722525] RIP: d_path (fs/dcache.c:2947)
> [ 1269.722525] RSP: 0018:ffff8801362f9d58  EFLAGS: 00010296
> [ 1269.722525] RAX: ffff88062855e660 RBX: ffff8803d5120e10 RCX: 00000000000000d0
> [ 1269.722525] RDX: 0000000000000ff8 RSI: ffff88062855d668 RDI: 0000000000000000
> [ 1269.722525] RBP: ffff8801362f9db8 R08: 0000000000000000 R09: 0000000000000000
> [ 1269.722525] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88062855d668
> [ 1269.722525] R13: ffff8803d5120e00 R14: 00007fbd5e7e9000 R15: ffff880627b61600
> [ 1269.722525] FS:  00007fbd5e7da700(0000) GS:ffff880628e00000(0000) knlGS:0000000000000000
> [ 1269.722525] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1269.722525] CR2: 00000000000000e0 CR3: 00000002b3fd7000 CR4: 00000000000006a0
> [ 1269.722525] DR0: 00000000006df000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1269.722525] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000030602
> [ 1269.722525] Stack:
> [ 1269.722525]  ffff8802c70ee798 ffffffff8f27dc2e 000000000000001b 00000ff800001000
> [ 1269.722525]  0000000000000000 ffff88062855e660 00007fbd5e7e9000 ffff8801362f9dd8
> [ 1269.722525]  ffff8801362f9dd8 ffff88062855d668 ffff8803d5120e00 00007fbd5e7e9000
> [ 1269.722525] Call Trace:
> [ 1269.722525] ? perf_event_mmap (kernel/events/core.c:5206 kernel/events/core.c:5308)
> [ 1269.722525] perf_event_mmap (kernel/events/core.c:5216 kernel/events/core.c:5308)
> [ 1269.722525] mprotect_fixup (mm/mprotect.c:337)
> [ 1269.722525] ? SyS_mprotect (mm/mprotect.c:377 mm/mprotect.c:345)
> [ 1269.722525] SyS_mprotect (mm/mprotect.c:424 mm/mprotect.c:345)
> [ 1269.722525] tracesys (arch/x86/kernel/entry_64.S:746)
> [ 1269.722525] Code: 48 63 c2 48 89 e5 48 83 ec 60 48 01 f0 48 89 5d e0 48 89 fb 4c 89 65 e8 4c 89 6d f0 4c 89 75 f8 48 8b 7f 08 89 55 bc 48 89 45 c8 <48> 8b 8f e0 00 00 00 48 85 c9 74 23 48 8b 49 40 48 85 c9 74 1a
> [ 1269.722525] RIP d_path (fs/dcache.c:2947)
> [ 1269.722525]  RSP <ffff8801362f9d58>
> [ 1269.722525] CR2: 00000000000000e0

Al, any clues? We're calling d_path() on whatever VMA just got changed,
and I was under the impression that our usage in perf_event_mmap_event()
was good -- its certainly not changed recently.
