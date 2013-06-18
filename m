Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab3FRLpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:45:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56258 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495Ab3FRLpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:45:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rafael Aquini <aquini@redhat.com>, Shaohua Li <shli@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 78/93] swap: avoid read_swap_cache_async() race to deadlock while waiting on discard I/O completion
Date: Tue, 18 Jun 2013 12:43:26 +0100
Message-Id: <1371555821-12820-79-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael Aquini <aquini@redhat.com>

commit cbab0e4eec299e9059199ebe6daf48730be46d2b upstream.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/swap_state.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 4c5ff7f..1fa9220 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -313,8 +313,24 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
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
1.8.1.2

