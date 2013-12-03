Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab3LCOFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:05:17 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:38102 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab3LCOFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:05:13 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Eremin <dmitry.eremin@intel.com>,
        Ned Bass <bass6@llnl.gov>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v3 15/15] staging/lustre/ptlrpc: better error handling in ptlrpcd_start
Date: Tue,  3 Dec 2013 21:58:53 +0800
Message-Id: <1386079133-6459-16-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
References: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

This is only part of the original Lustre tree commit. It cleans up
ptlrpcd_start error handling a bit.

Lustre-change: http://review.whamcloud.com/6139
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3204
Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Signed-off-by: Ned Bass <bass6@llnl.gov>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c |   44 ++++++++++++------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c b/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
index 2ebdb1b..8a95fa5 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
@@ -600,7 +600,6 @@ static int ptlrpcd_bind(int index, int max)
 int ptlrpcd_start(int index, int max, const char *name, struct ptlrpcd_ctl *pc)
 {
 	int rc;
-	int env = 0;
 
 	/*
 	 * Do not allow start second thread for one pc.
@@ -619,6 +618,7 @@ int ptlrpcd_start(int index, int max, const char *name, struct ptlrpcd_ctl *pc)
 	pc->pc_set = ptlrpc_prep_set();
 	if (pc->pc_set == NULL)
 		GOTO(out, rc = -ENOMEM);
+
 	/*
 	 * So far only "client" ptlrpcd uses an environment. In the future,
 	 * ptlrpcd thread (or a thread-set) has to be given an argument,
@@ -626,40 +626,40 @@ int ptlrpcd_start(int index, int max, const char *name, struct ptlrpcd_ctl *pc)
 	 */
 	rc = lu_context_init(&pc->pc_env.le_ctx, LCT_CL_THREAD|LCT_REMEMBER);
 	if (rc != 0)
-		GOTO(out, rc);
+		GOTO(out_set, rc);
 
-	env = 1;
 	{
 		struct task_struct *task;
-
 		if (index >= 0) {
 			rc = ptlrpcd_bind(index, max);
 			if (rc < 0)
-				GOTO(out, rc);
+				GOTO(out_env, rc);
 		}
 
-		task = kthread_run(ptlrpcd, pc, "%s", pc->pc_name);
+		task = kthread_run(ptlrpcd, pc, pc->pc_name);
 		if (IS_ERR(task))
-			GOTO(out, rc = PTR_ERR(task));
+			GOTO(out_env, rc = PTR_ERR(task));
 
-		rc = 0;
 		wait_for_completion(&pc->pc_starting);
 	}
-out:
-	if (rc) {
-		if (pc->pc_set != NULL) {
-			struct ptlrpc_request_set *set = pc->pc_set;
-
-			spin_lock(&pc->pc_lock);
-			pc->pc_set = NULL;
-			spin_unlock(&pc->pc_lock);
-			ptlrpc_set_destroy(set);
-		}
-		if (env != 0)
-			lu_context_fini(&pc->pc_env.le_ctx);
-		clear_bit(LIOD_BIND, &pc->pc_flags);
-		clear_bit(LIOD_START, &pc->pc_flags);
+	return 0;
+
+out_env:
+	lu_context_fini(&pc->pc_env.le_ctx);
+
+out_set:
+	if (pc->pc_set != NULL) {
+		struct ptlrpc_request_set *set = pc->pc_set;
+
+		spin_lock(&pc->pc_lock);
+		pc->pc_set = NULL;
+		spin_unlock(&pc->pc_lock);
+		ptlrpc_set_destroy(set);
 	}
+	clear_bit(LIOD_BIND, &pc->pc_flags);
+
+out:
+	clear_bit(LIOD_START, &pc->pc_flags);
 	return rc;
 }
 
-- 
1.7.9.5

