Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaCST65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:58:57 -0400
Received: from www85.your-server.de ([213.133.104.85]:58211 "EHLO
	www85.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbaCST6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:58:55 -0400
X-Greylist: delayed 1203 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2014 15:58:55 EDT
From: Olaf Dietsche <olaf--list.linux-kernel@olafdietsche.de>
To: Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] 3.8: access permission filesystem
Date: Wed, 19 Mar 2014 20:38:45 +0100
Message-ID: <87k3bqnflm.fsf@olafdietsche.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Authenticated-Sender: olaf@olafdietsche.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

I am in the process of catching up with the last two years or so.
Right now, I am at the changes involving user namespaces.

I have two possible implementations, both working equally well in a
shared environment. Since I am not familiar with namespaces in general
and user namespaces in particular, I would like you to look over the
patches and tell me, what you think.

Are the patches good so far? Are there are any things I missed and must
consider? Maybe, I am completely off track? Anything else?

I included both patches inline below. The patches are also available as
separate branches at github 

https://github.com/olafdietsche/linux-accessfs/tree/tmp-user-ns-1
https://github.com/olafdietsche/linux-accessfs/tree/tmp-user-ns-2

I am leaning toward the second patch. Although it is a little bit longer
than the first one, it involves no user id conversions.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=tmp-user-ns-1.diff
Content-Description: accessfs: adpapt to user namespaces, 1. version

 fs/accessfs/inode.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/accessfs/inode.c b/fs/accessfs/inode.c
index e02c275..ce62ff0 100644
--- a/fs/accessfs/inode.c
+++ b/fs/accessfs/inode.c
@@ -122,8 +122,8 @@ static void accessfs_init_inode(struct inode *inode, struct accessfs_entry *pe)
 {
 	static const struct timespec epoch = {0, 0};
 	inode->i_private = pe;
-	inode->i_uid = pe->attr->uid;
-	inode->i_gid = pe->attr->gid;
+	i_uid_write(inode, pe->attr->uid);
+	i_gid_write(inode, pe->attr->gid);
 	inode->i_mode = pe->attr->mode;
 /*
 	inode->i_blksize = PAGE_CACHE_SIZE;
@@ -269,8 +269,8 @@ static int accessfs_notify_change(struct dentry *dentry, struct iattr *iattr)
 	setattr_copy(i, iattr);
 
 	pe = (struct accessfs_entry *) i->i_private;
-	pe->attr->uid = i->i_uid;
-	pe->attr->gid = i->i_gid;
+	pe->attr->uid = i_uid_read(i);
+	pe->attr->gid = i_gid_read(i);
 	pe->attr->mode = i->i_mode;
 	return 0;
 }
@@ -363,9 +363,9 @@ static struct dentry *accessfs_mount(struct file_system_type *fs_type,
 int accessfs_permitted(struct access_attr *p, int mask)
 {
 	mode_t mode = p->mode;
-	if (current_fsuid() == p->uid)
+	if (uid_eq(current_fsuid(), make_kuid(current_user_ns(), p->uid)))
 		mode >>= 6;
-	else if (in_group_p(p->gid))
+	else if (in_group_p(make_kgid(current_user_ns(), p->gid)))
 		mode >>= 3;
 
 	return (mode & mask) == mask;

--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=tmp-user-ns-2.diff
Content-Description: accessfs: adpapt to user namespaces, 2. version

 fs/accessfs/capabilities.c  | 4 ++--
 fs/accessfs/inode.c         | 8 ++++----
 fs/accessfs/ip.c            | 4 ++--
 include/linux/accessfs_fs.h | 4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/accessfs/capabilities.c b/fs/accessfs/capabilities.c
index a8b52b3..d60b16f 100644
--- a/fs/accessfs/capabilities.c
+++ b/fs/accessfs/capabilities.c
@@ -83,8 +83,8 @@ static int __init init_capabilities(void)
 		return -ENOTDIR;
 
 	for (i = 0; i < ARRAY_SIZE(caps); ++i) {
-		caps[i].uid = 0;
-		caps[i].gid = 0;
+		caps[i].uid = GLOBAL_ROOT_UID;
+		caps[i].gid = GLOBAL_ROOT_GID;
 		caps[i].mode = S_IXUSR;
 		err = accessfs_register(dir, names[i], &caps[i]);
 		if (err) {
diff --git a/fs/accessfs/inode.c b/fs/accessfs/inode.c
index e02c275..4e4867d 100644
--- a/fs/accessfs/inode.c
+++ b/fs/accessfs/inode.c
@@ -115,7 +115,7 @@ static struct accessfs_direntry	accessfs_rootdir = {
 	  LIST_HEAD_INIT(accessfs_rootdir.node.siblings), 
 	  1, &accessfs_rootdir.attr },
 	NULL, LIST_HEAD_INIT(accessfs_rootdir.children), 
-	{ 0, 0, S_IFDIR | 0755 }
+	{ GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, S_IFDIR | 0755 }
 };
 
 static void accessfs_init_inode(struct inode *inode, struct accessfs_entry *pe)
@@ -174,8 +174,8 @@ static int accessfs_node_init(struct accessfs_direntry *parent,
 	de->name[len] = 0;
 	de->ino = ++ino;
 	de->attr = attr;
-	de->attr->uid = 0;
-	de->attr->gid = 0;
+	de->attr->uid = GLOBAL_ROOT_UID;
+	de->attr->gid = GLOBAL_ROOT_GID;
 	de->attr->mode = mode;
 
 	list_add_tail(&de->hash, &hash);
@@ -363,7 +363,7 @@ static struct dentry *accessfs_mount(struct file_system_type *fs_type,
 int accessfs_permitted(struct access_attr *p, int mask)
 {
 	mode_t mode = p->mode;
-	if (current_fsuid() == p->uid)
+	if (uid_eq(current_fsuid(), p->uid))
 		mode >>= 6;
 	else if (in_group_p(p->gid))
 		mode >>= 3;
diff --git a/fs/accessfs/ip.c b/fs/accessfs/ip.c
index a6c0ee0..493a2ca 100644
--- a/fs/accessfs/ip.c
+++ b/fs/accessfs/ip.c
@@ -66,8 +66,8 @@ static int __init init_ip(void)
 
 	for (i = 1; i < max_prot_sock; ++i) {
 		char	buf[sizeof("65536")];
-		bind_to_port[i].uid = 0;
-		bind_to_port[i].gid = 0;
+		bind_to_port[i].uid = GLOBAL_ROOT_UID;
+		bind_to_port[i].gid = GLOBAL_ROOT_GID;
 		bind_to_port[i].mode = i < PROT_SOCK ? S_IXUSR : S_IXUGO;
 		sprintf(buf, "%d", i);
 		accessfs_register(dir, buf, &bind_to_port[i]);
diff --git a/include/linux/accessfs_fs.h b/include/linux/accessfs_fs.h
index ecd914e..8ebc24a 100644
--- a/include/linux/accessfs_fs.h
+++ b/include/linux/accessfs_fs.h
@@ -14,8 +14,8 @@
 #include <net/sock.h>
 
 struct access_attr {
-	uid_t	uid;
-	gid_t	gid;
+	kuid_t	uid;
+	kgid_t	gid;
 	mode_t	mode;
 };
 

--=-=-=--
