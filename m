Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965326Ab3GCTQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:16:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933591Ab3GCTAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:14 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=3secFIVIplEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=qDHKUpw6SRIA:10 a=20KFwNOVAAAA:8 a=ufHFDILaAAAA:8 a=omOdbC7AAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=pQFG53Joc4AfjvbZiugA:9 a=jEp0ucaQiEUA:10 a=l7ZknGph1ugA:10 a=UTB_XpHje0EA:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184107.792578937@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:41:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Rafael Aquini <aquini@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Shaohua Li <shli@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [127/141] swap: avoid read_swap_cache_async() race to deadlock while waiting
 on discard I/O completion
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0127-swap-avoid-read_swap_cache_async-race-to-deadlock-wh.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Rafael Aquini <aquini@redhat.com>

[ Upstream commit cbab0e4eec299e9059199ebe6daf48730be46d2b ]

read_swap_cache_async() can race against get_swap_page(), and stumble
across a SWAP_HAS_CACHE entry in the swap map whose page wasn't brought
into the swapcache yet.

This transient swap_map state is expected to be transitory, but the
actual placement of discard at scan_swap_map() inserts a wait for I/O
completion thus making the thread at read_swap_cache_async() to loop
around its -EEXIST case, while the other end at get_swap_page() is
scheduled away at scan_swap_map().  This can leave the system deadlocked
if the I/O completion happens to be waiting on the CPU waitqueue where
read_swap_cache_async() is busy looping and !CONFIG_PREEMPT.

This patch introduces a cond_resched() call to make the aforementioned
read_swap_cache_async() busy loop condition to bail out when necessary,
thus avoiding the subtle race window.

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/swap_state.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 0cb36fb..f854fbd 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -314,8 +314,24 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		 * Swap entry may have been freed since our caller observed it.
 		 */
 		err = swapcache_prepare(entry);
-		if (err == -EEXIST) {	/* seems racy */
+		if (err == -EEXIST) {
 			radix_tree_preload_end();
+			/*
+			 * We might race against get_swap_page() and stumble
+			 * across a SWAP_HAS_CACHE swap_map entry whose page
+			 * has not been brought into the swapcache yet, while
+			 * the other end is scheduled away waiting on discard
+			 * I/O completion at scan_swap_map().
+			 *
+			 * In order to avoid turning this transitory state
+			 * into a permanent loop around this -EEXIST case
+			 * if !CONFIG_PREEMPT and the I/O completion happens
+			 * to be waiting on the CPU waitqueue where we are now
+			 * busy looping, we just conditionally invoke the
+			 * scheduler here, if there are some more important
+			 * tasks to run.
+			 */
+			cond_resched();
 			continue;
 		}
 		if (err) {		/* swp entry is obsolete ? */
-- 
1.7.10.4


