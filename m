Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab3KNQZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:25:38 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:44775 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab3KNQO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:14:58 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Amir Shehata <amir.shehata@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 08/40] staging/lustre/lnet: Fix assert on empty group in selftest module
Date: Fri, 15 Nov 2013 00:13:10 +0800
Message-Id: <1384445622-12346-9-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amir Shehata <amir.shehata@intel.com>

The core of the issue is that the selftest module doesn't sanitize its
own API, but it depends on lst utility to do such checks.  As a result
this issue manifests itself in this particular LU through an assert
on an empty group.  If the NID is misspelled then an empty group is
added.  An error output is provided, but if that's never checked in a
batch script, as is the case with this issue, then the script will try
to add an empty group to a test to run in a batch, and that will cause
an assert

The fix is two fold.  Ensure that lst utility checks that a group is
added with at least one node.  If not the group is subsequently
deleted.  And the add_test command would fail, since the group no
longer exists.

The second fix is to ensure that the kernel module itself sanitizes
its own API in this particular case, so that if a different utility is
used other than lst to communicate with the selftest kernel module
then this error would be caught.  This fix looks up the batch and the
groups, src and dst, in the ioctl handle and sanitizes that input at
this point.  If the group looked up either doesn't exist or doesn't
have at least one ACTIVE node, then the command fails.

NOTE:there are many other cases in the code where the selftest kernel
module doesn't check for sanity of the input, but depends totally on
the lst module to do such checks.  Particularly around length of
strings passed in.  Thus it is possible to crash the selftest module
if someone tries to create another userspace app to communicate with
the selftest kernel module without ensuring sanity of the params sent
to the kernel module.  In effect, it's always assumed that lst is the
front end for selftest and no other front end is to be used.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3093
Lustre-change: http://review.whamcloud.com/6092
Signed-off-by: Amir Shehata <amir.shehata@intel.com>
Reviewed-by: Isaac Huang <he.huang@intel.com>
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lnet/selftest/conctl.c  |   56 ++++++-------
 drivers/staging/lustre/lnet/selftest/conrpc.c  |    2 +-
 drivers/staging/lustre/lnet/selftest/console.c |  105 ++++++++++++++++--------
 drivers/staging/lustre/lnet/selftest/console.h |    6 +-
 4 files changed, 102 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/lustre/lnet/selftest/conctl.c b/drivers/staging/lustre/lnet/selftest/conctl.c
index bce3d3b..cbc416d 100644
--- a/drivers/staging/lustre/lnet/selftest/conctl.c
+++ b/drivers/staging/lustre/lnet/selftest/conctl.c
@@ -723,12 +723,12 @@ lst_stat_query_ioctl(lstio_stat_args_t *args)
 
 int lst_test_add_ioctl(lstio_test_args_t *args)
 {
-	char	   *name;
-	char	   *srcgrp = NULL;
-	char	   *dstgrp = NULL;
-	void	   *param = NULL;
-	int	     ret = 0;
-	int	     rc = -ENOMEM;
+	char		*batch_name;
+	char		*src_name = NULL;
+	char		*dst_name = NULL;
+	void		*param = NULL;
+	int		ret = 0;
+	int		rc = -ENOMEM;
 
 	if (args->lstio_tes_resultp == NULL ||
 	    args->lstio_tes_retp == NULL ||
@@ -755,16 +755,16 @@ int lst_test_add_ioctl(lstio_test_args_t *args)
 	     args->lstio_tes_param_len > PAGE_CACHE_SIZE - sizeof(lstcon_test_t)))
 		return -EINVAL;
 
-	LIBCFS_ALLOC(name, args->lstio_tes_bat_nmlen + 1);
-	if (name == NULL)
+	LIBCFS_ALLOC(batch_name, args->lstio_tes_bat_nmlen + 1);
+	if (batch_name == NULL)
 		return rc;
 
-	LIBCFS_ALLOC(srcgrp, args->lstio_tes_sgrp_nmlen + 1);
-	if (srcgrp == NULL)
+	LIBCFS_ALLOC(src_name, args->lstio_tes_sgrp_nmlen + 1);
+	if (src_name == NULL)
 		goto out;
 
-	LIBCFS_ALLOC(dstgrp, args->lstio_tes_dgrp_nmlen + 1);
-	 if (dstgrp == NULL)
+	LIBCFS_ALLOC(dst_name, args->lstio_tes_dgrp_nmlen + 1);
+	 if (dst_name == NULL)
 		goto out;
 
 	if (args->lstio_tes_param != NULL) {
@@ -774,39 +774,37 @@ int lst_test_add_ioctl(lstio_test_args_t *args)
 	}
 
 	rc = -EFAULT;
