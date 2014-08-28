Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbaH1Swi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:52:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbaH1Sgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:50 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 62/97] mm: fix direct reclaim writeback regression
Date: Thu, 28 Aug 2014 19:35:10 +0100
Message-Id: <1409250945-30874-63-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit 8bdd638091605dc66d92c57c4b80eb87fffc15f7 upstream.

Shortly before 3.16-rc1, Dave Jones reported:

  WARNING: CPU: 3 PID: 19721 at fs/xfs/xfs_aops.c:971
           xfs_vm_writepage+0x5ce/0x630 [xfs]()
  CPU: 3 PID: 19721 Comm: trinity-c61 Not tainted 3.15.0+ #3
  Call Trace:
    xfs_vm_writepage+0x5ce/0x630 [xfs]
    shrink_page_list+0x8f9/0xb90
    shrink_inactive_list+0x253/0x510
    shrink_lruvec+0x563/0x6c0
    shrink_zone+0x3b/0x100
    shrink_zones+0x1f1/0x3c0
    try_to_free_pages+0x164/0x380
    __alloc_pages_nodemask+0x822/0xc90
    alloc_pages_vma+0xaf/0x1c0
    handle_mm_fault+0xa31/0xc50
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

Yes, 3.16-rc1's commit 68711a746345 ("mm, migration: add destination
page freeing callback") has provided such a way to compaction: if
migrating a SwapBacked page fails, its newpage may be put back on the
list for later use with PageSwapBacked still set, and nothing will clear
it.

Whether that can do anything worse than issue WARN_ON_ONCEs, and get
some statistics wrong, is unclear: easier to fix than to think through
the consequences.

Fixing it here, before the put_new_page(), addresses the bug directly,
but is probably the worst place to fix it.  Page migration is doing too
many parts of the job on too many levels: fixing it in
move_to_new_page() to complement its SetPageSwapBacked would be
preferable, except why is it (and newpage->mapping and newpage->index)
done there, rather than down in migrate_page_move_mapping(), once we are
sure of success? Not a cleanup to get into right now, especially not
with memcg cleanups coming in 3.17.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/migrate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index e397bd2..96d4d81 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -919,9 +919,10 @@ out:
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
-- 
1.8.4.5

