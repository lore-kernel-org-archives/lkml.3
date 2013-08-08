Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275Ab3HHNTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:19:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4339 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934211Ab3HHNTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:19:54 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=p_SSGwTpz_kA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=2IV2AVxXqaEA:10 a=VwQbUJbxAAAA:8 a=UOTN6ITBXivppveW-sIA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375967992.6848.55.camel@gandalf.local.home>
Subject: [PATCH] Revert "slub: do not put a slab to cpu partial list when
 cpu_partial is 0"
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Christoph Lameeter <cl@linux.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>
Date: Thu, 08 Aug 2013 09:19:52 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 318df36e57c0ca9f2146660d41ff28e8650af423

When a box sets all cpu_partials to zero (for example with:

 find /sys/kernel/slab -name 'cpu_partial' -print | \
    while read f; do echo 0 > $f; done
)

and runs hackbench 50, a memory leak occurs rapidly, and the system can
crash with:

[   74.172202] hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_score_adj=0
[   74.179968] hackbench cpuset=/ mems_allowed=0
[   74.184345] CPU: 4 PID: 6390 Comm: hackbench Not tainted 3.11.0-rc4-test+ #28
[   74.191503] Hardware name: Hewlett-Packard HP Compaq Pro 6300 SFF/339A, BIOS K01 v02.05 05/07/2012
[   74.200477]  0000000000000000 ffff880011cbb8a8 ffffffff8162024f 00000000000000cc
[   74.207965]  ffff880011c6c650 ffff880011cbb928 ffffffff8161ca6e 000000000000821b
[   74.215482]  0000000000000b31 ffff880011cbb8d8 ffffffff810f15fe ffff880000000000
[   74.223082] Call Trace:
[   74.225548]  [<ffffffff8162024f>] dump_stack+0x46/0x58
[   74.230721]  [<ffffffff8161ca6e>] dump_header+0x7a/0x1be
[   74.236055]  [<ffffffff810f15fe>] ? __delayacct_freepages_end+0x2e/0x30
[   74.242699]  [<ffffffff812ee4c3>] ? ___ratelimit+0x93/0x110
[   74.248291]  [<ffffffff8112f65b>] oom_kill_process+0x1cb/0x330
[   74.254149]  [<ffffffff8105da15>] ? has_ns_capability_noaudit+0x15/0x20
[   74.260803]  [<ffffffff8105da37>] ? has_capability_noaudit+0x17/0x20
[   74.267188]  [<ffffffff8112fe20>] out_of_memory+0x470/0x4c0
[   74.272785]  [<ffffffff81135659>] __alloc_pages_nodemask+0xab9/0xad0
[   74.279166]  [<ffffffff810a857c>] ? ktime_get_ts+0x4c/0xe0
[   74.284669]  [<ffffffff81173cb3>] alloc_pages_vma+0xa3/0x150
[   74.290345]  [<ffffffff8116786b>] read_swap_cache_async+0x10b/0x190
[   74.296626]  [<ffffffff8116798e>] swapin_readahead+0x9e/0xf0
[   74.302299]  [<ffffffff81154e4f>] handle_pte_fault+0x29f/0xa60
[   74.308147]  [<ffffffff811567d6>] handle_mm_fault+0x256/0x5d0
[   74.313908]  [<ffffffff8162aa02>] __do_page_fault+0x182/0x4c0
[   74.319671]  [<ffffffff81194eac>] ? vfs_write+0x17c/0x200
[   74.325081]  [<ffffffff8162ad4e>] do_page_fault+0xe/0x10
[   74.330405]  [<ffffffff816273f2>] page_fault+0x22/0x30


Joonsoo Kim said that if cpu_partial is set to zero, the following can
happen:

"In this case, memory leak is possible in following case.
Code flow of possible leak is follwing case.

* in __slab_free()
1. (!new.inuse || !prior) && !was_frozen
2. !kmem_cache_debug && !prior
3. new.frozen = 1
4. after cmpxchg_double_slab, run the (!n) case with new.frozen=1
5. with this patch, put_cpu_partial() doesn't do anything,
        because this cache's cpu_partial is 0
6. return

In step 5, leak occur."

Joonsoo said that there's a better fix for this problem, but for now the
best thing to do is to revert the patch that causes the leak.

Link:
https://lkml.kernel.org/r/1375934936.6848.41.camel@gandalf.local.home

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/mm/slub.c b/mm/slub.c
index 2b02d66..e3ba1f2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1968,9 +1968,6 @@ static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
 	int pages;
 	int pobjects;
 
-	if (!s->cpu_partial)
-		return;
-
 	do {
 		pages = 0;
 		pobjects = 0;


