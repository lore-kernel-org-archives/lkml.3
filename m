Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527Ab3DBXMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:12:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab3DBWMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [ 050/124] vfs: Add a mount flag to lock read only bind mounts
Date: Tue,  2 Apr 2013 15:10:32 -0700
Message-Id: <20130402221109.995019468@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 90563b198e4c6674c63672fae1923da467215f45 upstream.

When a read-only bind mount is copied from mount namespace in a higher
privileged user namespace to a mount namespace in a lesser privileged
user namespace, it should not be possible to remove the the read-only
restriction.

Add a MNT_LOCK_READONLY mount flag to indicate that a mount must
remain read-only.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c        |    3 +++
 include/linux/mount.h |    2 ++
 2 files changed, 5 insertions(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1736,6 +1736,9 @@ static int change_mount_flags(struct vfs
 	if (readonly_request == __mnt_is_readonly(mnt))
 		return 0;
 
+	if (mnt->mnt_flags & MNT_LOCK_READONLY)
+		return -EPERM;
+
 	if (readonly_request)
 		error = mnt_make_readonly(real_mount(mnt));
 	else
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -47,6 +47,8 @@ struct mnt_namespace;
 
 #define MNT_INTERNAL	0x4000
 
+#define MNT_LOCK_READONLY	0x400000
+
 struct vfsmount {
 	struct dentry *mnt_root;	/* root of the mounted tree */
 	struct super_block *mnt_sb;	/* pointer to superblock */


