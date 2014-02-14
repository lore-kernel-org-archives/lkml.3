Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaBNUrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:47:16 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51818 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaBNUrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:47:14 -0500
Date: Fri, 14 Feb 2014 15:47:09 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 cgroup/for-3.15] cgroup: make
 cgroup_enable_task_cg_lists() to grab siglock
Message-ID: <20140214204709.GB2851@mtj.dyndns.org>
References: <20140213182931.GB17608@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213182931.GB17608@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there's nothing explicitly preventing
cgroup_enable_task_cg_lists() from missing set PF_EXITING and race
against cgroup_exit(), and, depending on the timing, cgroup_exit()
seemingly may finish with the task still linked on css_set leading to
list corruption because cgroup_enable_task_cg_lists() can end up
linking it after list_empty(&tsk->cg_list) test in cgroup_exit().

This can't really happen because exit_mm() grabs and release
task_lock() between setting of PF_EXITING and cgroup_exit(), and
cgroup_enable_task_cg_lists() synchronizes against task_lock too;
however, this is fragile and more of a happy accident.  Let's make the
synchronization explicit by making cgroup_enable_task_cg_lists() grab
siglock around PF_EXITING testing.

This whole on-demand cg_list optimization is extremely fragile and has
ample possibility to lead to bugs which can cause things like
once-a-year oops during boot.  I'm wondering whether the better
approach would be just adding "cgroup_disable=all" handling which
disables the whole cgroup rather than tempting fate with this dynamic
optimization craziness.

v2: Li pointed out that the race condition can't actually happen due
    to task_lock locking in exit_mm().  Updated the patch description
    accordingly and dropped -stable cc.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1331,9 +1331,13 @@ static void cgroup_enable_task_cg_lists(
 		 * We should check if the process is exiting, otherwise
 		 * it will race with cgroup_exit() in that the list
 		 * entry won't be deleted though the process has exited.
+		 * Do it while holding siglock so that we don't end up
+		 * racing against cgroup_exit().
 		 */
+		spin_lock_irq(&p->sighand->siglock);
 		if (!(p->flags & PF_EXITING))
 			list_add(&p->cg_list, &task_css_set(p)->tasks);
+		spin_unlock_irq(&p->sighand->siglock);
 
 		task_unlock(p);
 	} while_each_thread(g, p);
