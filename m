Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab3AOQkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:40:53 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35643 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3AOQkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:40:51 -0500
Date: Tue, 15 Jan 2013 08:40:47 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 1/2] cpuset: fix RCU lockdep splat
Message-ID: <20130115164047.GC2668@htj.dyndns.org>
References: <50F4F2F1.8070107@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F4F2F1.8070107@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 27e89ae5d6e94e30231ee89a7736f62d84ba4c6f Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan@huawei.com>
Date: Tue, 15 Jan 2013 14:10:57 +0800

5d21cc2db040d01f8c19b8602f6987813e1176b4 ("cpuset: replace
cgroup_mutex locking with cpuset internal locking") incorrectly
converted proc_cpuset_show() from cgroup_lock() to cpuset_mutex.
proc_cpuset_show() is accessing cgroup hierarchy proper to determine
cgroup path which can't be protected by cpuset_mutex.  This triggered
the following RCU warning.

 ===============================
 [ INFO: suspicious RCU usage. ]
 3.8.0-rc3-next-20130114-sasha-00016-ga107525-dirty #262 Tainted: G        W
 -------------------------------
 include/linux/cgroup.h:534 suspicious rcu_dereference_check() usage!

 other info that might help us debug this:

 rcu_scheduler_active = 1, debug_locks = 1
 2 locks held by trinity/7514:
  #0:  (&p->lock){+.+.+.}, at: [<ffffffff812b06aa>] seq_read+0x3a/0x3e0
  #1:  (cpuset_mutex){+.+...}, at: [<ffffffff811abae4>] proc_cpuset_show+0x84/0x190

 stack backtrace:
 Pid: 7514, comm: trinity Tainted: G        W
+3.8.0-rc3-next-20130114-sasha-00016-ga107525-dirty #262
 Call Trace:
  [<ffffffff81182cab>] lockdep_rcu_suspicious+0x10b/0x120
  [<ffffffff811abb71>] proc_cpuset_show+0x111/0x190
  [<ffffffff812b0827>] seq_read+0x1b7/0x3e0
  [<ffffffff812b0670>] ? seq_lseek+0x110/0x110
  [<ffffffff8128b4fb>] do_loop_readv_writev+0x4b/0x90
  [<ffffffff8128b776>] do_readv_writev+0xf6/0x1d0
  [<ffffffff8128b8ee>] vfs_readv+0x3e/0x60
  [<ffffffff8128b960>] sys_readv+0x50/0xd0
  [<ffffffff83d33d18>] tracesys+0xe1/0xe6

The operation can be performed under RCU read lock.  Replace
cpuset_mutex locking with RCU read locking.

tj: Rewrote patch description.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
I rewrote the patch description for clarity and commited it to
cgroup/for-3.9-cpuset.

Thanks.

 kernel/cpuset.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 6aa5bbb..1a675e4 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2678,15 +2678,15 @@ static int proc_cpuset_show(struct seq_file *m, void *unused_v)
 		goto out_free;
 
 	retval = -EINVAL;
-	mutex_lock(&cpuset_mutex);
+	rcu_read_lock();
 	css = task_subsys_state(tsk, cpuset_subsys_id);
 	retval = cgroup_path(css->cgroup, buf, PAGE_SIZE);
+	rcu_read_unlock();
 	if (retval < 0)
-		goto out_unlock;
+		goto out_put_task;
 	seq_puts(m, buf);
 	seq_putc(m, '\n');
-out_unlock:
-	mutex_unlock(&cpuset_mutex);
+out_put_task:
 	put_task_struct(tsk);
 out_free:
 	kfree(buf);
-- 
1.8.0.2

