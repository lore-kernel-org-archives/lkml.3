Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaBNIzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:55:33 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:54213 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaBNIzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:55:31 -0500
Message-ID: <52FDD9E8.4060408@huawei.com>
Date: Fri, 14 Feb 2014 16:55:04 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 2/3] cgroup: fix memory leak in cgroup_mount()
References: <52FDD9C4.1070001@huawei.com>
In-Reply-To: <52FDD9C4.1070001@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should free the memory allocated in parse_cgroupfs_options() before
calling this function again.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0e794ca..37d94a2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1540,6 +1540,8 @@ retry:
 		if (!atomic_inc_not_zero(&root->top_cgroup.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
 			mutex_unlock(&cgroup_tree_mutex);
+			kfree(opts.release_agent);
+			kfree(opts.name);
 			msleep(10);
 			goto retry;
 		}
-- 
1.8.0.2

