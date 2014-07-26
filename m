Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaGZUJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:09:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaGZTC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:02:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH 3.10 05/56] fuse: handle large user and group ID
Date: Sat, 26 Jul 2014 12:01:58 -0700
Message-Id: <20140726190200.232869055@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190200.061512159@linuxfoundation.org>
References: <20140726190200.061512159@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 233a01fa9c4c7c41238537e8db8434667ff28a2f upstream.

If the number in "user_id=N" or "group_id=N" mount options was larger than
INT_MAX then fuse returned EINVAL.

Fix this to handle all valid uid/gid values.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/inode.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

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
@@ -471,6 +482,7 @@ static int parse_fuse_opt(char *opt, str
 	while ((p = strsep(&opt, ",")) != NULL) {
 		int token;
 		int value;
+		unsigned uv;
 		substring_t args[MAX_OPT_ARGS];
 		if (!*p)
 			continue;
@@ -494,18 +506,18 @@ static int parse_fuse_opt(char *opt, str
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


