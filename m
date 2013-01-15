Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab3AOGMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 01:12:08 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:46644 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3AOGMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 01:12:07 -0500
Message-ID: <50F4F2F1.8070107@huawei.com>
Date: Tue, 15 Jan 2013 14:10:57 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 1/2] cpuset: fix RCU lockdep splat
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading /proc/<pid>/cpuset triggered RCU warning, and this bug was
introduced by Commit 5d21cc2db040d01f8c19b8602f6987813e1176b4
("cpuset: replace cgroup_mutex locking with cpuset internal locking")

Here we can retreive tsk->cgroups and call cgroup_path() inside RCU
read section.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
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
