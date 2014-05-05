Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660AbaEEMrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:47:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41042 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932323AbaEEMnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:35 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark Tinguely <tinguely@sgi.com>,
        Dave Chinner <david@fromorbit.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 36/50] xfs: fix directory hash ordering bug
Date: Mon,  5 May 2014 14:43:18 +0200
Message-Id: <fd4037cadecf7b5c0e288c19d958917ac1c62a83.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Tinguely <tinguely@sgi.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/xfs/xfs_da_btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 20bf8e8002d6..a6fcbd220f6b 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -1335,7 +1335,7 @@ xfs_da3_fixhashpath(
 		node = blk->bp->b_addr;
 		xfs_da3_node_hdr_from_disk(&nodehdr, node);
 		btree = xfs_da3_node_tree_p(node);
-		if (be32_to_cpu(btree->hashval) == lasthash)
+		if (be32_to_cpu(btree[blk->index].hashval) == lasthash)
 			break;
 		blk->hashval = lasthash;
 		btree[blk->index].hashval = cpu_to_be32(lasthash);
-- 
1.9.2

