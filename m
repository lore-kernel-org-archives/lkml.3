Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab3APQ7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:59:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35924 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757546Ab3APQBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:01:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Chinner <dchinner@redhat.com>, Ben Myers <bpm@sgi.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 059/222] xfs: fix stray dquot unlock when reclaiming dquots
Date: Wed, 16 Jan 2013 13:54:19 -0200
Message-Id: <1358351822-7675-60-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit b870553cdecb26d5291af09602352b763e323df2 upstream.

When we fail to get a dquot lock during reclaim, we jump to an error
handler that unlocks the dquot. This is wrong as we didn't lock the
dquot, and unlocking it means who-ever is holding the lock has had
it silently taken away, and hence it results in a lock imbalance.

Found by inspection while modifying the code for the numa-lru
patchset. This fixes a random hang I've been seeing on xfstest 232
for the past several months.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/xfs/xfs_qm.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 249db19..92eb490 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1453,7 +1453,7 @@ xfs_qm_dqreclaim_one(
 	int			error;
 
 	if (!xfs_dqlock_nowait(dqp))
-		goto out_busy;
+		goto out_move_tail;
 
 	/*
 	 * This dquot has acquired a reference in the meantime remove it from
@@ -1476,7 +1476,7 @@ xfs_qm_dqreclaim_one(
 	 * getting flushed to disk, we don't want to reclaim it.
 	 */
 	if (!xfs_dqflock_nowait(dqp))
-		goto out_busy;
+		goto out_unlock_move_tail;
 
 	if (XFS_DQ_IS_DIRTY(dqp)) {
 		struct xfs_buf	*bp = NULL;
@@ -1487,7 +1487,7 @@ xfs_qm_dqreclaim_one(
 		if (error) {
 			xfs_warn(mp, "%s: dquot %p flush failed",
 				 __func__, dqp);
-			goto out_busy;
+			goto out_unlock_move_tail;
 		}
 
 		xfs_buf_delwri_queue(bp, buffer_list);
@@ -1496,7 +1496,7 @@ xfs_qm_dqreclaim_one(
 		 * Give the dquot another try on the freelist, as the
 		 * flushing will take some time.
 		 */
-		goto out_busy;
+		goto out_unlock_move_tail;
 	}
 	xfs_dqfunlock(dqp);
 
@@ -1515,14 +1515,13 @@ xfs_qm_dqreclaim_one(
 	XFS_STATS_INC(xs_qm_dqreclaims);
 	return;
 
-out_busy:
-	xfs_dqunlock(dqp);
-
 	/*
 	 * Move the dquot to the tail of the list so that we don't spin on it.
 	 */
+out_unlock_move_tail:
+	xfs_dqunlock(dqp);
+out_move_tail:
 	list_move_tail(&dqp->q_lru, &qi->qi_lru_list);
-
 	trace_xfs_dqreclaim_busy(dqp);
 	XFS_STATS_INC(xs_qm_dqreclaim_misses);
 }
-- 
1.7.9.5

