Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbaCEOYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:24:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40743 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbaCEOYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:24:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anna Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 010/131] NFS: Enabling v4.2 should not recompile nfsd and lockd
Date: Wed,  5 Mar 2014 14:22:14 +0000
Message-Id: <1394029455-23128-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anna Schumaker <bjschuma@netapp.com>

commit 694e096fd7c2a7d40760fc9c9dfc826bdd495ea4 upstream.

When CONFIG_NFS_V4_2 is toggled nfsd and lockd will be recompiled,
instead of only the nfs client.  This patch moves a small amount of code
into the client directory to avoid unnecessary recompiles.

Signed-off-by: Anna Schumaker <bjschuma@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/blocklayout/blocklayout.h |  1 +
 fs/nfs/dns_resolve.c             |  2 ++
 fs/nfs/internal.h                | 15 +++++++++++++++
 fs/nfs/nfs4_fs.h                 |  8 ++++++++
 include/linux/nfs4.h             | 10 ----------
 include/linux/nfs_fs.h           | 18 ------------------
 6 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/fs/nfs/blocklayout/blocklayout.h b/fs/nfs/blocklayout/blocklayout.h
index 8485978..9838fb0 100644
--- a/fs/nfs/blocklayout/blocklayout.h
+++ b/fs/nfs/blocklayout/blocklayout.h
@@ -36,6 +36,7 @@
 #include <linux/nfs_fs.h>
 #include <linux/sunrpc/rpc_pipe_fs.h>
 
+#include "../nfs4_fs.h"
 #include "../pnfs.h"
 #include "../netns.h"
 
diff --git a/fs/nfs/dns_resolve.c b/fs/nfs/dns_resolve.c
index fc0f95e..d25f10f 100644
--- a/fs/nfs/dns_resolve.c
+++ b/fs/nfs/dns_resolve.c
@@ -46,7 +46,9 @@ ssize_t nfs_dns_resolve_name(struct net *net, char *name, size_t namelen,
 #include <linux/sunrpc/cache.h>
 #include <linux/sunrpc/svcauth.h>
 #include <linux/sunrpc/rpc_pipe_fs.h>
+#include <linux/nfs_fs.h>
 
+#include "nfs4_fs.h"
 #include "dns_resolve.h"
 #include "cache_lib.h"
 #include "netns.h"
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 3c8373f..f47305e 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -263,6 +263,21 @@ extern const u32 nfs41_maxgetdevinfo_overhead;
 extern struct rpc_procinfo nfs4_procedures[];
 #endif
 
+#ifdef CONFIG_NFS_V4_SECURITY_LABEL
+extern struct nfs4_label *nfs4_label_alloc(struct nfs_server *server, gfp_t flags);
+static inline void nfs4_label_free(struct nfs4_label *label)
+{
+	if (label) {
+		kfree(label->label);
+		kfree(label);
+	}
+	return;
+}
+#else
+static inline struct nfs4_label *nfs4_label_alloc(struct nfs_server *server, gfp_t flags) { return NULL; }
+static inline void nfs4_label_free(void *label) {}
+#endif /* CONFIG_NFS_V4_SECURITY_LABEL */
+
 /* proc.c */
 void nfs_close_context(struct nfs_open_context *ctx, int is_sync);
 extern struct nfs_client *nfs_init_client(struct nfs_client *clp,
diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index ee81e35..69c7c38 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -9,6 +9,14 @@
 #ifndef __LINUX_FS_NFS_NFS4_FS_H
 #define __LINUX_FS_NFS_NFS4_FS_H
 
+#if defined(CONFIG_NFS_V4_2)
+#define NFS4_MAX_MINOR_VERSION 2
+#elif defined(CONFIG_NFS_V4_1)
+#define NFS4_MAX_MINOR_VERSION 1
+#else
+#define NFS4_MAX_MINOR_VERSION 0
+#endif
+
 #if IS_ENABLED(CONFIG_NFS_V4)
 
 #define NFS4_MAX_LOOP_ON_RECOVER (10)
diff --git a/include/linux/nfs4.h b/include/linux/nfs4.h
index 3859ddb..32c7ef6 100644
--- a/include/linux/nfs4.h
+++ b/include/linux/nfs4.h
@@ -408,16 +408,6 @@ enum lock_type4 {
 #define NFS4_VERSION 4
 #define NFS4_MINOR_VERSION 0
 
-#if defined(CONFIG_NFS_V4_2)
-#define NFS4_MAX_MINOR_VERSION 2
-#else
-#if defined(CONFIG_NFS_V4_1)
-#define NFS4_MAX_MINOR_VERSION 1
-#else
-#define NFS4_MAX_MINOR_VERSION 0
-#endif /* CONFIG_NFS_V4_1 */
-#endif /* CONFIG_NFS_V4_2 */
-
 #define NFS4_DEBUG 1
 
 /* Index of predefined Linux client operations */
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 7125cef..dcb32f3 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -503,24 +503,6 @@ extern int nfs_mountpoint_expiry_timeout;
 extern void nfs_release_automount_timer(void);
 
 /*
- * linux/fs/nfs/nfs4proc.c
- */
-#ifdef CONFIG_NFS_V4_SECURITY_LABEL
-extern struct nfs4_label *nfs4_label_alloc(struct nfs_server *server, gfp_t flags);
-static inline void nfs4_label_free(struct nfs4_label *label)
-{
-	if (label) {
-		kfree(label->label);
-		kfree(label);
-	}
-	return;
-}
-#else
-static inline struct nfs4_label *nfs4_label_alloc(struct nfs_server *server, gfp_t flags) { return NULL; }
-static inline void nfs4_label_free(void *label) {}
-#endif
-
-/*
  * linux/fs/nfs/unlink.c
  */
 extern void nfs_complete_unlink(struct dentry *dentry, struct inode *);
-- 
1.9.0

