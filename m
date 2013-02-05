Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab3BEWN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:13:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48291 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758058Ab3BEWNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:13:23 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Chinner <dchinner@redhat.com>, Ben Myers <bpm@sgi.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 91/93] xfs: fix periodic log flushing
Date: Tue,  5 Feb 2013 20:07:20 -0200
Message-Id: <1360102042-10732-92-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

[ Please take this patch for -stable in kernels 3.5-3.7. It doesn't have
  an equivalent upstream commit because the code was removed before the
  bug was discovered. See f661f1e0bf50 and 7e18530bef6a ]

There is a logic inversion in xfssyncd_worker() which means that the
log is not periodically forced or idled correctly. This means that
metadata changes aggregated in memory do not get flushed in a timely
manner, and hence if filesystem is not cleanly unmounted those
changes can be lost. This loss can manifest itself even hours after
the changes were made if the filesystem is left to idle without a
sync() occurring between the last modification and the
crash/shutdown occuring.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/xfs/xfs_sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 1e9ee06..f3b3b3e 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -391,7 +391,7 @@ xfs_sync_worker(
 	 * cancel_delayed_work_sync on this work queue before tearing down
 	 * the ail and the log in xfs_log_unmount.
 	 */
-	if (!(mp->m_super->s_flags & MS_ACTIVE) &&
+	if ((mp->m_super->s_flags & MS_ACTIVE) &&
 	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		/* dgc: errors ignored here */
 		if (mp->m_super->s_frozen == SB_UNFROZEN &&
-- 
1.7.9.5

