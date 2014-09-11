Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbaIKMqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:46:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51630 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754980AbaIKMeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:07 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Filipe Manana" <fdmanana@suse.com>,
        "Chris Mason" <clm@fb.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.382124556@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 066/131] Btrfs: fix csum tree corruption, duplicate
 and outdated checksums
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/file-item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -717,7 +717,7 @@ again:
 				found_next = 1;
 			if (ret != 0)
 				goto insert;
-			slot = 0;
+			slot = path->slots[0];
 		}
 		btrfs_item_key_to_cpu(path->nodes[0], &found_key, slot);
 		if (found_key.objectid != BTRFS_EXTENT_CSUM_OBJECTID ||

