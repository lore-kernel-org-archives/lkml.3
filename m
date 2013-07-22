Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab3GVQM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:12:29 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:56006 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830Ab3GVQMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:12:23 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 31/48] staging/lustre/ldlm: Fix flock deadlock detection race
Date: Tue, 23 Jul 2013 00:06:52 +0800
Message-Id: <1374509230-3324-32-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andriy Skulysh <Andriy_Skulysh@xyratex.com>

Deadlock isn't detected if 2 threads are trying to
grant 2 locks which deadlock on each other.
They call ldlm_flock_deadlock() simultaneously
and deadlock ins't detected.

The soulition is to add lock to blocking list before
calling ldlm_flock_deadlock()

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-1602
Lustre-change: http://review.whamcloud.com/3277
Signed-off-by: Andriy Skulysh <Andriy_Skulysh@xyratex.com>
Reviewed-by: Vitaly Fertman <vitaly_fertman@xyratex.com>
Reviewed-by: Bruce Korb <bruce_korb@xyratex.com>
Reviewed-by: Keith Mannthey <keith.mannthey@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
index aca1073..39973cb 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
@@ -198,6 +198,7 @@ ldlm_flock_deadlock(struct ldlm_lock *req, struct ldlm_lock *bl_lock)
 		if (lock == NULL)
 			break;
 
+		LASSERT(req != lock);
 		flock = &lock->l_policy_data.l_flock;
 		LASSERT(flock->owner == bl_owner);
 		bl_owner = flock->blocking_owner;
@@ -329,18 +330,21 @@ reprocess:
 				RETURN(LDLM_ITER_STOP);
 			}
 
-			if (ldlm_flock_deadlock(req, lock)) {
-				ldlm_flock_destroy(req, mode, *flags);
-				*err = -EDEADLK;
-				RETURN(LDLM_ITER_STOP);
-			}
-
+			/* add lock to blocking list before deadlock
+			 * check to prevent race */
 			rc = ldlm_flock_blocking_link(req, lock);
 			if (rc) {
 				ldlm_flock_destroy(req, mode, *flags);
 				*err = rc;
 				RETURN(LDLM_ITER_STOP);
 			}
+			if (ldlm_flock_deadlock(req, lock)) {
+				ldlm_flock_blocking_unlink(req);
+				ldlm_flock_destroy(req, mode, *flags);
+				*err = -EDEADLK;
+				RETURN(LDLM_ITER_STOP);
+			}
+
 			ldlm_resource_add_lock(res, &res->lr_waiting, req);
 			*flags |= LDLM_FL_BLOCK_GRANTED;
 			RETURN(LDLM_ITER_STOP);
-- 
1.7.9.5

