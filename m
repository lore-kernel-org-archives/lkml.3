Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817AbaKLBgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:36:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933798AbaKLBgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:36:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3.17 315/319] xfs: bulkstat chunk-formatter has issues
Date: Wed, 12 Nov 2014 10:17:33 +0900
Message-Id: <20141112011044.996795542@linuxfoundation.org>
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

commit 2b831ac6bc87d3cbcbb1a8816827b6923403e461 upstream.

The loop construct has issues:
	- clustidx is completely unused, so remove it.
	- the loop tries to be smart by terminating when the
	  "freecount" tells it that all inodes are free. Just drop
	  it as in most cases we have to scan all inodes in the
	  chunk anyway.
	- move the "user buffer left" condition check to the only
	  point where we consume space int eh user buffer.
	- move the initialisation of agino out of the loop, leaving
	  just a simple loop control logic using the clusteridx.

Also, double handling of the user buffer variables leads to problems
tracking the current state - use the cursor variables directly
rather than keeping local copies and then having to update the
cursor before returning.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_itable.c |   58 +++++++++++++++++++++-------------------------------
 1 file changed, 24 insertions(+), 34 deletions(-)

--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -283,59 +283,49 @@ xfs_bulkstat_ag_ichunk(
 	xfs_ino_t			*lastino)
 {
 	char				__user **ubufp = acp->ac_ubuffer;
-	int				ubleft = acp->ac_ubleft;
-	int				ubelem = acp->ac_ubelem;
-	int				chunkidx, clustidx;
+	int				chunkidx;
 	int				error = 0;
 	xfs_agino_t			agino;
 
-	for (agino = irbp->ir_startino, chunkidx = clustidx = 0;
-	     XFS_BULKSTAT_UBLEFT(ubleft) &&
-	     irbp->ir_freecount < XFS_INODES_PER_CHUNK;
-	     chunkidx++, clustidx++, agino++) {
-		int		fmterror;	/* bulkstat formatter result */
+	agino = irbp->ir_startino;
+	for (chunkidx = 0; chunkidx < XFS_INODES_PER_CHUNK;
+	     chunkidx++, agino++) {
+		int		fmterror;
 		int		ubused;
 		xfs_ino_t	ino = XFS_AGINO_TO_INO(mp, agno, agino);
 
-		ASSERT(chunkidx < XFS_INODES_PER_CHUNK);
-
 		/* Skip if this inode is free */
 		if (XFS_INOBT_MASK(chunkidx) & irbp->ir_free) {
 			*lastino = ino;
 			continue;
 		}
 
-		/*
-		 * Count used inodes as free so we can tell when the
-		 * chunk is used up.
-		 */
-		irbp->ir_freecount++;
-
 		/* Get the inode and fill in a single buffer */
 		ubused = statstruct_size;
-		error = formatter(mp, ino, *ubufp, ubleft, &ubused, &fmterror);
-		if (fmterror == BULKSTAT_RV_NOTHING) {
-			if (error && error != -ENOENT && error != -EINVAL) {
-				ubleft = 0;
-				break;
-			}
-			*lastino = ino;
-			continue;
-		}
-		if (fmterror == BULKSTAT_RV_GIVEUP) {
-			ubleft = 0;
+		error = formatter(mp, ino, *ubufp, acp->ac_ubleft,
+				  &ubused, &fmterror);
+		if (fmterror == BULKSTAT_RV_GIVEUP ||
+		    (error && error != -ENOENT && error != -EINVAL)) {
+			acp->ac_ubleft = 0;
 			ASSERT(error);
 			break;
 		}
-		if (*ubufp)
-			*ubufp += ubused;
-		ubleft -= ubused;
-		ubelem++;
+
+		/* be careful not to leak error if at end of chunk */
+		if (fmterror == BULKSTAT_RV_NOTHING || error) {
+			*lastino = ino;
+			error = 0;
+			continue;
+		}
+
+		*ubufp += ubused;
+		acp->ac_ubleft -= ubused;
+		acp->ac_ubelem++;
 		*lastino = ino;
-	}
 
-	acp->ac_ubleft = ubleft;
-	acp->ac_ubelem = ubelem;
+		if (acp->ac_ubleft < statstruct_size)
+			break;
+	}
 
 	return error;
 }


