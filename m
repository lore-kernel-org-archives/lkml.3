Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab3H1Vwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:52:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:18127 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468Ab3H1Vwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:52:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,978,1367996400"; 
   d="scan'208";a="394965642"
Subject: [PATCH] Avoid useless inodes and dentries reclamation
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dchinner@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Aug 2013 14:52:12 -0700
Message-ID: <1377726732.3625.31.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch detects that when free inodes and dentries are really
low, their reclamation is skipped so we do not have to contend
on the global sb_lock uselessly under memory pressure. Otherwise
we create a log jam trying to acquire the sb_lock in prune_super(),
with little or no freed memory to show for the effort.

The profile below shows a multi-threaded large file read exerting
pressure on memory with page cache usage.  It is dominated
by the sb_lock contention in the cpu cycles profile.  The patch
eliminates the sb_lock contention almost entirely for prune_super().

    43.94%           usemem  [kernel.kallsyms]             [k] _raw_spin_lock
                     |
                     --- _raw_spin_lock
                        |
                        |--32.44%-- grab_super_passive
                        |          prune_super
                        |          shrink_slab
                        |          do_try_to_free_pages
                        |          try_to_free_pages
                        |          __alloc_pages_nodemask
                        |          alloc_pages_current
                        |
                        |--32.18%-- put_super
                        |          drop_super
                        |          prune_super
                        |          shrink_slab
                        |          do_try_to_free_pages
                        |          try_to_free_pages
                        |          __alloc_pages_nodemask
                        |          alloc_pages_current

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 fs/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index 68307c0..70fa26c 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -53,6 +53,7 @@ static char *sb_writers_name[SB_FREEZE_LEVELS] = {
  * shrinker path and that leads to deadlock on the shrinker_rwsem. Hence we
  * take a passive reference to the superblock to avoid this from occurring.
  */
+#define SB_CACHE_LOW 5
 static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct super_block *sb;
@@ -68,6 +69,13 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
 	if (sc->nr_to_scan && !(sc->gfp_mask & __GFP_FS))
 		return -1;
 
+	/*
+	 * Don't prune if we have few cached objects to reclaim to
+	 * avoid useless sb_lock contention
+	 */
+	if ((sb->s_nr_dentry_unused + sb->s_nr_inodes_unused) <= SB_CACHE_LOW)
+		return -1;
+
 	if (!grab_super_passive(sb))
 		return -1;
 
-- 
1.7.11.7


