Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031576AbaGDW7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:59:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760623AbaGDWQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:16:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Plamen Petrov <plamen.sisi@gmail.com>,
        Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3.15 52/66] xfs: xfs_readsb needs to check for magic numbers
Date: Fri,  4 Jul 2014 15:14:51 -0700
Message-Id: <20140704221425.178494676@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit 556b8883cfac3d3203557e161ea8005f8b5479b2 upstream.

Commit daba542 ("xfs: skip verification on initial "guess"
superblock read") dropped the use of a verifier for the initial
superblock read so we can probe the sector size of the filesystem
stored in the superblock. It, however, now fails to validate that
what was read initially is actually an XFS superblock and hence will
fail the sector size check and return ENOSYS.

This causes probe-based mounts to fail because it expects XFS to
return EINVAL when it doesn't recognise the superblock format.

Reported-by: Plamen Petrov <plamen.sisi@gmail.com>
Tested-by: Plamen Petrov <plamen.sisi@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_mount.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -323,8 +323,19 @@ reread:
 	/*
 	 * Initialize the mount structure from the superblock.
 	 */
-	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
-	xfs_sb_quota_from_disk(&mp->m_sb);
+	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
+	xfs_sb_quota_from_disk(sbp);
+
+	/*
+	 * If we haven't validated the superblock, do so now before we try
+	 * to check the sector size and reread the superblock appropriately.
+	 */
+	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
+		if (loud)
+			xfs_warn(mp, "Invalid superblock magic number");
+		error = EINVAL;
+		goto release_buf;
+	}
 
 	/*
 	 * We must be able to do sector-sized and sector-aligned IO.
@@ -337,11 +348,11 @@ reread:
 		goto release_buf;
 	}
 
-	/*
-	 * Re-read the superblock so the buffer is correctly sized,
-	 * and properly verified.
-	 */
 	if (buf_ops == NULL) {
+		/*
+		 * Re-read the superblock so the buffer is correctly sized,
+		 * and properly verified.
+		 */
 		xfs_buf_relse(bp);
 		sector_size = sbp->sb_sectsize;
 		buf_ops = loud ? &xfs_sb_buf_ops : &xfs_sb_quiet_buf_ops;


