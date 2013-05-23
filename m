Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183Ab3EWKXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:23:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:35515 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757918Ab3EWKXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:23:22 -0400
X-IronPort-AV: E=Sophos;i="4.87,727,1363104000"; 
   d="scan'208";a="7344738"
Message-ID: <519DED89.9000409@cn.fujitsu.com>
Date: Thu, 23 May 2013 18:20:57 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Mell <sub.atomic.fusion@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: move proc mount options out of pid_namespace
References: <3342521.NtikuogILA@pegasus>
In-Reply-To: <3342521.NtikuogILA@pegasus>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/23 18:21:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/23 18:21:56,
	Serialize complete at 2013/05/23 18:21:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,
	Refer to following inline comments.
Thanks,
Gu 

On 05/23/2013 04:05 PM, Stephen Mell wrote:

> From: Stephen Mell <sub.atomic.fusion@gmail.com>
> 
> hide_pid and pid_gid are proc mount options whose values are stored in the pid_namespace struct. As a result, if one mounts proc again for the same PID namespace with different mount options, all mounts for that PID namespace will be affected. This seems undesirable. This patch creates a proc_sb_info struct that points to the applicable PID namespace, and it moves hide_pid, pid_gid, and proc_self from pid_namespace to proc_sb_info.
> 
> Signed-off-by: Stephen Mell <sub.atomic.fusion@gmail.com>

Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

