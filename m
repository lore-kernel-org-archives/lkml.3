Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab3GVQSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:18:47 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:48457 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932893Ab3GVQMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:12:19 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 30/48] staging/lustre/llite: call simple_setattr() from ll_md_setattr()
Date: Tue, 23 Jul 2013 00:06:51 +0800
Message-Id: <1374509230-3324-31-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

This partially reverts the change from "LU-2482 layout: introduce new
layout for released files" by calling simple_setattr() from
ll_md_setattr() without ATTR_SIZE set. Doing so avoids failed
assertions in osc_page_delete(). Disable truncates on released files
and modify sanity 229 accordingly.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3448
Lustre-change: http://review.whamcloud.com/6643
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: jacques-Charles Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/llite_lib.c |   18 ++++++++----------
 drivers/staging/lustre/lustre/lov/lov_io.c      |    2 +-
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index b9cbe95..39d519b 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1282,6 +1282,13 @@ int ll_md_setattr(struct dentry *dentry, struct md_op_data *op_data,
 		RETURN(rc);
 	}
 
+	ia_valid = op_data->op_attr.ia_valid;
+	/* inode size will be in ll_setattr_ost, can't do it now since dirty
+	 * cache is not cleared yet. */
+	op_data->op_attr.ia_valid &= ~(TIMES_SET_FLAGS | ATTR_SIZE);
+	rc = simple_setattr(dentry, &op_data->op_attr);
+	op_data->op_attr.ia_valid = ia_valid;
+
 	/* Extract epoch data if obtained. */
 	op_data->op_handle = md.body->handle;
 	op_data->op_ioepoch = md.body->ioepoch;
@@ -1364,7 +1371,6 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr)
 	struct ll_inode_info *lli = ll_i2info(inode);
 	struct md_op_data *op_data = NULL;
 	struct md_open_data *mod = NULL;
-	unsigned int valid = attr->ia_valid;
 	int rc = 0, rc1 = 0;
 	ENTRY;
 
@@ -1476,13 +1482,6 @@ int ll_setattr_raw(struct dentry *dentry, struct iattr *attr)
 		rc = ll_setattr_ost(inode, attr);
 	EXIT;
 out:
-	if (rc == 0) {
-		/* Update inode attribute after dirty cache is cleaned
-		 * by truncating OST objects. */
-		attr->ia_valid |= ATTR_FORCE;
-		rc = simple_setattr(dentry, attr);
-		LASSERT(rc == 0);
-	}
 	if (op_data) {
 		if (op_data->op_ioepoch) {
 			rc1 = ll_setattr_done_writing(inode, op_data, mod);
@@ -1501,8 +1500,7 @@ out:
 	ll_stats_ops_tally(ll_i2sbi(inode), (attr->ia_valid & ATTR_SIZE) ?
 			LPROC_LL_TRUNC : LPROC_LL_SETATTR, 1);
 
-	attr->ia_valid = valid;
-	RETURN(rc);
+	return rc;
 }
 
 int ll_setattr(struct dentry *de, struct iattr *attr)
diff --git a/drivers/staging/lustre/lustre/lov/lov_io.c b/drivers/staging/lustre/lustre/lov/lov_io.c
index e78cdb7..b316ce8 100644
--- a/drivers/staging/lustre/lustre/lov/lov_io.c
+++ b/drivers/staging/lustre/lustre/lov/lov_io.c
@@ -980,9 +980,9 @@ int lov_io_init_released(const struct lu_env *env, struct cl_object *obj,
 		LASSERTF(0, "invalid type %d\n", io->ci_type);
 	case CIT_MISC:
 	case CIT_FSYNC:
-	case CIT_SETATTR:
 		result = +1;
 		break;
+	case CIT_SETATTR:
 	case CIT_READ:
 	case CIT_WRITE:
 	case CIT_FAULT:
-- 
1.7.9.5

