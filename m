Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138AbaKABKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 21:10:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54638 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651AbaKABKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 21:10:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Aditya Kali <adityakali@google.com>
Cc: tj@kernel.org, lizefan@huawei.com, serge.hallyn@ubuntu.com,
        luto@amacapital.net, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mingo@redhat.com, containers@lists.linux-foundation.org,
        jnagal@google.com
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
	<1414783141-6947-8-git-send-email-adityakali@google.com>
Date: Fri, 31 Oct 2014 18:09:12 -0700
In-Reply-To: <1414783141-6947-8-git-send-email-adityakali@google.com> (Aditya
	Kali's message of "Fri, 31 Oct 2014 12:19:01 -0700")
Message-ID: <87y4rvrakn.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18pLgt87RP7ZUqChiEysArohX1MLn/EU+g=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Aditya Kali <adityakali@google.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 872 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 4.9 (0.6%), b_tie_ro: 3.7 (0.4%), parse: 1.48 (0.2%),
	extract_message_metadata: 6 (0.7%), get_uri_detail_list: 3.8 (0.4%),
	tests_pri_-1000: 4.2 (0.5%), tests_pri_-950: 1.48 (0.2%), tests_pri_-900:
	1.15 (0.1%), tests_pri_-400: 31 (3.5%), check_bayes: 29 (3.4%), b_tokenize:
	11 (1.3%), b_tok_get_all: 11 (1.2%), b_comp_prob: 2.5 (0.3%),
	b_tok_touch_all: 2.9 (0.3%), b_finish: 0.69 (0.1%), tests_pri_0: 805 (92.3%),
	tests_pri_500: 5 (0.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init cgroupns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aditya Kali <adityakali@google.com> writes:

> This patch enables cgroup mounting inside userns when a process
> as appropriate privileges. The cgroup filesystem mounted is
> rooted at the cgroupns-root. Thus, in a container-setup, only
> the hierarchy under the cgroupns-root is exposed inside the container.
> This allows container management tools to run inside the containers
> without depending on any global state.
> In order to support this, a new kernfs api is added to lookup the
> dentry for the cgroupns-root.

There is a misdesign in this.  Because files already exist we need the
protections that are present in proc and sysfs that only allow you to
mount the filesystem if it is already mounted.  Otherwise you can wind
up mounting this cgroupfs in a chroot jail when the global root would
not like you to see it.  cgroupfs isn't as bad as proc and sys but there
is at the very least an information leak in mounting it.

Given that we are effectively performing a bind mount in this patch, and
that we need to require cgroupfs be mounted anyway (to be safe).

I don't see the point of this change.  

If we could change the set of cgroups or visible in cgroupfs I could
probably see the point.  But as it is this change seems to be pointless.

Eric


> Signed-off-by: Aditya Kali <adityakali@google.com>
> ---
>  fs/kernfs/mount.c      | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/kernfs.h |  2 ++
>  kernel/cgroup.c        | 47 +++++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 95 insertions(+), 2 deletions(-)
>
> diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> index f973ae9..e334f45 100644
> --- a/fs/kernfs/mount.c
> +++ b/fs/kernfs/mount.c
> @@ -62,6 +62,54 @@ struct kernfs_root *kernfs_root_from_sb(struct super_block *sb)
>  	return NULL;
>  }
>  
> +/**
> + * kernfs_make_root - create new root dentry for the given kernfs_node.
> + * @sb: the kernfs super_block
> + * @kn: kernfs_node for which a dentry is needed
> + *
> + * This can used used by callers which want to mount only a part of the kernfs
> + * as root of the filesystem.
> + */
> +struct dentry *kernfs_obtain_root(struct super_block *sb,
> +				  struct kernfs_node *kn)
> +{
> +	struct dentry *dentry;
> +	struct inode *inode;
> +
> +	BUG_ON(sb->s_op != &kernfs_sops);
> +
> +	/* inode for the given kernfs_node should already exist. */
> +	inode = ilookup(sb, kn->ino);
> +	if (!inode) {
> +		pr_debug("kernfs: could not get inode for '");
> +		pr_cont_kernfs_path(kn);
> +		pr_cont("'.\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	/* instantiate and link root dentry */
> +	dentry = d_obtain_root(inode);
> +	if (!dentry) {
> +		pr_debug("kernfs: could not get dentry for '");
> +		pr_cont_kernfs_path(kn);
> +		pr_cont("'.\n");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	/* If this is a new dentry, set it up. We need kernfs_mutex because this
> +	 * may be called by callers other than kernfs_fill_super. */
> +	mutex_lock(&kernfs_mutex);
> +	if (!dentry->d_fsdata) {
> +		kernfs_get(kn);
> +		dentry->d_fsdata = kn;
> +	} else {
> +		WARN_ON(dentry->d_fsdata != kn);
> +	}
> +	mutex_unlock(&kernfs_mutex);
> +
> +	return dentry;
> +}
> +
>  static int kernfs_fill_super(struct super_block *sb, unsigned long magic)
>  {
>  	struct kernfs_super_info *info = kernfs_info(sb);
> diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> index 3c2be75..b9538e0 100644
> --- a/include/linux/kernfs.h
> +++ b/include/linux/kernfs.h
> @@ -274,6 +274,8 @@ void kernfs_put(struct kernfs_node *kn);
>  struct kernfs_node *kernfs_node_from_dentry(struct dentry *dentry);
>  struct kernfs_root *kernfs_root_from_sb(struct super_block *sb);
>  
> +struct dentry *kernfs_obtain_root(struct super_block *sb,
> +				  struct kernfs_node *kn);
>  struct kernfs_root *kernfs_create_root(struct kernfs_syscall_ops *scops,
>  				       unsigned int flags, void *priv);
>  void kernfs_destroy_root(struct kernfs_root *root);
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 7e5d597..250aaec 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1302,6 +1302,13 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>  
>  	memset(opts, 0, sizeof(*opts));
>  
> +	/* Implicitly add CGRP_ROOT_SANE_BEHAVIOR if inside a non-init cgroup
> +	 * namespace.
> +	 */
> +	if (current->nsproxy->cgroup_ns != &init_cgroup_ns) {
> +		opts->flags |= CGRP_ROOT_SANE_BEHAVIOR;
> +	}
> +
>  	while ((token = strsep(&o, ",")) != NULL) {
>  		nr_opts++;
>  
> @@ -1391,7 +1398,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>  
>  	if (opts->flags & CGRP_ROOT_SANE_BEHAVIOR) {
>  		pr_warn("sane_behavior: this is still under development and its behaviors will change, proceed at your own risk\n");
> -		if (nr_opts != 1) {
> +		if (nr_opts > 1) {
>  			pr_err("sane_behavior: no other mount options allowed\n");
>  			return -EINVAL;
>  		}
> @@ -1581,6 +1588,15 @@ static void init_cgroup_root(struct cgroup_root *root,
>  		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &root->cgrp.flags);
>  }
>  
> +struct dentry *cgroupns_get_root(struct super_block *sb,
> +				 struct cgroup_namespace *ns)
> +{
> +	struct dentry *nsdentry;
> +
> +	nsdentry = kernfs_obtain_root(sb, ns->root_cgrp->kn);
> +	return nsdentry;
> +}
> +
>  static int cgroup_setup_root(struct cgroup_root *root, unsigned int ss_mask)
>  {
>  	LIST_HEAD(tmp_links);
> @@ -1685,6 +1701,14 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
>  	int ret;
>  	int i;
>  	bool new_sb;
> +	struct cgroup_namespace *ns =
> +		get_cgroup_ns(current->nsproxy->cgroup_ns);
> +
> +	/* Check if the caller has permission to mount. */
> +	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN)) {
> +		put_cgroup_ns(ns);
> +		return ERR_PTR(-EPERM);
> +	}
>  
>  	/*
>  	 * The first time anyone tries to mount a cgroup, enable the list
> @@ -1817,11 +1841,28 @@ out_free:
>  	kfree(opts.release_agent);
>  	kfree(opts.name);
>  
> -	if (ret)
> +	if (ret) {
> +		put_cgroup_ns(ns);
>  		return ERR_PTR(ret);
> +	}
>  
>  	dentry = kernfs_mount(fs_type, flags, root->kf_root,
>  				CGROUP_SUPER_MAGIC, &new_sb);
> +
> +	if (!IS_ERR(dentry) && (root == &cgrp_dfl_root)) {
> +		/* If this mount is for the default hierarchy in non-init cgroup
> +		 * namespace, then instead of root cgroup's dentry, we return
> +		 * the dentry corresponding to the cgroupns->root_cgrp.
> +		 */
> +		if (ns != &init_cgroup_ns) {
> +			struct dentry *nsdentry;
> +
> +			nsdentry = cgroupns_get_root(dentry->d_sb, ns);
> +			dput(dentry);
> +			dentry = nsdentry;
> +		}
> +	}
> +
>  	if (IS_ERR(dentry) || !new_sb)
>  		cgroup_put(&root->cgrp);
>  
> @@ -1834,6 +1875,7 @@ out_free:
>  		deactivate_super(pinned_sb);
>  	}
>  
> +	put_cgroup_ns(ns);
>  	return dentry;
>  }
>  
> @@ -1862,6 +1904,7 @@ static struct file_system_type cgroup_fs_type = {
>  	.name = "cgroup",
>  	.mount = cgroup_mount,
>  	.kill_sb = cgroup_kill_sb,
> +	.fs_flags = FS_USERNS_MOUNT,
>  };
>  
>  static struct kobject *cgroup_kobj;