> ---
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index dd51e50..853eb68 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -584,13 +584,13 @@ int proc_setattr(struct dentry *dentry, struct iattr *attr)
>   * May current process learn task's sched/cmdline info (for hide_pid_min=1)
>   * or euid/egid (for hide_pid_min=2)?
>   */
> -static bool has_pid_permissions(struct pid_namespace *pid,
> +static bool has_pid_permissions(struct proc_sb_info *fsi,
>  				 struct task_struct *task,
>  				 int hide_pid_min)
>  {
> -	if (pid->hide_pid < hide_pid_min)
> +	if (fsi->hide_pid < hide_pid_min)
>  		return true;
> -	if (in_group_p(pid->pid_gid))
> +	if (in_group_p(fsi->pid_gid))
>  		return true;
>  	return ptrace_may_access(task, PTRACE_MODE_READ);
>  }
> @@ -598,18 +598,18 @@ static bool has_pid_permissions(struct pid_namespace *pid,
>  
>  static int proc_pid_permission(struct inode *inode, int mask)
>  {
> -	struct pid_namespace *pid = inode->i_sb->s_fs_info;
> +	struct proc_sb_info *fsi = inode->i_sb->s_fs_info;
>  	struct task_struct *task;
>  	bool has_perms;
>  
>  	task = get_proc_task(inode);
>  	if (!task)
>  		return -ESRCH;
> -	has_perms = has_pid_permissions(pid, task, 1);
> +	has_perms = has_pid_permissions(fsi, task, 1);
>  	put_task_struct(task);
>  
>  	if (!has_perms) {
> -		if (pid->hide_pid == 2) {
> +		if (fsi->hide_pid == 2) {
>  			/*
>  			 * Let's make getdents(), stat(), and open()
>  			 * consistent with each other.  If a process
> @@ -670,12 +670,14 @@ static const struct file_operations proc_info_file_operations = {
>  static int proc_single_show(struct seq_file *m, void *v)
>  {
>  	struct inode *inode = m->private;
> +	struct proc_sb_info *fsi;
>  	struct pid_namespace *ns;
>  	struct pid *pid;
>  	struct task_struct *task;
>  	int ret;
>  
> -	ns = inode->i_sb->s_fs_info;
> +	fsi = inode->i_sb->s_fs_info;
> +	ns = fsi->ns;
>  	pid = proc_pid(inode);
>  	task = get_pid_task(pid, PIDTYPE_PID);
>  	if (!task)
> @@ -1574,7 +1576,7 @@ int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
>  	struct inode *inode = dentry->d_inode;
>  	struct task_struct *task;
>  	const struct cred *cred;
> -	struct pid_namespace *pid = dentry->d_sb->s_fs_info;
> +	struct proc_sb_info *fsi = dentry->d_sb->s_fs_info;
>  
>  	generic_fillattr(inode, stat);
>  
> @@ -1583,7 +1585,7 @@ int pid_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
>  	stat->gid = GLOBAL_ROOT_GID;
>  	task = pid_task(proc_pid(inode), PIDTYPE_PID);
>  	if (task) {
> -		if (!has_pid_permissions(pid, task, 2)) {
> +		if (!has_pid_permissions(fsi, task, 2)) {
>  			rcu_read_unlock();
>  			/*
>  			 * This doesn't prevent learning whether PID exists,
> @@ -2869,13 +2871,15 @@ struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, unsign
>  	struct dentry *result = NULL;
>  	struct task_struct *task;
>  	unsigned tgid;
> +	struct proc_sb_info *fsi;
>  	struct pid_namespace *ns;
>  
>  	tgid = name_to_int(dentry);
>  	if (tgid == ~0U)
>  		goto out;
>  
> -	ns = dentry->d_sb->s_fs_info;
> +	fsi = dentry->d_sb->s_fs_info;
> +	ns = fsi->ns;
>  	rcu_read_lock();
>  	task = find_task_by_pid_ns(tgid, ns);
>  	if (task)
> @@ -2954,6 +2958,7 @@ static int fake_filldir(void *buf, const char *name, int namelen,
>  int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
>  {
>  	struct tgid_iter iter;
> +	struct proc_sb_info *fsi;
>  	struct pid_namespace *ns;
>  	filldir_t __filldir;
>  	loff_t pos = filp->f_pos;
> @@ -2970,11 +2975,12 @@ int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
>  		iter.tgid = pos - TGID_OFFSET;
>  	}
>  	iter.task = NULL;
> -	ns = filp->f_dentry->d_sb->s_fs_info;
> +	fsi = filp->f_dentry->d_sb->s_fs_info;
> +	ns = fsi->ns;
>  	for (iter = next_tgid(ns, iter);
>  	     iter.task;
>  	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
> -		if (has_pid_permissions(ns, iter.task, 2))
> +		if (has_pid_permissions(fsi, iter.task, 2))
>  			__filldir = filldir;
>  		else
>  			__filldir = fake_filldir;
> @@ -3132,6 +3138,7 @@ static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry
>  	struct task_struct *task;
>  	struct task_struct *leader = get_proc_task(dir);
>  	unsigned tid;
> +	struct proc_sb_info *fsi;
>  	struct pid_namespace *ns;
>  
>  	if (!leader)
> @@ -3141,7 +3148,8 @@ static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry
>  	if (tid == ~0U)
>  		goto out;
>  
> -	ns = dentry->d_sb->s_fs_info;
> +	fsi = dentry->d_sb->s_fs_info;
> +	ns = fsi->ns;
>  	rcu_read_lock();
>  	task = find_task_by_pid_ns(tid, ns);
>  	if (task)
> @@ -3249,6 +3257,7 @@ static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldi
>  	int retval = -ENOENT;
>  	ino_t ino;
>  	int tid;
> +	struct proc_sb_info *fsi;
>  	struct pid_namespace *ns;
>  
>  	task = get_proc_task(inode);
> @@ -3283,7 +3292,8 @@ static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldi
>  	/* f_version caches the tgid value that the last readdir call couldn't
>  	 * return. lseek aka telldir automagically resets f_version to 0.
>  	 */
> -	ns = filp->f_dentry->d_sb->s_fs_info;
> +	fsi = filp->f_dentry->d_sb->s_fs_info;
> +	ns = fsi->ns;
>  	tid = (int)filp->f_version;
>  	filp->f_version = 0;
>  	for (task = first_tid(leader, tid, filp->f_pos - 2, ns);
> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 073aea6..148737d 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -110,12 +110,12 @@ void __init proc_init_inodecache(void)
>  static int proc_show_options(struct seq_file *seq, struct dentry *root)
>  {
>  	struct super_block *sb = root->d_sb;
> -	struct pid_namespace *pid = sb->s_fs_info;
> +	struct proc_sb_info *fsi = sb->s_fs_info;
>  
> -	if (!gid_eq(pid->pid_gid, GLOBAL_ROOT_GID))
> -		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, pid->pid_gid));
> -	if (pid->hide_pid != 0)
> -		seq_printf(seq, ",hidepid=%u", pid->hide_pid);
> +	if (!gid_eq(fsi->pid_gid, GLOBAL_ROOT_GID))
> +		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, fsi->pid_gid));
> +	if (fsi->hide_pid != 0)
> +		seq_printf(seq, ",hidepid=%u", fsi->hide_pid);
>  
>  	return 0;
>  }
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index d600fb0..ff970e4 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -29,6 +29,14 @@ struct mempolicy;
>   * /proc file has a parent, but "subdir" is NULL for all
>   * non-directory entries).
>   */
> +
> +struct proc_sb_info {
> +	struct pid_namespace *ns;
> +	struct dentry *proc_self;
> +	kgid_t pid_gid;
> +	int hide_pid;
> +};
> +
>  struct proc_dir_entry {
>  	unsigned int low_ino;
>  	umode_t mode;
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 41a6ea9..526aec6 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -20,6 +20,7 @@
>  #include <linux/mount.h>
>  #include <linux/pid_namespace.h>
>  #include <linux/parser.h>
> +#include <linux/slab.h>
>  
>  #include "internal.h"
>  
> @@ -31,10 +32,9 @@ static int proc_test_super(struct super_block *sb, void *data)
>  static int proc_set_super(struct super_block *sb, void *data)
>  {
>  	int err = set_anon_super(sb, NULL);
> -	if (!err) {
> -		struct pid_namespace *ns = (struct pid_namespace *)data;
> -		sb->s_fs_info = get_pid_ns(ns);
> -	}
> +	if (!err)
> +		sb->s_fs_info = (struct proc_sb_info *)data;
> +
>  	return err;
>  }
>  
> @@ -48,7 +48,7 @@ static const match_table_t tokens = {
>  	{Opt_err, NULL},
>  };
>  
> -static int proc_parse_options(char *options, struct pid_namespace *pid)
> +static int proc_parse_options(char *options, struct proc_sb_info *fsi)
>  {
>  	char *p;
>  	substring_t args[MAX_OPT_ARGS];
> @@ -68,7 +68,7 @@ static int proc_parse_options(char *options, struct pid_namespace *pid)
>  		case Opt_gid:
>  			if (match_int(&args[0], &option))
>  				return 0;
> -			pid->pid_gid = make_kgid(current_user_ns(), option);
> +			fsi->pid_gid = make_kgid(current_user_ns(), option);
>  			break;
>  		case Opt_hidepid:
>  			if (match_int(&args[0], &option))
> @@ -77,7 +77,7 @@ static int proc_parse_options(char *options, struct pid_namespace *pid)
>  				pr_err("proc: hidepid value must be between 0 and 2.\n");
>  				return 0;
>  			}
> -			pid->hide_pid = option;
> +			fsi->hide_pid = option;
>  			break;
>  		default:
>  			pr_err("proc: unrecognized mount option \"%s\" "
> @@ -91,36 +91,44 @@ static int proc_parse_options(char *options, struct pid_namespace *pid)
>  
>  int proc_remount(struct super_block *sb, int *flags, char *data)
>  {
> -	struct pid_namespace *pid = sb->s_fs_info;
> -	return !proc_parse_options(data, pid);
> +	struct proc_sb_info *fsi = sb->s_fs_info;
> +	return !proc_parse_options(data, fsi);
>  }
>  
>  static struct dentry *proc_mount(struct file_system_type *fs_type,
>  	int flags, const char *dev_name, void *data)
>  {
>  	int err;
> +	struct proc_sb_info *fsi;
>  	struct super_block *sb;
> -	struct pid_namespace *ns;
>  	char *options;
> +	
> +	fsi = kzalloc(sizeof(struct proc_sb_info), GFP_KERNEL);
> +	if (!fsi)
> +		return ERR_PTR(-ENOMEM);
> +
> +	sb = sget(fs_type, proc_test_super, proc_set_super, flags, fsi);


Here it'll create a new proc sb instance which holds the same context as the old ones
each time we mount proc though in the same PID namespace, won't it?

> +	if (IS_ERR(sb))
> +		return ERR_CAST(sb);
>  
>  	if (flags & MS_KERNMOUNT) {
> -		ns = (struct pid_namespace *)data;
> +		fsi->ns = (struct pid_namespace *)data;
> +		get_pid_ns(fsi->ns);
>  		options = NULL;
>  	} else {
> -		ns = task_active_pid_ns(current);
> -		options = data;
> -
>  		if (!current_user_ns()->may_mount_proc)
>  			return ERR_PTR(-EPERM);
> -	}
> -
> -	sb = sget(fs_type, proc_test_super, proc_set_super, flags, ns);
> -	if (IS_ERR(sb))
> -		return ERR_CAST(sb);
> +		
> +		options = data;
> +		if (!proc_parse_options(options, fsi)) {
> +			deactivate_locked_super(sb);
> +			return ERR_PTR(-EINVAL);
> +		}
>  
> -	if (!proc_parse_options(options, ns)) {
> -		deactivate_locked_super(sb);
> -		return ERR_PTR(-EINVAL);
> +		if (!fsi->ns) {
> +			fsi->ns = task_active_pid_ns(current);
> +			get_pid_ns(fsi->ns);
> +		}
>  	}
>  
>  	if (!sb->s_root) {
> @@ -138,13 +146,16 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
>  
>  static void proc_kill_sb(struct super_block *sb)
>  {
> +	struct proc_sb_info *fsi;
>  	struct pid_namespace *ns;
>  
> -	ns = (struct pid_namespace *)sb->s_fs_info;
> -	if (ns->proc_self)
> -		dput(ns->proc_self);
> +	fsi = (struct proc_sb_info *)sb->s_fs_info;
> +	ns = (struct pid_namespace *)fsi->ns;
> +	if (fsi->proc_self)


Here the pre-check seems needless.

> +		dput(fsi->proc_self);
>  	kill_anon_super(sb);
>  	put_pid_ns(ns);
> +	kfree(fsi);
>  }
>  
>  static struct file_system_type proc_fs_type = {
> diff --git a/fs/proc/self.c b/fs/proc/self.c
> index 6b6a993..ff4a2e2 100644
> --- a/fs/proc/self.c
> +++ b/fs/proc/self.c
> @@ -10,7 +10,8 @@
>  static int proc_self_readlink(struct dentry *dentry, char __user *buffer,
>  			      int buflen)
>  {
> -	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
> +	struct proc_sb_info *fsi = dentry->d_sb->s_fs_info;
> +	struct pid_namespace *ns = fsi->ns;
>  	pid_t tgid = task_tgid_nr_ns(current, ns);
>  	char tmp[PROC_NUMBUF];
>  	if (!tgid)
> @@ -21,7 +22,8 @@ static int proc_self_readlink(struct dentry *dentry, char __user *buffer,
>  
>  static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
>  {
> -	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
> +	struct proc_sb_info *fsi = dentry->d_sb->s_fs_info;
> +	struct pid_namespace *ns = fsi->ns;
>  	pid_t tgid = task_tgid_nr_ns(current, ns);
>  	char *name = ERR_PTR(-ENOENT);
>  	if (tgid) {
> @@ -55,7 +57,7 @@ static unsigned self_inum;
>  int proc_setup_self(struct super_block *s)
>  {
>  	struct inode *root_inode = s->s_root->d_inode;
> -	struct pid_namespace *ns = s->s_fs_info;
> +	struct proc_sb_info *fsi = s->s_fs_info;
>  	struct dentry *self;
>  	
>  	mutex_lock(&root_inode->i_mutex);
> @@ -82,7 +84,7 @@ int proc_setup_self(struct super_block *s)
>  		pr_err("proc_fill_super: can't allocate /proc/self\n");
>  		return PTR_ERR(self);
>  	}
> -	ns->proc_self = self;
> +	fsi->proc_self = self;
>  	return 0;
>  }
>  
> diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
> index e277266..6185386 100644
> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -31,15 +31,12 @@ struct pid_namespace {
>  	struct pid_namespace *parent;
>  #ifdef CONFIG_PROC_FS
>  	struct vfsmount *proc_mnt;
> -	struct dentry *proc_self;
>  #endif
>  #ifdef CONFIG_BSD_PROCESS_ACCT
>  	struct bsd_acct_struct *bacct;
>  #endif
>  	struct user_namespace *user_ns;
>  	struct work_struct proc_work;
> -	kgid_t pid_gid;
> -	int hide_pid;
>  	int reboot;	/* group exit code if this pidns was rebooted */
>  	unsigned int proc_inum;
>  };
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


