Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3LSAQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:16:51 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:59062 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3LSAQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:16:50 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH] mm/rmap: fix BUG at rmap_walk 
Date: Thu, 19 Dec 2013 08:16:35 +0800
Message-Id: <1387412195-26498-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121900-9574-0000-0000-00000B197DEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page_get_anon_vma() called in page_referenced_anon() will lock and 
increase the refcount of anon_vma, page won't be locked for anonymous 
page. This patch fix it by skip check anonymous page locked.

[  588.698828] kernel BUG at mm/rmap.c:1663!
[  588.699380] invalid opcode: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
[  588.700347] Dumping ftrace buffer:
[  588.701186]    (ftrace buffer empty)
[  588.702062] Modules linked in:
[  588.702759] CPU: 0 PID: 4647 Comm: kswapd0 Tainted: G      D W    3.13.0-rc4-next-20131218-sasha-00012-g1962367-dirty #4155
[  588.704330] task: ffff880062bcb000 ti: ffff880062450000 task.ti: ffff880062450000
[  588.705507] RIP: 0010:[<ffffffff81289c80>]  [<ffffffff81289c80>] rmap_walk+0x10/0x50
[  588.706800] RSP: 0018:ffff8800624518d8  EFLAGS: 00010246
[  588.707515] RAX: 000fffff80080048 RBX: ffffea00000227c0 RCX: 0000000000000000
[  588.707515] RDX: 0000000000000000 RSI: ffff8800624518e8 RDI: ffffea00000227c0
[  588.707515] RBP: ffff8800624518d8 R08: ffff8800624518e8 R09: 0000000000000000
[  588.707515] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800624519d8
[  588.707515] R13: 0000000000000000 R14: ffffea00000227e0 R15: 0000000000000000
[  588.707515] FS:  0000000000000000(0000) GS:ffff880065200000(0000) knlGS:0000000000000000
[  588.707515] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  588.707515] CR2: 00007fec40cbe0f8 CR3: 00000000c2382000 CR4: 00000000000006f0
[  588.707515] Stack:
[  588.707515]  ffff880062451958 ffffffff81289f4b ffff880062451918 ffffffff81289f80
[  588.707515]  0000000000000000 0000000000000000 ffffffff8128af60 0000000000000000
[  588.707515]  0000000000000024 0000000000000000 0000000000000000 0000000000000286
[  588.707515] Call Trace:
[  588.707515]  [<ffffffff81289f4b>] page_referenced+0xcb/0x100
[  588.707515]  [<ffffffff81289f80>] ? page_referenced+0x100/0x100
[  588.707515]  [<ffffffff8128af60>] ? invalid_page_referenced_vma+0x170/0x170
[  588.707515]  [<ffffffff81264302>] shrink_active_list+0x212/0x330
[  588.707515]  [<ffffffff81260e23>] ? inactive_file_is_low+0x33/0x50
[  588.707515]  [<ffffffff812646f5>] shrink_lruvec+0x2d5/0x300
[  588.707515]  [<ffffffff812647b6>] shrink_zone+0x96/0x1e0
[  588.707515]  [<ffffffff81265b06>] kswapd_shrink_zone+0xf6/0x1c0
[  588.707515]  [<ffffffff81265f43>] balance_pgdat+0x373/0x550
[  588.707515]  [<ffffffff81266d63>] kswapd+0x2f3/0x350
[  588.707515]  [<ffffffff81266a70>] ? perf_trace_mm_vmscan_lru_isolate_template+0x120/0x120
[  588.707515]  [<ffffffff8115c9c5>] kthread+0x105/0x110
[  588.707515]  [<ffffffff8115c8c0>] ? set_kthreadd_affinity+0x30/0x30
[  588.707515]  [<ffffffff843a6a7c>] ret_from_fork+0x7c/0xb0
[  588.707515]  [<ffffffff8115c8c0>] ? set_kthreadd_affinity+0x30/0x30
[  588.707515] Code: c0 48 83 c4 18 89 d0 5b 41 5c 41 5d 41 5e 41 5f c9 c3 66 0f 1f 84
00 00 00 00 00 55 48 89 e5 66 66 66 66 90 48 8b 07 a8 01 75 10 <0f> 0b 66 0f 1f 44 00 0
0 eb fe 66 0f 1f 44 00 00 f6 47 08 01 74
[  588.707515] RIP  [<ffffffff81289c80>] rmap_walk+0x10/0x50
[  588.707515]  RSP <ffff8800624518d8>

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/rmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index d792e71..daf20d5 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1660,7 +1660,8 @@ done:
 
 int rmap_walk(struct page *page, struct rmap_walk_control *rwc)
 {
-	VM_BUG_ON(!PageLocked(page));
+	if (!PageAnon(page) || PageKsm(page))
+		VM_BUG_ON(!PageLocked(page));
 
 	if (unlikely(PageKsm(page)))
 		return rmap_walk_ksm(page, rwc);
-- 
1.8.3.2

