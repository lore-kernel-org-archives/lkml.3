Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab3GVQNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:13:05 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:55127 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002Ab3GVQM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:12:57 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 37/48] staging/lustre/procfs: return -ENOMEM from lprocfs_register()
Date: Tue, 23 Jul 2013 00:06:58 +0800
Message-Id: <1374509230-3324-38-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

In lprocfs_register(), if proc_mkdir() fails then return
ERR_PTR(-ENOMEM) rather than NULL and hold _lprocfs_mutex for the
whole function.  In lprocfs_remove_nolock() return early if the entry
is an error pointer. Improve error handling around lprocfs_register()
in a few spots.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2650
Lustre-change: http://review.whamcloud.com/5161
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Emoly Liu <emoly.liu@intel.com>
Reviewed-by: Keith Mannthey <keith.mannthey@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |    1 +
 drivers/staging/lustre/lustre/llite/super25.c      |    2 +-
 drivers/staging/lustre/lustre/lov/lov_obd.c        |    6 ++---
 .../lustre/lustre/obdclass/linux/linux-module.c    |    9 ++++++-
 .../lustre/lustre/obdclass/lprocfs_status.c        |   28 ++++++++++++--------
 .../staging/lustre/lustre/ptlrpc/gss/lproc_gss.c   |    6 +++--
 6 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
index 3277a0d..101af4b 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
@@ -750,6 +750,7 @@ static int ldlm_pool_proc_init(struct ldlm_pool *pl)
 	if (IS_ERR(pl->pl_proc_dir)) {
 		CERROR("LProcFS failed in ldlm-pool-init\n");
 		rc = PTR_ERR(pl->pl_proc_dir);
+		pl->pl_proc_dir = NULL;
 		GOTO(out_free_name, rc);
 	}
 
diff --git a/drivers/staging/lustre/lustre/llite/super25.c b/drivers/staging/lustre/lustre/llite/super25.c
index 82c14a9..ea06f1a 100644
--- a/drivers/staging/lustre/lustre/llite/super25.c
+++ b/drivers/staging/lustre/lustre/llite/super25.c
@@ -214,7 +214,7 @@ static void __exit exit_lustre_lite(void)
 	ll_remote_perm_cachep = NULL;
 
 	kmem_cache_destroy(ll_file_data_slab);
-	if (proc_lustre_fs_root)
+	if (proc_lustre_fs_root && !IS_ERR(proc_lustre_fs_root))
 		lprocfs_remove(&proc_lustre_fs_root);
 }
 
diff --git a/drivers/staging/lustre/lustre/lov/lov_obd.c b/drivers/staging/lustre/lustre/lov/lov_obd.c
index 0a9e40d..c7c1a8c 100644
--- a/drivers/staging/lustre/lustre/lov/lov_obd.c
+++ b/drivers/staging/lustre/lustre/lov/lov_obd.c
@@ -836,11 +836,11 @@ int lov_setup(struct obd_device *obd, struct lustre_cfg *lcfg)
 	lprocfs_obd_setup(obd, lvars.obd_vars);
 #ifdef LPROCFS
 	{
-		int rc;
+		int rc1;
 
-		rc = lprocfs_seq_create(obd->obd_proc_entry, "target_obd",
+		rc1 = lprocfs_seq_create(obd->obd_proc_entry, "target_obd",
 					0444, &lov_proc_target_fops, obd);
-		if (rc)
+		if (rc1)
 			CWARN("Error adding the target_obd file\n");
 	}
 #endif
diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
index d2c3072..2abacf2 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
@@ -385,14 +385,21 @@ struct file_operations obd_device_list_fops = {
 
 int class_procfs_init(void)
 {
-	int rc;
+	int rc = 0;
 	ENTRY;
 
 	obd_sysctl_init();
 	proc_lustre_root = lprocfs_register("fs/lustre", NULL,
 					    lprocfs_base, NULL);
+	if (IS_ERR(proc_lustre_root)) {
+		rc = PTR_ERR(proc_lustre_root);
+		proc_lustre_root = NULL;
+		goto out;
+	}
+
 	rc = lprocfs_seq_create(proc_lustre_root, "devices", 0444,
 				&obd_device_list_fops, NULL);
+out:
 	if (rc)
 		CERROR("error adding /proc/fs/lustre/devices file\n");
 	RETURN(0);
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 85163f4..e57a922 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -179,17 +179,21 @@ struct proc_dir_entry *lprocfs_register(const char *name,
 					struct proc_dir_entry *parent,
 					struct lprocfs_vars *list, void *data)
 {
-	struct proc_dir_entry *newchild;
-
-	newchild = proc_mkdir(name, parent);
-	if (newchild != NULL && list != NULL) {
-		int rc = lprocfs_add_vars(newchild, list, data);
-		if (rc) {
-			lprocfs_remove(&newchild);
-			return ERR_PTR(rc);
+	struct proc_dir_entry *entry;
+
+	entry = proc_mkdir(name, parent);
+	if (entry == NULL)
+		GOTO(out, entry = ERR_PTR(-ENOMEM));
+
+	if (list != NULL) {
+		int rc = lprocfs_add_vars(entry, list, data);
+		if (rc != 0) {
+			lprocfs_remove(&entry);
+			entry = ERR_PTR(rc);
 		}
 	}
-	return newchild;
+out:
+	return entry;
 }
 EXPORT_SYMBOL(lprocfs_register);
 
@@ -1596,10 +1600,12 @@ int lprocfs_exp_setup(struct obd_export *exp, lnet_nid_t *nid, int *newnid)
 					      NULL, NULL);
 	OBD_FREE(buffer, LNET_NIDSTR_SIZE);
 
-	if (new_stat->nid_proc == NULL) {
+	if (IS_ERR(new_stat->nid_proc)) {
 		CERROR("Error making export directory for nid %s\n",
 		       libcfs_nid2str(*nid));
-		GOTO(destroy_new_ns, rc = -ENOMEM);
+		rc = PTR_ERR(new_stat->nid_proc);
+		new_stat->nid_proc = NULL;
+		GOTO(destroy_new_ns, rc);
 	}
 
 	entry = lprocfs_add_simple(new_stat->nid_proc, "uuid",
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/lproc_gss.c b/drivers/staging/lustre/lustre/ptlrpc/gss/lproc_gss.c
index 3404000..de100a1 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/lproc_gss.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/lproc_gss.c
@@ -199,15 +199,17 @@ int gss_init_lproc(void)
 	gss_proc_root = lprocfs_register("gss", sptlrpc_proc_root,
 					 gss_lprocfs_vars, NULL);
 	if (IS_ERR(gss_proc_root)) {
+		rc = PTR_ERR(gss_proc_root);
 		gss_proc_root = NULL;
-		GOTO(err_out, rc = PTR_ERR(gss_proc_root));
+		GOTO(err_out, rc);
 	}
 
 	gss_proc_lk = lprocfs_register("lgss_keyring", gss_proc_root,
 				       gss_lk_lprocfs_vars, NULL);
 	if (IS_ERR(gss_proc_lk)) {
+		rc = PTR_ERR(gss_proc_lk);
 		gss_proc_lk = NULL;
-		GOTO(err_out, rc = PTR_ERR(gss_proc_root));
+		GOTO(err_out, rc);
 	}
 
 	return 0;
-- 
1.7.9.5

