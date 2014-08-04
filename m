Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbaHDRKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:10:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56511 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751869AbaHDQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ben Myers" <bpm@sgi.com>,
        "Mike Snitzer" <snitzer@redhat.com>,
        "Dave Chinner" <dchinner@redhat.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.148019327@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 69/94] xfs: really fix the cursor leak in
 xfs_alloc_ag_vextent_near
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit e3a746f5aab71f2dd0a83116772922fb37ae29d6 upstream.

The current cursor is reallocated when retrying the allocation, so
the existing cursor needs to be destroyed in both the restart and
the failure cases.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/xfs/xfs_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -1075,13 +1075,13 @@ restart:
 	 * If we couldn't get anything, give up.
 	 */
 	if (bno_cur_lt == NULL && bno_cur_gt == NULL) {
+		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
+
 		if (!forced++) {
 			trace_xfs_alloc_near_busy(args);
 			xfs_log_force(args->mp, XFS_LOG_SYNC);
 			goto restart;
 		}
-
-		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 		trace_xfs_alloc_size_neither(args);
 		args->agbno = NULLAGBLOCK;
 		return 0;

