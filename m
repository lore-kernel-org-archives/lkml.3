Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaFCEGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 00:06:18 -0400
Received: from [119.145.14.64] ([119.145.14.64]:45688 "EHLO
	szxga01-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbaFCEGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 00:06:16 -0400
Message-ID: <538D4982.10905@huawei.com>
Date: Tue, 3 Jun 2014 12:05:22 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 2/3] cgroup: make the default root invisible when it's umounted
References: <538D4956.5050205@huawei.com>
In-Reply-To: <538D4956.5050205@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this patch (in a fresh system):

   # cat /proc/$$/cgroup
   # mount -t cgroup -o __DEVEL__sane_behavior xxx /cgroup
   # umount /cgroup
   # cat /proc/$$/cgroup
   0:cpuset,cpu,cpuacct,memory,devices,freezer,net_cls,blkio,perf_event,net_prio,hugetlb:/

After this patch (in a fresh system):

   # cat ...
   # mount ...
   # umount ...
   # cat /proc/$$/cgroup
   #

You won't see the default root after it's umounted.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f73fe48..dabc486 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1788,6 +1788,8 @@ static void cgroup_kill_sb(struct super_block *sb)
 	} else {
 		if (root != &cgrp_dfl_root)
 			percpu_ref_kill(&root->cgrp.self.refcnt);
+		else
+			cgrp_dfl_root_visible = false;
 	}
 
 	kernfs_kill_sb(sb);
-- 
1.8.0.2

