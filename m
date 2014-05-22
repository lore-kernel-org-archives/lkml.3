Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaEVN6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:58:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbaEVN6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:58:40 -0400
Date: Thu, 22 May 2014 09:58:28 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: 3.15.0-rc6: VM_BUG_ON_PAGE(PageTail(page), page)
Message-ID: <20140522135828.GA24879@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if Sasha has already reported this on -next (It's getting hard
to keep track of all the VM bugs he's been finding), but I hit this overnight
on .15-rc6.  First time I've seen this one.


page:ffffea0004599800 count:0 mapcount:0 mapping:          (null) index:0x2
page flags: 0x20000000008000(tail)
------------[ cut here ]------------
kernel BUG at include/linux/page-flags.h:415!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU: 1 PID: 6858 Comm: trinity-c42 Not tainted 3.15.0-rc6+ #216
task: ffff88012d18e900 ti: ffff88009e87a000 task.ti: ffff88009e87a000
RIP: 0010:[<ffffffffbb718d98>]  [<ffffffffbb718d98>] PageTransHuge.part.23+0xb/0xd
RSP: 0000:ffff88009e87b940  EFLAGS: 00010246
RAX: 0000000000000001 RBX: 0000000000116660 RCX: 0000000000000006
RDX: 0000000000000000 RSI: ffffffffbb0c00f8 RDI: ffffffffbb0bfed2
RBP: ffff88009e87b940 R08: ffffffffbc01203c R09: 00000000000003da
R10: 00000000000003d9 R11: 0000000000000003 R12: 0000000000000001
R13: 0000000000116800 R14: ffff88024d64ce00 R15: ffffea0004599800
FS:  00007f4fd192e740(0000) GS:ffff88024d040000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000004c00000 CR3: 00000000a19ce000 CR4: 00000000001407e0
DR0: 00000000024f4000 DR1: 0000000001d43000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 ffff88009e87b9e8 ffffffffbb1728a3 ffff88009e87b9e8 ffff88009e87baa8
 ffff88012d18e900 ffff88009e87ba60 0000000000000000 0000000400000016
 0000000000000000 ffff88009e87bfd8 00000000000008b3 ffff88009e87ba50
Call Trace:
 [<ffffffffbb1728a3>] isolate_migratepages_range+0x7a3/0x870
 [<ffffffffbb172d90>] compact_zone+0x370/0x560
 [<ffffffffbb173022>] compact_zone_order+0xa2/0x110
 [<ffffffffbb1733f1>] try_to_compact_pages+0x101/0x130
 [<ffffffffbb71861b>] __alloc_pages_direct_compact+0xac/0x1d0
 [<ffffffffbb15760b>] __alloc_pages_nodemask+0x6ab/0xaf0
 [<ffffffffbb19c9ea>] alloc_pages_vma+0x9a/0x160
 [<ffffffffbb1aef0d>] do_huge_pmd_anonymous_page+0xfd/0x3c0
 [<ffffffffbb0a19cd>] ? get_parent_ip+0xd/0x50
 [<ffffffffbb17ac18>] handle_mm_fault+0x158/0xcb0
 [<ffffffffbb72594d>] ? retint_restore_args+0xe/0xe
 [<ffffffffbb728bb6>] __do_page_fault+0x1a6/0x620
 [<ffffffffbb11011e>] ? __acct_update_integrals+0x8e/0x120
 [<ffffffffbb0a19cd>] ? get_parent_ip+0xd/0x50
 [<ffffffffbb72949b>] ? preempt_count_sub+0x6b/0xf0
 [<ffffffffbb72904e>] do_page_fault+0x1e/0x70
Code: 75 1d 55 be 6c 00 00 00 48 c7 c7 8a 2f a2 bb 48 89 e5 e8 6c 49 95 ff 5d c6 05 74 16 65 00 01 c3 55 31 f6 48 89 e5 e8 28 bd a3 ff <0f> 0b 0f 1f 44 00 00 55 48 89 e5 41 57 45 31 ff 41 56 49 89 fe 
RIP  [<ffffffffbb718d98>]

That BUG is..

413 static inline int PageTransHuge(struct page *page)
414 {
415         VM_BUG_ON_PAGE(PageTail(page), page);
416         return PageHead(page);
417 }

