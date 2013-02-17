Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab3BQGs6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 01:48:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47996 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3BQGs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 01:48:56 -0500
Date: Sun, 17 Feb 2013 06:48:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH 2/2] cgroup: fix cgroup_path() vs rename() race, take 2
Message-ID: <20130217064852.GD4503@ZenIV.linux.org.uk>
References: <51205684.5040407@huawei.com>
 <51205699.5080900@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51205699.5080900@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 12:03:37PM +0800, Li Zefan wrote:
> rename() will change dentry->d_name. The result of this race can
> be worse than seeing partially rewritten name, but we might access
> a stale pointer because rename() will re-allocate memory to hold
> a longer name.
> 
> As accessing dentry->name must be protected by dentry->d_lock or
> parent inode's i_mutex, while on the other hand cgroup-path() can
> be called with some irq-safe spinlocks held, we can't generate
> cgroup path using dentry->d_name.
> 
> Alternatively we make a copy of dentry->d_lock and save it in
> cgrp->name when a cgroup is created, and update cgrp->name at
> rename().

Yecchhh...  This is just plain wrong.  If nothing else, your locking
is way too heavy for your uses.  Just put freeing those separately
allocated names in RCU callback and assign them on rename with
rcu_assign_pointer().  Then put cgroup_path() under rcu_read_lock()
(most of the callers already are) and be done with that.
