Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaBNI4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:56:25 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:55035 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaBNI4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:56:20 -0500
Message-ID: <52FDDA24.6080204@huawei.com>
Date: Fri, 14 Feb 2014 16:56:04 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 3/3] cgroup: deal with dummp_top in cgroup_name() and cgroup_path()
References: <52FDD9C4.1070001@huawei.com>
In-Reply-To: <52FDD9C4.1070001@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My kernel fails to boot, because blkcg calls cgroup_path() while
cgroupfs is not mounted.

Fix both cgroup_name() and cgroup_path().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ef0b3af..8c283a9 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -487,13 +487,21 @@ struct cgroup_subsys_state *seq_css(struct seq_file *seq);
 
 static inline int cgroup_name(struct cgroup *cgrp, char *buf, size_t buflen)
 {
-	return kernfs_name(cgrp->kn, buf, buflen);
+	/* dummy_top doesn't have a kn associated */
+	if (cgrp->kn)
+		return kernfs_name(cgrp->kn, buf, buflen);
+	else
+		return strlcpy(buf, "/", buflen);
 }
 
 static inline char * __must_check cgroup_path(struct cgroup *cgrp, char *buf,
 					      size_t buflen)
 {
-	return kernfs_path(cgrp->kn, buf, buflen);
+	/* dummy_top doesn't have a kn associated */
+	if (cgrp->kn)
+		return kernfs_path(cgrp->kn, buf, buflen);
+	strlcpy(buf, "/", buflen);
+	return (buflen <= 2) ? NULL : buf;
 }
 
 static inline void pr_cont_cgroup_name(struct cgroup *cgrp)
-- 
1.8.0.2

