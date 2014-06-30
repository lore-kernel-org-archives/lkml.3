Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaF3OXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:23:32 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:54978 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaF3OXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:23:31 -0400
Date: Mon, 30 Jun 2014 10:23:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 3/3] cgroup: fix a race between cgroup_mount() and
 cgroup_kill_sb()
Message-ID: <20140630142324.GD14807@htj.dyndns.org>
References: <53B0DE66.5080100@huawei.com>
 <53B0DEA3.80807@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B0DEA3.80807@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

I applied the three patches with some updates (mostly comments).
Dynamic root management is turning out to be pretty ugly but I think
we can clean it up a bit.

On Mon, Jun 30, 2014 at 11:50:59AM +0800, Li Zefan wrote:
> @@ -1790,6 +1795,17 @@ out_free:
>  	dentry = kernfs_mount(fs_type, flags, root->kf_root, &new_sb);
>  	if (IS_ERR(dentry) || !new_sb)
>  		cgroup_put(&root->cgrp);
> +
> +	if (sb) {
> +		/*
> +		 * On success kernfs_mount() returns with sb->s_umount held,
> +		 * but kernfs_mount() also increases the superblock's refcnt,
> +		 * so calling deactivate_super() to drop the refcnt we got when
> +		 * looking up cgroup root won't acquire sb->s_umount again.
> +		 */
> +		WARN_ON(new_sb);
> +		deactivate_super(sb);
> +	}

So, @new_sb and @sb indicate the same conditions now.  When we reuse
an existing root, we always reuse its sb too which means that we at
least no longer need the @new_sb ugliness.  I actually kinda prefer it
as this means that the ugliness is confined to one ugly function -
kernfs_pin_sb() - instead of the generic kernfs_mount().  Can you
please prepare patches to clean these up?  I'll pull in for-3.16-fixes
into for-3.17 and apply the cleanup on top.

Thanks!

-- 
tejun
