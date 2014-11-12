Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834AbaKLBge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:36:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587AbaKLBg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:36:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3.17 317/319] xfs: bulkstat error handling is broken
Date: Wed, 12 Nov 2014 10:17:35 +0900
Message-Id: <20141112011045.357390277@linuxfoundation.org>
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

commit febe3cbe38b0bc0a925906dc90e8d59048851f87 upstream.

The error propagation is a horror - xfs_bulkstat() returns
a rval variable which is only set if there are formatter errors. Any
sort of btree walk error or corruption will cause the bulkstat walk
to terminate but will not pass an error back to userspace. Worse
is the fact that formatter errors will also be ignored if any inodes
were correctly formatted into the user buffer.

Hence bulkstat can fail badly yet still report success to userspace.
This causes significant issues with xfsdump not dumping everything
in the filesystem yet reporting success. It's not until a restore
fails that there is any indication that the dump was bad and tha
bulkstat failed. This patch now triggers xfsdump to fail with
bulkstat errors rather than silently missing files in the dump.

This now causes bulkstat to fail when the lastino cookie does not
fall inside an existing inode chunk. The pre-3.17 code tolerated
that error by allowing the code to move to the next inode chunk
as the agino target is guaranteed to fall into the next btree
record.

With the fixes up to this point in the series, xfsdump now passes on
the troublesome filesystem image that exposes all these bugs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_itable.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -236,8 +236,10 @@ xfs_bulkstat_grab_ichunk(
 	XFS_WANT_CORRUPTED_RETURN(stat == 1);
 
 	/* Check if the record contains the inode in request */
-	if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino)
-		return -EINVAL;
+	if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino) {
+		*icount = 0;
+		return 0;
+	}
 
 	idx = agino - irec->ir_startino + 1;
 	if (idx < XFS_INODES_PER_CHUNK &&
@@ -352,7 +354,6 @@ xfs_bulkstat(
 	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
 	xfs_ino_t		lastino; /* last inode number returned */
 	int			nirbuf;	/* size of irbuf */
-	int			rval;	/* return value error code */
 	int			ubcount; /* size of user's buffer */
 	struct xfs_bulkstat_agichunk ac;
 	int			error = 0;
@@ -388,7 +389,6 @@ xfs_bulkstat(
 	 * Loop over the allocation groups, starting from the last
 	 * inode returned; 0 means start of the allocation group.
 	 */
-	rval = 0;
 	while (agno < mp->m_sb.sb_agcount) {
 		struct xfs_inobt_rec_incore	*irbp = irbuf;
 		struct xfs_inobt_rec_incore	*irbufend = irbuf + nirbuf;
@@ -491,13 +491,16 @@ del_cursor:
 					formatter, statstruct_size, &ac,
 					&lastino);
 			if (error)
-				rval = error;
+				break;
 
 			cond_resched();
 		}
 
-		/* If we've run out of space, we are done */
-		if (ac.ac_ubleft < statstruct_size)
+		/*
+		 * If we've run out of space or had a formatting error, we
+		 * are now done
+		 */
+		if (ac.ac_ubleft < statstruct_size || error)
 			break;
 
 		if (end_of_ag) {
@@ -511,11 +514,17 @@ del_cursor:
 	 */
 	kmem_free(irbuf);
 	*ubcountp = ac.ac_ubelem;
+
 	/*
-	 * Found some inodes, return them now and return the error next time.
+	 * We found some inodes, so clear the error status and return them.
+	 * The lastino pointer will point directly at the inode that triggered
+	 * any error that occurred, so on the next call the error will be
+	 * triggered again and propagated to userspace as there will be no
+	 * formatted inodes in the buffer.
 	 */
 	if (ac.ac_ubelem)
-		rval = 0;
+		error = 0;
+
 	if (agno >= mp->m_sb.sb_agcount) {
 		/*
 		 * If we ran out of filesystem, mark lastino as off
@@ -527,7 +536,7 @@ del_cursor:
 	} else
 		*lastinop = (xfs_ino_t)lastino;
 
-	return rval;
+	return error;
 }
 
 int


