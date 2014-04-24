Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaDXJpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:45:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46832 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaDXIzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:55:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Tinguely <tinguely@sgi.com>, Dave Chinner <david@fromorbit.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 122/182] xfs: fix directory hash ordering bug
Date: Thu, 24 Apr 2014 09:50:47 +0100
Message-Id: <1398329507-5911-123-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Tinguely <tinguely@sgi.com>

commit c88547a8119e3b581318ab65e9b72f27f23e641d upstream.

Commit f5ea1100 ("xfs: add CRCs to dir2/da node blocks") introduced
in 3.10 incorrectly converted the btree hash index array pointer in
xfs_da3_fixhashpath(). It resulted in the the current hash always
being compared against the first entry in the btree rather than the
current block index into the btree block's hash entry array. As a
result, it was comparing the wrong hashes, and so could misorder the
entries in the btree.

For most cases, this doesn't cause any problems as it requires hash
collisions to expose the ordering problem. However, when there are
hash collisions within a directory there is a very good probability
that the entries will be ordered incorrectly and that actually
matters when duplicate hashes are placed into or removed from the
btree block hash entry array.

This bug results in an on-disk directory corruption and that results
in directory verifier functions throwing corruption warnings into
the logs. While no data or directory entries are lost, access to
them may be compromised, and attempts to remove entries from a
directory that has suffered from this corruption may result in a
filesystem shutdown.  xfs_repair will fix the directory hash
ordering without data loss occuring.

[dchinner: wrote useful a commit message]

Reported-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/xfs/xfs_da_btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index eca6f9d..79ddbaf 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -1334,7 +1334,7 @@ xfs_da3_fixhashpath(
 		node = blk->bp->b_addr;
 		xfs_da3_node_hdr_from_disk(&nodehdr, node);
 		btree = xfs_da3_node_tree_p(node);
-		if (be32_to_cpu(btree->hashval) == lasthash)
+		if (be32_to_cpu(btree[blk->index].hashval) == lasthash)
 			break;
 		blk->hashval = lasthash;
 		btree[blk->index].hashval = cpu_to_be32(lasthash);
-- 
1.9.1

