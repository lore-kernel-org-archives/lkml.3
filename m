Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaBQCmh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 21:42:37 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:9062 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaBQCmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 21:42:35 -0500
Message-ID: <530176EE.6030605@huawei.com>
Date: Mon, 17 Feb 2014 10:41:50 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH] cgroup: add a validation check to cgroup_add_cftyps()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang reported this bug:

BUG: unable to handle kernel NULL pointer dereference at 0000003c
IP: [<cc90b4ad>] cgroup_cfts_commit+0x27/0x1c1
...
Call Trace:
  [<cc9d1129>] ? kmem_cache_alloc_trace+0x33f/0x3b7
  [<cc90c6fc>] cgroup_add_cftypes+0x8f/0xca
  [<cd78b646>] cgroup_init+0x6a/0x26a
  [<cd764d7d>] start_kernel+0x4d7/0x57a
  [<cd7642ef>] i386_start_kernel+0x92/0x96

This happens in a corner case. If CGROUP_SCHED=y but CFS_BANDWIDTH=n &&
FAIR_GROUP_SCHED=n && RT_GROUP_SCHED=n, we have:

cpu_files[] = {
	{ }	/* terminate */
}

When we pass cpu_files to cgroup_apply_cftypes(), as cpu_files[0].ss
is NULL, we'll access NULL pointer.

The bug was introduced by commit de00ffa56ea3132c6013fc8f07133b8a1014cf53
("cgroup: make cgroup_subsys->base_cftypes use cgroup_add_cftypes()").

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index eaffc08..465c1d8 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2356,6 +2356,9 @@ int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
 	int ret;
 
+	if (!cfts || cfts[0].name[0] == '\0')
+		return 0;
+
 	ret = cgroup_init_cftypes(ss, cfts);
 	if (ret)
 		return ret;
-- 
1.8.0.2
