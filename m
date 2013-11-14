Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab3KNQkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:40:05 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:44093 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab3KNQjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:39:08 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jinshan Xiong <jinshan.xiong@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 10/39] staging/lustre/hsm: small fixes for HSM
Date: Fri, 15 Nov 2013 00:32:33 +0800
Message-Id: <1384446782-13741-11-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jinshan Xiong <jinshan.xiong@intel.com>

This patch includes the following fixes for HSM:
1. Redefine D_HSM. It was defined to D_TRACE;
2. Fix lu_ref for lease handle
3. User input verification to make sure the hur size is less than
MDS_MAXREQSIZE;

Lustre-change: http://review.whamcloud.com/7243
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3647
Signed-off-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: jacques-Charles Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/include/linux/libcfs/libcfs_debug.h     |  129 ++++++++++---------
 drivers/staging/lustre/lustre/libcfs/debug.c       |  131 ++------------------
 drivers/staging/lustre/lustre/llite/dir.c          |    5 +
 drivers/staging/lustre/lustre/llite/file.c         |    4 +-
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |    2 +-
 5 files changed, 89 insertions(+), 182 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h
index 40282b7..02a77de 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h
@@ -87,74 +87,83 @@ struct ptldebug_header {
 
 /* Debugging subsystems (32 bits, non-overlapping) */
 /* keep these in sync with lnet/utils/debug.c and lnet/libcfs/debug.c */
-#define S_UNDEFINED   0x00000001
-#define S_MDC	 0x00000002
-#define S_MDS	 0x00000004
-#define S_OSC	 0x00000008
-#define S_OST	 0x00000010
-#define S_CLASS       0x00000020
-#define S_LOG	 0x00000040
-#define S_LLITE       0x00000080
-#define S_RPC	 0x00000100
-#define S_MGMT	0x00000200
-#define S_LNET	0x00000400
-#define S_LND	 0x00000800 /* ALL LNDs */
-#define S_PINGER      0x00001000
-#define S_FILTER      0x00002000
+#define S_UNDEFINED	0x00000001
+#define S_MDC		0x00000002
+#define S_MDS		0x00000004
+#define S_OSC		0x00000008
+#define S_OST		0x00000010
+#define S_CLASS		0x00000020
+#define S_LOG		0x00000040
+#define S_LLITE		0x00000080
+#define S_RPC		0x00000100
+#define S_MGMT		0x00000200
+#define S_LNET		0x00000400
+#define S_LND		0x00000800 /* ALL LNDs */
+#define S_PINGER	0x00001000
+#define S_FILTER	0x00002000
 /* unused */
-#define S_ECHO	0x00008000
-#define S_LDLM	0x00010000
-#define S_LOV	 0x00020000
-#define S_LQUOTA      0x00040000
+#define S_ECHO		0x00008000
+#define S_LDLM		0x00010000
+#define S_LOV		0x00020000
+#define S_LQUOTA	0x00040000
 #define S_OSD		0x00080000
+#define S_LFSCK		0x00100000
 /* unused */
 /* unused */
+#define S_LMV		0x00800000 /* b_new_cmd */
 /* unused */
-#define S_LMV	 0x00800000 /* b_new_cmd */
+#define S_SEC		0x02000000 /* upcall cache */
+#define S_GSS		0x04000000 /* b_new_cmd */
 /* unused */
-#define S_SEC	 0x02000000 /* upcall cache */
-#define S_GSS	 0x04000000 /* b_new_cmd */
-/* unused */
-#define S_MGC	 0x10000000
-#define S_MGS	 0x20000000
-#define S_FID	 0x40000000 /* b_new_cmd */
-#define S_FLD	 0x80000000 /* b_new_cmd */
-/* keep these in sync with lnet/utils/debug.c and lnet/libcfs/debug.c */
+#define S_MGC		0x10000000
+#define S_MGS		0x20000000
+#define S_FID		0x40000000 /* b_new_cmd */
+#define S_FLD		0x80000000 /* b_new_cmd */
+
+#define LIBCFS_DEBUG_SUBSYS_NAMES {					\
+	"undefined", "mdc", "mds", "osc", "ost", "class", "log",	\
+	"llite", "rpc", "mgmt", "lnet", "lnd", "pinger", "filter", "",	\
+	"echo", "ldlm", "lov", "lquota", "osd", "lfsck", "", "", "lmv",	\
+	 "", "sec", "gss", "", "mgc", "mgs", "fid", "fld", NULL }
 
 /* Debugging masks (32 bits, non-overlapping) */
