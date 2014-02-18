Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaBRXMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:12:49 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:62574 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaBRXMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:12:46 -0500
Date: Tue, 18 Feb 2014 18:12:42 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] sysfs: fix namespace refcnt leak
Message-ID: <20140218231242.GJ31892@mtj.dyndns.org>
References: <53018813.7030409@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53018813.7030409@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Feb 17, 2014 at 11:54:59AM +0800, Li Zefan wrote:
> I think we have to fix kernfs in order to fix refcnt leak in sysfs
> and cgroupfs. This fix is for 3.14, but it creates conflicts for
> cgroup-next.
> 
> ====================
> 
> As mount() and kill_sb() is not a one-to-one match, we shoudn't get
> ns refcnt unconditionally in sysfs_mount(), and instead we should
> get the refcnt only when kernfs_mount() allocated a new superblock.

Ugh... nasty :(

> @@ -132,6 +132,7 @@ const void *kernfs_super_ns(struct super_block *sb)
>   * @flags: mount flags specified for the mount
>   * @root: kernfs_root of the hierarchy being mounted
>   * @ns: optional namespace tag of the mount
> + * @new: tell the caller if we allocated a new superblock

Maybe something like @new_sb_created is better?

>  	struct super_block *sb;
>  	struct kernfs_super_info *info;
>  	int error;
>  
> +	*new_sb = false;

Can we make it optional so that users who don't care about it can
ignore it?

> @@ -430,9 +431,9 @@ static inline int kernfs_rename(struct kernfs_node *kn,
>  
>  static inline struct dentry *
>  kernfs_mount(struct file_system_type *fs_type, int flags,
> -	     struct kernfs_root *root)
> +	     struct kernfs_root *root, bool *new_sb)
>  {
> -	return kernfs_mount_ns(fs_type, flags, root, NULL);
> +	return kernfs_mount_ns(fs_type, flags, root, NULL, new_sb);

And let kernfs_mount() just use NULL for the parameter?

Thanks.

-- 
tejun
