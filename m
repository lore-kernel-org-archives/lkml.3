Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbaFYPA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:00:59 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:65182 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbaFYPA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:00:57 -0400
Date: Wed, 25 Jun 2014 11:00:53 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 5/5] cgroup: fix a race between cgroup_mount() and
 cgroup_kill_sb()
Message-ID: <20140625150053.GE26883@htj.dyndns.org>
References: <53994943.60703@huawei.com>
 <539949A1.90301@huawei.com>
 <20140620193521.GB28324@mtj.dyndns.org>
 <53A8D2B8.4080107@huawei.com>
 <20140624210119.GC14909@htj.dyndns.org>
 <53AA2C4F.30808@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AA2C4F.30808@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Jun 25, 2014 at 09:56:31AM +0800, Li Zefan wrote:
> > Hmmm?  Why does that matter?  The only region in cgroup_mount() which
> > needs to be put inside such mutex would be root lookup, no?
> 
> unfortunately that won't help. I think what you suggest is:
> 
> cgroup_mount()
> {
> 	mutex_lock();
> 	lookup_cgroup_root();
> 	mutex_unlock();
> 	kernfs_mount();
> }
> 
> cgroup_kill_sb()
> {
> 	mutex_lock();
> 	percpu_ref_kill();
> 	mutex_Unlock();
> 	kernfs_kill_sb();
> }
> 
> See, we may still be destroying the superblock after we've succeeded
> in getting the refcnt of cgroup root.

Sure, but now the decision to kill is synchronized so the other side
can interlock with it.  e.g.

cgroup_mount()
{
	mutex_lock();
	lookup_cgroup_root();
	if (root isn't killed yet)
		root->this_better_stay_alive++;
	mutex_unlock();
	kernfs_mount();
}

cgroup_kill_sb()
{
	mutex_lock();
	if (check whether root can be killed)
		percpu_ref_kill();
	mutex_unlock();
	if (the above condition was true)
		kernfs_kill_sb();
}

-- 
tejun
