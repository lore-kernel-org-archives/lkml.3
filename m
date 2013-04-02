Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab3DBWoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:44:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933405Ab3DBWMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fusionio.com>,
        Lingzhu Xiang <lxiang@redhat.com>, CAI Qian <caiqian@redhat.com>
Subject: [ 091/124] Btrfs: fix space leak when we fail to reserve metadata space
Date: Tue,  2 Apr 2013 15:11:13 -0700
Message-Id: <20130402221114.673877345@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Reviewed-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |   47 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 6 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4601,14 +4601,49 @@ int btrfs_delalloc_reserve_metadata(stru
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


