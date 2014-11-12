Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965316AbaKLDPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:15:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933805AbaKLBgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:36:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3.17 316/319] xfs: bulkstat main loop logic is a mess
Date: Wed, 12 Nov 2014 10:17:34 +0900
Message-Id: <20141112011045.153175893@linuxfoundation.org>
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

commit 6e57c542cb7e0e580eb53ae76a77875c7d92b4b1 upstream.

There are a bunch of variables tha tare more wildy scoped than they
need to be, obfuscated user buffer checks and tortured "next inode"
tracking. This all needs cleaning up to expose the real issues that
need fixing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_itable.c |   56 ++++++++++++++++++++++------------------------------
 1 file changed, 24 insertions(+), 32 deletions(-)

--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -348,30 +348,23 @@ xfs_bulkstat(
 	xfs_agino_t		agino;	/* inode # in allocation group */
 	xfs_agnumber_t		agno;	/* allocation group number */
 	xfs_btree_cur_t		*cur;	/* btree cursor for ialloc btree */
-	int			end_of_ag; /* set if we've seen the ag end */
-	int			error;	/* error code */
-	int			icount;	/* count of inodes good in irbuf */
 	size_t			irbsize; /* size of irec buffer in bytes */
-	xfs_ino_t		ino;	/* inode number (filesystem) */
-	xfs_inobt_rec_incore_t	*irbp;	/* current irec buffer pointer */
 	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
-	xfs_inobt_rec_incore_t	*irbufend; /* end of good irec buffer entries */
 	xfs_ino_t		lastino; /* last inode number returned */
 	int			nirbuf;	/* size of irbuf */
 	int			rval;	/* return value error code */
 	int			ubcount; /* size of user's buffer */
-	int			stat;
 	struct xfs_bulkstat_agichunk ac;
+	int			error = 0;
 
 	/*
 	 * Get the last inode value, see if there's nothing to do.
 	 */
-	ino = (xfs_ino_t)*lastinop;
-	lastino = ino;
-	agno = XFS_INO_TO_AGNO(mp, ino);
-	agino = XFS_INO_TO_AGINO(mp, ino);
+	lastino = *lastinop;
+	agno = XFS_INO_TO_AGNO(mp, lastino);
+	agino = XFS_INO_TO_AGINO(mp, lastino);
 	if (agno >= mp->m_sb.sb_agcount ||
-	    ino != XFS_AGINO_TO_INO(mp, agno, agino)) {
+	    lastino != XFS_AGINO_TO_INO(mp, agno, agino)) {
 		*done = 1;
 		*ubcountp = 0;
 		return 0;
@@ -396,8 +389,13 @@ xfs_bulkstat(
 	 * inode returned; 0 means start of the allocation group.
 	 */
 	rval = 0;
-	while (XFS_BULKSTAT_UBLEFT(ac.ac_ubleft) && agno < mp->m_sb.sb_agcount) {
-		cond_resched();
+	while (agno < mp->m_sb.sb_agcount) {
+		struct xfs_inobt_rec_incore	*irbp = irbuf;
+		struct xfs_inobt_rec_incore	*irbufend = irbuf + nirbuf;
+		bool				end_of_ag = false;
+		int				icount = 0;
+		int				stat;
+
 		error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
 		if (error)
 			break;
@@ -407,10 +405,6 @@ xfs_bulkstat(
 		 */
 		cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno,
 					    XFS_BTNUM_INO);
-		irbp = irbuf;
-		irbufend = irbuf + nirbuf;
-		end_of_ag = 0;
-		icount = 0;
 		if (agino > 0) {
 			/*
 			 * In the middle of an allocation group, we need to get
@@ -435,7 +429,7 @@ xfs_bulkstat(
 			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &stat);
 		}
 		if (error || stat == 0) {
-			end_of_ag = 1;
+			end_of_ag = true;
 			goto del_cursor;
 		}
 
@@ -448,7 +442,7 @@ xfs_bulkstat(
 
 			error = xfs_inobt_get_rec(cur, &r, &stat);
 			if (error || stat == 0) {
-				end_of_ag = 1;
+				end_of_ag = true;
 				goto del_cursor;
 			}
 
@@ -470,7 +464,7 @@ xfs_bulkstat(
 			agino = r.ir_startino + XFS_INODES_PER_CHUNK;
 			error = xfs_btree_increment(cur, 0, &stat);
 			if (error || stat == 0) {
-				end_of_ag = 1;
+				end_of_ag = true;
 				goto del_cursor;
 			}
 			cond_resched();
@@ -491,7 +485,7 @@ del_cursor:
 		 */
 		irbufend = irbp;
 		for (irbp = irbuf;
-		     irbp < irbufend && XFS_BULKSTAT_UBLEFT(ac.ac_ubleft);
+		     irbp < irbufend && ac.ac_ubleft >= statstruct_size;
 		     irbp++) {
 			error = xfs_bulkstat_ag_ichunk(mp, agno, irbp,
 					formatter, statstruct_size, &ac,
@@ -502,17 +496,15 @@ del_cursor:
 			cond_resched();
 		}
 
-		/*
-		 * Set up for the next loop iteration.
-		 */
-		if (XFS_BULKSTAT_UBLEFT(ac.ac_ubleft)) {
-			if (end_of_ag) {
-				agno++;
-				agino = 0;
-			} else
-				agino = XFS_INO_TO_AGINO(mp, lastino);
-		} else
+		/* If we've run out of space, we are done */
+		if (ac.ac_ubleft < statstruct_size)
 			break;
+
+		if (end_of_ag) {
+			agno++;
+			agino = 0;
+		} else
+			agino = XFS_INO_TO_AGINO(mp, lastino);
 	}
 	/*
 	 * Done, we're either out of filesystem or space to put the data.


