Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbaG3MlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:41:20 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36644 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752762AbaG3MP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 18/94] fuse: handle large user and group ID
Date: Wed, 30 Jul 2014 14:14:07 +0200
Message-Id: <366a83d6b709c97460fc870fbcc016746ad20428.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 233a01fa9c4c7c41238537e8db8434667ff28a2f upstream.

If the number in "user_id=N" or "group_id=N" mount options was larger than
INT_MAX then fuse returned EINVAL.

Fix this to handle all valid uid/gid values.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/fuse/inode.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index a8ce6dab60a0..4937d4b51253 100644
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
2.0.1

