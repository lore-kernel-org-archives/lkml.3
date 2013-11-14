Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab3KNQoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:44:34 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61774 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157Ab3KNQoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:44:16 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 12/26] staging/lustre/ldlm: Fix flock detection for different mounts
Date: Fri, 15 Nov 2013 00:42:59 +0800
Message-Id: <1384447393-13838-13-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andriy Skulysh <Andriy_Skulysh@xyratex.com>

Deadlock can happen when 2 processes take concurrent locks
on files situated in different mountpoints.

Modify flock detection algorithm to distinguish process by
pair PID+NID instead of PID+export.
It is done by searching for a blocking owner in all OBD's
exports with the same NID.

Lustre-change: http://review.whamcloud.com/3276
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-1601
Signed-off-by: Andriy Skulysh <Andriy_Skulysh@xyratex.com>
Reviewed-by: Vitaly Fertman <vitaly_fertman@xyratex.com>
Reviewed-by: Bruce Korb <bruce_korb@xyratex.com>
Reviewed-by: Keith Mannthey <keith.mannthey@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c |   45 +++++++++++++++++++++--
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
index 37ebd2a..396e58b 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
@@ -161,6 +161,31 @@ ldlm_flock_destroy(struct ldlm_lock *lock, ldlm_mode_t mode, __u64 flags)
  * one client holds a lock on something and want a lock on something
  * else and at the same time another client has the opposite situation).
  */
+
+struct ldlm_flock_lookup_cb_data {
+	__u64 *bl_owner;
+	struct ldlm_lock *lock;
+	struct obd_export *exp;
+};
+
+static int ldlm_flock_lookup_cb(struct cfs_hash *hs, struct cfs_hash_bd *bd,
+				 struct hlist_node *hnode, void *data)
+{
+	struct ldlm_flock_lookup_cb_data *cb_data = data;
+	struct obd_export *exp = cfs_hash_object(hs, hnode);
+	struct ldlm_lock *lock;
+
+	lock = cfs_hash_lookup(exp->exp_flock_hash, cb_data->bl_owner);
+	if (lock == NULL)
+		return 0;
+
+	/* Stop on first found lock. Same process can't sleep twice */
+	cb_data->lock = lock;
+	cb_data->exp = class_export_get(exp);
+
+	return 1;
+}
+
 static int
 ldlm_flock_deadlock(struct ldlm_lock *req, struct ldlm_lock *bl_lock)
 {
@@ -175,16 +200,26 @@ ldlm_flock_deadlock(struct ldlm_lock *req, struct ldlm_lock *bl_lock)
 
 	class_export_get(bl_exp);
 	while (1) {
+		struct ldlm_flock_lookup_cb_data cb_data = {
+					.bl_owner = &bl_owner,
+					.lock = NULL,
+					.exp = NULL };
 		struct obd_export *bl_exp_new;
 		struct ldlm_lock *lock = NULL;
 		struct ldlm_flock *flock;
 
-		if (bl_exp->exp_flock_hash != NULL)
-			lock = cfs_hash_lookup(bl_exp->exp_flock_hash,
-					       &bl_owner);
+		if (bl_exp->exp_flock_hash != NULL) {
+			cfs_hash_for_each_key(bl_exp->exp_obd->obd_nid_hash,
+				&bl_exp->exp_connection->c_peer.nid,
+				ldlm_flock_lookup_cb, &cb_data);
+			lock = cb_data.lock;
+		}
 		if (lock == NULL)
 			break;
 
+		class_export_put(bl_exp);
+		bl_exp = cb_data.exp;
+
 		LASSERT(req != lock);
 		flock = &lock->l_policy_data.l_flock;
 		LASSERT(flock->owner == bl_owner);
@@ -198,7 +233,9 @@ ldlm_flock_deadlock(struct ldlm_lock *req, struct ldlm_lock *bl_lock)
 		if (bl_exp->exp_failed)
 			break;
 
-		if (bl_owner == req_owner && bl_exp == req_exp) {
+		if (bl_owner == req_owner &&
+		    (bl_exp->exp_connection->c_peer.nid ==
+		     req_exp->exp_connection->c_peer.nid)) {
 			class_export_put(bl_exp);
 			return 1;
 		}
-- 
1.7.9.5

