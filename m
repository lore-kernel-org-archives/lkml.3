Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab3BFT4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:56:43 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:55971 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030232Ab3BFTvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:51:04 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 62/77] target/iscsi: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:34 -0800
Message-Id: <1360179649-22465-63-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
---
 drivers/target/iscsi/iscsi_target.c       | 15 ++++++++-------
 drivers/target/iscsi/iscsi_target_login.c | 15 ++++++---------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 339f97f..f1fdf4f 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -144,23 +144,24 @@ struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *buf)
 	spin_lock_init(&tiqn->login_stats.lock);
 	spin_lock_init(&tiqn->logout_stats.lock);
 
-	if (!idr_pre_get(&tiqn_idr, GFP_KERNEL)) {
-		pr_err("idr_pre_get() for tiqn_idr failed\n");
-		kfree(tiqn);
-		return ERR_PTR(-ENOMEM);
-	}
 	tiqn->tiqn_state = TIQN_STATE_ACTIVE;
 
+	idr_preload(GFP_KERNEL);
 	spin_lock(&tiqn_lock);
-	ret = idr_get_new(&tiqn_idr, NULL, &tiqn->tiqn_index);
+
+	ret = idr_alloc(&tiqn_idr, NULL, 0, 0, GFP_NOWAIT);
 	if (ret < 0) {
-		pr_err("idr_get_new() failed for tiqn->tiqn_index\n");
+		pr_err("idr_alloc() failed for tiqn->tiqn_index\n");
 		spin_unlock(&tiqn_lock);
+		idr_preload_end();
 		kfree(tiqn);
 		return ERR_PTR(ret);
 	}
+	tiqn->tiqn_index = ret;
 	list_add_tail(&tiqn->tiqn_list, &g_tiqn_list);
+
 	spin_unlock(&tiqn_lock);
+	idr_preload_end();
 
 	pr_debug("CORE[0] - Added iSCSI Target IQN: %s\n", tiqn->tiqn);
 
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index fdb632f..2535d4d 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -247,19 +247,16 @@ static int iscsi_login_zero_tsih_s1(
 	spin_lock_init(&sess->session_usage_lock);
 	spin_lock_init(&sess->ttt_lock);
 
-	if (!idr_pre_get(&sess_idr, GFP_KERNEL)) {
-		pr_err("idr_pre_get() for sess_idr failed\n");
-		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		kfree(sess);
-		return -ENOMEM;
-	}
+	idr_preload(GFP_KERNEL);
 	spin_lock_bh(&sess_idr_lock);
-	ret = idr_get_new(&sess_idr, NULL, &sess->session_index);
+	ret = idr_alloc(&sess_idr, NULL, 0, 0, GFP_NOWAIT);
+	if (ret >= 0)
+		sess->session_index = ret;
 	spin_unlock_bh(&sess_idr_lock);
+	idr_preload_end();
 
 	if (ret < 0) {
-		pr_err("idr_get_new() for sess_idr failed\n");
+		pr_err("idr_alloc() for sess_idr failed\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
 		kfree(sess);
-- 
1.8.1