-	if (copy_from_user(name,
-			      args->lstio_tes_bat_name,
-			      args->lstio_tes_bat_nmlen) ||
-	    copy_from_user(srcgrp,
-			      args->lstio_tes_sgrp_name,
-			      args->lstio_tes_sgrp_nmlen) ||
-	    copy_from_user(dstgrp,
-			      args->lstio_tes_dgrp_name,
-			      args->lstio_tes_dgrp_nmlen) ||
+	if (copy_from_user(batch_name, args->lstio_tes_bat_name,
+			   args->lstio_tes_bat_nmlen) ||
+	    copy_from_user(src_name, args->lstio_tes_sgrp_name,
+			   args->lstio_tes_sgrp_nmlen) ||
+	    copy_from_user(dst_name, args->lstio_tes_dgrp_name,
+			   args->lstio_tes_dgrp_nmlen) ||
 	    copy_from_user(param, args->lstio_tes_param,
 			      args->lstio_tes_param_len))
 		goto out;
 
-	rc = lstcon_test_add(name,
+	rc = lstcon_test_add(batch_name,
 			    args->lstio_tes_type,
 			    args->lstio_tes_loop,
 			    args->lstio_tes_concur,
 			    args->lstio_tes_dist, args->lstio_tes_span,
-			    srcgrp, dstgrp, param, args->lstio_tes_param_len,
+			    src_name, dst_name, param,
+			    args->lstio_tes_param_len,
 			    &ret, args->lstio_tes_resultp);
 
 	if (ret != 0)
 		rc = (copy_to_user(args->lstio_tes_retp, &ret,
 				       sizeof(ret))) ? -EFAULT : 0;
 out:
-	if (name != NULL)
-		LIBCFS_FREE(name, args->lstio_tes_bat_nmlen + 1);
+	if (batch_name != NULL)
+		LIBCFS_FREE(batch_name, args->lstio_tes_bat_nmlen + 1);
 
-	if (srcgrp != NULL)
-		LIBCFS_FREE(srcgrp, args->lstio_tes_sgrp_nmlen + 1);
+	if (src_name != NULL)
+		LIBCFS_FREE(src_name, args->lstio_tes_sgrp_nmlen + 1);
 
-	if (dstgrp != NULL)
-		LIBCFS_FREE(dstgrp, args->lstio_tes_dgrp_nmlen + 1);
+	if (dst_name != NULL)
+		LIBCFS_FREE(dst_name, args->lstio_tes_dgrp_nmlen + 1);
 
 	if (param != NULL)
 		LIBCFS_FREE(param, args->lstio_tes_param_len);
diff --git a/drivers/staging/lustre/lnet/selftest/conrpc.c b/drivers/staging/lustre/lnet/selftest/conrpc.c
index 9a52f25..4d48c77 100644
--- a/drivers/staging/lustre/lnet/selftest/conrpc.c
+++ b/drivers/staging/lustre/lnet/selftest/conrpc.c
@@ -311,7 +311,7 @@ lstcon_rpc_trans_abort(lstcon_rpc_trans_t *trans, int error)
 
 		sfw_abort_rpc(rpc);
 
-		if  (error != ETIMEDOUT)
+		if (error != -ETIMEDOUT)
 			continue;
 
 		nd = crpc->crp_node;
diff --git a/drivers/staging/lustre/lnet/selftest/console.c b/drivers/staging/lustre/lnet/selftest/console.c
index f1152e4..d498e3e 100644
--- a/drivers/staging/lustre/lnet/selftest/console.c
+++ b/drivers/staging/lustre/lnet/selftest/console.c
@@ -265,7 +265,7 @@ lstcon_group_decref(lstcon_group_t *grp)
 }
 
 static int
-lstcon_group_find(char *name, lstcon_group_t **grpp)
+lstcon_group_find(const char *name, lstcon_group_t **grpp)
 {
 	lstcon_group_t   *grp;
 
@@ -831,7 +831,7 @@ lstcon_group_info(char *name, lstcon_ndlist_ent_t *gents_p,
 }
 
 int
-lstcon_batch_find(char *name, lstcon_batch_t **batpp)
+lstcon_batch_find(const char *name, lstcon_batch_t **batpp)
 {
 	lstcon_batch_t   *bat;
 
@@ -1237,41 +1237,77 @@ again:
 	goto again;
 }
 
-int
-lstcon_test_add(char *name, int type, int loop, int concur,
-		int dist, int span, char *src_name, char * dst_name,
-		void *param, int paramlen, int *retp,
-		struct list_head *result_up)
+static int
+lstcon_verify_batch(const char *name, lstcon_batch_t **batch)
 {
-	lstcon_group_t  *src_grp = NULL;
-	lstcon_group_t  *dst_grp = NULL;
-	lstcon_test_t   *test    = NULL;
-	lstcon_batch_t  *batch;
-	int	      rc;
+	int rc;
 
-	rc = lstcon_batch_find(name, &batch);
+	rc = lstcon_batch_find(name, batch);
 	if (rc != 0) {
 		CDEBUG(D_NET, "Can't find batch %s\n", name);
 		return rc;
 	}
 
-	if (batch->bat_state != LST_BATCH_IDLE) {
+	if ((*batch)->bat_state != LST_BATCH_IDLE) {
 		CDEBUG(D_NET, "Can't change running batch %s\n", name);
-		return rc;
+		return -EINVAL;
 	}
 
-	rc = lstcon_group_find(src_name, &src_grp);
+	return 0;
+}
+
+static int
+lstcon_verify_group(const char *name, lstcon_group_t **grp)
+{
+	int			rc;
+	lstcon_ndlink_t		*ndl;
+
+	rc = lstcon_group_find(name, grp);
 	if (rc != 0) {
-		CDEBUG(D_NET, "Can't find group %s\n", src_name);
-		goto out;
+		CDEBUG(D_NET, "can't find group %s\n", name);
+		return rc;
 	}
 
-	rc = lstcon_group_find(dst_name, &dst_grp);
-	if (rc != 0) {
-		CDEBUG(D_NET, "Can't find group %s\n", dst_name);
-		goto out;
+	list_for_each_entry(ndl, &(*grp)->grp_ndl_list, ndl_link) {
+		if (ndl->ndl_node->nd_state == LST_NODE_ACTIVE)
+			return 0;
 	}
 
+	CDEBUG(D_NET, "Group %s has no ACTIVE nodes\n", name);
+
+	return -EINVAL;
+}
+
+int
+lstcon_test_add(char *batch_name, int type, int loop,
+		int concur, int dist, int span,
+		char *src_name, char *dst_name,
+		void *param, int paramlen, int *retp,
+		struct list_head *result_up)
+{
+	lstcon_test_t	 *test	 = NULL;
+	int		 rc;
+	lstcon_group_t	 *src_grp = NULL;
+	lstcon_group_t	 *dst_grp = NULL;
+	lstcon_batch_t	 *batch = NULL;
+
+	/*
+	 * verify that a batch of the given name exists, and the groups
+	 * that will be part of the batch exist and have at least one
+	 * active node
+	 */
+	rc = lstcon_verify_batch(batch_name, &batch);
+	if (rc != 0)
+		goto out;
+
+	rc = lstcon_verify_group(src_name, &src_grp);
+	if (rc != 0)
+		goto out;
+
+	rc = lstcon_verify_group(dst_name, &dst_grp);
+	if (rc != 0)
+		goto out;
+
 	if (dst_grp->grp_userland)
 		*retp = 1;
 
@@ -1284,18 +1320,18 @@ lstcon_test_add(char *name, int type, int loop, int concur,
 	}
 
 	memset(test, 0, offsetof(lstcon_test_t, tes_param[paramlen]));
-	test->tes_hdr.tsb_id    = batch->bat_hdr.tsb_id;
-	test->tes_batch	 = batch;
-	test->tes_type	  = type;
-	test->tes_oneside       = 0; /* TODO */
-	test->tes_loop	  = loop;
+	test->tes_hdr.tsb_id	= batch->bat_hdr.tsb_id;
+	test->tes_batch		= batch;
+	test->tes_type		= type;
+	test->tes_oneside	= 0; /* TODO */
+	test->tes_loop		= loop;
 	test->tes_concur	= concur;
-	test->tes_stop_onerr    = 1; /* TODO */
-	test->tes_span	  = span;
-	test->tes_dist	  = dist;
+	test->tes_stop_onerr	= 1; /* TODO */
+	test->tes_span		= span;
+	test->tes_dist		= dist;
 	test->tes_cliidx	= 0; /* just used for creating RPC */
-	test->tes_src_grp       = src_grp;
-	test->tes_dst_grp       = dst_grp;
+	test->tes_src_grp	= src_grp;
+	test->tes_dst_grp	= dst_grp;
 	INIT_LIST_HEAD(&test->tes_trans_list);
 
 	if (param != NULL) {
@@ -1310,12 +1346,13 @@ lstcon_test_add(char *name, int type, int loop, int concur,
 
 	if (lstcon_trans_stat()->trs_rpc_errno != 0 ||
 	    lstcon_trans_stat()->trs_fwk_errno != 0)
-		CDEBUG(D_NET, "Failed to add test %d to batch %s\n", type, name);
+		CDEBUG(D_NET, "Failed to add test %d to batch %s\n", type,
+		       batch_name);
 
 	/* add to test list anyway, so user can check what's going on */
 	list_add_tail(&test->tes_link, &batch->bat_test_list);
 
-	batch->bat_ntest ++;
+	batch->bat_ntest++;
 	test->tes_hdr.tsb_index = batch->bat_ntest;
 
 	/*  hold groups so nobody can change them */
diff --git a/drivers/staging/lustre/lnet/selftest/console.h b/drivers/staging/lustre/lnet/selftest/console.h
index e61b266..b57dbd8 100644
--- a/drivers/staging/lustre/lnet/selftest/console.h
+++ b/drivers/staging/lustre/lnet/selftest/console.h
@@ -224,9 +224,9 @@ extern int lstcon_group_stat(char *grp_name, int timeout,
 			     struct list_head *result_up);
 extern int lstcon_nodes_stat(int count, lnet_process_id_t *ids_up,
 			     int timeout, struct list_head *result_up);
-extern int lstcon_test_add(char *name, int type, int loop, int concur,
-			   int dist, int span, char *src_name, char * dst_name,
+extern int lstcon_test_add(char *batch_name, int type, int loop,
+			   int concur, int dist, int span,
+			   char *src_name, char *dst_name,
 			   void *param, int paramlen, int *retp,
 			   struct list_head *result_up);
-
 #endif
-- 
1.7.9.5

