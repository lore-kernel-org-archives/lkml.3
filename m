Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3C0KOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:14:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58545 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab3C0KOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:14:04 -0400
Date: Wed, 27 Mar 2013 10:14:01 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 116/150] vfs,proc: guarantee unique inodes in /proc
Message-ID: <20130327101401.GC3103@hercules>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
 <1364311249-14454-117-git-send-email-luis.henriques@canonical.com>
 <1364362839.3520.52.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364362839.3520.52.camel@deadeye.wl.decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 05:40:39AM +0000, Ben Hutchings wrote:
> On Tue, 2013-03-26 at 15:20 +0000, Luis Henriques wrote:
> > 3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> > 
> > commit 51f0885e5415b4cc6535e9cdcc5145bfbc134353 upstream.
> > 
> > Dave Jones found another /proc issue with his Trinity tool: thanks to
> > the namespace model, we can have multiple /proc dentries that point to
> > the same inode, aliasing directories in /proc/<pid>/net/ for example.
> > 
> > This ends up being a total disaster, because it acts like hardlinked
> > directories, and causes locking problems.  We rely on the topological
> > sort of the inodes pointed to by dentries, and if we have aliased
> > directories, that odering becomes unreliable.
> > 
> > In short: don't do this.  Multiple dentries with the same (directory)
> > inode is just a bad idea, and the namespace code should never have
> > exposed things this way.  But we're kind of stuck with it.
> > 
> > This solves things by just always allocating a new inode during /proc
> > dentry lookup, instead of using "iget_locked()" to look up existing
> > inodes by superblock and number.  That actually simplies the code a bit,
> > at the cost of potentially doing more inode [de]allocations.
> > 
> > That said, the inode lookup wasn't free either (and did a lot of locking
> > of inodes), so it is probably not that noticeable.  We could easily keep
> > the old lookup model for non-directory entries, but rather than try to
> > be excessively clever this just implements the minimal and simplest
> > workaround for the problem.
> > 
> > Reported-and-tested-by: Dave Jones <davej@redhat.com>
> > Analyzed-by: Al Viro <viro@zeniv.linux.org.uk>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > [ luis: backported to 3.5; adjust context ]
> 
> Prior to commit d3d009cb965eae7e002ea5badf603ea8f4c34915, callers of
> proc_get_inode() don't expect it to call pde_put() before returning NULL
> - only when returning an existing inode, which it will never do after
> this.  So I think you must either cherry-pick that first, or delete
> 'else pde_put(de);' as part of this fix.

Nice catch, thanks Ben.  I will use your backport to 3.2 instead, which
fixes this issue.

Cheers,
--
Luis

>From 9bb1703bd0fb8df183c09fd61939a10b749f29f9 Mon Sep 17 00:00:00 2001
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 25 Mar 2013 01:07:04 +0000
Subject: [PATCH] vfs,proc: guarantee unique inodes in /proc

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/proc/inode.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 7ac817b..578f8a8 100644
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
@@ -477,9 +475,7 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
 				inode->i_fop = de->proc_fops;
 			}
 		}
-		unlock_new_inode(inode);
-	} else
-	       pde_put(de);
+	}
 	return inode;
 }			
 
-- 
1.8.1.2
