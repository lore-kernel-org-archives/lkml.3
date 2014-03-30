Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbaC3XzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:55:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754619AbaC3Xn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:29 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Li Zefan" <lizefan@huawei.com>,
        "Tejun Heo" <tj@kernel.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.671118274@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 129/200] cgroup: update cgroup_enable_task_cg_lists()
 to grab siglock
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2785,9 +2785,14 @@ static void cgroup_enable_task_cg_lists(
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
 	write_unlock(&css_set_lock);

