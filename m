Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab3AXGoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 01:44:05 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:60805 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3AXGnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 01:43:55 -0500
Message-ID: <5100D810.5020406@huawei.com>
Date: Thu, 24 Jan 2013 14:43:28 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] cgroup: fix exit() vsrmdir() race
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cgroup_exit() put_css_set_taskexit() is called without any lock,
which might lead to accessing a freed cgroup:

thread1                           thread2
---------------------------------------------
exit()
  cgroup_exit()
    put_css_set_taskexit()
      atomic_dec(cgrp->count);
                                   rmdir();
      /* not safe !! */
      check_for_release(cgrp);

rcu_read_lock() can be used to make sure the cgroup is alive.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 368cff1..09c5869 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -422,12 +422,20 @@ static void __put_css_set(struct css_set *cg, int taskexit)
 		struct cgroup *cgrp = link->cgrp;
 		list_del(&link->cg_link_list);
 		list_del(&link->cgrp_link_list);
+
+		/*
+		 * We may not be holding cgroup_mutex, and if cgrp->count is
+		 * dropped to 0 the cgroup can be destroyed at any time, hence
+		 * rcu_read_lock is used to keep it alive.
+		 */
+		rcu_read_lock();
 		if (atomic_dec_and_test(&cgrp->count) &&
 		    notify_on_release(cgrp)) {
 			if (taskexit)
 				set_bit(CGRP_RELEASABLE, &cgrp->flags);
 			check_for_release(cgrp);
 		}
+		rcu_read_unlock();
 
 		kfree(link);
 	}
-- 
1.8.0.2
