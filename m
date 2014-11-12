Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766AbaKLBgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:36:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbaKLBgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:36:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3.17 311/319] xfs: bulkstat doesnt release AGI buffer on error
Date: Wed, 12 Nov 2014 10:17:29 +0900
Message-Id: <20141112011044.320167654@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit a6bbce54efa9145dbcf3029c885549f7ebc40a3b upstream.

The recent refactoring of the bulkstat code left a small landmine in
the code. If a inobt read fails, then the tree walk is aborted and
returns without releasing the AGI buffer or freeing the cursor. This
can lead to a subsequent bulkstat call hanging trying to grab the
AGI buffer again.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_itable.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -427,7 +427,7 @@ xfs_bulkstat(
 
 			error = xfs_bulkstat_grab_ichunk(cur, agino, &icount, &r);
 			if (error)
-				break;
+				goto del_cursor;
 			if (icount) {
 				irbp->ir_startino = r.ir_startino;
 				irbp->ir_freecount = r.ir_freecount;
@@ -442,7 +442,7 @@ xfs_bulkstat(
 			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &tmp);
 		}
 		if (error)
-			break;
+			goto del_cursor;
 
 		/*
 		 * Loop through inode btree records in this ag,
@@ -454,7 +454,7 @@ xfs_bulkstat(
 			error = xfs_inobt_get_rec(cur, &r, &i);
 			if (error || i == 0) {
 				end_of_ag = 1;
-				break;
+				goto del_cursor;
 			}
 
 			/*
@@ -476,13 +476,17 @@ xfs_bulkstat(
 			error = xfs_btree_increment(cur, 0, &tmp);
 			cond_resched();
 		}
+
 		/*
-		 * Drop the btree buffers and the agi buffer.
-		 * We can't hold any of the locks these represent
-		 * when calling iget.
+		 * Drop the btree buffers and the agi buffer as we can't hold any
+		 * of the locks these represent when calling iget. If there is a
+		 * pending error, then we are done.
 		 */
+del_cursor:
 		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 		xfs_buf_relse(agbp);
+		if (error)
+			break;
 		/*
 		 * Now format all the good inodes into the user's buffer.
 		 */


