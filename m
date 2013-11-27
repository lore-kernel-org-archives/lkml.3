Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3K0A4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:56:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3K0A4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:56:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 01/39] vfs,proc: guarantee unique inodes in /proc
Date: Tue, 26 Nov 2013 16:56:25 -0800
Message-Id: <20131127005619.151214882@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005619.011763867@linuxfoundation.org>
References: <20131127005619.011763867@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - Never drop the pde reference in proc_get_inode(), as callers only
   expect this when we return an existing inode, and we never do that now]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/inode.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -443,12 +443,10 @@ static const struct file_operations proc
 
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
@@ -477,9 +475,7 @@ struct inode *proc_get_inode(struct supe
 				inode->i_fop = de->proc_fops;
 			}
 		}
-		unlock_new_inode(inode);
-	} else
-	       pde_put(de);
+	}
 	return inode;
 }			
 


