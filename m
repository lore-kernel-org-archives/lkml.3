Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab3GVQLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:11:00 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:36906 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab3GVQKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:10:49 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, jcl <jacques-charles.lafoucriere@cea.fr>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 12/48] staging/lustre/mdc: layout lock rpc must not take rpc_lock
Date: Tue, 23 Jul 2013 00:06:33 +0800
Message-Id: <1374509230-3324-13-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jcl <jacques-charles.lafoucriere@cea.fr>

When a client issue an RPC to get a layout lock, it
must not hold rpc_lock because in case of a restore
the rpc can be blocking for a long time

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3200
Lustre-change: http://review.whamcloud.com/6115
Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Johann Lombardi <johann.lombardi@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_mdc.h |    6 ++++--
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_mdc.h b/drivers/staging/lustre/lustre/include/lustre_mdc.h
index fb1561a..82d1f2f 100644
--- a/drivers/staging/lustre/lustre/include/lustre_mdc.h
+++ b/drivers/staging/lustre/lustre/include/lustre_mdc.h
@@ -86,7 +86,8 @@ static inline void mdc_get_rpc_lock(struct mdc_rpc_lock *lck,
 {
 	ENTRY;
 
-	if (it != NULL && (it->it_op == IT_GETATTR || it->it_op == IT_LOOKUP))
+	if (it != NULL && (it->it_op == IT_GETATTR || it->it_op == IT_LOOKUP ||
+			   it->it_op == IT_LAYOUT))
 		return;
 
 	/* This would normally block until the existing request finishes.
@@ -123,7 +124,8 @@ static inline void mdc_get_rpc_lock(struct mdc_rpc_lock *lck,
 static inline void mdc_put_rpc_lock(struct mdc_rpc_lock *lck,
 				    struct lookup_intent *it)
 {
-	if (it != NULL && (it->it_op == IT_GETATTR || it->it_op == IT_LOOKUP))
+	if (it != NULL && (it->it_op == IT_GETATTR || it->it_op == IT_LOOKUP ||
+			   it->it_op == IT_LAYOUT))
 		goto out;
 
 	if (lck->rpcl_it == MDC_FAKE_RPCL_IT) { /* OBD_FAIL_MDC_RPCS_SEM */
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index bae2d67..9532134 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -884,7 +884,7 @@ static int mdc_finish_intent_lock(struct obd_export *exp,
 	struct mdt_body *mdt_body;
 	struct ldlm_lock *lock;
 	int rc;
-
+	ENTRY;
 
 	LASSERT(request != NULL);
 	LASSERT(request != LP_POISON);
-- 
1.7.9.5

