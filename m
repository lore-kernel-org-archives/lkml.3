Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936489Ab3DHKSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:18:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42730 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935557Ab3DHJvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fusionio.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 031/102] Btrfs: fix space leak when we fail to reserve metadata space
Date: Mon,  8 Apr 2013 10:49:46 +0100
Message-Id: <1365414657-29191-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit f4881bc7a83eff263789dd524b7c269d138d4af5 upstream.

Dave reported a warning when running xfstest 275.  We have been leaking delalloc
metadata space when our reservations fail.  This is because we were improperly
calculating how much space to free for our checksum reservations.  The problem
is we would sometimes free up space that had already been freed in another
thread and we would end up with negative usage for the delalloc space.  This
patch fixes the problem by calculating how much space the other threads would
have already freed, and then calculate how much space we need to free had we not
done the reservation at all, and then freeing any excess space.  This makes
xfstests 275 no longer have leaked space.  Thanks

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/extent-tree.c | 47 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6e1d367..fe6cec5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4487,14 +4487,49 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 		 * If the inodes csum_bytes is the same as the original
 		 * csum_bytes then we know we haven't raced with any free()ers
 		 * so we can just reduce our inodes csum bytes and carry on.
-		 * Otherwise we have to do the normal free thing to account for
-		 * the case that the free side didn't free up its reserve
-		 * because of this outstanding reservation.
 		 */
-		if (BTRFS_I(inode)->csum_bytes == csum_bytes)
+		if (BTRFS_I(inode)->csum_bytes == csum_bytes) {
 			calc_csum_metadata_size(inode, num_bytes, 0);
-		else
-			to_free = calc_csum_metadata_size(inode, num_bytes, 0);
+		} else {
+			u64 orig_csum_bytes = BTRFS_I(inode)->csum_bytes;
+			u64 bytes;
+
+			/*
+			 * This is tricky, but first we need to figure out how much we
+			 * free'd from any free-ers that occured during this
+			 * reservation, so we reset ->csum_bytes to the csum_bytes
+			 * before we dropped our lock, and then call the free for the
+			 * number of bytes that were freed while we were trying our
+			 * reservation.
+			 */
+			bytes = csum_bytes - BTRFS_I(inode)->csum_bytes;
+			BTRFS_I(inode)->csum_bytes = csum_bytes;
+			to_free = calc_csum_metadata_size(inode, bytes, 0);
+
+
+			/*
+			 * Now we need to see how much we would have freed had we not
+			 * been making this reservation and our ->csum_bytes were not
+			 * artificially inflated.
+			 */
+			BTRFS_I(inode)->csum_bytes = csum_bytes - num_bytes;
+			bytes = csum_bytes - orig_csum_bytes;
+			bytes = calc_csum_metadata_size(inode, bytes, 0);
+
+			/*
+			 * Now reset ->csum_bytes to what it should be.  If bytes is
+			 * more than to_free then we would have free'd more space had we
+			 * not had an artificially high ->csum_bytes, so we need to free
+			 * the remainder.  If bytes is the same or less then we don't
+			 * need to do anything, the other free-ers did the correct
+			 * thing.
+			 */
+			BTRFS_I(inode)->csum_bytes = orig_csum_bytes - num_bytes;
+			if (bytes > to_free)
+				to_free = bytes - to_free;
+			else
+				to_free = 0;
+		}
 		spin_unlock(&BTRFS_I(inode)->lock);
 		if (dropped)
 			to_free += btrfs_calc_trans_metadata_size(root, dropped);
-- 
1.8.1.2

