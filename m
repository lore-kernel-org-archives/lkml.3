Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbaGIIsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:48:12 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:1201 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbaGIIsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:48:08 -0400
Message-ID: <53BD01C1.9080308@huawei.com>
Date: Wed, 9 Jul 2014 16:48:01 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v3 06/12] cpuset: initialize top_cpuset's configured masks
 at mount
References: <53BD0174.4060002@huawei.com>
In-Reply-To: <53BD0174.4060002@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.53BD01C6.007B,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: a36860a75e82fddb69df89e165f7fbe7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now have to support different behaviors for default hierachy and
legacy hiearchy, top_cpuset's configured masks need to be initialized
accordingly.

Suppose we've offlined cpu1.

On default hierarchy:

	# mount -t cgroup -o __DEVEL__sane_behavior xxx /cpuset
	# cat /cpuset/cpuset.cpus
	0-15

On legacy hierarchy:

	# mount -t cgroup xxx /cpuset
	# cat /cpuset/cpuset.cpus
	0,2-15

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 60577cc..e4c31e6 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2015,16 +2015,35 @@ static void cpuset_css_free(struct cgroup_subsys_state *css)
 	kfree(cs);
 }
 
+static void cpuset_bind(struct cgroup_subsys_state *root_css)
+{
+	mutex_lock(&cpuset_mutex);
+	mutex_lock(&callback_mutex);
+
+	if (cgroup_on_dfl(root_css->cgroup)) {
+		cpumask_copy(top_cpuset.cpus_allowed, cpu_possible_mask);
+		top_cpuset.mems_allowed = node_possible_map;
+	} else {
+		cpumask_copy(top_cpuset.cpus_allowed,
+			     top_cpuset.effective_cpus);
+		top_cpuset.mems_allowed = top_cpuset.effective_mems;
+	}
+
+	mutex_unlock(&callback_mutex);
+	mutex_unlock(&cpuset_mutex);
+}
+
 struct cgroup_subsys cpuset_cgrp_subsys = {
-	.css_alloc = cpuset_css_alloc,
-	.css_online = cpuset_css_online,
-	.css_offline = cpuset_css_offline,
-	.css_free = cpuset_css_free,
-	.can_attach = cpuset_can_attach,
-	.cancel_attach = cpuset_cancel_attach,
-	.attach = cpuset_attach,
-	.base_cftypes = files,
-	.early_init = 1,
+	.css_alloc	= cpuset_css_alloc,
+	.css_online	= cpuset_css_online,
+	.css_offline	= cpuset_css_offline,
+	.css_free	= cpuset_css_free,
+	.can_attach	= cpuset_can_attach,
+	.cancel_attach	= cpuset_cancel_attach,
+	.attach		= cpuset_attach,
+	.bind		= cpuset_bind,
+	.base_cftypes	= files,
+	.early_init	= 1,
 };
 
 /**
-- 
1.8.0.2

