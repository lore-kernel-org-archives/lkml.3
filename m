Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422846Ab3BANO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:14:27 -0500
Received: from mail.kernel.org ([198.145.19.201]:45538 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422625Ab3BANOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:14:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Ben Myers <bpm@sgi.com>
Subject: [ 75/89] xfs: fix periodic log flushing
Date: Fri,  1 Feb 2013 14:08:30 +0100
Message-Id: <20130201130212.880042649@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

[Please take this patch for -stable in kernels 3.5-3.7.  It doesn't have an
equivalent upstream commit because the code was removed before the bug was
discovered.  See f661f1e0bf50 and 7e18530bef6a.]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

If people agree the fix is correct, I'll post it to the -stable
list for inclusion...

--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -400,7 +400,7 @@ xfs_sync_worker(
 	 * cancel_delayed_work_sync on this work queue before tearing down
 	 * the ail and the log in xfs_log_unmount.
 	 */
-	if (!(mp->m_super->s_flags & MS_ACTIVE) &&
+	if ((mp->m_super->s_flags & MS_ACTIVE) &&
 	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		/* dgc: errors ignored here */
 		if (mp->m_super->s_writers.frozen == SB_UNFROZEN &&