-/* keep these in sync with lnet/utils/debug.c and lnet/libcfs/debug.c */
-#define D_TRACE       0x00000001 /* ENTRY/EXIT markers */
-#define D_INODE       0x00000002
-#define D_SUPER       0x00000004
-#define D_EXT2	0x00000008 /* anything from ext2_debug */
-#define D_MALLOC      0x00000010 /* print malloc, free information */
-#define D_CACHE       0x00000020 /* cache-related items */
-#define D_INFO	0x00000040 /* general information */
-#define D_IOCTL       0x00000080 /* ioctl related information */
-#define D_NETERROR    0x00000100 /* network errors */
-#define D_NET	 0x00000200 /* network communications */
-#define D_WARNING     0x00000400 /* CWARN(...) == CDEBUG (D_WARNING, ...) */
-#define D_BUFFS       0x00000800
-#define D_OTHER       0x00001000
-#define D_DENTRY      0x00002000
-#define D_NETTRACE    0x00004000
-#define D_PAGE	0x00008000 /* bulk page handling */
-#define D_DLMTRACE    0x00010000
-#define D_ERROR       0x00020000 /* CERROR(...) == CDEBUG (D_ERROR, ...) */
-#define D_EMERG       0x00040000 /* CEMERG(...) == CDEBUG (D_EMERG, ...) */
-#define D_HA	  0x00080000 /* recovery and failover */
-#define D_RPCTRACE    0x00100000 /* for distributed debugging */
-#define D_VFSTRACE    0x00200000
-#define D_READA       0x00400000 /* read-ahead */
-#define D_MMAP	0x00800000
-#define D_CONFIG      0x01000000
-#define D_CONSOLE     0x02000000
-#define D_QUOTA       0x04000000
-#define D_SEC	 0x08000000
-#define D_LFSCK	      0x10000000 /* For both OI scrub and LFSCK */
-/* keep these in sync with lnet/{utils,libcfs}/debug.c */
-
-#define D_HSM	 D_TRACE
+#define D_TRACE		0x00000001 /* ENTRY/EXIT markers */
+#define D_INODE		0x00000002
+#define D_SUPER		0x00000004
+#define D_EXT2		0x00000008 /* anything from ext2_debug */
+#define D_MALLOC	0x00000010 /* print malloc, free information */
+#define D_CACHE		0x00000020 /* cache-related items */
+#define D_INFO		0x00000040 /* general information */
+#define D_IOCTL		0x00000080 /* ioctl related information */
+#define D_NETERROR	0x00000100 /* network errors */
+#define D_NET		0x00000200 /* network communications */
+#define D_WARNING	0x00000400 /* CWARN(...) == CDEBUG (D_WARNING, ...) */
+#define D_BUFFS		0x00000800
+#define D_OTHER		0x00001000
+#define D_DENTRY	0x00002000
+#define D_NETTRACE	0x00004000
+#define D_PAGE		0x00008000 /* bulk page handling */
+#define D_DLMTRACE	0x00010000
+#define D_ERROR		0x00020000 /* CERROR(...) == CDEBUG (D_ERROR, ...) */
+#define D_EMERG		0x00040000 /* CEMERG(...) == CDEBUG (D_EMERG, ...) */
+#define D_HA		0x00080000 /* recovery and failover */
+#define D_RPCTRACE	0x00100000 /* for distributed debugging */
+#define D_VFSTRACE	0x00200000
+#define D_READA		0x00400000 /* read-ahead */
+#define D_MMAP		0x00800000
+#define D_CONFIG	0x01000000
+#define D_CONSOLE	0x02000000
+#define D_QUOTA		0x04000000
+#define D_SEC		0x08000000
+#define D_LFSCK		0x10000000 /* For both OI scrub and LFSCK */
+#define D_HSM		0x20000000
+
+#define LIBCFS_DEBUG_MASKS_NAMES {					\
+	"trace", "inode", "super", "ext2", "malloc", "cache", "info",	\
+	"ioctl", "neterror", "net", "warning", "buffs", "other",	\
+	"dentry", "nettrace", "page", "dlmtrace", "error", "emerg",	\
+	"ha", "rpctrace", "vfstrace", "reada", "mmap", "config",	\
+	"console", "quota", "sec", "lfsck", "hsm", NULL }
 
 #define D_CANTMASK   (D_ERROR | D_EMERG | D_WARNING | D_CONSOLE)
 
diff --git a/drivers/staging/lustre/lustre/libcfs/debug.c b/drivers/staging/lustre/lustre/libcfs/debug.c
index 9b9c451..581fc18 100644
--- a/drivers/staging/lustre/lustre/libcfs/debug.c
+++ b/drivers/staging/lustre/lustre/libcfs/debug.c
@@ -124,132 +124,25 @@ int libcfs_panic_in_progress;
 
 /* libcfs_debug_token2mask() expects the returned
  * string in lower-case */
