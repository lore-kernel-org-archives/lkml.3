Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab3KNQjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:39:01 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:43031 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab3KNQii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:38:38 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Vitaly Fertman <vitaly_fertman@xyratex.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 02/39] staging/lustre/clio: wrong cl_lock usage
Date: Fri, 15 Nov 2013 00:32:25 +0800
Message-Id: <1384446782-13741-3-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Fertman <vitaly_fertman@xyratex.com>

granted lock is moved to HELD state in cl_wait_try() only which is
done after upcall for non-agl locks. as the result, lock unuse moves
cl_lock not to CACHED state, but to NEW state. A parallel thread
gets this lock and tries to enqueue it - instead of re-using a
cached lock, cl_enqueue_try() initiates a new enqueue and gets to
osc_lock_enqueue() where it asserts:

LASSERTF(ols->ols_state == OLS_NEW, ...);

the state of osc lock is RELEASED already - moved here by unuse.

Lustre-change: http://review.whamcloud.com/6709
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3433
Signed-off-by: Vitaly Fertman <vitaly_fertman@xyratex.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/osc/osc_lock.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lustre/lustre/osc/osc_lock.c b/drivers/staging/lustre/lustre/osc/osc_lock.c
index c90abfb..476b2e8 100644
--- a/drivers/staging/lustre/lustre/osc/osc_lock.c
+++ b/drivers/staging/lustre/lustre/osc/osc_lock.c
@@ -554,15 +554,18 @@ static int osc_lock_upcall(void *cookie, int errcode)
 				lock->cll_flags |= CLF_FROM_UPCALL;
 				cl_wait_try(env, lock);
 				lock->cll_flags &= ~CLF_FROM_UPCALL;
-				if (!olck->ols_glimpse)
-					olck->ols_agl = 0;
 			}
 			cl_lock_signal(env, lock);
 			/* del user for lock upcall cookie */
-			cl_unuse_try(env, lock);
+			if (olck->ols_agl) {
+				if (!olck->ols_glimpse)
+					olck->ols_agl = 0;
+				cl_unuse_try(env, lock);
+			}
 		} else {
 			/* del user for lock upcall cookie */
-			cl_lock_user_del(env, lock);
+			if (olck->ols_agl)
+				cl_lock_user_del(env, lock);
 			cl_lock_error(env, lock, rc);
 		}
 
@@ -1128,8 +1131,9 @@ static int osc_lock_enqueue(const struct lu_env *env,
 			/* lock will be passed as upcall cookie,
 			 * hold ref to prevent to be released. */
 			cl_lock_hold_add(env, lock, "upcall", lock);
-			/* a user for lock also */
-			cl_lock_user_add(env, lock);
+			/* a user for agl lock also */
+			if (ols->ols_agl)
+				cl_lock_user_add(env, lock);
 			ols->ols_state = OLS_ENQUEUED;
 
 			/*
@@ -1147,7 +1151,8 @@ static int osc_lock_enqueue(const struct lu_env *env,
 					  ols, einfo, &ols->ols_handle,
 					  PTLRPCD_SET, 1, ols->ols_agl);
 			if (result != 0) {
-				cl_lock_user_del(env, lock);
+				if (ols->ols_agl)
+					cl_lock_user_del(env, lock);
 				cl_lock_unhold(env, lock, "upcall", lock);
 				if (unlikely(result == -ECANCELED)) {
 					ols->ols_state = OLS_NEW;
-- 
1.7.9.5

