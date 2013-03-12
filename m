Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3CLGwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:52:25 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:44108 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3CLGwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:52:23 -0400
Message-ID: <513ED09F.2020906@huawei.com>
Date: Tue, 12 Mar 2013 14:52:15 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 7/8] cgroup: fix an almost harmless off-by-one bug
References: <513ED010.5060906@huawei.com>
In-Reply-To: <513ED010.5060906@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 3rd parameter of flex_array_prealloc() is the number of elements,
not the index of the last element.

The effect of the bug is, when opening cgroup.procs, a flex array will
be allocated and all elements of the array is allocated with GFP_KERNEL
flag, but the last one is GFP_ATOMIC, , and if we fail to allocate memory
for it, it'll trigger a BUG_ON().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3206137..4b92b9a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2076,7 +2076,7 @@ static int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	if (!group)
 		return -ENOMEM;
 	/* pre-allocate to guarantee space while iterating in rcu read-side. */
-	retval = flex_array_prealloc(group, 0, group_size - 1, GFP_KERNEL);
+	retval = flex_array_prealloc(group, 0, group_size, GFP_KERNEL);
 	if (retval)
 		goto out_free_group_list;
 
-- 
1.8.0.2

