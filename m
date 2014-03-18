Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaCRJCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 05:02:50 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:56569 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaCRJCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 05:02:46 -0400
Message-ID: <53280BAC.5060404@huawei.com>
Date: Tue, 18 Mar 2014 17:02:36 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH] cgroup: fix a failure path in create_css()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If online_css() fails, we should remove cgroup files belonging
to css->ss.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3790617..e673407 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3408,17 +3408,17 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 
 	err = percpu_ref_init(&css->refcnt, css_release);
 	if (err)
-		goto err_free;
+		goto err_free_css;
 
 	init_css(css, ss, cgrp);
 
 	err = cgroup_populate_dir(cgrp, 1 << ss->id);
 	if (err)
-		goto err_free;
+		goto err_free_percpu_ref;
 
 	err = online_css(css);
 	if (err)
-		goto err_free;
+		goto err_clear_dir;
 
 	cgroup_get(cgrp);
 	css_get(css->parent);
@@ -3434,8 +3434,11 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 
 	return 0;
 
-err_free:
+err_clear_dir:
+	cgroup_clear_dir(css->cgroup, 1 << css->ss->id);
+err_free_percpu_ref:
 	percpu_ref_cancel_init(&css->refcnt);
+err_free_css:
 	ss->css_free(css);
 	return err;
 }
-- 
1.8.0.2
