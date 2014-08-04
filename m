Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaHDQ7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:59:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56581 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Miklos Szeredi" <mszeredi@suse.cz>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.314063850@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 40/94] fuse: handle large user and group ID
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 233a01fa9c4c7c41238537e8db8434667ff28a2f upstream.

If the number in "user_id=N" or "group_id=N" mount options was larger than
INT_MAX then fuse returned EINVAL.

Fix this to handle all valid uid/gid values.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
[bwh: Backported to 3.2: no user namespace conversion]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/fuse/inode.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -437,6 +437,17 @@ static const match_table_t tokens = {
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
@@ -447,6 +458,7 @@ static int parse_fuse_opt(char *opt, str
 	while ((p = strsep(&opt, ",")) != NULL) {
 		int token;
 		int value;
+		unsigned uv;
 		substring_t args[MAX_OPT_ARGS];
 		if (!*p)
 			continue;
@@ -470,16 +482,16 @@ static int parse_fuse_opt(char *opt, str
 			break;
 
 		case OPT_USER_ID:
-			if (match_int(&args[0], &value))
+			if (fuse_match_uint(&args[0], &uv))
 				return 0;
-			d->user_id = value;
+			d->user_id = uv;
 			d->user_id_present = 1;
 			break;
 
 		case OPT_GROUP_ID:
-			if (match_int(&args[0], &value))
+			if (fuse_match_uint(&args[0], &uv))
 				return 0;
-			d->group_id = value;
+			d->group_id = uv;
 			d->group_id_present = 1;
 			break;
 

