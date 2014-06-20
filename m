Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbaFTRpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:45:38 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:44436 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaFTRph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:45:37 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>,
        James Morris <james.l.morris@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH] selinux: no recursive read_lock of policy_rwlock in security_genfs_sid()
Date: Fri, 20 Jun 2014 13:45:24 -0400
Message-Id: <1403286324-34421-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With introduction of fair queued rwlock, recursive read_lock() may hang
the offending process if there is a write_lock() somewhere in between.

With recursive read_lock checking enabled, the following error was
reported:

=============================================
[ INFO: possible recursive locking detected ]
3.16.0-rc1 #2 Tainted: G            E
---------------------------------------------
load_policy/708 is trying to acquire lock:
 (policy_rwlock){.+.+..}, at: [<ffffffff8125b32a>] security_genfs_sid+0x3a/0x170

but task is already holding lock:
 (policy_rwlock){.+.+..}, at: [<ffffffff8125b48c>] security_fs_use+0x2c/0x110

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(policy_rwlock);
  lock(policy_rwlock);

This patch fixes the occurrence of recursive read_lock() of
policy_rwlock in security_genfs_sid() by adding a 5th argument to
indicate if the rwlock has been taken.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 security/selinux/hooks.c            |    2 +-
 security/selinux/include/security.h |    2 +-
 security/selinux/selinuxfs.c        |    3 ++-
 security/selinux/ss/services.c      |   13 +++++++++----
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 83d06db..430035a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1248,7 +1248,7 @@ static int selinux_proc_get_sid(struct dentry *dentry,
 			path[1] = '/';
 			path++;
 		}
-		rc = security_genfs_sid("proc", path, tclass, sid);
+		rc = security_genfs_sid("proc", path, tclass, sid, false);
 	}
 	free_page((unsigned long)buffer);
 	return rc;
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index ce7852c..6bc5b2f 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -180,7 +180,7 @@ int security_get_allow_unknown(void);
 int security_fs_use(struct super_block *sb);
 
 int security_genfs_sid(const char *fstype, char *name, u16 sclass,
-	u32 *sid);
+	u32 *sid, int locked);
 
 #ifdef CONFIG_NETLABEL
 int security_netlbl_secattr_to_sid(struct netlbl_lsm_secattr *secattr,
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index c71737f..405799e 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1273,7 +1273,8 @@ static int sel_make_bools(void)
 			goto out;
 
 		isec = (struct inode_security_struct *)inode->i_security;
-		ret = security_genfs_sid("selinuxfs", page, SECCLASS_FILE, &sid);
+		ret = security_genfs_sid("selinuxfs", page, SECCLASS_FILE,
+					&sid, false);
 		if (ret)
 			goto out;
 
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 4bca494..2b23c2c 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2282,6 +2282,7 @@ out:
  * @path: path from root of mount
  * @sclass: file security class
  * @sid: SID for path
+ * @locked: true if policy_rwlock taken
  *
  * Obtain a SID to use for a file in a filesystem that
  * cannot support xattr or use a fixed labeling behavior like
@@ -2290,7 +2291,8 @@ out:
 int security_genfs_sid(const char *fstype,
 		       char *path,
 		       u16 orig_sclass,
-		       u32 *sid)
+		       u32 *sid,
+		       int locked)
 {
 	int len;
 	u16 sclass;
@@ -2301,7 +2303,8 @@ int security_genfs_sid(const char *fstype,
 	while (path[0] == '/' && path[1] == '/')
 		path++;
 
-	read_lock(&policy_rwlock);
+	if (!locked)
+		read_lock(&policy_rwlock);
 
 	sclass = unmap_class(orig_sclass);
 	*sid = SECINITSID_UNLABELED;
@@ -2336,7 +2339,8 @@ int security_genfs_sid(const char *fstype,
 	*sid = c->sid[0];
 	rc = 0;
 out:
-	read_unlock(&policy_rwlock);
+	if (!locked)
+		read_unlock(&policy_rwlock);
 	return rc;
 }
 
@@ -2370,7 +2374,8 @@ int security_fs_use(struct super_block *sb)
 		}
 		sbsec->sid = c->sid[0];
 	} else {
-		rc = security_genfs_sid(fstype, "/", SECCLASS_DIR, &sbsec->sid);
+		rc = security_genfs_sid(fstype, "/", SECCLASS_DIR, &sbsec->sid,
+					true);
 		if (rc) {
 			sbsec->behavior = SECURITY_FS_USE_NONE;
 			rc = 0;
-- 
1.7.1

