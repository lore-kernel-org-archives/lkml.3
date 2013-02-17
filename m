Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3BQEEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 23:04:46 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:62562 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab3BQEEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 23:04:44 -0500
Message-ID: <51205684.5040407@huawei.com>
Date: Sun, 17 Feb 2013 12:03:16 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 1/2] Revert "cgroup: fix cgroup_path() vs rename() race"
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 299772fab304ab3a36b22b5d28ed81f9408972e7

Sasha reported this:

[  313.262599] ======================================================
[  313.271340] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[  313.277542] 3.8.0-rc6-next-20130208-sasha-00028-ge4e162d #278 Tainted: G       W
[  313.277542] ------------------------------------------------------
[  313.277542] kworker/u:3/4490 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[  313.277542]  (rename_lock){+.+...}, at: [<ffffffff812a11f9>] dentry_path_raw+0x29/0x70
[  313.277542]
[  313.277542] and this task is already holding:
[  313.277542]  (&(&q->__queue_lock)->rlock){-.-...}, at: [<ffffffff819e78f3>] put_io_context_active+0x63/0x100
[  313.277542] which would create a new lock dependency:
[  313.277542]  (&(&q->__queue_lock)->rlock){-.-...} -> (rename_lock){+.+...}
[  313.277542]
[  313.277542] but this new dependency connects a HARDIRQ-irq-safe lock:
[  313.277542]  (&(&q->__queue_lock)->rlock){-.-...}

dentry_path_raw() grabs rename_lock and dentry->d_lock without disabling
irqs, which means cgroup_path() can't be called if the caller has already
held a spinlock with irq disabled.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 776ff75..5d4c92e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1792,10 +1792,26 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 		return 0;
 	}
 
-	start = dentry_path_raw(dentry, buf, buflen);
-	if (IS_ERR(start))
-		return PTR_ERR(start);
+	start = buf + buflen - 1;
 
+	*start = '\0';
+	for (;;) {
+		int len = dentry->d_name.len;
+
+		if ((start -= len) < buf)
+			return -ENAMETOOLONG;
+		memcpy(start, dentry->d_name.name, len);
+		cgrp = cgrp->parent;
+		if (!cgrp)
+			break;
+
+		dentry = cgrp->dentry;
+		if (!cgrp->parent)
+			continue;
+		if (--start < buf)
+			return -ENAMETOOLONG;
+		*start = '/';
+	}
 	memmove(buf, start, buf + buflen - start);
 	return 0;
 }
-- 
1.8.0.2

