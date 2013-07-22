Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab3GVQNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:13:11 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:59948 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041Ab3GVQNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:13:06 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Nathaniel Clark <nathaniel.l.clark@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 39/48] staging/lustre/obdclass: be more careful processing server name
Date: Tue, 23 Jul 2013 00:07:00 +0800
Message-Id: <1374509230-3324-40-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathaniel Clark <nathaniel.l.clark@intel.com>

Because whole options line gets passed to exclude processing, don't
search from end of passed in argument to determine fsname at
beginning.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2200
Lustre-change: http://review.whamcloud.com/6197
Signed-off-by: Nathaniel Clark <nathaniel.l.clark@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lustre/obdclass/obd_config.c    |   11 ++--
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |   58 +++++++++++---------
 2 files changed, 40 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/obd_config.c b/drivers/staging/lustre/lustre/obdclass/obd_config.c
index bbf06d0..8b5eb6c 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_config.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_config.c
@@ -1426,10 +1426,13 @@ int class_config_llog_handler(const struct lu_env *env,
 		}
 
 
-		if ((clli->cfg_flags & CFG_F_EXCLUDE) &&
-		    (lcfg->lcfg_command == LCFG_LOV_ADD_OBD))
-			/* Add inactive instead */
-			lcfg->lcfg_command = LCFG_LOV_ADD_INA;
+		if (clli->cfg_flags & CFG_F_EXCLUDE) {
+			CDEBUG(D_CONFIG, "cmd: %x marked EXCLUDED\n",
+			       lcfg->lcfg_command);
+			if (lcfg->lcfg_command == LCFG_LOV_ADD_OBD)
+				/* Add inactive instead */
+				lcfg->lcfg_command = LCFG_LOV_ADD_INA;
+		}
 
 		lustre_cfg_bufs_init(&bufs, lcfg);
 
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_mount.c b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
index 4f20723..2cc6a26 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_mount.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
@@ -649,6 +649,15 @@ int lustre_put_lsi(struct super_block *sb)
 	RETURN(0);
 }
 
+/*** SERVER NAME ***
+ * <FSNAME><SEPERATOR><TYPE><INDEX>
+ * FSNAME is between 1 and 8 characters (inclusive).
+ *	Excluded characters are '/' and ':'
+ * SEPERATOR is either ':' or '-'
+ * TYPE: "OST", "MDT", etc.
+ * INDEX: Hex representation of the index
+ */
+
 /** Get the fsname ("lustre") from the server name ("lustre-OST003F").
  * @param [in] svname server name including type and index
  * @param [out] fsname Buffer to copy filesystem name prefix into.
@@ -658,22 +667,13 @@ int lustre_put_lsi(struct super_block *sb)
  */
 int server_name2fsname(const char *svname, char *fsname, const char **endptr)
 {
-	const char *dash = strrchr(svname, '-');
-	if (!dash) {
-		dash = strrchr(svname, ':');
-		if (!dash)
-			return -EINVAL;
-	}
+	const char *dash;
 
-	/* interpret <fsname>-MDTXXXXX-mdc as mdt, the better way is to pass
-	 * in the fsname, then determine the server index */
-	if (!strcmp(LUSTRE_MDC_NAME, dash + 1)) {
-		dash--;
-		for (; dash > svname && *dash != '-' && *dash != ':'; dash--)
-			;
-		if (dash == svname)
-			return -EINVAL;
-	}
+	dash = svname + strnlen(svname, 8); /* max fsname length is 8 */
+	for (; dash > svname && *dash != '-' && *dash != ':'; dash--)
+		;
+	if (dash == svname)
+		return -EINVAL;
 
 	if (fsname != NULL) {
 		strncpy(fsname, svname, dash - svname);
@@ -696,15 +696,15 @@ int server_name2svname(const char *label, char *svname, const char **endptr,
 		       size_t svsize)
 {
 	int rc;
-	const const char *dash;
+	const char *dash;
 
 	/* We use server_name2fsname() just for parsing */
 	rc = server_name2fsname(label, NULL, &dash);
 	if (rc != 0)
 		return rc;
 
-	if (*dash != '-')
-		return -1;
+	if (endptr != NULL)
+		*endptr = dash;
 
 	if (strlcpy(svname, dash + 1, svsize) >= svsize)
 		return -E2BIG;
@@ -729,9 +729,6 @@ int server_name2index(const char *svname, __u32 *idx, const char **endptr)
 	if (rc != 0)
 		return rc;
 
-	if (*dash != '-')
-		return -EINVAL;
-
 	dash++;
 
 	if (strncmp(dash, "MDT", 3) == 0)
@@ -743,11 +740,20 @@ int server_name2index(const char *svname, __u32 *idx, const char **endptr)
 
 	dash += 3;
 
-	if (strcmp(dash, "all") == 0)
+	if (strncmp(dash, "all", 3) == 0) {
+		if (endptr != NULL)
+			*endptr = dash + 3;
 		return rc | LDD_F_SV_ALL;
+	}
 
 	index = simple_strtoul(dash, (char **)endptr, 16);
-	*idx = index;
+	if (idx != NULL)
+		*idx = index;
+
+	/* Account for -mdc after index that is possible when specifying mdt */
+	if (endptr != NULL && strncmp(LUSTRE_MDC_NAME, *endptr + 1,
+				      sizeof(LUSTRE_MDC_NAME)-1) == 0)
+		*endptr += sizeof(LUSTRE_MDC_NAME);
 
 	return rc;
 }
@@ -857,13 +863,15 @@ static int lmd_make_exclusion(struct lustre_mount_data *lmd, const char *ptr)
 		s1++;
 		rc = server_name2index(s1, &index, &s2);
 		if (rc < 0) {
-			CERROR("Can't parse server name '%s'\n", s1);
+			CERROR("Can't parse server name '%s': rc = %d\n",
+			       s1, rc);
 			break;
 		}
 		if (rc == LDD_F_SV_TYPE_OST)
 			exclude_list[lmd->lmd_exclude_count++] = index;
 		else
-			CDEBUG(D_MOUNT, "ignoring exclude %.7s\n", s1);
+			CDEBUG(D_MOUNT, "ignoring exclude %.*s: type = %#x\n",
+			       (uint)(s2-s1), s1, rc);
 		s1 = s2;
 		/* now we are pointing at ':' (next exclude)
 		   or ',' (end of excludes) */
-- 
1.7.9.5

