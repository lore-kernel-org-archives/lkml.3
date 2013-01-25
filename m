Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab3AYHKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:10:04 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:51796 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3AYHKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:10:00 -0500
Message-ID: <51022FBC.2020705@huawei.com>
Date: Fri, 25 Jan 2013 15:09:48 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] cpuset: fix cpuset_print_task_mems_allowed() vs rename()
 race
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rename() will change dentry->d_name. The result of this race can
be worse than seeing partially rewritten name, but we might access
a stale pointer because rename() will re-allocate memory to hold
a longer name.

It's safe in the protection of dentry->d_lock.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 16be7c9..b2476c2 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2606,8 +2606,12 @@ void cpuset_print_task_mems_allowed(struct task_struct *tsk)
 
 	dentry = task_cs(tsk)->css.cgroup->dentry;
 	spin_lock(&cpuset_buffer_lock);
+
+	spin_lock(&dentry->d_lock);
 	snprintf(cpuset_name, CPUSET_NAME_LEN,
 		 dentry ? (const char *)dentry->d_name.name : "/");
+	spin_unlock(&dentry->d_lock);
+
 	nodelist_scnprintf(cpuset_nodelist, CPUSET_NODELIST_LEN,
 			   tsk->mems_allowed);
 	printk(KERN_INFO "%s cpuset=%s mems_allowed=%s\n",
-- 
1.8.0.2
