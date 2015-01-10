Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbbAJIzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 03:55:39 -0500
Received: from mx2.parallels.com ([199.115.105.18]:45073 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbbAJIzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 03:55:38 -0500
Date: Sat, 10 Jan 2015 11:55:25 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
CC: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [Regression] 3.19-rc3 : memcg: Hang in mount memcg
Message-ID: <20150110085525.GD2110@esperanza>
References: <54B01335.4060901@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <54B01335.4060901@arm.com>
X-Originating-IP: [81.5.99.36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 05:43:17PM +0000, Suzuki K. Poulose wrote:
> Hi
> 
> We have hit a hang on ARM64 defconfig, while running LTP tests on
> 3.19-rc3. We are
> in the process of a git bisect and will update the results as and
> when we find the commit.
> 
> During the ksm ltp run, the test hangs trying to mount memcg with
> the following strace
> output:
> 
> mount("memcg", "/dev/cgroup", "cgroup", 0, "memory") = ?
> ERESTARTNOINTR (To be restarted)
> mount("memcg", "/dev/cgroup", "cgroup", 0, "memory") = ?
> ERESTARTNOINTR (To be restarted)
> [ ... repeated forever ... ]
> 
> At this point, one can try mounting the memcg to verify the problem.
> # mount -t cgroup -o memory memcg memcg_dir
> --hangs--
> 
> Strangely, if we run the mount command from a cold boot (i.e.
> without running LTP first),
> then it succeeds.
> 
> Upon a quick look we are hitting the following code :
> kernel/cgroup.c: cgroup_mount() :
> 
> 1779         for_each_subsys(ss, i) {
> 1780                 if (!(opts.subsys_mask & (1 << i)) ||
> 1781                     ss->root == &cgrp_dfl_root)
> 1782                         continue;
> 1783
> 1784                 if
> (!percpu_ref_tryget_live(&ss->root->cgrp.self.refcnt)) {
> 1785                         mutex_unlock(&cgroup_mutex);
> 1786                         msleep(10);
> 1787                         ret = restart_syscall(); <=====
> 1788                         goto out_free;
> 1789                 }
> 1790                 cgroup_put(&ss->root->cgrp);
> 1791         }
> 
> with ss->root->cgrp.self.refct.percpu_count_ptr == __PERCPU_REF_ATOMIC_DEAD
> 
> Any ideas?

The problem is that the memory cgroup controller takes a css reference
per each charged page and does not reparent charged pages on css
offline, while cgroup_mount/cgroup_kill_sb expect all css references to
offline cgroups to be gone soon, restarting the syscall if the ref count
!= 0. As a result, if you create a memory cgroup, charge some page cache
to it, and then remove it, unmount/mount will hang forever.

May be, we should kill the ref counter to the memory controller root in
cgroup_kill_sb only if there is no children at all, neither online nor
offline.

Thanks,
Vladimir
