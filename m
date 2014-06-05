Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaFEJQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 05:16:52 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:4824 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaFEJQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 05:16:50 -0400
Message-ID: <5390356E.70305@huawei.com>
Date: Thu, 5 Jun 2014 17:16:30 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] cgroup: disallow disabled controllers on the default hierarchy
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After booting with cgroup_disable=memory, I still saw memcg files
in the default hierarchy, and I can write to them, though it won't
take effect.

  # dmesg
  ...
  Disabling memory control group subsystem
  ...
  # mount -t cgroup -o __DEVEL__sane_behavior xxx /cgroup
  # ls /cgroup
  ...
  memory.failcnt                   memory.move_charge_at_immigrate
  memory.force_empty               memory.numa_stat
  memory.limit_in_bytes            memory.oom_control
  ...
  # cat /cgroup/memory.usage_in_bytes
  0

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d5032d2..57b647a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3070,6 +3070,9 @@ int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
 	int ret;
 
+	if (ss->disabled)
+		return 0;
+
 	if (!cfts || cfts[0].name[0] == '\0')
 		return 0;
 
@@ -4679,8 +4682,6 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 
 	BUG_ON(online_css(css));
 
-	cgrp_dfl_root.subsys_mask |= 1 << ss->id;
-
 	mutex_unlock(&cgroup_mutex);
 }
 
@@ -4760,10 +4761,13 @@ int __init cgroup_init(void)
 
 		/*
 		 * cftype registration needs kmalloc and can't be done
-		 * during early_init.  Register base cftypes separately.
+		 * during early_init, and the disable flag is set after
+		 * early_init.  Register base cftypes separately.
 		 */
-		if (ss->base_cftypes)
+		if (!ss->disabled) {
+			cgrp_dfl_root.subsys_mask |= 1 << ss->id;
 			WARN_ON(cgroup_add_cftypes(ss, ss->base_cftypes));
+		}
 	}
 
 	cgroup_kobj = kobject_create_and_add("cgroup", fs_kobj);
-- 
1.8.0.2

