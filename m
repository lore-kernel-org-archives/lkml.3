Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab3GYScs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:32:48 -0400
Received: from smtp103.biz.mail.gq1.yahoo.com ([98.137.12.178]:25559 "HELO
	smtp103.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756810Ab3GYScc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:32:32 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: cdAP7CsVM1laBQLWDvDiFBMJd.HqMvrbAqUEt5QwnOQsSdX
 jKRi3oYNF2HI8axQ0z5.n3kgaNQ34IPFIqHqt..D9GAVd4zZ9auckky12_o6
 LQ.8eku6QxijxVyN11UE0rX7vcChqEtQv3ID7hhsFxn1utkvGdNArVV3obBA
 k5J69uMQ4plRz3_1S5Xiffmayu9dVL_37X8w5yz56eqvYLijSnojAqeQrVSU
 SFwxw0PihZXZhUFMa3TYoC0PfYNd0jnPgQU_SjMGLbwWm5IzH1MoHAXd1vyi
 b_.Q8qWuE6cHOsLg5kVOUbVpZw.XG1JOPBCfKy4xOC2U5Q6Ylz0sEP.XsxzI
 3qyg6Pk.vwP4600jhXE2.iU16e2WR.8ack4AZj7c8SqfJt5qMVfPwaXCXVJC
 ZTEmk5uxDtHqD66g3MeGC3OzHpco_KbQOHYX6JtaUtXfHjQdVa3WTTgcuJxP
 pZDiOm.PFoLpkf_47IEVRf.SaENpQnmgLm3nakufICfYtHKhN79D9EJSBlgl
 86MrVkITvyBlfeVynvVmspPwPPS4jlMLG7466urjFyHemPe7Ek38h0bA1wAy
 _lfTo9tuiOBSYwqIPy1F33vS2q5sCvZNFk.E1SkGH3617g0LdzPIjeVlB_PW
 ro7KymNqPM_DIbOwodimpvXsA_Ky8xFU-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp103.biz.mail.gq1.yahoo.com with SMTP; 25 Jul 2013 11:32:30 -0700 PDT
Message-ID: <51F16F3E.4040608@schaufler-ca.com>
Date: Thu, 25 Jul 2013 11:32:30 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: LKLM <linux-kernel@vger.kernel.org>
CC: Casey Schaufler <casey@schaufler-ca.com>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v14 6/6] LSM: Multiple LSM Documentation and cleanup
References: <51F16CFB.6040603@schaufler-ca.com>
In-Reply-To: <51F16CFB.6040603@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v14 6/6] LSM: Multiple LSM Documentation and cleanup

Add documentation and remove the obsolete capability LSM.
Clean up some comments in security.h

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 Documentation/security/LSM.txt |   56 +-
 include/linux/security.h       |   48 +-
 security/Makefile              |    1 -
 security/capability.c          | 1106 ----------------------------------------
 4 files changed, 77 insertions(+), 1134 deletions(-)

diff --git a/Documentation/security/LSM.txt b/Documentation/security/LSM.txt
index c335a76..69cf466 100644
--- a/Documentation/security/LSM.txt
+++ b/Documentation/security/LSM.txt
@@ -7,20 +7,56 @@ various security checks to be hooked by new kernel extensions. The name
 loadable kernel modules. Instead, they are selectable at build-time via
 CONFIG_DEFAULT_SECURITY and can be overridden at boot-time via the
 "security=..." kernel command line argument, in the case where multiple
-LSMs were built into a given kernel.
+LSMs were built into a given kernel. The names of the active LSMs
+can be read from /sys/kernel/security/lsm.
+
+Both CONFIG_DEFAULT_SECURITY and the "security=" option take a comma
+separated list of LSM names. The LSM hooks are invoked in the order
+specified. All hooks provided are invoked regardless of the outcome
+of preceding hooks. Hooks that return success or failure results
+return success if all of the LSM provided hooks succeed and the error
+code of the last failing hook on error.
+
+Information from an LSM can come in one of two forms. The raw data
+used by the LSM is typically the preferred form. SELinux contexts and
+Smack labels are examples of raw LSM data. If the data from multiple
+LSMs is presented together it will be in the form:
+
+	lsmname='value'[lsmname='value']...
+
+Interfaces that accept LSM data as input accept this format as well,
+passing only the relevant portion of the data to each LSM.
+
+The /proc filesystem attribute interface supports files from a time
+when only one LSM could be used at a time. CONFIG_PRESENT_SECURITY
+defines which LSM uses these interfaces. The name of this LSM can be
+read from /sys/kernel/security/present. There are also LSM identified
+interfaces which should be used in preference to the undifferentiated
+interfaces. The attribute interface "context" always provides the
+data from all LSMs that maintain it in the lsmname='value' format.
+
+The three networking mechanisms supporting LSM attributes are
+restricted to providing those attributes for a single LSM each.
+CONFIG_SECMARK_LSM specifies which LSM will provide hooks for the
+secmark mechanism. CONFIG_NETLABEL_LSM specifies which LSM hooks
+are used by NetLabel to provide IPv4 CIPSO headers. CONFIG_XFRM_LSM
+specifies the LSM providing xfrm hooks. CONFIG_PEERSEC_LSM allows
+for either a specific LSM to provide data with SO_PEERSEC or for
+all LSMs that provide data to do so.
+
+The Linux capabilities system is used in conjunction with any LSMs.
+LSM hooks are called after the capability checks in most cases,
+but after in a small number of cases. All LSM hooks need to be aware
+of the potential interactions with the capability system. For more
+details on capabilities, see capabilities(7) in the Linux man-pages
+project.
 
 The primary users of the LSM interface are Mandatory Access Control
 (MAC) extensions which provide a comprehensive security policy. Examples
 include SELinux, Smack, Tomoyo, and AppArmor. In addition to the larger
