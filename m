Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbaIZKhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:37:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681AbaIZJp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:45:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Chris Mason <clm@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 010/142] Btrfs: fix csum tree corruption, duplicate and outdated checksums
Date: Fri, 26 Sep 2014 11:43:41 +0200
Message-Id: <e2e8bf61f04c4560db4bbb1cbc87334b824d892b.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 27b9a8122ff71a8cadfbffb9c4f0694300464f3b upstream.

Under rare circumstances we can end up leaving 2 versions of a checksum
for the same file extent range.

The reason for this is that after calling btrfs_next_leaf we process
slot 0 of the leaf it returns, instead of processing the slot set in
path->slots[0]. Most of the time (by far) path->slots[0] is 0, but after
btrfs_next_leaf() releases the path and before it searches for the next
leaf, another task might cause a split of the next leaf, which migrates
some of its keys to the leaf we were processing before calling
btrfs_next_leaf(). In this case btrfs_next_leaf() returns again the
same leaf but with path->slots[0] having a slot number corresponding
to the first new key it got, that is, a slot number that didn't exist
before calling btrfs_next_leaf(), as the leaf now has more keys than
it had before. So we must really process the returned leaf starting at
path->slots[0] always, as it isn't always 0, and the key at slot 0 can
have an offset much lower than our search offset/bytenr.

For example, consider the following scenario, where we have:

sums->bytenr: 40157184, sums->len: 16384, sums end: 40173568
four 4kb file data blocks with offsets 40157184, 40161280, 40165376, 40169472

  Leaf N:

    slot = 0                           slot = btrfs_header_nritems() - 1
  |-------------------------------------------------------------------|
  | [(CSUM CSUM 39239680), size 8] ... [(CSUM CSUM 40116224), size 4] |
  |-------------------------------------------------------------------|

  Leaf N + 1:

      slot = 0                          slot = btrfs_header_nritems() - 1
  |--------------------------------------------------------------------|
  | [(CSUM CSUM 40161280), size 32] ... [((CSUM CSUM 40615936), size 8 |
  |--------------------------------------------------------------------|

Because we are at the last slot of leaf N, we call btrfs_next_leaf() to
find the next highest key, which releases the current path and then searches
for that next key. However after releasing the path and before finding that
next key, the item at slot 0 of leaf N + 1 gets moved to leaf N, due to a call
to ctree.c:push_leaf_left() (via ctree.c:split_leaf()), and therefore
btrfs_next_leaf() will returns us a path again with leaf N but with the slot
pointing to its new last key (CSUM CSUM 40161280). This new version of leaf N
is then:

    slot = 0                        slot = btrfs_header_nritems() - 2  slot = btrfs_header_nritems() - 1
  |----------------------------------------------------------------------------------------------------|
  | [(CSUM CSUM 39239680), size 8] ... [(CSUM CSUM 40116224), size 4]  [(CSUM CSUM 40161280), size 32] |
  |----------------------------------------------------------------------------------------------------|

And incorrecly using slot 0, makes us set next_offset to 39239680 and we jump
into the "insert:" label, which will set tmp to:

    tmp = min((sums->len - total_bytes) >> blocksize_bits,
        (next_offset - file_key.offset) >> blocksize_bits) =
    min((16384 - 0) >> 12, (39239680 - 40157184) >> 12) =
    min(4, (u64)-917504 = 18446744073708634112 >> 12) = 4

and

   ins_size = csum_size * tmp = 4 * 4 = 16 bytes.

In other words, we insert a new csum item in the tree with key
(CSUM_OBJECTID CSUM_KEY 40157184 = sums->bytenr) that contains the checksums
for all the data (4 blocks of 4096 bytes each = sums->len). Which is wrong,
because the item with key (CSUM CSUM 40161280) (the one that was moved from
leaf N + 1 to the end of leaf N) contains the old checksums of the last 12288
bytes of our data and won't get those old checksums removed.

So this leaves us 2 different checksums for 3 4kb blocks of data in the tree,
and breaks the logical rule:

   Key_N+1.offset >= Key_N.offset + length_of_data_its_checksums_cover

An obvious bad effect of this is that a subsequent csum tree lookup to get
the checksum of any of the blocks with logical offset of 40161280, 40165376
or 40169472 (the last 3 4kb blocks of file data), will get the old checksums.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/file-item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 4f53159bdb9d..d4731e9808ea 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -752,7 +752,7 @@ again:
 				found_next = 1;
 			if (ret != 0)
 				goto insert;
-			slot = 0;
+			slot = path->slots[0];
 		}
 		btrfs_item_key_to_cpu(path->nodes[0], &found_key, slot);
 		if (found_key.objectid != BTRFS_EXTENT_CSUM_OBJECTID ||
-- 
2.1.0

