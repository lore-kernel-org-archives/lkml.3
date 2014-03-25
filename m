Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbaCYRlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:41:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55888 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbaCYRVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:21:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 40/81] cgroup: update cgroup_enable_task_cg_lists() to grab siglock
Date: Tue, 25 Mar 2014 10:15:53 -0700
Message-Id: <1395767794-5012-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 532de3fc72adc2a6525c4d53c07bf81e1732083d upstream.

Currently, there's nothing preventing cgroup_enable_task_cg_lists()
from missing set PF_EXITING and race against cgroup_exit().  Depending
on the timing, cgroup_exit() may finish with the task still linked on
css_set leading to list corruption.  Fix it by grabbing siglock in
cgroup_enable_task_cg_lists() so that PF_EXITING is guaranteed to be
visible.

This whole on-demand cg_list optimization is extremely fragile and has
ample possibility to lead to bugs which can cause things like
once-a-year oops during boot.  I'm wondering whether the better
approach would be just adding "cgroup_disable=all" handling which
disables the whole cgroup rather than tempting fate with this
on-demand craziness.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ba9e28c..a2d2c80 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2982,9 +2982,14 @@ static void cgroup_enable_task_cg_lists(void)
 		 * We should check if the process is exiting, otherwise
 		 * it will race with cgroup_exit() in that the list
 		 * entry won't be deleted though the process has exited.
+		 * Do it while holding siglock so that we don't end up
+		 * racing against cgroup_exit().
 		 */
+		spin_lock_irq(&p->sighand->siglock);
 		if (!(p->flags & PF_EXITING) && list_empty(&p->cg_list))
 			list_add(&p->cg_list, &p->cgroups->tasks);
+		spin_unlock_irq(&p->sighand->siglock);
+
 		task_unlock(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
-- 
1.8.3.2