-MAC extensions, other extensions can be built using the LSM to provide
-specific changes to system operation when these tweaks are not available
-in the core functionality of Linux itself.
-
-Without a specific LSM built into the kernel, the default LSM will be the
-Linux capabilities system. Most LSMs choose to extend the capabilities
-system, building their checks on top of the defined capability hooks.
-For more details on capabilities, see capabilities(7) in the Linux
-man-pages project.
+MAC extensions, other extensions such as Yama can be built using the LSM
+to provide specific changes to system operation when these tweaks are not
+available in the core functionality of Linux itself.
 
 Based on http://kerneltrap.org/Linux/Documenting_Security_Module_Intent,
 a new LSM is accepted into the kernel when its intent (a description of
diff --git a/include/linux/security.h b/include/linux/security.h
index 3ec3489..d60e21c 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -160,7 +160,8 @@ struct request_sock;
 
 #ifdef CONFIG_MMU
 extern int mmap_min_addr_handler(struct ctl_table *table, int write,
-				 void __user *buffer, size_t *lenp, loff_t *ppos);
+				 void __user *buffer, size_t *lenp,
+				 loff_t *ppos);
 #endif
 
 /* security_inode_init_security callback function to write xattrs */
@@ -398,6 +399,7 @@ enum lsm_hooks_index {
 	LSM_MAX_HOOKS
 };
 
+extern struct security_operations *peersec_ops;
 /*
  * There is a list for each hook.
  */
@@ -520,7 +522,8 @@ extern struct list_head lsm_hooks[LSM_MAX_HOOKS];
  *	Return 0 if permission is granted.
  * @sb_pivotroot:
  *	Check permission before pivoting the root filesystem.
- *	@old_path contains the path for the new location of the current root (put_old).
+ *	@old_path contains the path for the new location of the
+ *	current root (put_old).
  *	@new_path contains the path for the new root (new_root).
  *	Return 0 if permission is granted.
  * @sb_set_mnt_opts:
@@ -576,8 +579,10 @@ extern struct list_head lsm_hooks[LSM_MAX_HOOKS];
  *	Return 0 if permission is granted.
  * @inode_link:
  *	Check permission before creating a new hard link to a file.
- *	@old_dentry contains the dentry structure for an existing link to the file.
- *	@dir contains the inode structure of the parent directory of the new link.
+ *	@old_dentry contains the dentry structure for an existing link
+ *	to the file.
+ *	@dir contains the inode structure of the parent directory of
+ *	the new link.
  *	@new_dentry contains the dentry structure for the new link.
  *	Return 0 if permission is granted.
  * @path_link:
@@ -600,7 +605,8 @@ extern struct list_head lsm_hooks[LSM_MAX_HOOKS];
  *	Return 0 if permission is granted.
  * @inode_symlink:
  *	Check the permission to create a symbolic link to a file.
- *	@dir contains the inode structure of parent directory of the symbolic link.
+ *	@dir contains the inode structure of parent directory of the
+ *	symbolic link.
  *	@dentry contains the dentry structure of the symbolic link.
  *	@old_name contains the pathname of file.
  *	Return 0 if permission is granted.
@@ -614,7 +620,8 @@ extern struct list_head lsm_hooks[LSM_MAX_HOOKS];
  * @inode_mkdir:
  *	Check permissions to create a new directory in the existing directory
  *	associated with inode structure @dir.
- *	@dir contains the inode structure of parent of the directory to be created.
+ *	@dir contains the inode structure of parent of the directory
+ *	to be created.
  *	@dentry contains the dentry structure of new directory.
  *	@mode contains the mode of new directory.
  *	Return 0 if permission is granted.
@@ -628,7 +635,8 @@ extern struct list_head lsm_hooks[LSM_MAX_HOOKS];
  *	Return 0 if permission is granted.
  * @inode_rmdir:
  *	Check the permission to remove a directory.
- *	@dir contains the inode structure of parent of the directory to be removed.
+ *	@dir contains the inode structure of parent of the directory to be
+ *	removed.
  *	@dentry contains the dentry structure of directory to be removed.
  *	Return 0 if permission is granted.
  * @path_rmdir:
@@ -1159,7 +1167,8 @@ extern struct list_head lsm_hooks[LSM_MAX_HOOKS];
  *	Checks permission before all or part of a connection on the socket
  *	@sock is shut down.
  *	@sock contains the socket structure.
- *	@how contains the flag indicating how future sends and receives are handled.
+ *	@how contains the flag indicating how future sends and receives
+ *	are handled.
  *	Return 0 if permission is granted.
  * @socket_sock_rcv_skb:
  *	Check permissions on incoming network packets.  This hook is distinct
@@ -1200,18 +1209,21 @@ extern struct list_head lsm_hooks[LSM_MAX_HOOKS];
  * @sk_clone_security:
  *	Clone/copy security structure.
  * @sk_getsecid:
- *	Retrieve the LSM-specific secid for the sock to enable caching of network
+ *	Retrieve the LSM-specific secid for the sock to enable caching
+ *	of network
  *	authorizations.
  * @sock_graft:
  *	Sets the socket's isec sid to the sock's sid.
  * @inet_conn_request:
- *	Sets the openreq's sid to socket's sid with MLS portion taken from peer sid.
+ *	Sets the openreq's sid to socket's sid with MLS portion taken
+ *	from peer sid.
  * @inet_csk_clone:
  *	Sets the new child socket's sid to the openreq sid.
  * @inet_conn_established:
  *	Sets the connection's peersid to the secmark on skb.
  * @secmark_relabel_packet:
- *	check if the process should be allowed to relabel packets to the given secid
+ *	check if the process should be allowed to relabel packets to the
+ *	given secid
  * @security_secmark_refcount_inc
  *	tells the LSM to increment the number of secmark labeling rules loaded
  * @security_secmark_refcount_dec
@@ -1273,12 +1285,14 @@ extern struct list_head lsm_hooks[LSM_MAX_HOOKS];
  *	Database by the XFRM system.
  *	@sec_ctx contains the security context information being provided by
  *	the user-level SA generation program (e.g., setkey or racoon).
