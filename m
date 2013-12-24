Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab3LXCvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 21:51:31 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:47074 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202Ab3LXCv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 21:51:29 -0500
X-AuditID: 9c93017e-b7be0ae000007d1a-6c-52b8f6afa959
Date: Tue, 24 Dec 2013 11:51:27 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, khlebnikov@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Bob Liu <bob.liu@oracle.com>
Subject: Re: mm: kernel BUG at include/linux/swapops.h:131!
Message-ID: <20131224025127.GA2835@lge.com>
References: <52B1C143.8080301@oracle.com>
 <52B871B2.7040409@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B871B2.7040409@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 12:24:02PM -0500, Sasha Levin wrote:
> Ping?
> 
> I've also Cc'ed the "this page shouldn't be locked at all" team.

Hello,

I can't find the reason of this problem.
If it is reproducible, how about bisecting?

Thanks.

> 
> On 12/18/2013 10:37 AM, Sasha Levin wrote:
> >Hi all,
> >
> >While fuzzing with trinity inside a KVM tools guest running latest -next kernel, I've stumbled on
> >the following spew.
> >
> >The code is in zap_pte_range():
> >
> >                 if (!non_swap_entry(entry))
> >                         rss[MM_SWAPENTS]--;
> >                 else if (is_migration_entry(entry)) {
> >                         struct page *page;
> >
> >                         page = migration_entry_to_page(entry);    <==== HERE
> >
> >                         if (PageAnon(page))
> >                                 rss[MM_ANONPAGES]--;
> >                         else
> >                                 rss[MM_FILEPAGES]--;
> >
> >
> >[ 2622.589064] kernel BUG at include/linux/swapops.h:131!
> >[ 2622.589064] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> >[ 2622.589064] Dumping ftrace buffer:
> >[ 2622.589064]    (ftrace buffer empty)
> >[ 2622.589064] Modules linked in:
> >[ 2622.589064] CPU: 9 PID: 15984 Comm: trinity-child16 Tainted: G        W    3.13.0-rc
> >4-next-20131217-sasha-00013-ga878504-dirty #4150
> >[ 2622.589064] task: ffff88168346b000 ti: ffff8816561d8000 task.ti: ffff8816561d8000
> >[ 2622.589064] RIP: 0010:[<ffffffff8127c730>]  [<ffffffff8127c730>] zap_pte_range+0x360
> >/0x4a0
> >[ 2622.589064] RSP: 0018:ffff8816561d9c18  EFLAGS: 00010246
> >[ 2622.589064] RAX: ffffea00736a6600 RBX: ffff88200299d068 RCX: 0000000000000009
> >[ 2622.589064] RDX: 022fffff80380000 RSI: ffffea0000000000 RDI: 3c00000001cda998
> >[ 2622.589064] RBP: ffff8816561d9cb8 R08: 0000000000000000 R09: 0000000000000000
> >[ 2622.589064] R10: 0000000000000001 R11: 0000000000000000 R12: 00007fc7ee20d000
> >[ 2622.589064] R13: ffff8816561d9de8 R14: 000000039b53303c R15: 00007fc7ee29b000
> >[ 2622.589064] FS:  00007fc7eeceb700(0000) GS:ffff882011a00000(0000) knlGS:000000000000
> >0000
> >[ 2622.589064] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >[ 2622.589064] CR2: 000000000068c000 CR3: 0000000005c26000 CR4: 00000000000006e0
> >[ 2622.589064] Stack:
> >[ 2622.589064]  ffff8816561d9c58 0000000000000286 ffff88168327b060 ffff88168327b060
> >[ 2622.589064]  00007fc700000160 ffff881667067b88 00000000c8f4b120 00ff88168327b060
> >[ 2622.589064]  ffff88168327b060 ffff8820051a8600 0000000000000000 ffff88168327b000
> >[ 2622.589064] Call Trace:
> >[ 2622.589064]  [<ffffffff8127cc5e>] unmap_page_range+0x3ee/0x400
> >[ 2622.589064]  [<ffffffff8127cd71>] unmap_single_vma+0x101/0x120
> >[ 2622.589064]  [<ffffffff8127cdf1>] unmap_vmas+0x61/0xa0
> >[ 2622.589064]  [<ffffffff81283980>] exit_mmap+0xd0/0x170
> >[ 2622.589064]  [<ffffffff8112d430>] mmput+0x70/0xe0
> >[ 2622.589064]  [<ffffffff8113144d>] exit_mm+0x18d/0x1a0
> >[ 2622.589064]  [<ffffffff811defb5>] ? acct_collect+0x175/0x1b0
> >[ 2622.589064]  [<ffffffff8113389f>] do_exit+0x24f/0x500
> >[ 2622.589064]  [<ffffffff81133bf9>] do_group_exit+0xa9/0xe0
> >[ 2622.589064]  [<ffffffff81133c47>] SyS_exit_group+0x17/0x20
> >[ 2622.589064]  [<ffffffff843a6150>] tracesys+0xdd/0xe2
> >[ 2622.589064] Code: 83 f8 1f 75 46 48 b8 ff ff ff ff ff ff ff 01 48 be 00 00 00 00 00 ea ff ff 48
> >21 f8 48 c1 e0 06 48 01 f0 48 8b 10 80 e2 01 75 0a <0f> 0b 66 0f 1f 44 00 00 eb fe f6 40 08 01 74 05
> >ff 4d c4 eb 0b
> >[ 2622.589064] RIP  [<ffffffff8127c730>] zap_pte_range+0x360/0x4a0
> >[ 2622.589064]  RSP <ffff8816561d9c18>
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
