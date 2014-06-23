Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbaFWP3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:29:05 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:36097 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbaFWP3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:29:02 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>,
        James Morris <james.l.morris@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v3] selinux: no recursive read_lock of policy_rwlock in security_genfs_sid()
Date: Mon, 23 Jun 2014 11:28:51 -0400
Message-Id: <1403537331-38759-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of fair queued rwlock, recursive read_lock()
may hang the offending process if there is a write_lock() somewhere
in between.

With recursive read_lock checking enabled, the following error was
reported:

=============================================
[ INFO: possible recursive locking detected ]
3.16.0-rc1 #2 Tainted: G            E
---------------------------------------------
load_policy/708 is trying to acquire lock:
 (policy_rwlock){.+.+..}, at: [<ffffffff8125b32a>]
security_genfs_sid+0x3a/0x170

but task is already holding lock:
 (policy_rwlock){.+.+..}, at: [<ffffffff8125b48c>]
security_fs_use+0x2c/0x110

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(policy_rwlock);
  lock(policy_rwlock);

This patch fixes the occurrence of recursive read_lock() of
policy_rwlock by adding a helper function __security_genfs_sid()
which requires caller to take the lock before calling it. The
security_fs_use() was then modified to call the new helper function.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 security/selinux/ss/services.c |   41 +++++++++++++++++++++++++++++++--------
 1 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 4bca494..2aa9d17 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2277,7 +2277,7 @@ out:
 }
 
 /**
- * security_genfs_sid - Obtain a SID for a file in a filesystem
+ * __security_genfs_sid - Helper to obtain a SID for a file in a filesystem
  * @fstype: filesystem type
  * @path: path from root of mount
  * @sclass: file security class
@@ -2286,11 +2286,13 @@ out:
  * Obtain a SID to use for a file in a filesystem that
  * cannot support xattr or use a fixed labeling behavior like
  * transition SIDs or task SIDs.
+ *
+ * The caller must acquire the policy_rwlock before calling this function.
  */
-int security_genfs_sid(const char *fstype,
-		       char *path,
-		       u16 orig_sclass,
-		       u32 *sid)
+static inline int __security_genfs_sid(const char *fstype,
+				       char *path,
+				       u16 orig_sclass,
+				       u32 *sid)
 {
 	int len;
 	u16 sclass;
@@ -2301,8 +2303,6 @@ int security_genfs_sid(const char *fstype,
 	while (path[0] == '/' && path[1] == '/')
 		path++;
 
-	read_lock(&policy_rwlock);
-
 	sclass = unmap_class(orig_sclass);
 	*sid = SECINITSID_UNLABELED;
 
@@ -2336,11 +2336,33 @@ int security_genfs_sid(const char *fstype,
 	*sid = c->sid[0];
 	rc = 0;
 out:
-	read_unlock(&policy_rwlock);
 	return rc;
 }
 
 /**
+ * security_genfs_sid - Obtain a SID for a file in a filesystem
+ * @fstype: filesystem type
+ * @path: path from root of mount
+ * @sclass: file security class
+ * @sid: SID for path
+ *
+ * Acquire policy_rwlock before calling __security_genfs_sid() and release
+ * it afterward.
+ */
+int security_genfs_sid(const char *fstype,
+		       char *path,
+		       u16 orig_sclass,
+		       u32 *sid)
+{
+	int retval;
+
+	read_lock(&policy_rwlock);
+	retval = __security_genfs_sid(fstype, path, orig_sclass, sid);
+	read_unlock(&policy_rwlock);
+	return retval;
+}
+
+/**
  * security_fs_use - Determine how to handle labeling for a filesystem.
  * @sb: superblock in question
  */
@@ -2370,7 +2392,8 @@ int security_fs_use(struct super_block *sb)
 		}
 		sbsec->sid = c->sid[0];
 	} else {
-		rc = security_genfs_sid(fstype, "/", SECCLASS_DIR, &sbsec->sid);
+		rc = __security_genfs_sid(fstype, "/", SECCLASS_DIR,
+					  &sbsec->sid);
 		if (rc) {
 			sbsec->behavior = SECURITY_FS_USE_NONE;
 			rc = 0;
-- 
1.7.1

