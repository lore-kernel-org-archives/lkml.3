Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab3GOO2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:28:15 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56055 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab3GOO2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:28:12 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v3 10/17] staging/lustre/llite: fix build erorr if CONFIG_FS_POSIX_ACL is off
Date: Mon, 15 Jul 2013 22:27:13 +0800
Message-Id: <1373898440-14208-11-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lustre/llite/llite_internal.h   |   21 ++++++++++++--------
 drivers/staging/lustre/lustre/llite/xattr.c        |    2 ++
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 5227c5c..1069b8d 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -438,14 +438,6 @@ struct rmtacl_ctl_table {
 
 #define EE_HASHES       32
 
-struct eacl_entry {
-	struct list_head	    ee_list;
-	pid_t		 ee_key; /* hash key */
-	struct lu_fid	 ee_fid;
-	int		   ee_type; /* ACL type for ACCESS or DEFAULT */
-	ext_acl_xattr_header *ee_acl;
-};
-
 struct eacl_table {
 	spinlock_t	et_lock;
 	struct list_head	et_entries[EE_HASHES];
@@ -1168,6 +1160,14 @@ void ll_ra_stats_inc(struct address_space *mapping, enum ra_stat which);
 
 /* llite/llite_rmtacl.c */
 #ifdef CONFIG_FS_POSIX_ACL
+struct eacl_entry {
+	struct list_head	    ee_list;
+	pid_t		 ee_key; /* hash key */
+	struct lu_fid	 ee_fid;
+	int		   ee_type; /* ACL type for ACCESS or DEFAULT */
+	ext_acl_xattr_header *ee_acl;
+};
+
 obd_valid rce_ops2valid(int ops);
 struct rmtacl_ctl_entry *rct_search(struct rmtacl_ctl_table *rct, pid_t key);
 int rct_add(struct rmtacl_ctl_table *rct, pid_t key, int ops);
@@ -1183,6 +1183,11 @@ struct eacl_entry *et_search_del(struct eacl_table *et, pid_t key,
 void et_search_free(struct eacl_table *et, pid_t key);
 void et_init(struct eacl_table *et);
 void et_fini(struct eacl_table *et);
+#else
+static inline obd_valid rce_ops2valid(int ops)
+{
+	return 0;
+}
 #endif
 
 /* statahead.c */
diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
index 4176264..0a11902 100644
--- a/drivers/staging/lustre/lustre/llite/xattr.c
+++ b/drivers/staging/lustre/lustre/llite/xattr.c
@@ -112,9 +112,11 @@ int ll_setxattr_common(struct inode *inode, const char *name,
 	struct ptlrpc_request *req;
 	int xattr_type, rc;
 	struct obd_capa *oc;
+#ifdef CONFIG_FS_POSIX_ACL
 	posix_acl_xattr_header *new_value = NULL;
 	struct rmtacl_ctl_entry *rce = NULL;
 	ext_acl_xattr_header *acl = NULL;
+#endif
 	const char *pv = value;
 	ENTRY;
 
-- 
1.7.9.5

