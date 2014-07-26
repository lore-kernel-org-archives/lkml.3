Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaGZUAP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:00:15 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:47949 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbaGZUAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 16:00:09 -0400
Date: Sat, 26 Jul 2014 12:58:23 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Dave Jones <davej@redhat.com>,
        Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] mm: fix direct reclaim writeback regression
Message-ID: <alpine.LSU.2.11.1407261248140.13796@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shortly before 3.16-rc1, Dave Jones reported:

WARNING: CPU: 3 PID: 19721 at fs/xfs/xfs_aops.c:971
         xfs_vm_writepage+0x5ce/0x630 [xfs]()
CPU: 3 PID: 19721 Comm: trinity-c61 Not tainted 3.15.0+ #3
Call Trace:
 [<ffffffffc023068e>] xfs_vm_writepage+0x5ce/0x630 [xfs]
 [<ffffffff8316f759>] shrink_page_list+0x8f9/0xb90
 [<ffffffff83170123>] shrink_inactive_list+0x253/0x510
 [<ffffffff83170c93>] shrink_lruvec+0x563/0x6c0
 [<ffffffff83170e2b>] shrink_zone+0x3b/0x100
 [<ffffffff831710e1>] shrink_zones+0x1f1/0x3c0
 [<ffffffff83171414>] try_to_free_pages+0x164/0x380
 [<ffffffff83163e52>] __alloc_pages_nodemask+0x822/0xc90
 [<ffffffff831abeff>] alloc_pages_vma+0xaf/0x1c0
 [<ffffffff8318a931>] handle_mm_fault+0xa31/0xc50
etc.

 970   if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
 971                   PF_MEMALLOC))

I did not respond at the time, because a glance at the PageDirty block
in shrink_page_list() quickly shows that this is impossible: we don't do
writeback on file pages (other than tmpfs) from direct reclaim nowadays.
Dave was hallucinating, but it would have been disrespectful to say so.

However, my own /var/log/messages now shows similar complaints
WARNING: CPU: 1 PID: 28814 at fs/ext4/inode.c:1881 ext4_writepage+0xa7/0x38b()
WARNING: CPU: 0 PID: 27347 at fs/ext4/inode.c:1764 ext4_writepage+0xa7/0x38b()
from stressing some mmotm trees during July.

Could a dirty xfs or ext4 file page somehow get marked PageSwapBacked,
so fail shrink_page_list()'s page_is_file_cache() test, and so proceed
to mapping->a_ops->writepage()?

Yes, 3.16-rc1's 68711a746345 ("mm, migration: add destination page
freeing callback") has provided such a way to compaction: if migrating
a SwapBacked page fails, its newpage may be put back on the list for
later use with PageSwapBacked still set, and nothing will clear it.

Whether that can do anything worse than issue WARN_ON_ONCEs, and get
some statistics wrong, is unclear: easier to fix than to think through
the consequences.

Fixing it here, before the put_new_page(), addresses the bug directly,
but is probably the worst place to fix it.  Page migration is doing too
many parts of the job on too many levels: fixing it in move_to_new_page()
to complement its SetPageSwapBacked would be preferable, except why is it
(and newpage->mapping and newpage->index) done there, rather than down in
migrate_page_move_mapping(), once we are sure of success?  Not a cleanup
to get into right now, especially not with memcg cleanups coming in 3.17.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/migrate.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- 3.16-rc6/mm/migrate.c	2014-06-29 15:22:10.584003935 -0700
+++ linux/mm/migrate.c	2014-07-26 11:28:34.488126591 -0700
@@ -988,9 +988,10 @@ out:
 	 * it.  Otherwise, putback_lru_page() will drop the reference grabbed
 	 * during isolation.
 	 */
-	if (rc != MIGRATEPAGE_SUCCESS && put_new_page)
+	if (rc != MIGRATEPAGE_SUCCESS && put_new_page) {
+		ClearPageSwapBacked(newpage);
 		put_new_page(newpage, private);
-	else
+	} else
 		putback_lru_page(newpage);
 
 	if (result) {
