Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbaF3MDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:03:34 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52046 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753814AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>,
        Eric Sandeen <sandeen@redhat.com>, Ben Myers <bpm@sgi.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 039/181] xfs: don't break from growfs ag update loop on error
Date: Mon, 30 Jun 2014 13:51:00 +0200
Message-Id: <503141e595882718c732b12afc5e2944d4a1723b.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@sandeen.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 59e5a0e821d838854b3afd030d31f82cee3ecd58 upstream.

When xfs_growfs_data_private() is updating backup superblocks,
it bails out on the first error encountered, whether reading or
writing:

* If we get an error writing out the alternate superblocks,
* just issue a warning and continue.  The real work is
* already done and committed.

This can cause a problem later during repair, because repair
looks at all superblocks, and picks the most prevalent one
as correct.  If we bail out early in the backup superblock
loop, we can end up with more "bad" matching superblocks than
good, and a post-growfs repair may revert the filesystem to
the old geometry.

With the combination of superblock verifiers and old bugs,
we're more likely to encounter read errors due to verification.

And perhaps even worse, we don't even properly write any of the
newly-added superblocks in the new AGs.

Even with this change, growfs will still say:

  xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs cleaning
  data blocks changed from 319815680 to 335216640

which might be confusing to the user, but it at least communicates
that something has gone wrong, and dmesg will probably highlight
the need for an xfs_repair.

And this is still best-effort; if verifiers fail on more than
half the backup supers, they may still "win" - but that's probably
best left to repair to more gracefully handle by doing its own
strict verification as part of the backup super "voting."

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/xfs/xfs_fsops.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index c888040a1e93..20ccca12a11d 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -153,7 +153,7 @@ xfs_growfs_data_private(
 	xfs_buf_t		*bp;
 	int			bucket;
 	int			dpct;
-	int			error;
+	int			error, saved_error = 0;
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
 	xfs_rfsblock_t		nb, nb_mod;
@@ -500,29 +500,33 @@ xfs_growfs_data_private(
 				error = ENOMEM;
 		}
 
+		/*
+		 * If we get an error reading or writing alternate superblocks,
+		 * continue.  xfs_repair chooses the "best" superblock based
+		 * on most matches; if we break early, we'll leave more
+		 * superblocks un-updated than updated, and xfs_repair may
+		 * pick them over the properly-updated primary.
+		 */
 		if (error) {
 			xfs_warn(mp,
 		"error %d reading secondary superblock for ag %d",
 				error, agno);
-			break;
+			saved_error = error;
+			continue;
 		}
 		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, XFS_SB_ALL_BITS);
 
-		/*
-		 * If we get an error writing out the alternate superblocks,
-		 * just issue a warning and continue.  The real work is
-		 * already done and committed.
-		 */
 		error = xfs_bwrite(bp);
 		xfs_buf_relse(bp);
 		if (error) {
 			xfs_warn(mp,
 		"write error %d updating secondary superblock for ag %d",
 				error, agno);
-			break; /* no point in continuing */
+			saved_error = error;
+			continue;
 		}
 	}
-	return error;
+	return saved_error ? saved_error : error;
 
  error0:
 	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
-- 
2.0.0

