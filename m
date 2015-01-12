Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbbALS2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:28:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57496 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbbALSFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 043/216] Btrfs: do not move em to modified list when unpinning
Date: Mon, 12 Jan 2015 18:02:40 +0000
Message-Id: <1421085933-32536-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fb.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/extent_map.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 225302b39afb..6a98bddd8f33 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -287,8 +287,6 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
 	if (!em)
 		goto out;
 
-	if (!test_bit(EXTENT_FLAG_LOGGING, &em->flags))
-		list_move(&em->list, &tree->modified_extents);
 	em->generation = gen;
 	clear_bit(EXTENT_FLAG_PINNED, &em->flags);
 	em->mod_start = em->start;
-- 
2.1.4

