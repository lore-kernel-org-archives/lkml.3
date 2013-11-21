Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab3KUO1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:27:43 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40571 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab3KUO10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:27:26 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Amir Shehata <amir.shehata@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v2 3/3] staging/lustre/lnet: Fix assert on empty group in selftest module
Date: Thu, 21 Nov 2013 22:24:50 +0800
Message-Id: <1385043890-3053-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385043890-3053-1-git-send-email-bergwolf@gmail.com>
References: <1385043890-3053-1-git-send-email-bergwolf@gmail.com>
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
[coding style fix of the original patch is splitted into a new one -- PengTao]
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lnet/selftest/console.c |   79 +++++++++++++++++-------
 drivers/staging/lustre/lnet/selftest/console.h |    6 +-
 2 files changed, 61 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/lustre/lnet/selftest/console.c b/drivers/staging/lustre/lnet/selftest/console.c
index 067a8b5..9556bc0 100644
--- a/drivers/staging/lustre/lnet/selftest/console.c
+++ b/drivers/staging/lustre/lnet/selftest/console.c
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
 
@@ -1310,7 +1346,8 @@ lstcon_test_add(char *name, int type, int loop, int concur,
 
 	if (lstcon_trans_stat()->trs_rpc_errno != 0 ||
 	    lstcon_trans_stat()->trs_fwk_errno != 0)
-		CDEBUG(D_NET, "Failed to add test %d to batch %s\n", type, name);
+		CDEBUG(D_NET, "Failed to add test %d to batch %s\n", type,
+		       batch_name);
 
 	/* add to test list anyway, so user can check what's going on */
 	list_add_tail(&test->tes_link, &batch->bat_test_list);
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