- *	@secid contains the secid from which to take the mls portion of the context.
+ *	@secid contains the secid from which to take the mls portion of
+ *	the context.
  *	Allocate a security structure to the x->security field; the security
  *	field is initialized to NULL when the xfrm_state is allocated. Set the
  *	context to correspond to either sec_ctx or polsec, with the mls portion
  *	taken from secid in the latter case.
- *	Return 0 if operation was successful (memory to allocate, legal context).
+ *	Return 0 if operation was successful (memory to allocate,
+ *	legal context).
  * @xfrm_state_free_security:
  *	@x contains the xfrm_state.
  *	Deallocate x->security.
@@ -1566,7 +1580,8 @@ extern struct list_head lsm_hooks[LSM_MAX_HOOKS];
  *
  * @audit_rule_init:
  *	Allocate and initialize an LSM audit rule structure.
- *	@field contains the required Audit action. Fields flags are defined in include/linux/audit.h
+ *	@field contains the required Audit action. Fields flags are
+ *	defined in include/linux/audit.h
  *	@op contains the operator the rule uses.
  *	@rulestr contains the context where the rule will be applied to.
  *	@lsmrule contains a pointer to receive the result.
@@ -1574,7 +1589,8 @@ extern struct list_head lsm_hooks[LSM_MAX_HOOKS];
  *	-EINVAL in case of an invalid rule.
  *
  * @audit_rule_known:
- *	Specifies whether given @rule contains any fields related to current LSM.
+ *	Specifies whether given @rule contains any fields related to
+ *	current LSM.
  *	@rule contains the audit rule of interest.
  *	Return 1 in case of relation found, 0 otherwise.
  *