-const char *
-libcfs_debug_subsys2str(int subsys)
+const char *libcfs_debug_subsys2str(int subsys)
 {
-	switch (1 << subsys) {
-	default:
+	static const char *libcfs_debug_subsystems[] = LIBCFS_DEBUG_SUBSYS_NAMES;
+
+	if (subsys >= ARRAY_SIZE(libcfs_debug_subsystems))
 		return NULL;
-	case S_UNDEFINED:
-		return "undefined";
-	case S_MDC:
-		return "mdc";
-	case S_MDS:
-		return "mds";
-	case S_OSC:
-		return "osc";
-	case S_OST:
-		return "ost";
-	case S_CLASS:
-		return "class";
-	case S_LOG:
-		return "log";
-	case S_LLITE:
-		return "llite";
-	case S_RPC:
-		return "rpc";
-	case S_LNET:
-		return "lnet";
-	case S_LND:
-		return "lnd";
-	case S_PINGER:
-		return "pinger";
-	case S_FILTER:
-		return "filter";
-	case S_ECHO:
-		return "echo";
-	case S_LDLM:
-		return "ldlm";
-	case S_LOV:
-		return "lov";
-	case S_LQUOTA:
-		return "lquota";
-	case S_OSD:
-		return "osd";
-	case S_LMV:
-		return "lmv";
-	case S_SEC:
-		return "sec";
-	case S_GSS:
-		return "gss";
-	case S_MGC:
-		return "mgc";
-	case S_MGS:
-		return "mgs";
-	case S_FID:
-		return "fid";
-	case S_FLD:
-		return "fld";
-	}
-}
 
+	return libcfs_debug_subsystems[subsys];
+}
 /* libcfs_debug_token2mask() expects the returned
  * string in lower-case */
-const char *
-libcfs_debug_dbg2str(int debug)
+const char *libcfs_debug_dbg2str(int debug)
 {
-	switch (1 << debug) {
-	default:
+	static const char *libcfs_debug_masks[] = LIBCFS_DEBUG_MASKS_NAMES;
+
+	if (debug >= ARRAY_SIZE(libcfs_debug_masks))
 		return NULL;
-	case D_TRACE:
-		return "trace";
-	case D_INODE:
-		return "inode";
-	case D_SUPER:
-		return "super";
-	case D_EXT2:
-		return "ext2";
-	case D_MALLOC:
-		return "malloc";
-	case D_CACHE:
-		return "cache";
-	case D_INFO:
-		return "info";
-	case D_IOCTL:
-		return "ioctl";
-	case D_NETERROR:
-		return "neterror";
-	case D_NET:
-		return "net";
-	case D_WARNING:
-		return "warning";
-	case D_BUFFS:
-		return "buffs";
-	case D_OTHER:
-		return "other";
-	case D_DENTRY:
-		return "dentry";
-	case D_NETTRACE:
-		return "nettrace";
-	case D_PAGE:
-		return "page";
-	case D_DLMTRACE:
-		return "dlmtrace";
-	case D_ERROR:
-		return "error";
-	case D_EMERG:
-		return "emerg";
-	case D_HA:
-		return "ha";
-	case D_RPCTRACE:
-		return "rpctrace";
-	case D_VFSTRACE:
-		return "vfstrace";
-	case D_READA:
-		return "reada";
-	case D_MMAP:
-		return "mmap";
-	case D_CONFIG:
-		return "config";
-	case D_CONSOLE:
-		return "console";
-	case D_QUOTA:
-		return "quota";
-	case D_SEC:
-		return "sec";
-	case D_LFSCK:
-		return "lfsck";
-	}
+
+	return libcfs_debug_masks[debug];
 }
 
 int
diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index 1b217c8..044aa095 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -1804,6 +1804,11 @@ out_rmdir:
 		/* Compute the whole struct size */
 		totalsize = hur_len(hur);
 		OBD_FREE_PTR(hur);
+
+		/* Make sure the size is reasonable */
+		if (totalsize >= MDS_MAXREQSIZE)
+			return -E2BIG;
+
 		OBD_ALLOC_LARGE(hur, totalsize);
 		if (hur == NULL)
 			return -ENOMEM;
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index d3f375d..04dc9ce 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -881,7 +881,7 @@ int ll_lease_close(struct obd_client_handle *och, struct inode *inode,
 		lock_res_and_lock(lock);
 		cancelled = ldlm_is_cancel(lock);
 		unlock_res_and_lock(lock);
-		ldlm_lock_put(lock);
+		LDLM_LOCK_PUT(lock);
 	}
 
 	CDEBUG(D_INODE, "lease for "DFID" broken? %d\n",
@@ -2478,7 +2478,7 @@ long ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 					rc = och->och_flags &
 						(FMODE_READ | FMODE_WRITE);
 				unlock_res_and_lock(lock);
-				ldlm_lock_put(lock);
+				LDLM_LOCK_PUT(lock);
 			}
 		}
 		mutex_unlock(&lli->lli_och_mutex);
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_lib.c b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
index 91f6876..a839c96 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_lib.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
@@ -504,7 +504,7 @@ static void mdc_hsm_release_pack(struct ptlrpc_request *req,
 		lock = ldlm_handle2lock(&op_data->op_lease_handle);
 		if (lock != NULL) {
 			data->cd_handle = lock->l_remote_handle;
-			ldlm_lock_put(lock);
+			LDLM_LOCK_PUT(lock);
 		}
 		ldlm_cli_cancel(&op_data->op_lease_handle, LCF_LOCAL);
 
-- 
1.7.9.5

