Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbaCDUDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:03:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbaCDUD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.13 081/172] cgroup: update cgroup_enable_task_cg_lists() to grab siglock
Date: Tue,  4 Mar 2014 12:02:45 -0800
Message-Id: <20140304200302.327641428@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2985,9 +2985,14 @@ static void cgroup_enable_task_cg_lists(
 		 * We should check if the process is exiting, otherwise
 		 * it will race with cgroup_exit() in that the list
 		 * entry won't be deleted though the process has exited.
+		 * Do it while holding siglock so that we don't end up
+		 * racing against cgroup_exit().
 		 */
+		spin_lock_irq(&p->sighand->siglock);
 		if (!(p->flags & PF_EXITING) && list_empty(&p->cg_list))
 			list_add(&p->cg_list, &task_css_set(p)->tasks);
+		spin_unlock_irq(&p->sighand->siglock);
+
 		task_unlock(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);


