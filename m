Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab3GVQO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:14:29 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:58584 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933141Ab3GVQNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:13:37 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, jcl <jacques-charles.lafoucriere@cea.fr>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 46/48] staging/lustre/mdt: HSM on disk actions record
Date: Tue, 23 Jul 2013 00:07:07 +0800
Message-Id: <1374509230-3324-47-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jcl <jacques-charles.lafoucriere@cea.fr>

HSM coordinator memorizes all actions in a llog
This patch implements the methods needed to create
update display these records.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3339
Lustre-change: http://review.whamcloud.com/6529
Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lustre/include/lprocfs_status.h |    3 --
 .../lustre/lustre/include/lustre/lustre_idl.h      |   47 ++++++++++++++++
 .../staging/lustre/lustre/include/lustre_disk.h    |   56 ++++++++++----------
 drivers/staging/lustre/lustre/include/obd.h        |    7 +--
 drivers/staging/lustre/lustre/obdclass/llog_swab.c |   17 ++++++
 5 files changed, 97 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lprocfs_status.h b/drivers/staging/lustre/lustre/include/lprocfs_status.h
index 20633d4..d7f1be9 100644
--- a/drivers/staging/lustre/lustre/include/lprocfs_status.h
+++ b/drivers/staging/lustre/lustre/include/lprocfs_status.h
@@ -804,9 +804,6 @@ extern int lprocfs_quota_rd_qs_factor(char *page, char **start, loff_t off,
 extern int lprocfs_quota_wr_qs_factor(struct file *file,
 				      const char *buffer,
 				      unsigned long count, void *data);
-
-
-
 #else
 /* LPROCFS is not defined */
 
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 3aaa869..984235c 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -2986,6 +2986,7 @@ typedef enum {
 	/* LLOG_JOIN_REC	= LLOG_OP_MAGIC | 0x50000, obsolete  1.8.0 */
 	CHANGELOG_REC		= LLOG_OP_MAGIC | 0x60000,
 	CHANGELOG_USER_REC	= LLOG_OP_MAGIC | 0x70000,
+	HSM_AGENT_REC		= LLOG_OP_MAGIC | 0x80000,
 	LLOG_HDR_MAGIC		= LLOG_OP_MAGIC | 0x45539,
 	LLOG_LOGID_MAGIC	= LLOG_OP_MAGIC | 0x4553b,
 } llog_op_type;
@@ -3105,6 +3106,52 @@ struct llog_changelog_user_rec {
 	struct llog_rec_tail  cur_tail;
 } __attribute__((packed));
 
+enum agent_req_status {
+	ARS_WAITING,
+	ARS_STARTED,
+	ARS_FAILED,
+	ARS_CANCELED,
+	ARS_SUCCEED,
+};
+
+static inline char *agent_req_status2name(enum agent_req_status ars)
+{
+	switch (ars) {
+	case ARS_WAITING:
+		return "WAITING";
+	case ARS_STARTED:
+		return "STARTED";
+	case ARS_FAILED:
+		return "FAILED";
+	case ARS_CANCELED:
+		return "CANCELED";
+	case ARS_SUCCEED:
+		return "SUCCEED";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static inline bool agent_req_in_final_state(enum agent_req_status ars)
+{
+	return ((ars == ARS_SUCCEED) || (ars == ARS_FAILED) ||
+		(ars == ARS_CANCELED));
+}
+
+struct llog_agent_req_rec {
+	struct llog_rec_hdr	arr_hdr;	/**< record header */
+	__u32			arr_status;	/**< status of the request */
+						/* must match enum
+						 * agent_req_status */
+	__u32			arr_archive_id;	/**< backend archive number */
+	__u64			arr_flags;	/**< req flags */
+	__u64			arr_compound_id;	/**< compound cookie */
+	__u64			arr_req_create;	/**< req. creation time */
+	__u64			arr_req_change;	/**< req. status change time */
+	struct hsm_action_item	arr_hai;	/**< req. to the agent */
+	struct llog_rec_tail	arr_tail; /**< record tail for_sizezof_only */
+} __attribute__((packed));
+
 /* Old llog gen for compatibility */
 struct llog_gen {
 	__u64 mnt_cnt;
diff --git a/drivers/staging/lustre/lustre/include/lustre_disk.h b/drivers/staging/lustre/lustre/include/lustre_disk.h
index 8db6086..9228b16 100644
--- a/drivers/staging/lustre/lustre/include/lustre_disk.h
+++ b/drivers/staging/lustre/lustre/include/lustre_disk.h
@@ -53,20 +53,21 @@
 
 /****************** on-disk files *********************/
 
-#define MDT_LOGS_DIR      "LOGS"  /* COMPAT_146 */
-#define MOUNT_CONFIGS_DIR "CONFIGS"
-#define CONFIGS_FILE      "mountdata"
+#define MDT_LOGS_DIR		"LOGS"  /* COMPAT_146 */
+#define MOUNT_CONFIGS_DIR	"CONFIGS"
+#define CONFIGS_FILE		"mountdata"
 /** Persistent mount data are stored on the disk in this file. */
-#define MOUNT_DATA_FILE    MOUNT_CONFIGS_DIR"/"CONFIGS_FILE
-#define LAST_RCVD	 "last_rcvd"
-#define LOV_OBJID	 "lov_objid"
+#define MOUNT_DATA_FILE		MOUNT_CONFIGS_DIR"/"CONFIGS_FILE
+#define LAST_RCVD		"last_rcvd"
+#define LOV_OBJID		"lov_objid"
 #define LOV_OBJSEQ		"lov_objseq"
-#define HEALTH_CHECK      "health_check"
-#define CAPA_KEYS	 "capa_keys"
-#define CHANGELOG_USERS   "changelog_users"
-#define MGS_NIDTBL_DIR    "NIDTBL_VERSIONS"
-#define QMT_DIR	   "quota_master"
-#define QSD_DIR	   "quota_slave"
+#define HEALTH_CHECK		"health_check"
+#define CAPA_KEYS		"capa_keys"
+#define CHANGELOG_USERS		"changelog_users"
+#define MGS_NIDTBL_DIR		"NIDTBL_VERSIONS"
+#define QMT_DIR			"quota_master"
+#define QSD_DIR			"quota_slave"
+#define HSM_ACTIONS		"hsm_actions"
 
 /****************** persistent mount data *********************/
 
@@ -226,21 +227,22 @@ struct lustre_mount_data {
 	char	*lmd_osd_type;      /* OSD type */
 };
 
-#define LMD_FLG_SERVER       0x0001  /* Mounting a server */
-#define LMD_FLG_CLIENT       0x0002  /* Mounting a client */
-#define LMD_FLG_ABORT_RECOV  0x0008  /* Abort recovery */
-#define LMD_FLG_NOSVC	0x0010  /* Only start MGS/MGC for servers,
-					no other services */
-#define LMD_FLG_NOMGS	0x0020  /* Only start target for servers, reusing
-					existing MGS services */
-#define LMD_FLG_WRITECONF    0x0040  /* Rewrite config log */
-#define LMD_FLG_NOIR	 0x0080  /* NO imperative recovery */
-#define LMD_FLG_NOSCRUB	     0x0100  /* Do not trigger scrub automatically */
-#define LMD_FLG_MGS	     0x0200  /* Also start MGS along with server */
-#define LMD_FLG_IAM	     0x0400  /* IAM dir */
-#define LMD_FLG_NO_PRIMNODE  0x0800  /* all nodes are service nodes */
-#define LMD_FLG_VIRGIN	     0x1000  /* the service registers first time */
-#define LMD_FLG_UPDATE	     0x2000  /* update parameters */
+#define LMD_FLG_SERVER		0x0001	/* Mounting a server */
+#define LMD_FLG_CLIENT		0x0002	/* Mounting a client */
+#define LMD_FLG_ABORT_RECOV	0x0008	/* Abort recovery */
+#define LMD_FLG_NOSVC		0x0010	/* Only start MGS/MGC for servers,
+					   no other services */
+#define LMD_FLG_NOMGS		0x0020	/* Only start target for servers, reusing
+					   existing MGS services */
+#define LMD_FLG_WRITECONF	0x0040	/* Rewrite config log */
+#define LMD_FLG_NOIR		0x0080	/* NO imperative recovery */
+#define LMD_FLG_NOSCRUB		0x0100	/* Do not trigger scrub automatically */
+#define LMD_FLG_MGS		0x0200	/* Also start MGS along with server */
+#define LMD_FLG_IAM		0x0400	/* IAM dir */
+#define LMD_FLG_NO_PRIMNODE	0x0800	/* all nodes are service nodes */
+#define LMD_FLG_VIRGIN		0x1000	/* the service registers first time */
+#define LMD_FLG_UPDATE		0x2000	/* update parameters */
+#define LMD_FLG_HSM		0x4000	/* Start coordinator */
 
 #define lmd_is_client(x) ((x)->lmd_flags & LMD_FLG_CLIENT)
 
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index be3a08f..094eb96 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -267,9 +267,10 @@ enum llog_ctxt_id {
 	LLOG_TEST_REPL_CTXT,
 	LLOG_LOVEA_ORIG_CTXT,
 	LLOG_LOVEA_REPL_CTXT,
-	LLOG_CHANGELOG_ORIG_CTXT,      /**< changelog generation on mdd */
-	LLOG_CHANGELOG_REPL_CTXT,      /**< changelog access on clients */
-	LLOG_CHANGELOG_USER_ORIG_CTXT, /**< for multiple changelog consumers */
+	LLOG_CHANGELOG_ORIG_CTXT,	/**< changelog generation on mdd */
+	LLOG_CHANGELOG_REPL_CTXT,	/**< changelog access on clients */
+	LLOG_CHANGELOG_USER_ORIG_CTXT,	/**< for multiple changelog consumers */
+	LLOG_AGENT_ORIG_CTXT,		/**< agent requests generation on cdt */
 	LLOG_MAX_CTXTS
 };
 
diff --git a/drivers/staging/lustre/lustre/obdclass/llog_swab.c b/drivers/staging/lustre/lustre/obdclass/llog_swab.c
index dedfecf..a75b04e 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_swab.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_swab.c
@@ -203,6 +203,23 @@ void lustre_swab_llog_rec(struct llog_rec_hdr *rec)
 		break;
 	}
 
+	case HSM_AGENT_REC: {
+		struct llog_agent_req_rec *arr =
+			(struct llog_agent_req_rec *)rec;
+
+		__swab32s(&arr->arr_hai.hai_len);
+		__swab32s(&arr->arr_hai.hai_action);
+		lustre_swab_lu_fid(&arr->arr_hai.hai_fid);
+		lustre_swab_lu_fid(&arr->arr_hai.hai_dfid);
+		__swab64s(&arr->arr_hai.hai_cookie);
+		__swab64s(&arr->arr_hai.hai_extent.offset);
+		__swab64s(&arr->arr_hai.hai_extent.length);
+		__swab64s(&arr->arr_hai.hai_gid);
+		/* no swabing for opaque data */
+		/* hai_data[0]; */
+		break;
+	}
+
 	case MDS_SETATTR64_REC:
 	{
 		struct llog_setattr64_rec *lsr =
-- 
1.7.9.5

