Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab3KNQUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:20:19 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:53873 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab3KNQQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:16:59 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Henri Doreau <henri.doreau@cea.fr>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 39/40] staging/lustre/utils: HSM Posix CopyTool
Date: Fri, 15 Nov 2013 00:13:41 +0800
Message-Id: <1384445622-12346-40-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>

POSIX HSM CopyTool utils named lhsmtool_posix.
This user space command is the 'glue" between Lustre-HSM
and a POSIX filesytem used as a backend.
The main functionalities implemented are:
daemon mode:
- archive: read in lustre write with POSIX backend
- restore: read in POSIX backend write to Lustre
- remove: remove an entry from backend
cmd line mode:
- import: create in lustre a released file from a backend file
- rebind: change the FID associated to a file in the backend
- maxseq: get the larger sequence of FID found in the backend

The 2 last options are used for disaster recovery mode

This tools is also used for all the non regression tests made in
sanity-hsm.sh

Lustre-change: http://review.whamcloud.com/4737
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2062
Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Signed-off-by: Henri Doreau <henri.doreau@cea.fr>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_user.h     |    9 ++---
 .../lustre/lustre/include/lustre/lustreapi.h       |   36 +++++++++++++-------
 2 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index 49ab5be..c63a1ae 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -311,6 +311,9 @@ struct ost_id {
 #define LOV_ALL_STRIPES       0xffff /* only valid for directories */
 #define LOV_V1_INSANE_STRIPE_COUNT 65532 /* maximum stripe count bz13933 */
 
+#define XATTR_LUSTRE_PREFIX	"lustre."
+#define XATTR_LUSTRE_LOV	XATTR_LUSTRE_PREFIX"lov"
+
 #define lov_user_ost_data lov_user_ost_data_v1
 struct lov_user_ost_data_v1 {     /* per-stripe data structure */
 	struct ost_id l_ost_oi;	  /* OST object ID */
@@ -1158,12 +1161,6 @@ struct hsm_progress {
 	__u32			padding;
 };
 
-/**
- * Use by copytool during any hsm request they handled.
- * This structure is initialized by llapi_hsm_copy_start()
- * which is an helper over the ioctl() interface
- * Store Lustre, internal use only, data.
- */
 struct hsm_copy {
 	__u64			hc_data_version;
 	__u16			hc_flags;
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustreapi.h b/drivers/staging/lustre/lustre/include/lustre/lustreapi.h
index 1748138..0bb3c9f 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustreapi.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustreapi.h
@@ -219,8 +219,8 @@ extern int llapi_lmv_get_uuids(int fd, struct obd_uuid *uuidp, int *mdt_count);
 extern int llapi_is_lustre_mnttype(const char *type);
 extern int llapi_search_ost(char *fsname, char *poolname, char *ostname);
 extern int llapi_get_obd_count(char *mnt, int *count, int is_mdt);
-extern int parse_size(char *optarg, unsigned long long *size,
-		      unsigned long long *size_units, int bytes_spec);
+extern int llapi_parse_size(const char *optarg, unsigned long long *size,
+			    unsigned long long *size_units, int bytes_spec);
 extern int llapi_search_mounts(const char *pathname, int index,
 			       char *mntdir, char *fsname);
 extern int llapi_search_fsname(const char *pathname, char *fsname);
@@ -298,18 +298,27 @@ extern int llapi_changelog_clear(const char *mdtname, const char *idstr,
  * priv is private state, managed internally by these functions
  */
 struct hsm_copytool_private;
-extern int llapi_hsm_copytool_start(struct hsm_copytool_private **priv,
-				    char *fsname, int flags,
-				    int archive_count, int *archives);
-extern int llapi_hsm_copytool_fini(struct hsm_copytool_private **priv);
+struct hsm_copyaction_private;
+
+extern int llapi_hsm_copytool_register(struct hsm_copytool_private **priv,
+				       const char *mnt, int flags,
+				       int archive_count, int *archives);
+extern int llapi_hsm_copytool_unregister(struct hsm_copytool_private **priv);
 extern int llapi_hsm_copytool_recv(struct hsm_copytool_private *priv,
 				   struct hsm_action_list **hal, int *msgsize);
-extern int llapi_hsm_copytool_free(struct hsm_action_list **hal);
-extern int llapi_hsm_copy_start(char *mnt, struct hsm_copy *copy,
-				const struct hsm_action_item *hai);
-extern int llapi_hsm_copy_end(char *mnt, struct hsm_copy *copy,
-			      const struct hsm_progress *hp);
-extern int llapi_hsm_progress(char *mnt, struct hsm_progress *hp);
+extern void llapi_hsm_action_list_free(struct hsm_action_list **hal);
+extern int llapi_hsm_action_begin(struct hsm_copyaction_private **hcp,
+				  const struct hsm_copytool_private *ct_priv,
+				  const struct hsm_action_item *hai,
+				  bool is_error);
+extern int llapi_hsm_action_end(struct hsm_copyaction_private **hcp,
+				const struct hsm_extent *he, int flags,
+				int errval);
+extern int llapi_hsm_action_progress(struct hsm_copyaction_private *hcp,
+				     const struct hsm_extent *he, int hp_flags);
+extern int llapi_hsm_action_get_dfid(const struct hsm_copyaction_private *hcp,
+				     lustre_fid *fid);
+extern int llapi_hsm_action_get_fd(const struct hsm_copyaction_private *hcp);
 extern int llapi_hsm_import(const char *dst, int archive, const struct stat *st,
 			    unsigned long long stripe_size, int stripe_offset,
 			    int stripe_count, int stripe_pattern,
@@ -318,7 +327,8 @@ extern int llapi_hsm_import(const char *dst, int archive, const struct stat *st,
 /* HSM user interface */
 extern struct hsm_user_request *llapi_hsm_user_request_alloc(int itemcount,
 							     int data_len);
-extern int llapi_hsm_request(char *mnt, struct hsm_user_request *request);
+extern int llapi_hsm_request(const char *path,
+			     const struct hsm_user_request *request);
 extern int llapi_hsm_current_action(const char *path,
 				    struct hsm_current_action *hca);
 /** @} llapi */
-- 
1.7.9.5

