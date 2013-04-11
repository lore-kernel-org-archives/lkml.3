Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935502Ab3DKVTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:19:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4377 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935471Ab3DKUsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:55 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=7JO_WXpox2EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=c141nPkKEmIA:10 a=vpVRfoo1AAAA:8 a=VwQbUJbxAAAA:8 a=0u0nhMPvhaUjrep2UKUA:9 a=0yVQzcu7H6MA:10 a=jeBq3FmKZ4MA:10 a=_INW_wqmVuC4EhIw:21 a=ipRlBlmf3etX93Bb:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202609.909003478@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fusionio.com>
Subject: [ 144/171 ] Btrfs: fix space leak when we fail to reserve metadata space
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0144-Btrfs-fix-space-leak-when-we-fail-to-reserve-metadat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

[ Upstream commit f4881bc7a83eff263789dd524b7c269d138d4af5 ]

Dave reported a warning when running xfstest 275.  We have been leaking delalloc
metadata space when our reservations fail.  This is because we were improperly
calculating how much space to free for our checksum reservations.  The problem
is we would sometimes free up space that had already been freed in another
thread and we would end up with negative usage for the delalloc space.  This
patch fixes the problem by calculating how much space the other threads would
have already freed, and then calculate how much space we need to free had we not
done the reservation at all, and then freeing any excess space.  This makes
xfstests 275 no longer have leaked space.  Thanks

Cc: stable@vger.kernel.org
Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/btrfs/extent-tree.c |   47 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f1bdfb5..6d7b589 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4582,14 +4582,49 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
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
1.7.10.4


