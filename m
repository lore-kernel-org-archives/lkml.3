Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab3KNQuC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:50:02 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59158 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab3KNQnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:43:51 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Swapnil Pimpale <spimpale@ddn.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 05/26] staging/lustre/dcache: Unsafe error handling arnd ll_splice_alias
Date: Fri, 15 Nov 2013 00:42:52 +0800
Message-Id: <1384447393-13838-6-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Swapnil Pimpale <spimpale@ddn.com>

Callers of ll_splice_alias() should not assign the returned pointer to
the dentry since it can be an err pointer. Fixed the above bug using a
temporary dentry pointer. This temporary pointer is assigned to dentry
only if ll_splice_alias has not returned an err pointer.

Lustre-change: http://review.whamcloud.com/7460
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3807
Signed-off-by: Swapnil Pimpale <spimpale@ddn.com>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/namei.c     |   21 ++++++++++--------
 drivers/staging/lustre/lustre/llite/statahead.c |   27 +++++++++++++----------
 2 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index c760059..3cfd34d 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -428,12 +428,12 @@ struct dentry *ll_splice_alias(struct inode *inode, struct dentry *de)
 int ll_lookup_it_finish(struct ptlrpc_request *request,
 			struct lookup_intent *it, void *data)
 {
-	struct it_cb_data *icbd = data;
-	struct dentry **de = icbd->icbd_childp;
-	struct inode *parent = icbd->icbd_parent;
-	struct inode *inode = NULL;
-	__u64 bits = 0;
-	int rc;
+	struct it_cb_data	 *icbd = data;
+	struct dentry		**de = icbd->icbd_childp;
+	struct inode		 *parent = icbd->icbd_parent;
+	struct inode		 *inode = NULL;
+	__u64			  bits = 0;
+	int			  rc;
 
 	/* NB 1 request reference will be taken away by ll_intent_lock()
 	 * when I return */
@@ -460,9 +460,12 @@ int ll_lookup_it_finish(struct ptlrpc_request *request,
 	 * Atoimc_open may passin hashed dentries for open.
 	 */
 	if (d_unhashed(*de)) {
-		*de = ll_splice_alias(inode, *de);
-		if (IS_ERR(*de))
-			return PTR_ERR(*de);
+		struct dentry *alias;
+
+		alias = ll_splice_alias(inode, *de);
+		if (IS_ERR(alias))
+			return PTR_ERR(alias);
+		*de = alias;
 	}
 
 	if (!it_disposition(it, DISP_LOOKUP_NEG)) {
diff --git a/drivers/staging/lustre/lustre/llite/statahead.c b/drivers/staging/lustre/lustre/llite/statahead.c
index 183b415..0db4006 100644
--- a/drivers/staging/lustre/lustre/llite/statahead.c
+++ b/drivers/staging/lustre/lustre/llite/statahead.c
@@ -1500,14 +1500,14 @@ ll_sai_unplug(struct ll_statahead_info *sai, struct ll_sa_entry *entry)
 int do_statahead_enter(struct inode *dir, struct dentry **dentryp,
 		       int only_unplug)
 {
-	struct ll_inode_info     *lli   = ll_i2info(dir);
-	struct ll_statahead_info *sai   = lli->lli_sai;
-	struct dentry	    *parent;
-	struct ll_sa_entry       *entry;
-	struct ptlrpc_thread     *thread;
-	struct l_wait_info	lwi   = { 0 };
-	int		       rc    = 0;
-	struct ll_inode_info     *plli;
+	struct ll_inode_info		*lli = ll_i2info(dir);
+	struct ll_statahead_info	*sai = lli->lli_sai;
+	struct dentry			*parent;
+	struct ll_sa_entry		*entry;
+	struct ptlrpc_thread		*thread;
+	struct l_wait_info		 lwi = { 0 };
+	int				 rc = 0;
+	struct ll_inode_info		*plli;
 
 	LASSERT(lli->lli_opendir_pid == current_pid());
 
@@ -1585,12 +1585,15 @@ int do_statahead_enter(struct inode *dir, struct dentry **dentryp,
 						ll_inode2fid(inode), &bits);
 			if (rc == 1) {
 				if ((*dentryp)->d_inode == NULL) {
-					*dentryp = ll_splice_alias(inode,
-								   *dentryp);
-					if (IS_ERR(*dentryp)) {
+					struct dentry *alias;
+
+					alias = ll_splice_alias(inode,
+								*dentryp);
+					if (IS_ERR(alias)) {
 						ll_sai_unplug(sai, entry);
-						return PTR_ERR(*dentryp);
+						return PTR_ERR(alias);
 					}
+					*dentryp = alias;
 				} else if ((*dentryp)->d_inode != inode) {
 					/* revalidate, but inode is recreated */
 					CDEBUG(D_READA,
-- 
1.7.9.5

