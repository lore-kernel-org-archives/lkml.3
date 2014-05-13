Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033AbaEMHfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:35:54 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:15625 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759001AbaEMHfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:35:52 -0400
Message-ID: <5371CB4A.3030905@huawei.com>
Date: Tue, 13 May 2014 15:35:38 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: remove cgroup_tree_mutex
References: <1399407574-21472-1-git-send-email-tj@kernel.org>
In-Reply-To: <1399407574-21472-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/7 4:19, Tejun Heo wrote:
> Hello,
> 
> cgroup_tree_mutex was introduced during kernfs conversion to work
> around the cyclic locking dependency between kernfs active protection
> and cgroup_mutex.  Some file and directory operations need to acquire
> cgroup_mutex which puts the mutex under the kernfs active protection;
> however, cgroup also needs to access the hierarchy and the registered
> cftypes to detemine which files to remove, which obviously can't be
> done while holding cgroup_mutex anymore.
> 
> cgroup_tree_mutex nests above both cgroup_mutex and kernfs active
> protection and protects hierarchy and cftypes so that those file
> operations can be performed while holding it without cgroup_mutex.
> This works but is kinda cumbersome as most places end up taking both
> cgroup_tree_mutex and cgroup_mutex and there's on-going friction on
> what needs to be protected by which combination.
> 
> Furthermore, due to new requirements from subtree_control
> implementations, kernfs ended up growing full-blown mechanism to
> bypass active protection instead of just supporting self-removal and
> cgroup ended up using both mechanisms - two layered mutexes and active
> protection bypss - on different areas, which is totally unncessary.
> 
> This patchset converts everything over to kernfs active protection
> bypass and drops cgroup_tree_mutex making cgroup locking noticeably
> simpler.  It contains the following eight patches.
> 
>  0001-cgroup-reorganize-cgroup_create.patch
>  0002-cgroup-collapse-cgroup_create-into-croup_mkdir.patch
>  0003-cgroup-grab-cgroup_mutex-earlier-in-cgroup_subtree_c.patch
>  0004-cgroup-move-cgroup-kn-priv-clearing-to-cgroup_rmdir.patch
>  0005-cgroup-factor-out-cgroup_kn_lock_live-and-cgroup_kn_.patch
>  0006-cgroup-use-cgroup_kn_lock_live-in-other-cgroup-kernf.patch
>  0007-cgroup-nest-kernfs-active-protection-under-cgroup_mu.patch
>  0008-cgroup-remove-cgroup_tree_mutex.patch
> 
> 0001-0004 reorganize various kernfs handling paths so that they are
> more uniform in terms of active protection handling.
> 
> 0005 factors out two locking helpers - cgroup_kn_lock_live() and
> cgroup_kn_unlock() - which handle both kernfs active protection bypass
> and locking.
> 
> 0006 applies it to other kernfs method implementations which were
> grabbing cgroup_mutex under active protection.
> 
> 0007 reverses the locking dependency between cgroup_mutex and kernfs
> active protection so that the latter nests under the former, making
> cgroup_mutex equivalent to cgroup_tree_mutex.
> 
> 0008 removes cgroup_tree_mutex.
> 
> This patchset is on top of
> 
>   cgroup/for-3.16 12d3089c192c ("kernel/cpuset.c: convert printk to pr_foo()")
> + [1] [PATCHSET cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates
> + [2] [PATCHSET cgroup/for-3.16] cgroup: implement cftype->write()
> 
> and is available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-kill-tree_mutex
> 
> diffstat follows.  Thanks.
> 
>  kernel/cgroup.c |  385 +++++++++++++++++++++++---------------------------------
>  1 file changed, 163 insertions(+), 222 deletions(-)
> 

Acked-by: Li Zefan <lizefan@huawei.com>
