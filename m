Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaIBK6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:58:01 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:60313 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaIBK57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:57:59 -0400
Message-ID: <5405A2B2.4010406@huawei.com>
Date: Tue, 2 Sep 2014 18:57:54 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 2/2] cgroup: check cgroup liveliness before unbreaking kernfs
 protection
References: <5405A27A.3090605@huawei.com>
In-Reply-To: <5405A27A.3090605@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020207.5405A2B5.00D9,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: d70464cfe201343c54ecb22fa0e1b6d3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cgroup_kn_lock_live() is called through some kernfs operation and
another thread is calling cgroup_rmdir(), we may trigger the warning in
cgroup_get().

------------[ cut here ]------------
WARNING: CPU: 1 PID: 1228 at kernel/cgroup.c:1034 cgroup_get+0x89/0xa0()
...
Call Trace:
 [<c16ee73d>] dump_stack+0x41/0x52
 [<c10468ef>] warn_slowpath_common+0x7f/0xa0
 [<c104692d>] warn_slowpath_null+0x1d/0x20
 [<c10bb999>] cgroup_get+0x89/0xa0
 [<c10bbe58>] cgroup_kn_lock_live+0x28/0x70
 [<c10be3c1>] __cgroup_procs_write.isra.26+0x51/0x230
 [<c10be5b2>] cgroup_tasks_write+0x12/0x20
 [<c10bb7b0>] cgroup_file_write+0x40/0x130
 [<c11aee71>] kernfs_fop_write+0xd1/0x160
 [<c1148e58>] vfs_write+0x98/0x1e0
 [<c114934d>] SyS_write+0x4d/0xa0
 [<c16f656b>] sysenter_do_call+0x12/0x12
---[ end trace 6f2e0c38c2108a74 ]---

Fix this by calling css_tryget() instead of cgroup_get().

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e03fc62..c8d07e5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1025,6 +1025,11 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
 	return mode;
 }
 
+static bool cgroup_tryget(struct cgroup *cgrp)
+{
+	return css_tryget(&cgrp->self);
+}
+
 static void cgroup_get(struct cgroup *cgrp)
 {
 	WARN_ON_ONCE(cgroup_is_dead(cgrp));
@@ -1091,7 +1096,8 @@ static struct cgroup *cgroup_kn_lock_live(struct kernfs_node *kn)
 	 * protection against removal.  Ensure @cgrp stays accessible and
 	 * break the active_ref protection.
 	 */
-	cgroup_get(cgrp);
+	if (!cgroup_tryget(cgrp))
+		return NULL;
 	kernfs_break_active_protection(kn);
 
 	mutex_lock(&cgroup_mutex);
-- 
1.8.0.2
