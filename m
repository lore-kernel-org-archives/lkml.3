Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaAOWCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:02:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41499 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbaAOWBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:01:04 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jie Liu <jeff.liu@oracle.com>, Ben Myers <bpm@sgi.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 076/166] xfs: fix infinite loop by detaching the group/project hints from user dquot
Date: Wed, 15 Jan 2014 13:51:30 -0800
Message-Id: <1389822780-4729-77-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Liu <jeff.liu@oracle.com>

commit 718cc6f88cbfc4fbd39609f28c4c86883945f90d upstream.

xfs_quota(8) will hang up if trying to turn group/project quota off
before the user quota is off, this could be 100% reproduced by:
  # mount -ouquota,gquota /dev/sda7 /xfs
  # mkdir /xfs/test
  # xfs_quota -xc 'off -g' /xfs <-- hangs up
  # echo w > /proc/sysrq-trigger
  # dmesg

  SysRq : Show Blocked State
  task                        PC stack   pid father
  xfs_quota       D 0000000000000000     0 27574   2551 0x00000000
  [snip]
  Call Trace:
  [<ffffffff81aaa21d>] schedule+0xad/0xc0
  [<ffffffff81aa327e>] schedule_timeout+0x35e/0x3c0
  [<ffffffff8114b506>] ? mark_held_locks+0x176/0x1c0
  [<ffffffff810ad6c0>] ? call_timer_fn+0x2c0/0x2c0
  [<ffffffffa0c25380>] ? xfs_qm_shrink_count+0x30/0x30 [xfs]
  [<ffffffff81aa3306>] schedule_timeout_uninterruptible+0x26/0x30
  [<ffffffffa0c26155>] xfs_qm_dquot_walk+0x235/0x260 [xfs]
  [<ffffffffa0c059d8>] ? xfs_perag_get+0x1d8/0x2d0 [xfs]
  [<ffffffffa0c05805>] ? xfs_perag_get+0x5/0x2d0 [xfs]
  [<ffffffffa0b7707e>] ? xfs_inode_ag_iterator+0xae/0xf0 [xfs]
  [<ffffffffa0c22280>] ? xfs_trans_free_dqinfo+0x50/0x50 [xfs]
  [<ffffffffa0b7709f>] ? xfs_inode_ag_iterator+0xcf/0xf0 [xfs]
  [<ffffffffa0c261e6>] xfs_qm_dqpurge_all+0x66/0xb0 [xfs]
  [<ffffffffa0c2497a>] xfs_qm_scall_quotaoff+0x20a/0x5f0 [xfs]
  [<ffffffffa0c2b8f6>] xfs_fs_set_xstate+0x136/0x180 [xfs]
  [<ffffffff8136cf7a>] do_quotactl+0x53a/0x6b0
  [<ffffffff812fba4b>] ? iput+0x5b/0x90
  [<ffffffff8136d257>] SyS_quotactl+0x167/0x1d0
  [<ffffffff814cf2ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff81abcd19>] system_call_fastpath+0x16/0x1b

It's fine if we turn user quota off at first, then turn off other
kind of quotas if they are enabled since the group/project dquot
refcount is decreased to zero once the user quota if off. Otherwise,
those dquots refcount is non-zero due to the user dquot might refer
to them as hint(s).  Hence, above operation cause an infinite loop
at xfs_qm_dquot_walk() while trying to purge dquot cache.

This problem has been around since Linux 3.4, it was introduced by:
  [ b84a3a9675 xfs: remove the per-filesystem list of dquots ]

Originally we will release the group dquot pointers because the user
dquots maybe carrying around as a hint via xfs_qm_detach_gdquots().
However, with above change, there is no such work to be done before
purging group/project dquot cache.

In order to solve this problem, this patch introduces a special routine
xfs_qm_dqpurge_hints(), and it would release the group/project dquot
pointers the user dquots maybe carrying around as a hint, and then it
will proceed to purge the user dquot cache if requested.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
[ kamal: backport to 3.8 (no q_pdquot member, just q_gdquot) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/xfs/xfs_qm.c | 58 +++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 60eff47..e2db199 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -135,7 +135,6 @@ xfs_qm_dqpurge(
 {
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
-	struct xfs_dquot	*gdqp = NULL;
 
 	xfs_dqlock(dqp);
 	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
@@ -143,16 +142,6 @@ xfs_qm_dqpurge(
 		return EAGAIN;
 	}
 
-	/*
-	 * If this quota has a group hint attached, prepare for releasing it
-	 * now.
-	 */
-	gdqp = dqp->q_gdquot;
-	if (gdqp) {
-		xfs_dqlock(gdqp);
-		dqp->q_gdquot = NULL;
-	}
-
 	dqp->dq_flags |= XFS_DQ_FREEING;
 
 	xfs_dqflock(dqp);
@@ -204,9 +193,40 @@ xfs_qm_dqpurge(
 	mutex_unlock(&qi->qi_lru_lock);
 
 	xfs_qm_dqdestroy(dqp);
+	return 0;
+}
+
+/*
+ * Release the group or project dquot pointers the user dquots maybe carrying
+ * around as a hint, and proceed to purge the user dquot cache if requested.
+*/
+STATIC int
+xfs_qm_dqpurge_hints(
+	struct xfs_dquot	*dqp,
+	void			*data)
+{
+	struct xfs_dquot	*gdqp = NULL;
+	uint			flags = *((uint *)data);
+
+	xfs_dqlock(dqp);
+	if (dqp->dq_flags & XFS_DQ_FREEING) {
+		xfs_dqunlock(dqp);
+		return EAGAIN;
+	}
+
+	/* If this quota has a hint attached, prepare for releasing it now */
+	gdqp = dqp->q_gdquot;
+	if (gdqp)
+		dqp->q_gdquot = NULL;
+
+	xfs_dqunlock(dqp);
 
 	if (gdqp)
-		xfs_qm_dqput(gdqp);
+		xfs_qm_dqrele(gdqp);
+
+	if (flags & XFS_QMOPT_UQUOTA)
+		return xfs_qm_dqpurge(dqp, NULL);
+
 	return 0;
 }
 
@@ -218,8 +238,18 @@ xfs_qm_dqpurge_all(
 	struct xfs_mount	*mp,
 	uint			flags)
 {
-	if (flags & XFS_QMOPT_UQUOTA)
-		xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge, NULL);
+	/*
+	 * We have to release group/project dquot hint(s) from the user dquot
+	 * at first if they are there, otherwise we would run into an infinite
+	 * loop while walking through radix tree to purge other type of dquots
+	 * since their refcount is not zero if the user dquot refers to them
+	 * as hint.
+	 *
+	 * Call the special xfs_qm_dqpurge_hints() will end up go through the
+	 * general xfs_qm_dqpurge() against user dquot cache if requested.
+	 */
+	xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge_hints, &flags);
+
 	if (flags & XFS_QMOPT_GQUOTA)
 		xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge, NULL);
 	if (flags & XFS_QMOPT_PQUOTA)
-- 
1.8.3.2

