Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaDRJWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:22:52 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45876 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751161AbaDRJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paul Moore <pmoore@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 05/72] selinux: correctly label /proc inodes in use before the policy is loaded
Date: Fri, 18 Apr 2014 11:21:38 +0200
Message-Id: <4a1bdd99a8f04c5dd591079a00b1c0b2dad7c51d.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Moore <pmoore@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 security/selinux/hooks.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 25d5ebaf25f9..630b8adf0ce5 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1386,15 +1386,33 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
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
-- 
1.9.2

