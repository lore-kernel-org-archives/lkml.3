Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbaCEOhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:37:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41630 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229AbaCEOho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:37:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 23/62] cgroup: update cgroup_enable_task_cg_lists() to grab siglock
Date: Wed,  5 Mar 2014 14:36:27 +0000
Message-Id: <1394030226-26652-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7720f52..e4a16ed 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2941,9 +2941,14 @@ static void cgroup_enable_task_cg_lists(void)
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
1.9.0

