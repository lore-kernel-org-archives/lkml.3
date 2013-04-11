Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934753Ab3DKUeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:34:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16423 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3DKU0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:13 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=nG1pd-0fYoEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Q3dr9x84rdIA:10 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=drOt6m5kAAAA:8 a=VwQbUJbxAAAA:8 a=ayC55rCoAAAA:8 a=RvlEQHu-AAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=E6k37eg1NvgA:10 a=jbrJJM5MRmoA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=18wLc48eJEMHdTOA:21 a=qrd-UK6g-l35_Ta7:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202551.428270117@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 032/171 ] vfs,proc: guarantee unique inodes in /proc
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0032-vfs-proc-guarantee-unique-inodes-in-proc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 51f0885e5415b4cc6535e9cdcc5145bfbc134353 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/proc/inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 710e28f..e5b57da 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -443,9 +443,10 @@ static const struct file_operations proc_reg_file_ops_no_compat = {
 
 struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 {
-	struct inode *inode = iget_locked(sb, de->low_ino);
+	struct inode *inode = new_inode_pseudo(sb);
 
-	if (inode && (inode->i_state & I_NEW)) {
+	if (inode) {
+		inode->i_ino = de->low_ino;
 		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 		PROC_I(inode)->fd = 0;
 		PROC_I(inode)->pde = de;
@@ -474,7 +475,6 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 				inode->i_fop = de->proc_fops;
 			}
 		}
-		unlock_new_inode(inode);
 	} else
 	       pde_put(de);
 	return inode;
-- 
1.7.10.4


