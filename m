Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622Ab3EGNy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:54:59 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:46844 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821Ab3EGNyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:54:54 -0400
Date: Tue, 7 May 2013 15:54:46 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: raven@themaw.net
Cc: autofs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, sukadev@linux.vnet.ibm.com,
        serge.hallyn@canonical.com, ebiederm@xmission.com
Subject: [PATCH 1/2] autofs4: allow autofs to work outside the initial PID
 namespace
Message-ID: <20130507135446.GA6129@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

This patch enables autofs4 to work in a "container".  oz_pgrp is converted from
pid_t to struct pid and this is stored at mount time based on the "pgrp=" option
or if the option is missing then the current pgrp.

The "pgrp=" option is interpreted in the PID namespace of the current process.
This option is flawed in that it doesn't carry the namespace information, so it
should be deprecated.  AFAICS the autofs daemon always sends the current pgrp,
which is the default anyway.

The oz_pgrp is also set from the AUTOFS_DEV_IOCTL_SETPIPEFD_CMD ioctl.  This
ioctl sets oz_pgrp to the current pgrp.  It is not allowed to change the pid
namespace.

oz_pgrp is used mainly to determine whether the process traversing the autofs
mount tree is the autofs daemon itself or not.  This function now compares the
pid pointers instead of the pid_t values.

One other use of oz_pgrp is in autofs4_show_options.  There is shows the
virtual pid number (i.e. the one that is valid inside the PID namespace of the
calling process)

For debugging printk convert oz_pgrp to the value in the initial pid namespace.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/autofs4/autofs_i.h  |    4 ++--
 fs/autofs4/dev-ioctl.c |   16 ++++++++++++++--
 fs/autofs4/inode.c     |   33 +++++++++++++++++++++++++--------
 3 files changed, 41 insertions(+), 12 deletions(-)

