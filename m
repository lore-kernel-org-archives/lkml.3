Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaILOm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:42:26 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:43278 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaILOmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:42:21 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v3 2/4] vfs,userns: Ensure real root is always capable towards inodes
Date: Fri, 12 Sep 2014 09:41:43 -0500
Message-Id: <1410532905-114262-3-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410532905-114262-1-git-send-email-seth.forshee@canonical.com>
References: <1410532905-114262-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently root is restricted from performing some modifications
to inodes whose owner is INVALID_UID or group is INVALID_GID
because this id doesn't map into any user namespace. Add a
special case to the relevant checks to make sure root is always
capable of performing these operations.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/inode.c          | 3 +++
 kernel/capability.c | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index 26753ba7b6d6..1029320ff029 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1840,6 +1840,9 @@ bool inode_owner_or_capable(const struct inode *inode)
 {
 	struct user_namespace *ns;
 
+	if (capable(CAP_SYS_ADMIN))
+		return true;
+
 	if (uid_eq(current_fsuid(), inode->i_uid))
 		return true;
 
diff --git a/kernel/capability.c b/kernel/capability.c
index 989f5bfc57dc..a472eaa52b6a 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -438,8 +438,12 @@ EXPORT_SYMBOL(capable);
  */
 bool capable_wrt_inode_uidgid(const struct inode *inode, int cap)
 {
-	struct user_namespace *ns = current_user_ns();
+	struct user_namespace *ns;
 
+	if (capable(CAP_SYS_ADMIN))
+		return true;
+
+	ns = current_user_ns();
 	return ns_capable(ns, cap) && kuid_has_mapping(ns, inode->i_uid) &&
 		kgid_has_mapping(ns, inode->i_gid);
 }
-- 
1.9.1

