Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab3BRRah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:30:37 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41088 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab3BRRaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:30:35 -0500
Date: Mon, 18 Feb 2013 09:30:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Sasha Levin <levinsasha928@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] cgroup: fix cgroup_path() vs rename() race, take 2
Message-ID: <20130218173023.GG17414@htj.dyndns.org>
References: <51218100.5020007@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51218100.5020007@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Mon, Feb 18, 2013 at 09:16:48AM +0800, Li Zefan wrote:
> @@ -171,6 +171,7 @@ struct cgroup {
>  
>  	struct cgroup *parent;		/* my parent */
>  	struct dentry *dentry;		/* cgroup fs entry, RCU protected */
> +	char __rcu *name;		/* a copy of dentry->d_name */

A brief explanation of why this is necessary and how rcu is used would
be nice.

> +static char *cgroup_alloc_name(struct dentry *dentry)
> +{
> +	char *name;
> +
> +	name = kmalloc(dentry->d_name.len + 1, GFP_KERNEL);
> +	if (!name)
> +		return NULL;
> +	memcpy(name, dentry->d_name.name, dentry->d_name.len);
> +	name[dentry->d_name.len] = '\0';
> +	return name;
> +}

While d_name has length field, it's always properly NULL terminated,
so kstrdup() should suffice here.  Right, Al?

> @@ -1613,13 +1626,19 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
...
> -		inode = sb->s_root->d_inode;
> +		dentry = sb->s_root;
> +		inode = dentry->d_inode;
> +
> +		root_cgrp->name = cgroup_alloc_name(dentry);
> +		if (!root_cgrp->name)
> +			goto drop_new_super;

Don't we need an RCU assignment?  Is it safe because it isn't online
yet?  But wouldn't this still trigger sparse warning?

> @@ -1751,6 +1770,8 @@ static void cgroup_kill_sb(struct super_block *sb) {
>  	mutex_unlock(&cgroup_root_mutex);
>  	mutex_unlock(&cgroup_mutex);
>  
> +	synchronize_rcu();

An explanation on what we're synchronizing would be nice.  Barriers
without explanation sucks because there's nothing directly linking the
barriers to the things which are being protected.

> @@ -2539,13 +2558,41 @@ static int cgroup_file_release(struct inode *inode, struct file *file)
>  static int cgroup_rename(struct inode *old_dir, struct dentry *old_dentry,
>  			    struct inode *new_dir, struct dentry *new_dentry)
>  {
...
> +	old_name = cgrp->name;
> +	rcu_assign_pointer(cgrp->name, name);
> +
> +	synchronize_rcu();

Please don't call synchronize_rcu() from interface which is directly
visible to userland.  It leads to sporadic difficult-to-reproduce
latencies which hurt enough in corner cases and this is kmalloc
memory.  It's not like kfree_rcu() is difficult to use or anything.

> +	kfree(old_name);
> +	return 0;
>  }
>  
>  static struct simple_xattrs *__d_xattrs(struct dentry *dentry)
> @@ -4144,9 +4191,13 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>  	if (!cgrp)
>  		return -ENOMEM;
>  
> +	cgrp->name = cgroup_alloc_name(dentry);
> +	if (!cgrp->name)
> +		goto err_free_cgrp;

Ditto with assignment.

Thanks.

-- 
tejun