--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -104,7 +104,7 @@ struct autofs_sb_info {
 	u32 magic;
 	int pipefd;
 	struct file *pipe;
-	pid_t oz_pgrp;
+	struct pid *oz_pgrp;
 	int catatonic;
 	int version;
 	int sub_version;
@@ -139,7 +139,7 @@ static inline struct autofs_info *autofs
    filesystem without "magic".) */
 
 static inline int autofs4_oz_mode(struct autofs_sb_info *sbi) {
-	return sbi->catatonic || task_pgrp_nr(current) == sbi->oz_pgrp;
+	return sbi->catatonic || task_pgrp(current) == sbi->oz_pgrp;
 }
 
 /* Does a dentry have some pending activity? */
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -62,6 +62,8 @@ void autofs4_kill_sb(struct super_block
 	/* Free wait queues, close pipe */
 	autofs4_catatonic_mode(sbi);
 
+	put_pid(sbi->oz_pgrp);
+
 	sb->s_fs_info = NULL;
 	kfree(sbi);
 
@@ -85,7 +87,7 @@ static int autofs4_show_options(struct s
 	if (!gid_eq(root_inode->i_gid, GLOBAL_ROOT_GID))
 		seq_printf(m, ",gid=%u",
 			from_kgid_munged(&init_user_ns, root_inode->i_gid));
-	seq_printf(m, ",pgrp=%d", sbi->oz_pgrp);
+	seq_printf(m, ",pgrp=%d", pid_vnr(sbi->oz_pgrp));
 	seq_printf(m, ",timeout=%lu", sbi->exp_timeout/HZ);
 	seq_printf(m, ",minproto=%d", sbi->min_proto);
 	seq_printf(m, ",maxproto=%d", sbi->max_proto);
@@ -129,7 +131,8 @@ static const match_table_t tokens = {
 };
 
 static int parse_options(char *options, int *pipefd, kuid_t *uid, kgid_t *gid,
-		pid_t *pgrp, unsigned int *type, int *minproto, int *maxproto)
+			 int *pgrp, bool *pgrp_set, unsigned int *type,
+			 int *minproto, int *maxproto)
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
@@ -137,7 +140,6 @@ static int parse_options(char *options,
 
 	*uid = current_uid();
 	*gid = current_gid();
-	*pgrp = task_pgrp_nr(current);
 
 	*minproto = AUTOFS_MIN_PROTO_VERSION;
 	*maxproto = AUTOFS_MAX_PROTO_VERSION;
@@ -176,6 +178,7 @@ static int parse_options(char *options,
 			if (match_int(args, &option))
 				return 1;
 			*pgrp = option;
+			*pgrp_set = true;
 			break;
 		case Opt_minproto:
 			if (match_int(args, &option))
@@ -211,6 +214,8 @@ int autofs4_fill_super(struct super_bloc
 	int pipefd;
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
+	int pgrp;
+	bool pgrp_set = false;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
@@ -223,7 +228,7 @@ int autofs4_fill_super(struct super_bloc
 	sbi->pipe = NULL;
 	sbi->catatonic = 1;
 	sbi->exp_timeout = 0;
-	sbi->oz_pgrp = task_pgrp_nr(current);
+	sbi->oz_pgrp = NULL;
 	sbi->sb = s;
 	sbi->version = 0;
 	sbi->sub_version = 0;
@@ -260,12 +265,23 @@ int autofs4_fill_super(struct super_bloc
 
 	/* Can this call block? */
 	if (parse_options(data, &pipefd, &root_inode->i_uid, &root_inode->i_gid,
-				&sbi->oz_pgrp, &sbi->type, &sbi->min_proto,
-				&sbi->max_proto)) {
+			  &pgrp, &pgrp_set, &sbi->type, &sbi->min_proto,
+			  &sbi->max_proto)) {
 		printk("autofs: called with bogus options\n");
 		goto fail_dput;
 	}
 
+	if (pgrp_set) {
+		sbi->oz_pgrp = find_get_pid(pgrp);
+		if (!sbi->oz_pgrp) {
+			pr_warn("autofs: could not find process group %d\n",
+				pgrp);
+			goto fail_dput;
+		}
+	} else {
+		sbi->oz_pgrp = get_task_pid(current, PIDTYPE_PGID);
+	}
+
 	if (autofs_type_trigger(sbi->type))
 		__managed_dentry_set_managed(root);
 
@@ -289,9 +305,9 @@ int autofs4_fill_super(struct super_bloc
 		sbi->version = sbi->max_proto;
 	sbi->sub_version = AUTOFS_PROTO_SUBVERSION;
 
-	DPRINTK("pipe fd = %d, pgrp = %u", pipefd, sbi->oz_pgrp);
+	DPRINTK("pipe fd = %d, pgrp = %u", pipefd, pid_nr(sbi->oz_pgrp));
 	pipe = fget(pipefd);
-	
+
 	if (!pipe) {
 		printk("autofs: could not open pipe file descriptor\n");
 		goto fail_dput;
@@ -321,6 +337,7 @@ int autofs4_fill_super(struct super_bloc
 fail_ino:
 	kfree(ino);
 fail_free:
+	put_pid(sbi->oz_pgrp);
 	kfree(sbi);
 	s->s_fs_info = NULL;
 fail_unlock:
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -346,6 +346,7 @@ static int autofs_dev_ioctl_setpipefd(st
 {
 	int pipefd;
 	int err = 0;
+	struct pid *new_pid = NULL;
 
 	if (param->setpipefd.pipefd == -1)
 		return -EINVAL;
@@ -357,7 +358,17 @@ static int autofs_dev_ioctl_setpipefd(st
 		mutex_unlock(&sbi->wq_mutex);
 		return -EBUSY;
 	} else {
-		struct file *pipe = fget(pipefd);
+		struct file *pipe;
+
+		new_pid = get_task_pid(current, PIDTYPE_PGID);
+
+		if (ns_of_pid(new_pid) != ns_of_pid(sbi->oz_pgrp)) {
+			AUTOFS_WARN("Not allowed to change PID namespace");
+			err = -EINVAL;
+			goto out;
+		}
+
+		pipe = fget(pipefd);
 		if (!pipe) {
 			err = -EBADF;
 			goto out;
@@ -367,12 +378,13 @@ static int autofs_dev_ioctl_setpipefd(st
 			fput(pipe);
 			goto out;
 		}
-		sbi->oz_pgrp = task_pgrp_nr(current);
+		swap(sbi->oz_pgrp, new_pid);
 		sbi->pipefd = pipefd;
 		sbi->pipe = pipe;
 		sbi->catatonic = 0;
 	}
 out:
+	put_pid(new_pid);
 	mutex_unlock(&sbi->wq_mutex);
 	return err;
 }
