Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965366Ab3CZPXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:23:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54065 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965314Ab3CZPXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 116/150] vfs,proc: guarantee unique inodes in /proc
Date: Tue, 26 Mar 2013 15:20:15 +0000
Message-Id: <1364311249-14454-117-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 51f0885e5415b4cc6535e9cdcc5145bfbc134353 upstream.

Dave Jones found another /proc issue with his Trinity tool: thanks to
the namespace model, we can have multiple /proc dentries that point to
the same inode, aliasing directories in /proc/<pid>/net/ for example.

This ends up being a total disaster, because it acts like hardlinked
directories, and causes locking problems.  We rely on the topological
sort of the inodes pointed to by dentries, and if we have aliased
directories, that odering becomes unreliable.

In short: don't do this.  Multiple dentries with the same (directory)
inode is just a bad idea, and the namespace code should never have
exposed things this way.  But we're kind of stuck with it.

This solves things by just always allocating a new inode during /proc
dentry lookup, instead of using "iget_locked()" to look up existing
inodes by superblock and number.  That actually simplies the code a bit,
at the cost of potentially doing more inode [de]allocations.

That said, the inode lookup wasn't free either (and did a lot of locking
of inodes), so it is probably not that noticeable.  We could easily keep
the old lookup model for non-directory entries, but rather than try to
be excessively clever this just implements the minimal and simplest
workaround for the problem.

Reported-and-tested-by: Dave Jones <davej@redhat.com>
Analyzed-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: backported to 3.5; adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/proc/inode.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 7ac817b..b02ddd0 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -443,12 +443,10 @@ static const struct file_operations proc_reg_file_ops_no_compat = {
 
 struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 {
-	struct inode * inode;
+	struct inode *inode = new_inode_pseudo(sb);
 
-	inode = iget_locked(sb, de->low_ino);
-	if (!inode)
-		return NULL;
-	if (inode->i_state & I_NEW) {
+	if (inode) {
+		inode->i_ino = de->low_ino;
 		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 		PROC_I(inode)->fd = 0;
 		PROC_I(inode)->pde = de;
@@ -477,7 +475,6 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 				inode->i_fop = de->proc_fops;
 			}
 		}
-		unlock_new_inode(inode);
 	} else
 	       pde_put(de);
 	return inode;
-- 
1.8.1.2

