Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933802AbaKLBgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:36:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933779AbaKLBgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:36:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3.17 313/319] xfs: bulkstat btree walk doesnt terminate
Date: Wed, 12 Nov 2014 10:17:31 +0900
Message-Id: <20141112011044.636843196@linuxfoundation.org>
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

commit afa947cb52a8e73fe71915a0b0af6fcf98dfbe1a upstream.

The bulkstat code has several different ways of detecting the end of
an AG when doing a walk. They are not consistently detected, and the
code that checks for the end of AG conditions is not consistently
coded. Hence the are conditions where the walk code can get stuck in
an endless loop making no progress and not triggering any
termination conditions.

Convert all the "tmp/i" status return codes from btree operations
to a common name (stat) and apply end-of-ag detection to these
operations consistently.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_itable.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -356,7 +356,6 @@ xfs_bulkstat(
 	int			end_of_ag; /* set if we've seen the ag end */
 	int			error;	/* error code */
 	int                     fmterror;/* bulkstat formatter result */
-	int			i;	/* loop index */
 	int			icount;	/* count of inodes good in irbuf */
 	size_t			irbsize; /* size of irec buffer in bytes */
 	xfs_ino_t		ino;	/* inode number (filesystem) */
@@ -366,11 +365,11 @@ xfs_bulkstat(
 	xfs_ino_t		lastino; /* last inode number returned */
 	int			nirbuf;	/* size of irbuf */
 	int			rval;	/* return value error code */
-	int			tmp;	/* result value from btree calls */
 	int			ubcount; /* size of user's buffer */
 	int			ubleft;	/* bytes left in user's buffer */
 	char			__user *ubufp;	/* pointer into user's buffer */
 	int			ubelem;	/* spaces used in user's buffer */
+	int			stat;
 
 	/*
 	 * Get the last inode value, see if there's nothing to do.
@@ -436,13 +435,15 @@ xfs_bulkstat(
 				agino = r.ir_startino + XFS_INODES_PER_CHUNK;
 			}
 			/* Increment to the next record */
-			error = xfs_btree_increment(cur, 0, &tmp);
+			error = xfs_btree_increment(cur, 0, &stat);
 		} else {
 			/* Start of ag.  Lookup the first inode chunk */
-			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &tmp);
+			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &stat);
 		}
-		if (error)
+		if (error || stat == 0) {
+			end_of_ag = 1;
 			goto del_cursor;
+		}
 
 		/*
 		 * Loop through inode btree records in this ag,
@@ -451,8 +452,8 @@ xfs_bulkstat(
 		while (irbp < irbufend && icount < ubcount) {
 			struct xfs_inobt_rec_incore	r;
 
-			error = xfs_inobt_get_rec(cur, &r, &i);
-			if (error || i == 0) {
+			error = xfs_inobt_get_rec(cur, &r, &stat);
+			if (error || stat == 0) {
 				end_of_ag = 1;
 				goto del_cursor;
 			}
@@ -473,8 +474,8 @@ xfs_bulkstat(
 			 * Set agino to after this chunk and bump the cursor.
 			 */
 			agino = r.ir_startino + XFS_INODES_PER_CHUNK;
-			error = xfs_btree_increment(cur, 0, &tmp);
-			if (error) {
+			error = xfs_btree_increment(cur, 0, &stat);
+			if (error || stat == 0) {
 				end_of_ag = 1;
 				goto del_cursor;
 			}


