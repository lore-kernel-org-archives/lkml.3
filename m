Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaD1B3Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:29:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42813 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752105AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paul Moore" <pmoore@redhat.com>,
        "Eric Paris" <eparis@redhat.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.971320997@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 90/94] selinux: correctly label /proc inodes in use
 before the policy is loaded
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

commit f64410ec665479d7b4b77b7519e814253ed0f686 upstream.

This patch is based on an earlier patch by Eric Paris, he describes
the problem below:

  "If an inode is accessed before policy load it will get placed on a
   list of inodes to be initialized after policy load.  After policy
   load we call inode_doinit() which calls inode_doinit_with_dentry()
   on all inodes accessed before policy load.  In the case of inodes
   in procfs that means we'll end up at the bottom where it does:

     /* Default to the fs superblock SID. */
     isec->sid = sbsec->sid;

     if ((sbsec->flags & SE_SBPROC) && !S_ISLNK(inode->i_mode)) {
             if (opt_dentry) {
                     isec->sclass = inode_mode_to_security_class(...)
                     rc = selinux_proc_get_sid(opt_dentry,
                                               isec->sclass,
                                               &sid);
                     if (rc)
                             goto out_unlock;
                     isec->sid = sid;
             }
     }

   Since opt_dentry is null, we'll never call selinux_proc_get_sid()
   and will leave the inode labeled with the label on the superblock.
   I believe a fix would be to mimic the behavior of xattrs.  Look
   for an alias of the inode.  If it can't be found, just leave the
   inode uninitialized (and pick it up later) if it can be found, we
   should be able to call selinux_proc_get_sid() ..."

On a system exhibiting this problem, you will notice a lot of files in
/proc with the generic "proc_t" type (at least the ones that were
accessed early in the boot), for example:

   # ls -Z /proc/sys/kernel/shmmax | awk '{ print $4 " " $5 }'
   system_u:object_r:proc_t:s0 /proc/sys/kernel/shmmax

However, with this patch in place we see the expected result:

   # ls -Z /proc/sys/kernel/shmmax | awk '{ print $4 " " $5 }'
   system_u:object_r:sysctl_kernel_t:s0 /proc/sys/kernel/shmmax

Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Acked-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/selinux/hooks.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1328,15 +1328,33 @@ static int inode_doinit_with_dentry(stru
 		isec->sid = sbsec->sid;
 
 		if ((sbsec->flags & SE_SBPROC) && !S_ISLNK(inode->i_mode)) {
-			if (opt_dentry) {
-				isec->sclass = inode_mode_to_security_class(inode->i_mode);
-				rc = selinux_proc_get_sid(opt_dentry,
-							  isec->sclass,
-							  &sid);
-				if (rc)
-					goto out_unlock;
-				isec->sid = sid;
-			}
+			/* We must have a dentry to determine the label on
+			 * procfs inodes */
+			if (opt_dentry)
+				/* Called from d_instantiate or
+				 * d_splice_alias. */
+				dentry = dget(opt_dentry);
+			else
+				/* Called from selinux_complete_init, try to
+				 * find a dentry. */
+				dentry = d_find_alias(inode);
+			/*
+			 * This can be hit on boot when a file is accessed
+			 * before the policy is loaded.  When we load policy we
+			 * may find inodes that have no dentry on the
+			 * sbsec->isec_head list.  No reason to complain as
+			 * these will get fixed up the next time we go through
+			 * inode_doinit() with a dentry, before these inodes
+			 * could be used again by userspace.
+			 */
+			if (!dentry)
+				goto out_unlock;
+			isec->sclass = inode_mode_to_security_class(inode->i_mode);
+			rc = selinux_proc_get_sid(dentry, isec->sclass, &sid);
+			dput(dentry);
+			if (rc)
+				goto out_unlock;
+			isec->sid = sid;
 		}
 		break;
 	}

