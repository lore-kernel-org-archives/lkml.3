Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbaHHVAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:00:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41460 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157AbaHHUyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:54:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Miklos Szeredi <mszeredi@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 120/259] fuse: handle large user and group ID
Date: Fri,  8 Aug 2014 13:39:03 -0700
Message-Id: <1407530482-4483-121-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 233a01fa9c4c7c41238537e8db8434667ff28a2f upstream.

If the number in "user_id=N" or "group_id=N" mount options was larger than
INT_MAX then fuse returned EINVAL.

Fix this to handle all valid uid/gid values.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/fuse/inode.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index d468643..73f6bcb 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -461,6 +461,17 @@ static const match_table_t tokens = {
 	{OPT_ERR,			NULL}
 };
 
+static int fuse_match_uint(substring_t *s, unsigned int *res)
+{
+	int err = -ENOMEM;
+	char *buf = match_strdup(s);
+	if (buf) {
+		err = kstrtouint(buf, 10, res);
+		kfree(buf);
+	}
+	return err;
+}
+
 static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
 {
 	char *p;
@@ -471,6 +482,7 @@ static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
 	while ((p = strsep(&opt, ",")) != NULL) {
 		int token;
 		int value;
+		unsigned uv;
 		substring_t args[MAX_OPT_ARGS];
 		if (!*p)
 			continue;
@@ -494,18 +506,18 @@ static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
 			break;
 
 		case OPT_USER_ID:
-			if (match_int(&args[0], &value))
+			if (fuse_match_uint(&args[0], &uv))
 				return 0;
-			d->user_id = make_kuid(current_user_ns(), value);
+			d->user_id = make_kuid(current_user_ns(), uv);
 			if (!uid_valid(d->user_id))
 				return 0;
 			d->user_id_present = 1;
 			break;
 
 		case OPT_GROUP_ID:
-			if (match_int(&args[0], &value))
+			if (fuse_match_uint(&args[0], &uv))
 				return 0;
-			d->group_id = make_kgid(current_user_ns(), value);
+			d->group_id = make_kgid(current_user_ns(), uv);
 			if (!gid_valid(d->group_id))
 				return 0;
 			d->group_id_present = 1;
-- 
1.9.1

