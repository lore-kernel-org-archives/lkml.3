Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaDUEgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:36:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbaDUEfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:35:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Mark Tinguely <tinguely@sgi.com>, Ben Myers <bpm@sgi.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3.13 18/32] xfs: fix directory hash ordering bug
Date: Sun, 20 Apr 2014 19:13:35 -0700
Message-Id: <20140421021136.365957377@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140421021133.865086647@linuxfoundation.org>
References: <20140421021133.865086647@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_da_btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -1295,7 +1295,7 @@ xfs_da3_fixhashpath(
 		node = blk->bp->b_addr;
 		dp->d_ops->node_hdr_from_disk(&nodehdr, node);
 		btree = dp->d_ops->node_tree_p(node);
-		if (be32_to_cpu(btree->hashval) == lasthash)
+		if (be32_to_cpu(btree[blk->index].hashval) == lasthash)
 			break;
 		blk->hashval = lasthash;
 		btree[blk->index].hashval = cpu_to_be32(lasthash);


