Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934140Ab3IDAzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:55:05 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58083 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761437Ab3IDAzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:55:02 -0400
X-Sasl-enc: ZwwKCTVjQozON2Zu6euVswVnzFY8nrYKxypM9iRc53Tf 1378256100
Subject: [PATCH 1/3] autofs4 - fix device ioctl mount lookup
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, rui.xiang@huawei.com,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date: Wed, 04 Sep 2013 08:54:57 +0800
Message-ID: <20130904005456.5025.94309.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reconnecting to automounts at startup an autofs ioctl is used
to find the device and inode of existing mounts so they can be used
to open a file descriptor of possibly covered mounts.

At this time the the caller might not yet "own" the mount so it can
trigger calling ->d_automount(). This causes automount to hang when
trying to reconnect to direct or offset mount types.

Consequently kern_path() can't be used.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/dev-ioctl.c |   72 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 62 insertions(+), 10 deletions(-)

diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 743c7c2..1d24e42 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -183,13 +183,67 @@ static int autofs_dev_ioctl_protosubver(struct file *fp,
 	return 0;
 }
 
+/*
+ * Lookup the the topmost path of a (possible) mount stack.
+ *
+ * kern_path() can't be used here because the caller might not
+ * "own" the automount dentry yet and we would end up calling
+ * back to ourself.
+ */
+static int kern_path_top(const char *pathname,
+			 unsigned int flags, struct path *path)
+{
+	struct dentry *dentry;
+	struct qstr name;
+	const char *tmp;
+	unsigned int len;
+	int err;
+
+	len = strlen(pathname);
+	if (len <= 1)
+		return -EINVAL;
+
+	tmp = pathname + len - 1;
+	len = 0;
+	if (*tmp == '/')
+		tmp--;
+	do {
+		if (*tmp == '/')
+			break;
+		len++;
+	} while (--tmp >= pathname);
+	tmp++;
+
+	err = kern_path(pathname, flags | LOOKUP_PARENT, path);
+	if (err)
+		return err;
+
+	name.name = tmp;
+	name.len = len;
+	name.hash = full_name_hash(tmp, len);
+
+	dentry = d_lookup(path->dentry, &name);
+	if (!dentry) {
+		path_put(path);
+		return -ENOENT;
+	}
+	dput(path->dentry);
+	path->dentry = dentry;
+
+	while (follow_down_one(path))
+		;
+
+	return 0;
+}
+
+/* Find the topmost mount satisfying test() */
 static int find_autofs_mount(const char *pathname,
 			     struct path *res,
 			     int test(struct path *path, void *data),
 			     void *data)
 {
 	struct path path;
-	int err = kern_path(pathname, 0, &path);
+	int err = kern_path_top(pathname, 0, &path);
 	if (err)
 		return err;
 	err = -ENOENT;
@@ -197,10 +251,9 @@ static int find_autofs_mount(const char *pathname,
 		if (path.dentry->d_sb->s_magic == AUTOFS_SUPER_MAGIC) {
 			if (test(&path, data)) {
 				path_get(&path);
-				if (!err) /* already found some */
-					path_put(res);
 				*res = path;
 				err = 0;
+				break;
 			}
 		}
 		if (!follow_up(&path))
@@ -486,12 +539,11 @@ static int autofs_dev_ioctl_askumount(struct file *fp,
  * mount if there is one or 0 if it isn't a mountpoint.
  *
  * If we aren't supplied with a file descriptor then we
- * lookup the nameidata of the path and check if it is the
- * root of a mount. If a type is given we are looking for
- * a particular autofs mount and if we don't find a match
- * we return fail. If the located nameidata path is the
- * root of a mount we return 1 along with the super magic
- * of the mount or 0 otherwise.
+ * lookup the path and check if it is the root of a mount.
+ * If a type is given we are looking for a particular autofs
+ * mount and if we don't find a match we return fail. If the
+ * located path is the root of a mount we return 1 along with
+ * the super magic of the mount or 0 otherwise.
  *
  * In both cases the the device number (as returned by
  * new_encode_dev()) is also returned.
@@ -519,7 +571,7 @@ static int autofs_dev_ioctl_ismountpoint(struct file *fp,
 
 	if (!fp || param->ioctlfd == -1) {
 		if (autofs_type_any(type))
-			err = kern_path(name, LOOKUP_FOLLOW, &path);
+			err = kern_path_top(name, LOOKUP_FOLLOW, &path);
 		else
 			err = find_autofs_mount(name, &path, test_by_type, &type);
 		if (err)

