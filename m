Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab3KNQty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:49:54 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:61279 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab3KNQoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:44:01 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Andrew Perepechko <andrew_perepechko@xyratex.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 08/26] staging/lustre/llite: speedup in unlink/rmdir
Date: Fri, 15 Nov 2013 00:42:55 +0800
Message-Id: <1384447393-13838-9-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Perepechko <andrew_perepechko@xyratex.com>

Assume dchild argument is fully initialized in ->unlink and
->rmdir callbacks, so additional lookup for ELC is not needed.

Lustre-change: http://review.whamcloud.com/6648
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3473
Reviewed-by: Alexander Boyko <Alexander_Boyko@xyratex.com>
Reviewed-by: Vitaly Fertman <Vitaly_Fertman@xyratex.com>
Signed-off-by: Andrew Perepechko <andrew_perepechko@xyratex.com>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/namei.c |   30 +++++++++------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index 3cfd34d..46b9ca8 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -942,22 +942,6 @@ static int ll_mkdir_generic(struct inode *dir, struct qstr *name,
 	return err;
 }
 
-/* Try to find the child dentry by its name.
-   If found, put the result fid into @fid. */
-static void ll_get_child_fid(struct inode * dir, struct qstr *name,
-			     struct lu_fid *fid)
-{
-	struct dentry *parent, *child;
-
-	parent = ll_d_hlist_entry(dir->i_dentry, struct dentry, d_alias);
-	child = d_lookup(parent, name);
-	if (child) {
-		if (child->d_inode)
-			*fid = *ll_inode2fid(child->d_inode);
-		dput(child);
-	}
-}
-
 static int ll_rmdir_generic(struct inode *dir, struct dentry *dparent,
 			    struct dentry *dchild, struct qstr *name)
 {
@@ -976,7 +960,8 @@ static int ll_rmdir_generic(struct inode *dir, struct dentry *dparent,
 	if (IS_ERR(op_data))
 		return PTR_ERR(op_data);
 
-	ll_get_child_fid(dir, name, &op_data->op_fid3);
+	if (dchild != NULL && dchild->d_inode != NULL)
+		op_data->op_fid3 = *ll_inode2fid(dchild->d_inode);
 	op_data->op_fid2 = op_data->op_fid3;
 	rc = md_unlink(ll_i2sbi(dir)->ll_md_exp, op_data, &request);
 	ll_finish_md_op_data(op_data);
@@ -1117,7 +1102,9 @@ static int ll_unlink_generic(struct inode *dir, struct dentry *dparent,
 	if (IS_ERR(op_data))
 		return PTR_ERR(op_data);
 
-	ll_get_child_fid(dir, name, &op_data->op_fid3);
+	if (dchild != NULL && dchild->d_inode != NULL)
+		op_data->op_fid3 = *ll_inode2fid(dchild->d_inode);
+
 	op_data->op_fid2 = op_data->op_fid3;
 	rc = md_unlink(ll_i2sbi(dir)->ll_md_exp, op_data, &request);
 	ll_finish_md_op_data(op_data);
@@ -1157,8 +1144,11 @@ static int ll_rename_generic(struct inode *src, struct dentry *src_dparent,
 	if (IS_ERR(op_data))
 		return PTR_ERR(op_data);
 
-	ll_get_child_fid(src, src_name, &op_data->op_fid3);
-	ll_get_child_fid(tgt, tgt_name, &op_data->op_fid4);
+	if (src_dchild != NULL && src_dchild->d_inode != NULL)
+		op_data->op_fid3 = *ll_inode2fid(src_dchild->d_inode);
+	if (tgt_dchild != NULL && tgt_dchild->d_inode != NULL)
+		op_data->op_fid4 = *ll_inode2fid(tgt_dchild->d_inode);
+
 	err = md_rename(sbi->ll_md_exp, op_data,
 			src_name->name, src_name->len,
 			tgt_name->name, tgt_name->len, &request);
-- 
1.7.9.5

