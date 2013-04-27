Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab3D0Jzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 05:55:55 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:13923 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab3D0Jzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 05:55:54 -0400
Message-ID: <517BA02C.8080005@huawei.com>
Date: Sat, 27 Apr 2013 17:53:48 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 2/2] cpuset: fix cpu hotplug vs rebuild_sched_domains() race
References: <517BA01C.6060806@huawei.com>
In-Reply-To: <517BA01C.6060806@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rebuild_sched_domains() might pass doms with offlined cpu to
partition_sched_domains(), which results in an oops:

general protection fault: 0000 [#1] SMP
...
RIP: 0010:[<ffffffff81077a1e>]  [<ffffffff81077a1e>] get_group+0x6e/0x90
...
Call Trace:
 [<ffffffff8107f07c>] build_sched_domains+0x70c/0xcb0
 [<ffffffff8107f2a7>] ? build_sched_domains+0x937/0xcb0
 [<ffffffff81173f64>] ? kfree+0xe4/0x1b0
 [<ffffffff8107f6e0>] ? partition_sched_domains+0xc0/0x470
 [<ffffffff8107f905>] partition_sched_domains+0x2e5/0x470
 [<ffffffff8107f6e0>] ? partition_sched_domains+0xc0/0x470
 [<ffffffff810c9007>] ? generate_sched_domains+0xc7/0x530
 [<ffffffff810c94a8>] rebuild_sched_domains_locked+0x38/0x70
 [<ffffffff810cb4a4>] cpuset_write_resmask+0x1a4/0x500
 [<ffffffff810c8700>] ? cpuset_mount+0xe0/0xe0
 [<ffffffff810c7f50>] ? cpuset_read_u64+0x100/0x100
 [<ffffffff810be890>] ? cgroup_iter_next+0x90/0x90
 [<ffffffff810cb300>] ? cpuset_css_offline+0x70/0x70
 [<ffffffff810c1a73>] cgroup_file_write+0x133/0x2e0
 [<ffffffff8118995b>] vfs_write+0xcb/0x130
 [<ffffffff8118a174>] sys_write+0x64/0xa0

Reported-by: Li Zhong <zhong@linux.vnet.ibm.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index b0f18ba..ef05901 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -769,12 +769,20 @@ static void rebuild_sched_domains_locked(void)
 	lockdep_assert_held(&cpuset_mutex);
 	get_online_cpus();
 
+	/*
+	 * We have raced with CPU hotplug. Don't do anything to avoid
+	 * passing doms with offlined cpu to partition_sched_domains().
+	 * Anyways, hotplug work item will rebuild sched domains.
+	 */
+	if (!cpumask_equal(top_cpuset.cpus_allowed, cpu_active_mask))
+		goto out;
+
 	/* Generate domain masks and attrs */
 	ndoms = generate_sched_domains(&doms, &attr);
 
 	/* Have scheduler rebuild the domains */
 	partition_sched_domains(ndoms, doms, attr);
-
+out:
 	put_online_cpus();
 }
 #else /* !CONFIG_SMP */
-- 
1.8.0.2
