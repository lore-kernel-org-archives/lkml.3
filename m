Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3FRKnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:43:20 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:42717 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab3FRKnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:43:19 -0400
Message-ID: <51C03971.7000008@huawei.com>
Date: Tue, 18 Jun 2013 18:41:53 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 3/3] cgroup: fix memory leak in cgroup_rm_cftypes()
References: <51C03913.5020008@huawei.com>
In-Reply-To: <51C03913.5020008@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory allocated in cgroup_add_cftypes() should be freed. The
effect of this bug is we leak a bit memory everytime we unload
cfq-iosched module if blkio cgroup is enabled.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e2dcf08..1d5b1d6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2879,7 +2879,8 @@ int cgroup_rm_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 
 	list_for_each_entry(set, &ss->cftsets, node) {
 		if (set->cfts == cfts) {
-			list_del_init(&set->node);
+			list_del(&set->node);
+			kfree(set);
 			cgroup_cfts_commit(ss, cfts, false);
 			return 0;
 		}
-- 
1.8.0.2
