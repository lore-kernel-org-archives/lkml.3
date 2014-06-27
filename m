Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbaF0PA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 11:00:26 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:47489 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbaF0PAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:00:24 -0400
Date: Fri, 27 Jun 2014 11:00:21 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 5/5] cgroup: fix a race between cgroup_mount() and
 cgroup_kill_sb()
Message-ID: <20140627150021.GA4044@htj.dyndns.org>
References: <53994943.60703@huawei.com>
 <539949A1.90301@huawei.com>
 <20140620193521.GB28324@mtj.dyndns.org>
 <53A8D2B8.4080107@huawei.com>
 <20140624210119.GC14909@htj.dyndns.org>
 <53AA2C4F.30808@huawei.com>
 <20140625150053.GE26883@htj.dyndns.org>
 <53AD1001.4090405@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AD1001.4090405@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 02:32:33PM +0800, Li Zefan wrote:
> > cgroup_mount()
> > {
> > 	mutex_lock();
> > 	lookup_cgroup_root();
> > 	if (root isn't killed yet)
> > 		root->this_better_stay_alive++;
> > 	mutex_unlock();
> > 	kernfs_mount();
> > }
> > 
> > cgroup_kill_sb()
> > {
> > 	mutex_lock();
> > 	if (check whether root can be killed)
> > 		percpu_ref_kill();
> > 	mutex_unlock();
> > 	if (the above condition was true)
> > 		kernfs_kill_sb();
> > }
> > 
> 
> This looks nasty, and I don't think it's correct. If we skip the call
> to kernfs_kill_sb(), kernfs_super_info won't be freed but super_block
> will, so we will end up either leaking memory or accessing invalid
> memory. There are other problems like returning with sb->s_umount still
> held.

Yeah, right, the conditional shouldn't be on kernfs_kill_sb().  It
should only be on percpu_ref_kill().  kernfs mount code will wait out
the dead sb and create a new one; however, this is still not feasible
because we don't have a place to dec ->this_better_stay_alive as
there's no umount callback.  :(

Thanks.

-- 
tejun
