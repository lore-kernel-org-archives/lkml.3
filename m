Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116Ab3B1PLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:11:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42170 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab3B1OsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:48:20 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 061/139] cgroup: fix exit() vs rmdir() race
Date: Thu, 28 Feb 2013 14:43:31 +0000
Message-Id: <1362062689-2567-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 71b5707e119653039e6e95213f00479668c79b75 upstream.

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
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/cgroup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 963c956..87fbb45 100644
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
1.8.1.2

