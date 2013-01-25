Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab3AYHKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:10:51 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:52228 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3AYHKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:10:48 -0500
Message-ID: <51022FC7.5020607@huawei.com>
Date: Fri, 25 Jan 2013 15:09:59 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH] cgroup: fix cgroup_path() vs rename() race
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

Use dentry_path_raw(), and this vfs API will take care of lockings.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5d4c92e..776ff75 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1792,26 +1792,10 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 		return 0;
 	}
 
-	start = buf + buflen - 1;
+	start = dentry_path_raw(dentry, buf, buflen);
+	if (IS_ERR(start))
+		return PTR_ERR(start);
 
-	*start = '\0';
-	for (;;) {
-		int len = dentry->d_name.len;
-
-		if ((start -= len) < buf)
-			return -ENAMETOOLONG;
-		memcpy(start, dentry->d_name.name, len);
-		cgrp = cgrp->parent;
-		if (!cgrp)
-			break;
-
-		dentry = cgrp->dentry;
-		if (!cgrp->parent)
-			continue;
-		if (--start < buf)
-			return -ENAMETOOLONG;
-		*start = '/';
-	}
 	memmove(buf, start, buf + buflen - start);
 	return 0;
 }
-- 
1.8.0.2
