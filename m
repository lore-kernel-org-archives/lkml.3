Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437Ab3JKUX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:23:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab3JKTkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Tinguely <tinguely@sgi.com>, Ben Myers <bpm@sgi.com>
Subject: [ 098/110] xfs: fix node forward in xfs_node_toosmall
Date: Fri, 11 Oct 2013 12:39:18 -0700
Message-Id: <20131011193818.477652239@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Tinguely <tinguely@sgi.com>

commit 997def25e4b9cee3b01609e18a52f926bca8bd2b upstream.

Commit f5ea1100 cleans up the disk to host conversions for
node directory entries, but because a variable is reused in
xfs_node_toosmall() the next node is not correctly found.
If the original node is small enough (<= 3/8 of the node size),
this change may incorrectly cause a node collapse when it should
not. That will cause an assert in xfstest generic/319:

   Assertion failed: first <= last && last < BBTOB(bp->b_length),
   file: /root/newest/xfs/fs/xfs/xfs_trans_buf.c, line: 569

Keep the original node header to get the correct forward node.

(When a node is considered for a merge with a sibling, it overwrites the
 sibling pointers of the original incore nodehdr with the sibling's
 pointers.  This leads to loop considering the original node as a merge
 candidate with itself in the second pass, and so it incorrectly
 determines a merge should occur.)

[v3: added Dave Chinner's (slightly modified) suggestion to the commit header,
	cleaned up whitespace.  -bpm]

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/xfs/xfs_da_btree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -1223,6 +1223,7 @@ xfs_da3_node_toosmall(
 	/* start with smaller blk num */
 	forward = nodehdr.forw < nodehdr.back;
 	for (i = 0; i < 2; forward = !forward, i++) {
+		struct xfs_da3_icnode_hdr thdr;
 		if (forward)
 			blkno = nodehdr.forw;
 		else
@@ -1235,10 +1236,10 @@ xfs_da3_node_toosmall(
 			return(error);
 
 		node = bp->b_addr;
-		xfs_da3_node_hdr_from_disk(&nodehdr, node);
+		xfs_da3_node_hdr_from_disk(&thdr, node);
 		xfs_trans_brelse(state->args->trans, bp);
 
-		if (count - nodehdr.count >= 0)
+		if (count - thdr.count >= 0)
 			break;	/* fits with at least 25% to spare */
 	}
 	if (i >= 2) {


