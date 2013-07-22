Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab3GVQNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:13:19 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59097 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933051Ab3GVQNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:13:10 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Fan Yong <yong.fan@whamcloud.com>,
        Fan Yong <fan.yong@intel.com>, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 40/48] staging/lustre/llite: return valid fsid for statfs
Date: Tue, 23 Jul 2013 00:07:01 +0800
Message-Id: <1374509230-3324-41-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fan Yong <yong.fan@whamcloud.com>

Lustre uses 64-bits inode number to identify object on client side.
When re-export Lustre via NFS, NFS will detect whether support fsid
via statfs(). For the non-support case, it will only recognizes and
packs low 32-bits inode number in nfs handle. Such handle cannot be
used to locate the object properly.

To avoid patch linux kernel, Lustre client should generate fsid and
return it via statfs() to up layer.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2904
Lustre-change: http://review.whamcloud.com/6493
Signed-off-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lustre/llite/llite_internal.h   |    2 ++
 drivers/staging/lustre/lustre/llite/llite_lib.c    |    6 ++++--
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |   16 ++++++++++++++++
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 0534665..28aed68 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -505,6 +505,7 @@ struct ll_sb_info {
 						 * clustred nfs */
 	struct rmtacl_ctl_table   ll_rct;
 	struct eacl_table	 ll_et;
+	__kernel_fsid_t		  ll_fsid;
 };
 
 #define LL_DEFAULT_MAX_RW_CHUNK      (32 * 1024 * 1024)
@@ -833,6 +834,7 @@ char *ll_get_fsname(struct super_block *sb, char *buf, int buflen);
 /* llite/llite_nfs.c */
 extern struct export_operations lustre_export_operations;
 __u32 get_uuid2int(const char *name, int len);
+void get_uuid2fsid(const char *name, int len, __kernel_fsid_t *fsid);
 struct inode *search_inode_for_lustre(struct super_block *sb,
 				      const struct lu_fid *fid);
 
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 39d519b..d7d87b1 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -583,8 +583,10 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 	/* s_dev is also used in lt_compare() to compare two fs, but that is
 	 * only a node-local comparison. */
 	uuid = obd_get_uuid(sbi->ll_md_exp);
-	if (uuid != NULL)
+	if (uuid != NULL) {
 		sb->s_dev = get_uuid2int(uuid->uuid, strlen(uuid->uuid));
+		get_uuid2fsid(uuid->uuid, strlen(uuid->uuid), &sbi->ll_fsid);
+	}
 
 	if (data != NULL)
 		OBD_FREE_PTR(data);
@@ -1615,7 +1617,7 @@ int ll_statfs(struct dentry *de, struct kstatfs *sfs)
 	sfs->f_blocks = osfs.os_blocks;
 	sfs->f_bfree = osfs.os_bfree;
 	sfs->f_bavail = osfs.os_bavail;
-
+	sfs->f_fsid = ll_s2sbi(sb)->ll_fsid;
 	return 0;
 }
 
diff --git a/drivers/staging/lustre/lustre/llite/llite_nfs.c b/drivers/staging/lustre/lustre/llite/llite_nfs.c
index f142a1e..b830004 100644
--- a/drivers/staging/lustre/lustre/llite/llite_nfs.c
+++ b/drivers/staging/lustre/lustre/llite/llite_nfs.c
@@ -58,6 +58,22 @@ __u32 get_uuid2int(const char *name, int len)
 	return (key0 << 1);
 }
 
+void get_uuid2fsid(const char *name, int len, __kernel_fsid_t *fsid)
+{
+	__u64 key = 0, key0 = 0x12a3fe2d, key1 = 0x37abe8f9;
+
+	while (len--) {
+		key = key1 + (key0 ^ (*name++ * 7152373));
+		if (key & 0x8000000000000000ULL)
+			key -= 0x7fffffffffffffffULL;
+		key1 = key0;
+		key0 = key;
+	}
+
+	fsid->val[0] = key;
+	fsid->val[1] = key >> 32;
+}
+
 static int ll_nfs_test_inode(struct inode *inode, void *opaque)
 {
 	return lu_fid_eq(&ll_i2info(inode)->lli_fid,
-- 
1.7.9.5