@@ -1937,12 +1953,10 @@ struct security_operations {
 /* prototypes */
 extern int security_init(void);
 extern int security_module_enable(struct security_operations *ops);
-extern void __init security_fixup_ops(struct security_operations *ops);
 
 #ifdef CONFIG_SECURITY_SELINUX_DISABLE
 extern void security_module_disable(struct security_operations *ops);
 #endif /* CONFIG_SECURITY_SELINUX_DISABLE */
-extern struct security_operations *peersec_ops;
 
 /* Security operations */
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
diff --git a/security/Makefile b/security/Makefile
index 0370e41..cf62a69 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -9,7 +9,6 @@ subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
 subdir-$(CONFIG_SECURITY_APPARMOR)	+= apparmor
 subdir-$(CONFIG_SECURITY_YAMA)		+= yama
 
-# always enable default capabilities
 obj-y					+= commoncap.o
 obj-$(CONFIG_MMU)			+= min_addr.o
 
diff --git a/security/capability.c b/security/capability.c
deleted file mode 100644
index 1728d4e..0000000
--- a/security/capability.c
+++ /dev/null
@@ -1,1106 +0,0 @@
-/*
- *  Capabilities Linux Security Module
- *
- *  This is the default security module in case no other module is loaded.
- *
- *	This program is free software; you can redistribute it and/or modify
- *	it under the terms of the GNU General Public License as published by
- *	the Free Software Foundation; either version 2 of the License, or
- *	(at your option) any later version.
- *
- */
-
-#include <linux/security.h>
-
-static int cap_syslog(int type)
-{
-	return 0;
-}
-
-static int cap_quotactl(int cmds, int type, int id, struct super_block *sb)
-{
-	return 0;
-}
-
-static int cap_quota_on(struct dentry *dentry)
-{
-	return 0;
-}
-
-static int cap_bprm_check_security(struct linux_binprm *bprm)
-{
-	return 0;
-}
-
-static void cap_bprm_committing_creds(struct linux_binprm *bprm)
-{
-}
-
-static void cap_bprm_committed_creds(struct linux_binprm *bprm)
-{
-}
-
-static int cap_sb_alloc_security(struct super_block *sb)
-{
-	return 0;
-}
-
-static void cap_sb_free_security(struct super_block *sb)
-{
-}
-
-static int cap_sb_copy_data(char *orig, char *copy)
-{
-	return 0;
-}
-
-static int cap_sb_remount(struct super_block *sb, void *data)
-{
-	return 0;
-}
-
-static int cap_sb_kern_mount(struct super_block *sb, int flags, void *data)
-{
-	return 0;
-}
-
-static int cap_sb_show_options(struct seq_file *m, struct super_block *sb)
-{
-	return 0;
-}
-
-static int cap_sb_statfs(struct dentry *dentry)
-{
-	return 0;
-}
-
-static int cap_sb_mount(const char *dev_name, struct path *path,
-			const char *type, unsigned long flags, void *data)
-{
-	return 0;
-}
-
-static int cap_sb_umount(struct vfsmount *mnt, int flags)
-{
-	return 0;
-}
-
-static int cap_sb_pivotroot(struct path *old_path, struct path *new_path)
-{
-	return 0;
-}
-
-static int cap_sb_set_mnt_opts(struct super_block *sb,
-			       struct security_mnt_opts *opts)
-{
-	if (unlikely(opts->num_mnt_opts))
-		return -EOPNOTSUPP;
-	return 0;
-}
-
-static int cap_sb_clone_mnt_opts(const struct super_block *oldsb,
-				  struct super_block *newsb)
-{
-	return 0;
-}
-
-static int cap_sb_parse_opts_str(char *options, struct security_mnt_opts *opts)
-{
-	return 0;
-}
-
-static int cap_inode_alloc_security(struct inode *inode)
-{
-	return 0;
-}
-
-static void cap_inode_free_security(struct inode *inode)
-{
-}
-
-static int cap_inode_init_security(struct inode *inode, struct inode *dir,
-				   const struct qstr *qstr, char **name,
-				   void **value, size_t *len)
-{
-	return -EOPNOTSUPP;
-}
-
-static int cap_inode_create(struct inode *inode, struct dentry *dentry,
-			    umode_t mask)
-{
-	return 0;
-}
-
-static int cap_inode_link(struct dentry *old_dentry, struct inode *inode,
-			  struct dentry *new_dentry)
-{
-	return 0;
-}
-
-static int cap_inode_unlink(struct inode *inode, struct dentry *dentry)
-{
-	return 0;
-}
-
-static int cap_inode_symlink(struct inode *inode, struct dentry *dentry,
-			     const char *name)
-{
-	return 0;
-}
-
-static int cap_inode_mkdir(struct inode *inode, struct dentry *dentry,
-			   umode_t mask)
-{
-	return 0;
-}
-
-static int cap_inode_rmdir(struct inode *inode, struct dentry *dentry)
-{
-	return 0;
-}
-
-static int cap_inode_mknod(struct inode *inode, struct dentry *dentry,
-			   umode_t mode, dev_t dev)
-{
-	return 0;
-}
-
-static int cap_inode_rename(struct inode *old_inode, struct dentry *old_dentry,
-			    struct inode *new_inode, struct dentry *new_dentry)
-{
-	return 0;
-}
-
-static int cap_inode_readlink(struct dentry *dentry)
-{
-	return 0;
-}
-
-static int cap_inode_follow_link(struct dentry *dentry,
-				 struct nameidata *nameidata)
-{
-	return 0;
-}
-
-static int cap_inode_permission(struct inode *inode, int mask)
-{
-	return 0;
-}
-
-static int cap_inode_setattr(struct dentry *dentry, struct iattr *iattr)
-{
-	return 0;
-}
-
-static int cap_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
-{
-	return 0;
-}
-
-static void cap_inode_post_setxattr(struct dentry *dentry, const char *name,
-				    const void *value, size_t size, int flags)
-{
-}
-
-static int cap_inode_getxattr(struct dentry *dentry, const char *name)
-{
-	return 0;
-}
-
-static int cap_inode_listxattr(struct dentry *dentry)
-{
-	return 0;
-}
-
-static int cap_inode_getsecurity(const struct inode *inode, const char *name,
-				 void **buffer, bool alloc)
-{
-	return -EOPNOTSUPP;
-}
-
-static int cap_inode_setsecurity(struct inode *inode, const char *name,
-				 const void *value, size_t size, int flags)
-{
-	return -EOPNOTSUPP;
-}
-
-static int cap_inode_listsecurity(struct inode *inode, char *buffer,
-				  size_t buffer_size)
-{
-	return 0;
-}
-
-static void cap_inode_getsecid(const struct inode *inode, u32 *secid)
-{
-	*secid = 0;
-}
-
-#ifdef CONFIG_SECURITY_PATH
-static int cap_path_mknod(struct path *dir, struct dentry *dentry, umode_t mode,
-			  unsigned int dev)
-{
-	return 0;
-}
-
-static int cap_path_mkdir(struct path *dir, struct dentry *dentry, umode_t mode)
-{
-	return 0;
-}
-
-static int cap_path_rmdir(struct path *dir, struct dentry *dentry)
-{
-	return 0;
-}
-
-static int cap_path_unlink(struct path *dir, struct dentry *dentry)
-{
-	return 0;
-}
-
-static int cap_path_symlink(struct path *dir, struct dentry *dentry,
-			    const char *old_name)
-{
-	return 0;
-}
-
-static int cap_path_link(struct dentry *old_dentry, struct path *new_dir,
-			 struct dentry *new_dentry)
-{
-	return 0;
-}
-
-static int cap_path_rename(struct path *old_path, struct dentry *old_dentry,
-			   struct path *new_path, struct dentry *new_dentry)
-{
-	return 0;
-}
-
-static int cap_path_truncate(struct path *path)
-{
-	return 0;
-}
-
-static int cap_path_chmod(struct path *path, umode_t mode)
-{
-	return 0;
-}
-
-static int cap_path_chown(struct path *path, kuid_t uid, kgid_t gid)
-{
-	return 0;
-}
-
-static int cap_path_chroot(struct path *root)
-{
-	return 0;
-}
-#endif
-
-static int cap_file_permission(struct file *file, int mask)
-{
-	return 0;
-}
-
-static int cap_file_alloc_security(struct file *file)
-{
-	return 0;
-}
-
-static void cap_file_free_security(struct file *file)
-{
-}
-
-static int cap_file_ioctl(struct file *file, unsigned int command,
-			  unsigned long arg)
-{
-	return 0;
-}
-
-static int cap_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
-			     unsigned long prot)
-{
-	return 0;
-}
-
-static int cap_file_lock(struct file *file, unsigned int cmd)
-{
-	return 0;
-}
-
-static int cap_file_fcntl(struct file *file, unsigned int cmd,
-			  unsigned long arg)
-{
-	return 0;
-}
-
-static int cap_file_set_fowner(struct file *file)
-{
-	return 0;
-}
-
-static int cap_file_send_sigiotask(struct task_struct *tsk,
-				   struct fown_struct *fown, int sig)
-{
-	return 0;
-}
-
-static int cap_file_receive(struct file *file)
-{
-	return 0;
-}
-
-static int cap_file_open(struct file *file, const struct cred *cred)
-{
-	return 0;
-}
-
-static int cap_task_create(unsigned long clone_flags)
-{
-	return 0;
-}
-
-static void cap_task_free(struct task_struct *task)
-{
-}
-
-static int cap_cred_alloc_blank(struct cred *cred, gfp_t gfp)
-{
-	return 0;
-}
-
-static void cap_cred_free(struct cred *cred)
-{
-}
-
-static int cap_cred_prepare(struct cred *new, const struct cred *old, gfp_t gfp)
-{
-	return 0;
-}
-
-static void cap_cred_transfer(struct cred *new, const struct cred *old)
-{
-}
-
-static int cap_kernel_act_as(struct cred *new, u32 secid)
-{
-	return 0;
-}
-
-static int cap_kernel_create_files_as(struct cred *new, struct inode *inode)
-{
-	return 0;
-}
-
-static int cap_kernel_module_request(char *kmod_name)
-{
-	return 0;
-}
-
-static int cap_kernel_module_from_file(struct file *file)
-{
-	return 0;
-}
-
-static int cap_task_setpgid(struct task_struct *p, pid_t pgid)
-{
-	return 0;
-}
-
-static int cap_task_getpgid(struct task_struct *p)
-{
-	return 0;
-}
-
-static int cap_task_getsid(struct task_struct *p)
-{
-	return 0;
-}
-
-static void cap_task_getsecid(struct task_struct *p, u32 *secid)
-{
-	*secid = 0;
-}
-
-static int cap_task_getioprio(struct task_struct *p)
-{
-	return 0;
-}
-
-static int cap_task_setrlimit(struct task_struct *p, unsigned int resource,
-		struct rlimit *new_rlim)
-{
-	return 0;
-}
-
-static int cap_task_getscheduler(struct task_struct *p)
-{
-	return 0;
-}
-
-static int cap_task_movememory(struct task_struct *p)
-{
-	return 0;
-}
-
-static int cap_task_wait(struct task_struct *p)
-{
-	return 0;
-}
-
-static int cap_task_kill(struct task_struct *p, struct siginfo *info,
-			 int sig, u32 secid)
-{
-	return 0;
-}
-
-static void cap_task_to_inode(struct task_struct *p, struct inode *inode)
-{
-}
-
-static int cap_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
-{
-	return 0;
-}
-
-static void cap_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
-{
-	*secid = 0;
-}
-
-static int cap_msg_msg_alloc_security(struct msg_msg *msg)
-{
-	return 0;
-}
-
-static void cap_msg_msg_free_security(struct msg_msg *msg)
-{
-}
-
-static int cap_msg_queue_alloc_security(struct msg_queue *msq)
-{
-	return 0;
-}
-
-static void cap_msg_queue_free_security(struct msg_queue *msq)
-{
-}
-
-static int cap_msg_queue_associate(struct msg_queue *msq, int msqflg)
-{
-	return 0;
-}
-
-static int cap_msg_queue_msgctl(struct msg_queue *msq, int cmd)
-{
-	return 0;
-}
-
-static int cap_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
-				int msgflg)
-{
-	return 0;
-}
-
-static int cap_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
-				struct task_struct *target, long type, int mode)
-{
-	return 0;
-}
-
-static int cap_shm_alloc_security(struct shmid_kernel *shp)
-{
-	return 0;
-}
-
-static void cap_shm_free_security(struct shmid_kernel *shp)
-{
-}
-
-static int cap_shm_associate(struct shmid_kernel *shp, int shmflg)
-{
-	return 0;
-}
-
-static int cap_shm_shmctl(struct shmid_kernel *shp, int cmd)
-{
-	return 0;
-}
-
-static int cap_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr,
-			 int shmflg)
-{
-	return 0;
-}
-
-static int cap_sem_alloc_security(struct sem_array *sma)
-{
-	return 0;
-}
-
-static void cap_sem_free_security(struct sem_array *sma)
-{
-}
-
-static int cap_sem_associate(struct sem_array *sma, int semflg)
-{
-	return 0;
-}
-
-static int cap_sem_semctl(struct sem_array *sma, int cmd)
-{
-	return 0;
-}
-
-static int cap_sem_semop(struct sem_array *sma, struct sembuf *sops,
-			 unsigned nsops, int alter)
-{
-	return 0;
-}
-
-#ifdef CONFIG_SECURITY_NETWORK
-static int cap_unix_stream_connect(struct sock *sock, struct sock *other,
-				   struct sock *newsk)
-{
-	return 0;
-}
-
-static int cap_unix_may_send(struct socket *sock, struct socket *other)
-{
-	return 0;
-}
-
-static int cap_socket_create(int family, int type, int protocol, int kern)
-{
-	return 0;
-}
-
-static int cap_socket_post_create(struct socket *sock, int family, int type,
-				  int protocol, int kern)
-{
-	return 0;
-}
-
-static int cap_socket_bind(struct socket *sock, struct sockaddr *address,
-			   int addrlen)
-{
-	return 0;
-}
-
-static int cap_socket_connect(struct socket *sock, struct sockaddr *address,
-			      int addrlen)
-{
-	return 0;
-}
-
-static int cap_socket_listen(struct socket *sock, int backlog)
-{
-	return 0;
-}
-
-static int cap_socket_accept(struct socket *sock, struct socket *newsock)
-{
-	return 0;
-}
-
-static int cap_socket_sendmsg(struct socket *sock, struct msghdr *msg, int size)
-{
-	return 0;
-}
-
-static int cap_socket_recvmsg(struct socket *sock, struct msghdr *msg,
-			      int size, int flags)
-{
-	return 0;
-}
-
-static int cap_socket_getsockname(struct socket *sock)
-{
-	return 0;
-}
-
-static int cap_socket_getpeername(struct socket *sock)
-{
-	return 0;
-}
-
-static int cap_socket_setsockopt(struct socket *sock, int level, int optname)
-{
-	return 0;
-}
-
-static int cap_socket_getsockopt(struct socket *sock, int level, int optname)
-{
-	return 0;
-}
-
-static int cap_socket_shutdown(struct socket *sock, int how)
-{
-	return 0;
-}
-
-static int cap_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
-{
-	return 0;
-}
-
-static int cap_socket_getpeersec_stream(struct socket *sock,
-					char __user *optval,
-					int __user *optlen, unsigned len)
-{
-	return -ENOPROTOOPT;
-}
-
-static int cap_socket_getpeersec_dgram(struct socket *sock,
-				       struct sk_buff *skb, u32 *secid)
-{
-	return -ENOPROTOOPT;
-}
-
-static int cap_sk_alloc_security(struct sock *sk, int family, gfp_t priority)
-{
-	return 0;
-}
-
-static void cap_sk_free_security(struct sock *sk)
-{
-}
-
-static void cap_sk_clone_security(const struct sock *sk, struct sock *newsk)
-{
-}
-
-static void cap_sk_getsecid(struct sock *sk, u32 *secid)
-{
-}
-
-static void cap_sock_graft(struct sock *sk, struct socket *parent)
-{
-}
-
-static int cap_inet_conn_request(struct sock *sk, struct sk_buff *skb,
-				 struct request_sock *req)
-{
-	return 0;
-}
-
-static void cap_inet_csk_clone(struct sock *newsk,
-			       const struct request_sock *req)
-{
-}
-
-static void cap_inet_conn_established(struct sock *sk, struct sk_buff *skb)
-{
-}
-
-static int cap_secmark_relabel_packet(u32 secid)
-{
-	return 0;
-}
-
-static void cap_secmark_refcount_inc(void)
-{
-}
-
-static void cap_secmark_refcount_dec(void)
-{
-}
-
-static void cap_req_classify_flow(const struct request_sock *req,
-				  struct flowi *fl)
-{
-}
-
-static int cap_tun_dev_alloc_security(void **security)
-{
-	return 0;
-}
-
-static void cap_tun_dev_free_security(void *security)
-{
-}
-
-static int cap_tun_dev_create(void)
-{
-	return 0;
-}
-
-static int cap_tun_dev_attach_queue(void *security)
-{
-	return 0;
-}
-
-static int cap_tun_dev_attach(struct sock *sk, void *security)
-{
-	return 0;
-}
-
-static int cap_tun_dev_open(void *security)
-{
-	return 0;
-}
-
-static void cap_skb_owned_by(struct sk_buff *skb, struct sock *sk)
-{
-}
-
-#endif	/* CONFIG_SECURITY_NETWORK */
-
-#ifdef CONFIG_SECURITY_NETWORK_XFRM
-static int cap_xfrm_policy_alloc_security(struct xfrm_sec_ctx **ctxp,
-					  struct xfrm_user_sec_ctx *sec_ctx)
-{
-	return 0;
-}
-
-static int cap_xfrm_policy_clone_security(struct xfrm_sec_ctx *old_ctx,
-					  struct xfrm_sec_ctx **new_ctxp)
-{
-	return 0;
-}
-
-static void cap_xfrm_policy_free_security(struct xfrm_sec_ctx *ctx)
-{
-}
-
-static int cap_xfrm_policy_delete_security(struct xfrm_sec_ctx *ctx)
-{
-	return 0;
-}
-
-static int cap_xfrm_state_alloc_security(struct xfrm_state *x,
-					 struct xfrm_user_sec_ctx *sec_ctx,
-					 u32 secid)
-{
-	return 0;
-}
-
-static void cap_xfrm_state_free_security(struct xfrm_state *x)
-{
-}
-
-static int cap_xfrm_state_delete_security(struct xfrm_state *x)
-{
-	return 0;
-}
-
-static int cap_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 sk_sid, u8 dir)
-{
-	return 0;
-}
-
-static int cap_xfrm_state_pol_flow_match(struct xfrm_state *x,
-					 struct xfrm_policy *xp,
-					 const struct flowi *fl)
-{
-	return 1;
-}
-
-static int cap_xfrm_decode_session(struct sk_buff *skb, u32 *fl, int ckall)
-{
-	return 0;
-}
-
-#endif /* CONFIG_SECURITY_NETWORK_XFRM */
-static void cap_d_instantiate(struct dentry *dentry, struct inode *inode)
-{
-}
-
-static int cap_getprocattr(struct task_struct *p, char *name, char **value)
-{
-	return -EINVAL;
-}
-
-static int cap_setprocattr(struct task_struct *p, char *name, void *value,
-			   size_t size)
-{
-	return -EINVAL;
-}
-
-static int cap_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
-{
-	return -EOPNOTSUPP;
-}
-
-static int cap_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
-{
-	*secid = 0;
-	return 0;
-}
-
-static void cap_release_secctx(char *secdata, u32 seclen)
-{
-}
-
-static int cap_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen)
-{
-	return 0;
-}
-
-static int cap_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
-{
-	return 0;
-}
-
-static int cap_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
-{
-	return 0;
-}
-#ifdef CONFIG_KEYS
-static int cap_key_alloc(struct key *key, const struct cred *cred,
-			 unsigned long flags)
-{
-	return 0;
-}
-
-static void cap_key_free(struct key *key)
-{
-}
-
-static int cap_key_permission(key_ref_t key_ref, const struct cred *cred,
-			      key_perm_t perm)
-{
-	return 0;
-}
-
-static int cap_key_getsecurity(struct key *key, char **_buffer)
-{
-	*_buffer = NULL;
-	return 0;
-}
-
-#endif /* CONFIG_KEYS */
-
-#ifdef CONFIG_AUDIT
-static int cap_audit_rule_init(u32 field, u32 op, char *rulestr, void **lsmrule)
-{
-	return 0;
-}
-
-static int cap_audit_rule_known(struct audit_krule *krule)
-{
-	return 0;
-}
-
-static int cap_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
-				struct audit_context *actx)
-{
-	return 0;
-}
-
-static void cap_audit_rule_free(void *lsmrule)
-{
-}
-#endif /* CONFIG_AUDIT */
-
-#define set_to_cap_if_null(ops, function)				\
-	do {								\
-		if (!ops->function) {					\
-			ops->function = cap_##function;			\
-			pr_debug("Had to override the " #function	\
-				 " security operation with the default.\n");\
-			}						\
-	} while (0)
-
-void __init security_fixup_ops(struct security_operations *ops)
-{
-	set_to_cap_if_null(ops, ptrace_access_check);
-	set_to_cap_if_null(ops, ptrace_traceme);
-	set_to_cap_if_null(ops, capget);
-	set_to_cap_if_null(ops, capset);
-	set_to_cap_if_null(ops, capable);
-	set_to_cap_if_null(ops, quotactl);
-	set_to_cap_if_null(ops, quota_on);
-	set_to_cap_if_null(ops, syslog);
-	set_to_cap_if_null(ops, settime);
-	set_to_cap_if_null(ops, vm_enough_memory);
-	set_to_cap_if_null(ops, bprm_set_creds);
-	set_to_cap_if_null(ops, bprm_committing_creds);
-	set_to_cap_if_null(ops, bprm_committed_creds);
-	set_to_cap_if_null(ops, bprm_check_security);
-	set_to_cap_if_null(ops, bprm_secureexec);
-	set_to_cap_if_null(ops, sb_alloc_security);
-	set_to_cap_if_null(ops, sb_free_security);
-	set_to_cap_if_null(ops, sb_copy_data);
-	set_to_cap_if_null(ops, sb_remount);
-	set_to_cap_if_null(ops, sb_kern_mount);
-	set_to_cap_if_null(ops, sb_show_options);
-	set_to_cap_if_null(ops, sb_statfs);
-	set_to_cap_if_null(ops, sb_mount);
-	set_to_cap_if_null(ops, sb_umount);
-	set_to_cap_if_null(ops, sb_pivotroot);
-	set_to_cap_if_null(ops, sb_set_mnt_opts);
-	set_to_cap_if_null(ops, sb_clone_mnt_opts);
-	set_to_cap_if_null(ops, sb_parse_opts_str);
-	set_to_cap_if_null(ops, inode_alloc_security);
-	set_to_cap_if_null(ops, inode_free_security);
-	set_to_cap_if_null(ops, inode_init_security);
-	set_to_cap_if_null(ops, inode_create);
-	set_to_cap_if_null(ops, inode_link);
-	set_to_cap_if_null(ops, inode_unlink);
-	set_to_cap_if_null(ops, inode_symlink);
-	set_to_cap_if_null(ops, inode_mkdir);
-	set_to_cap_if_null(ops, inode_rmdir);
-	set_to_cap_if_null(ops, inode_mknod);
-	set_to_cap_if_null(ops, inode_rename);
-	set_to_cap_if_null(ops, inode_readlink);
-	set_to_cap_if_null(ops, inode_follow_link);
-	set_to_cap_if_null(ops, inode_permission);
-	set_to_cap_if_null(ops, inode_setattr);
-	set_to_cap_if_null(ops, inode_getattr);
-	set_to_cap_if_null(ops, inode_setxattr);
-	set_to_cap_if_null(ops, inode_post_setxattr);
-	set_to_cap_if_null(ops, inode_getxattr);
-	set_to_cap_if_null(ops, inode_listxattr);
-	set_to_cap_if_null(ops, inode_removexattr);
-	set_to_cap_if_null(ops, inode_need_killpriv);
-	set_to_cap_if_null(ops, inode_killpriv);
-	set_to_cap_if_null(ops, inode_getsecurity);
-	set_to_cap_if_null(ops, inode_setsecurity);
-	set_to_cap_if_null(ops, inode_listsecurity);
-	set_to_cap_if_null(ops, inode_getsecid);
-#ifdef CONFIG_SECURITY_PATH
-	set_to_cap_if_null(ops, path_mknod);
-	set_to_cap_if_null(ops, path_mkdir);
-	set_to_cap_if_null(ops, path_rmdir);
-	set_to_cap_if_null(ops, path_unlink);
-	set_to_cap_if_null(ops, path_symlink);
-	set_to_cap_if_null(ops, path_link);
-	set_to_cap_if_null(ops, path_rename);
-	set_to_cap_if_null(ops, path_truncate);
-	set_to_cap_if_null(ops, path_chmod);
-	set_to_cap_if_null(ops, path_chown);
-	set_to_cap_if_null(ops, path_chroot);
-#endif
-	set_to_cap_if_null(ops, file_permission);
-	set_to_cap_if_null(ops, file_alloc_security);
-	set_to_cap_if_null(ops, file_free_security);
-	set_to_cap_if_null(ops, file_ioctl);
-	set_to_cap_if_null(ops, mmap_addr);
-	set_to_cap_if_null(ops, mmap_file);
-	set_to_cap_if_null(ops, file_mprotect);
-	set_to_cap_if_null(ops, file_lock);
-	set_to_cap_if_null(ops, file_fcntl);
-	set_to_cap_if_null(ops, file_set_fowner);
-	set_to_cap_if_null(ops, file_send_sigiotask);
-	set_to_cap_if_null(ops, file_receive);
-	set_to_cap_if_null(ops, file_open);
-	set_to_cap_if_null(ops, task_create);
-	set_to_cap_if_null(ops, task_free);
-	set_to_cap_if_null(ops, cred_alloc_blank);
-	set_to_cap_if_null(ops, cred_free);
-	set_to_cap_if_null(ops, cred_prepare);
-	set_to_cap_if_null(ops, cred_transfer);
-	set_to_cap_if_null(ops, kernel_act_as);
-	set_to_cap_if_null(ops, kernel_create_files_as);
-	set_to_cap_if_null(ops, kernel_module_request);
-	set_to_cap_if_null(ops, kernel_module_from_file);
-	set_to_cap_if_null(ops, task_fix_setuid);
-	set_to_cap_if_null(ops, task_setpgid);
-	set_to_cap_if_null(ops, task_getpgid);
-	set_to_cap_if_null(ops, task_getsid);
-	set_to_cap_if_null(ops, task_getsecid);
-	set_to_cap_if_null(ops, task_setnice);
-	set_to_cap_if_null(ops, task_setioprio);
-	set_to_cap_if_null(ops, task_getioprio);
-	set_to_cap_if_null(ops, task_setrlimit);
-	set_to_cap_if_null(ops, task_setscheduler);
-	set_to_cap_if_null(ops, task_getscheduler);
-	set_to_cap_if_null(ops, task_movememory);
-	set_to_cap_if_null(ops, task_wait);
-	set_to_cap_if_null(ops, task_kill);
-	set_to_cap_if_null(ops, task_prctl);
-	set_to_cap_if_null(ops, task_to_inode);
-	set_to_cap_if_null(ops, ipc_permission);
-	set_to_cap_if_null(ops, ipc_getsecid);
-	set_to_cap_if_null(ops, msg_msg_alloc_security);
-	set_to_cap_if_null(ops, msg_msg_free_security);
-	set_to_cap_if_null(ops, msg_queue_alloc_security);
-	set_to_cap_if_null(ops, msg_queue_free_security);
-	set_to_cap_if_null(ops, msg_queue_associate);
-	set_to_cap_if_null(ops, msg_queue_msgctl);
-	set_to_cap_if_null(ops, msg_queue_msgsnd);
-	set_to_cap_if_null(ops, msg_queue_msgrcv);
-	set_to_cap_if_null(ops, shm_alloc_security);
-	set_to_cap_if_null(ops, shm_free_security);
-	set_to_cap_if_null(ops, shm_associate);
-	set_to_cap_if_null(ops, shm_shmctl);
-	set_to_cap_if_null(ops, shm_shmat);
-	set_to_cap_if_null(ops, sem_alloc_security);
-	set_to_cap_if_null(ops, sem_free_security);
-	set_to_cap_if_null(ops, sem_associate);
-	set_to_cap_if_null(ops, sem_semctl);
-	set_to_cap_if_null(ops, sem_semop);
-	set_to_cap_if_null(ops, netlink_send);
-	set_to_cap_if_null(ops, d_instantiate);
-	set_to_cap_if_null(ops, getprocattr);
-	set_to_cap_if_null(ops, setprocattr);
-	set_to_cap_if_null(ops, secid_to_secctx);
-	set_to_cap_if_null(ops, secctx_to_secid);
-	set_to_cap_if_null(ops, release_secctx);
-	set_to_cap_if_null(ops, inode_notifysecctx);
-	set_to_cap_if_null(ops, inode_setsecctx);
-	set_to_cap_if_null(ops, inode_getsecctx);
-#ifdef CONFIG_SECURITY_NETWORK
-	set_to_cap_if_null(ops, unix_stream_connect);
-	set_to_cap_if_null(ops, unix_may_send);
-	set_to_cap_if_null(ops, socket_create);
-	set_to_cap_if_null(ops, socket_post_create);
-	set_to_cap_if_null(ops, socket_bind);
-	set_to_cap_if_null(ops, socket_connect);
-	set_to_cap_if_null(ops, socket_listen);
-	set_to_cap_if_null(ops, socket_accept);
-	set_to_cap_if_null(ops, socket_sendmsg);
-	set_to_cap_if_null(ops, socket_recvmsg);
-	set_to_cap_if_null(ops, socket_getsockname);
-	set_to_cap_if_null(ops, socket_getpeername);
-	set_to_cap_if_null(ops, socket_setsockopt);
-	set_to_cap_if_null(ops, socket_getsockopt);
-	set_to_cap_if_null(ops, socket_shutdown);
-	set_to_cap_if_null(ops, socket_sock_rcv_skb);
-	set_to_cap_if_null(ops, socket_getpeersec_stream);
-	set_to_cap_if_null(ops, socket_getpeersec_dgram);
-	set_to_cap_if_null(ops, sk_alloc_security);
-	set_to_cap_if_null(ops, sk_free_security);
-	set_to_cap_if_null(ops, sk_clone_security);
-	set_to_cap_if_null(ops, sk_getsecid);
-	set_to_cap_if_null(ops, sock_graft);
-	set_to_cap_if_null(ops, inet_conn_request);
-	set_to_cap_if_null(ops, inet_csk_clone);
-	set_to_cap_if_null(ops, inet_conn_established);
-	set_to_cap_if_null(ops, secmark_relabel_packet);
-	set_to_cap_if_null(ops, secmark_refcount_inc);
-	set_to_cap_if_null(ops, secmark_refcount_dec);
-	set_to_cap_if_null(ops, req_classify_flow);
-	set_to_cap_if_null(ops, tun_dev_alloc_security);
-	set_to_cap_if_null(ops, tun_dev_free_security);
-	set_to_cap_if_null(ops, tun_dev_create);
-	set_to_cap_if_null(ops, tun_dev_open);
-	set_to_cap_if_null(ops, tun_dev_attach_queue);
-	set_to_cap_if_null(ops, tun_dev_attach);
-	set_to_cap_if_null(ops, skb_owned_by);
-#endif	/* CONFIG_SECURITY_NETWORK */
-#ifdef CONFIG_SECURITY_NETWORK_XFRM
-	set_to_cap_if_null(ops, xfrm_policy_alloc_security);
-	set_to_cap_if_null(ops, xfrm_policy_clone_security);
-	set_to_cap_if_null(ops, xfrm_policy_free_security);
-	set_to_cap_if_null(ops, xfrm_policy_delete_security);
-	set_to_cap_if_null(ops, xfrm_state_alloc_security);
-	set_to_cap_if_null(ops, xfrm_state_free_security);
-	set_to_cap_if_null(ops, xfrm_state_delete_security);
-	set_to_cap_if_null(ops, xfrm_policy_lookup);
-	set_to_cap_if_null(ops, xfrm_state_pol_flow_match);
-	set_to_cap_if_null(ops, xfrm_decode_session);
-#endif	/* CONFIG_SECURITY_NETWORK_XFRM */
-#ifdef CONFIG_KEYS
-	set_to_cap_if_null(ops, key_alloc);
-	set_to_cap_if_null(ops, key_free);
-	set_to_cap_if_null(ops, key_permission);
-	set_to_cap_if_null(ops, key_getsecurity);
-#endif	/* CONFIG_KEYS */
-#ifdef CONFIG_AUDIT
-	set_to_cap_if_null(ops, audit_rule_init);
-	set_to_cap_if_null(ops, audit_rule_known);
-	set_to_cap_if_null(ops, audit_rule_match);
-	set_to_cap_if_null(ops, audit_rule_free);
-#endif
-}

