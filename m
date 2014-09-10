Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbaIJMfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 08:35:44 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:37561 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaIJMfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 08:35:42 -0400
Date: Wed, 10 Sep 2014 07:35:25 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user
 namespaces
Message-ID: <20140910123525.GA29064@ubuntu-hedt>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 10:44:53AM -0500, Seth Forshee wrote:
> Another issue mentioned by Eric was what to use for i_[ug]id if the ids
> from userspace don't map into the user namespace, which is going to be a
> problem for any other filesystems which become mountable from user
> namespaces as well. We discussed a few options for addressing this, the
> most promising of which seems to be either using INVALID_[UG]ID for
> these inodes or creating vfs-wide "nobody" ids for this purpose. After
> thinking about it for a while I'm favoring using the invalid ids, but
> I'm hoping to solicit some more feedback.
> 
> For now these patches are using invalid ids if the user doesn't map into
> the namespace. I went through the vfs code and found one place where
> this could be handled better (addressed in patch 1 of the series). The
> only other issue I found was that currently no one, not even root, can
> change onwership of such inodes, but I suspect we can find a way around
> this.

I started playing around with using -2 as a global nobody id. The
changes below (made on top of this series) are working fine in light
testing. I'm still not sure about the security implications of doing
this though. Possibly the nobody id should be removed from init_user_ns
to prevent any use of the id to gain unauthroized access to such files.
Thoughts?


diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index c0b9968db6a1..893fc0d6ff96 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -905,8 +905,8 @@ static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
 	stat->ino = attr->ino;
 	stat->mode = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
 	stat->nlink = attr->nlink;
-	stat->uid = make_kuid(fc->user_ns, attr->uid);
-	stat->gid = make_kgid(fc->user_ns, attr->gid);
+	stat->uid = make_kuid_munged(fc->user_ns, attr->uid);
+	stat->gid = make_kgid_munged(fc->user_ns, attr->gid);
 	stat->rdev = inode->i_rdev;
 	stat->atime.tv_sec = attr->atime;
 	stat->atime.tv_nsec = attr->atimensec;
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index f3a3ded82f85..330ac3d502a6 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -167,8 +167,8 @@ void fuse_change_attributes_common(struct inode *inode, struct fuse_attr *attr,
 	inode->i_ino     = fuse_squash_ino(attr->ino);
 	inode->i_mode    = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
 	set_nlink(inode, attr->nlink);
-	inode->i_uid     = make_kuid(fc->user_ns, attr->uid);
-	inode->i_gid     = make_kgid(fc->user_ns, attr->gid);
+	inode->i_uid     = make_kuid_munged(fc->user_ns, attr->uid);
+	inode->i_gid     = make_kgid_munged(fc->user_ns, attr->gid);
 	inode->i_blocks  = attr->blocks;
 	inode->i_atime.tv_sec   = attr->atime;
 	inode->i_atime.tv_nsec  = attr->atimensec;
diff --git a/include/linux/uidgid.h b/include/linux/uidgid.h
index 6c302267f7cc..9054273af163 100644
--- a/include/linux/uidgid.h
+++ b/include/linux/uidgid.h
@@ -45,6 +45,9 @@ static inline gid_t __kgid_val(kgid_t gid)
 #define INVALID_UID KUIDT_INIT(-1)
 #define INVALID_GID KGIDT_INIT(-1)
 
+#define NOBODY_UID KUIDT_INIT(-2)
+#define NOBODY_GID KGIDT_INIT(-2)
+
 static inline bool uid_eq(kuid_t left, kuid_t right)
 {
 	return __kuid_val(left) == __kuid_val(right);
@@ -175,4 +178,44 @@ static inline bool kgid_has_mapping(struct user_namespace *ns, kgid_t gid)
 
 #endif /* CONFIG_USER_NS */
 
+/**
+ *	make_kuid_munged - Map a user-namespace uid pair into a kuid
+ * 	@from: User namespace that the uid is in
+ * 	@uid:  User identifier
+ *
+ *	Maps a user-namespace uid pair into a kernel internal kuid,
+ *	and returns that kuid.
+ *
+ *	Unlike make_kuid, make_kuid_munged never fails and always
+ *	returns a valid uid. If @uid has no mapping in @from
+ *	NOBODY_UID is returned.
+ */
+static inline kuid_t make_kuid_munged(struct user_namespace *from, uid_t uid)
+{
+	kuid_t kuid = make_kuid(from, uid);
+	if (!uid_valid(kuid))
+		kuid = NOBODY_UID;
+	return kuid;
+}
+
+/**
+ *	make_kgid_munged - Map a user-namespace gid pair into a kgid
+ * 	@from: User namespace that the gid is in
+ * 	@gid:  User identifier
+ *
+ *	Maps a user-namespace gid pair into a kernel internal kgid,
+ *	and returns that kgid.
+ *
+ *	Unlike make_kgid, make_kgid_munged never fails and always
+ *	returns a valid gid. If @gid has no mapping in @from
+ *	NOBODY_GID is returned.
+ */
+static inline kgid_t make_kgid_munged(struct user_namespace *from, gid_t gid)
+{
+	kgid_t kgid = make_kgid(from, gid);
+	if (!gid_valid(kgid))
+		kgid = NOBODY_GID;
+	return kgid;
+}
+
 #endif /* _LINUX_UIDGID_H */
