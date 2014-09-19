Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaISI3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 04:29:48 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:62037 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaISI3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 04:29:45 -0400
Message-ID: <541BE96B.1090605@huawei.com>
Date: Fri, 19 Sep 2014 16:29:31 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH] cgroup: remove redundant check in cgroup_ino()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.541BE971.0057,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 4407b808e8c67e2d02e7323ad064ec5b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we implemented default unified hierarchy, cgrp->kn can never
be NULL.

Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 include/linux/cgroup.h | 7 ++-----
 mm/memory-failure.c    | 2 +-
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 77a1d37..818a81f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -532,13 +532,10 @@ static inline bool cgroup_has_tasks(struct cgroup *cgrp)
 	return !list_empty(&cgrp->cset_links);
 }
 
-/* returns ino associated with a cgroup, 0 indicates unmounted root */
+/* returns ino associated with a cgroup */
 static inline ino_t cgroup_ino(struct cgroup *cgrp)
 {
-	if (cgrp->kn)
-		return cgrp->kn->ino;
-	else
-		return 0;
+	return cgrp->kn->ino;
 }
 
 /* cft/css accessors for cftype->write() operation */
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 44c6bd2..8639f6b 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -148,7 +148,7 @@ static int hwpoison_filter_task(struct page *p)
 	ino = cgroup_ino(css->cgroup);
 	css_put(css);
 
-	if (!ino || ino != hwpoison_filter_memcg)
+	if (ino != hwpoison_filter_memcg)
 		return -EINVAL;
 
 	return 0;
-- 
1.8.0.2

