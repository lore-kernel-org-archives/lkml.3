Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbaIRJ2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 05:28:54 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:50267 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545AbaIRJ2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 05:28:52 -0400
Message-ID: <541AA5CE.8040006@huawei.com>
Date: Thu, 18 Sep 2014 17:28:46 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cgroup: fix unbalanced locking
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_pidlist_start() holds cgrp->pidlist_mutex and then calls
pidlist_array_load(), and cgroup_pidlist_stop() releases the mutex.

It is wrong that we release the mutex in the failure path in
pidlist_array_load(), because cgroup_pidlist_stop() will be called
no matter if cgroup_pidlist_start() returns errno or not.

Fixes: 4bac00d16a8760eae7205e41d2c246477d42a210
Cc: <stable@vger.kernel.org> # 3.14+
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 kernel/cgroup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2332efd..de70b63 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3970,7 +3970,6 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 
 	l = cgroup_pidlist_find_create(cgrp, type);
 	if (!l) {
-		mutex_unlock(&cgrp->pidlist_mutex);
 		pidlist_free(array);
 		return -ENOMEM;
 	}
-- 
1.8.0.2

