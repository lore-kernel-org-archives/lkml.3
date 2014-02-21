Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbaBUKMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 05:12:54 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49448 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbaBUKMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 05:12:52 -0500
Date: Fri, 21 Feb 2014 05:12:48 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2] sysfs: fix namespace refcnt leak
Message-ID: <20140221101248.GB14653@mtj.dyndns.org>
References: <5306C03B.4060808@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5306C03B.4060808@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 10:55:55AM +0800, Li Zefan wrote:
> As mount() and kill_sb() is not a one-to-one match, we shoudn't get
> ns refcnt unconditionally in sysfs_mount(), and instead we should
> get the refcnt only when kernfs_mount() allocated a new superblock.
> 
> v2:
> - Changed the name of the new argument, suggested by Tejun.
> - Made the argument optional, suggested by Tejun.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
...
> @@ -132,6 +132,7 @@ const void *kernfs_super_ns(struct super_block *sb)
>   * @flags: mount flags specified for the mount
>   * @root: kernfs_root of the hierarchy being mounted
>   * @ns: optional namespace tag of the mount
> + * @new_sb_created: tell the caller if we allocated a new superblock
>   *
>   * This is to be called from each kernfs user's file_system_type->mount()
>   * implementation, which should pass through the specified @fs_type and
> @@ -141,7 +142,8 @@ const void *kernfs_super_ns(struct super_block *sb)
>   * The return value can be passed to the vfs layer verbatim.
>   */
>  struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
> -			       struct kernfs_root *root, const void *ns)
> +			       struct kernfs_root *root, const void *ns,
> +			       bool *new_sb_created)

Oops, just one more thing.  Let's please put @new_sb_created before
@ns; otherwise, kernfs_mount_ns() and kernfs_mount() become really
confusing as we end up omitting the second-to-last param for the
latter instead of the last.

Other than that,

 Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
