Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbbAIKe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:34:29 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44651 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757530AbbAIKca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:30 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 74/78] Btrfs: do not move em to modified list when unpinning
Date: Fri,  9 Jan 2015 11:32:23 +0100
Message-Id: <f25952649585cdd0643741a50d02d600fcc28ef2.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a28046956c71985046474283fa3bcd256915fb72 upstream.

We use the modified list to keep track of which extents have been modified so we
know which ones are candidates for logging at fsync() time.  Newly modified
extents are added to the list at modification time, around the same time the
ordered extent is created.  We do this so that we don't have to wait for ordered
extents to complete before we know what we need to log.  The problem is when
something like this happens

log extent 0-4k on inode 1
copy csum for 0-4k from ordered extent into log
sync log
commit transaction
log some other extent on inode 1
ordered extent for 0-4k completes and adds itself onto modified list again
log changed extents
see ordered extent for 0-4k has already been logged
	at this point we assume the csum has been copied
sync log
crash

On replay we will see the extent 0-4k in the log, drop the original 0-4k extent
which is the same one that we are replaying which also drops the csum, and then
we won't find the csum in the log for that bytenr.  This of course causes us to
have errors about not having csums for certain ranges of our inode.  So remove
the modified list manipulation in unpin_extent_cache, any modified extents
should have been added well before now, and we don't want them re-logged.  This
fixes my test that I could reliably reproduce this problem with.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/extent_map.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index a4a7a1a8da95..0a3809500599 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -263,8 +263,6 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
 	if (!em)
 		goto out;
 
-	if (!test_bit(EXTENT_FLAG_LOGGING, &em->flags))
-		list_move(&em->list, &tree->modified_extents);
 	em->generation = gen;
 	clear_bit(EXTENT_FLAG_PINNED, &em->flags);
 	em->mod_start = em->start;
-- 
2.2.1

