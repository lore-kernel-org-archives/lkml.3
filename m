Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3HUTOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 15:14:33 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:60909 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3HUTOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 15:14:32 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>, spender@grsecurity.net,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
Date: Wed, 21 Aug 2013 12:14:26 -0700
Message-Id: <b121a1082bf3365fda22a131782147c169c969f5.1377112282.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have long been two ways to ask the kernel to create a new
hardlink to the inode represented by an fd: linkat(..., AT_EMPTY_PATH)
and AT_SYMLINK_FOLLOW on /proc/self/fd/N.  The latter has no
particular security restrictions, but the former required privilege
until:

    commit bb2314b47996491bbc5add73633905c3120b6268
    Author: Andy Lutomirski <luto@amacapital.net>
    Date:   Thu Aug 1 21:44:31 2013 -0700

        fs: Allow unprivileged linkat(..., AT_EMPTY_PATH) aka flink

Spender pointed out that there could be code that passes an fd to an
untrusted, chrooted process, and allowing that process to flink the
fd could be dangerous.  (I'm not aware of any actual known attack.)

So let's be careful for now: only allow linkat(..., AT_EMPTY_PATH)
if the target is I_LINKABLE.  I_LINKABLE is only set for inodes
created by O_TMPFILE without O_EXCL, which is an explicit request
for flinkability.

Reported-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Changes from v1: Removed an unnecessary spin_lock.

 fs/namei.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 89a612e..9802d51 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3652,6 +3652,26 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 }
 
 /*
+ * flink is dangerous.  For now, only allow it when specifically requested
+ * or when the caller is privileged.
+ *
+ * NB: This is not currently enforced for AT_SYMLINK_FOLLOW on procfs.
+ *     Fixing that would be intrusive and could break something.
+ */
+static bool may_flink(const struct path *path)
+{
+	struct inode *inode = path->dentry->d_inode;
+
+	/*
+	 * This is racy: I_LINKABLE could be cleared between this check
+	 * and the actual link operation.  This is odd but not a security
+	 * problem: the caller could get the same effect by flinking once
+	 * and then using normal link(2) to create a second link.
+	 */
+	return (inode->i_state & I_LINKABLE) || capable(CAP_DAC_READ_SEARCH);
+}
+
+/*
  * Hardlinks are often used in delicate situations.  We avoid
  * security-related surprises by not following symlinks on the
  * newname.  --KAB
@@ -3670,10 +3690,7 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 
 	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0)
 		return -EINVAL;
-	/*
-	 * Using empty names is equivalent to using AT_SYMLINK_FOLLOW
-	 * on /proc/self/fd/<fd>.
-	 */
+
 	if (flags & AT_EMPTY_PATH)
 		how = LOOKUP_EMPTY;
 
@@ -3684,6 +3701,11 @@ retry:
 	if (error)
 		return error;
 
+	if ((flags & AT_EMPTY_PATH) && !may_flink(&old_path)) {
+		error = -EPERM;
+		goto out;
+	}
+
 	new_dentry = user_path_create(newdfd, newname, &new_path,
 					(how & LOOKUP_REVAL));
 	error = PTR_ERR(new_dentry);
-- 
1.8.3.1

