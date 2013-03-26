Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab3CZWoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:44:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab3CZWoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 35/98] vfs,proc: guarantee unique inodes in /proc
Date: Tue, 26 Mar 2013 15:42:24 -0700
Message-Id: <20130326224246.074997161@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -445,9 +445,10 @@ static const struct file_operations proc
 
 struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 {
-	struct inode *inode = iget_locked(sb, de->low_ino);
+	struct inode *inode = new_inode_pseudo(sb);
 
-	if (inode && (inode->i_state & I_NEW)) {
+	if (inode) {
+		inode->i_ino = de->low_ino;
 		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 		PROC_I(inode)->pde = de;
 
@@ -475,7 +476,6 @@ struct inode *proc_get_inode(struct supe
 				inode->i_fop = de->proc_fops;
 			}
 		}
-		unlock_new_inode(inode);
 	} else
 	       pde_put(de);
 	return inode;


