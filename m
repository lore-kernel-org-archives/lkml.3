Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbbAIRnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:43:24 -0500
Received: from service87.mimecast.com ([91.220.42.44]:58995 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbbAIRnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:43:22 -0500
Message-ID: <54B01335.4060901@arm.com>
Date: Fri, 09 Jan 2015 17:43:17 +0000
From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
CC: linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: [Regression] 3.19-rc3 : memcg: Hang in mount memcg
X-OriginalArrivalTime: 09 Jan 2015 17:43:18.0220 (UTC) FILETIME=[C0BB50C0:01D02C33]
X-MC-Unique: 115010917432000201
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

We have hit a hang on ARM64 defconfig, while running LTP tests on 
3.19-rc3. We are
in the process of a git bisect and will update the results as and
when we find the commit.

During the ksm ltp run, the test hangs trying to mount memcg with the 
following strace
output:

mount("memcg", "/dev/cgroup", "cgroup", 0, "memory") = ? ERESTARTNOINTR 
(To be restarted)
mount("memcg", "/dev/cgroup", "cgroup", 0, "memory") = ? ERESTARTNOINTR 
(To be restarted)
[ ... repeated forever ... ]

At this point, one can try mounting the memcg to verify the problem.
# mount -t cgroup -o memory memcg memcg_dir
--hangs--

Strangely, if we run the mount command from a cold boot (i.e. without 
running LTP first),
then it succeeds.

Upon a quick look we are hitting the following code :
kernel/cgroup.c: cgroup_mount() :

1779         for_each_subsys(ss, i) {
1780                 if (!(opts.subsys_mask & (1 << i)) ||
1781                     ss->root == &cgrp_dfl_root)
1782                         continue;
1783
1784                 if 
(!percpu_ref_tryget_live(&ss->root->cgrp.self.refcnt)) {
1785                         mutex_unlock(&cgroup_mutex);
1786                         msleep(10);
1787                         ret = restart_syscall(); <=====
1788                         goto out_free;
1789                 }
1790                 cgroup_put(&ss->root->cgrp);
1791         }

with ss->root->cgrp.self.refct.percpu_count_ptr == __PERCPU_REF_ATOMIC_DEAD

Any ideas?

Thanks
Suzuki

