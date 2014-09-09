Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbaIIOhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:37:16 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:50646 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbaIIOhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:37:06 -0400
From: Hugues Morisset <morisset.hugues@gmail.com>
X-Google-Original-From: Hugues Morisset <morisset.hugues@gamil.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com
Cc: gregkh@linuxfoundation.org, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Hugues Morisset <morisset.hugues@gmail.com>
Subject: [PATCH 2/3] staging: lustre: fix inappropriate enums declarations.
Date: Tue,  9 Sep 2014 16:36:26 +0200
Message-Id: <1410273387-682902-3-git-send-email-morisset.hugues@gamil.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410273387-682902-1-git-send-email-morisset.hugues@gamil.com>
References: <1410273387-682902-1-git-send-email-morisset.hugues@gamil.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugues Morisset <morisset.hugues@gmail.com>

Signed-off-by: Hugues Morisset <morisset.hugues@gmail.com>
---
 drivers/staging/lustre/lustre/include/obd.h   | 10 +++-------
 drivers/staging/lustre/lustre/lmv/lmv_obd.c   |  2 +-
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c |  6 +++---
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index db39d23..7f2b8cb 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -589,13 +589,11 @@ enum placement_policy {
 	PLACEMENT_MAX_POLICY
 };
 
-typedef enum placement_policy placement_policy_t;
-
 struct lmv_obd {
 	int			refcount;
 	struct lu_client_fld	lmv_fld;
 	spinlock_t		lmv_lock;
-	placement_policy_t	lmv_placement;
+	enum placement_policy	lmv_placement;
 	struct lmv_desc		desc;
 	struct obd_uuid		cluuid;
 	struct obd_export	*exp;
@@ -1115,16 +1113,14 @@ enum op_cli_flags {
 
 struct md_enqueue_info;
 /* metadata stat-ahead */
-typedef int (* md_enqueue_cb_t)(struct ptlrpc_request *req,
-				struct md_enqueue_info *minfo,
-				int rc);
 
 struct md_enqueue_info {
 	struct md_op_data       mi_data;
 	struct lookup_intent    mi_it;
 	struct lustre_handle    mi_lockh;
 	struct inode	   *mi_dir;
-	md_enqueue_cb_t	 mi_cb;
+	int (*mi_cb)(struct ptlrpc_request *req,
+		struct md_enqueue_info *minfo, int rc);
 	__u64		   mi_cbdata;
 	unsigned int	    mi_generation;
 };
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index dfb10d6..1a58212 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -1189,7 +1189,7 @@ static int lmv_nid_policy(struct lmv_obd *lmv)
 }
 
 static int lmv_choose_mds(struct lmv_obd *lmv, struct md_op_data *op_data,
-			  placement_policy_t placement)
+			  enum placement_policy placement)
 {
 	switch (placement) {
 	case PLACEMENT_CHAR_POLICY:
diff --git a/drivers/staging/lustre/lustre/lmv/lproc_lmv.c b/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
index a7814f1..1170020 100644
--- a/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
+++ b/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
@@ -58,7 +58,7 @@ static const char *placement_name[] = {
 	[PLACEMENT_INVAL_POLICY]  = "INVAL"
 };
 
-static placement_policy_t placement_name2policy(char *name, int len)
+static enum placement_policy placement_name2policy(char *name, int len)
 {
 	int		     i;
 
@@ -69,7 +69,7 @@ static placement_policy_t placement_name2policy(char *name, int len)
 	return PLACEMENT_INVAL_POLICY;
 }
 
-static const char *placement_policy2name(placement_policy_t placement)
+static const char *placement_policy2name(enum placement_policy placement)
 {
 	LASSERT(placement < PLACEMENT_MAX_POLICY);
 	return placement_name[placement];
@@ -94,7 +94,7 @@ static ssize_t lmv_placement_seq_write(struct file *file,
 	struct obd_device *dev = ((struct seq_file *)file->private_data)->private;
 	char		     dummy[MAX_POLICY_STRING_SIZE + 1];
 	int		      len = count;
-	placement_policy_t       policy;
+	enum placement_policy       policy;
 	struct lmv_obd	  *lmv;
 
 	if (copy_from_user(dummy, buffer, MAX_POLICY_STRING_SIZE))
-- 
2.1.0

