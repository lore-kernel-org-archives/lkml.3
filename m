Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaHYL2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:28:41 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:42398 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753795AbaHYL2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:28:38 -0400
X-IronPort-AV: E=Sophos;i="5.04,396,1406563200"; 
   d="scan'208";a="35035611"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <tj@kernel.org>, <lizefan@huawei.com>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] cgroup: Enable controllers for default hierarchy by default.
Date: Mon, 25 Aug 2014 19:27:32 +0800
Message-ID: <1408966052-2076-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we create a cgroup in unified hierarchy, we have to enable
controllers in cgrp_dfl_root.subtree_control manually. From
my practice, I did not find the benefit we disable controllers
in cgrp_dfl_root by default.

As I am a newbie to cgroup, please correct me if I am wrong.

Thanx.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/cgroup.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7dc8788..70996ee 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1267,12 +1267,9 @@ static int rebind_subsystems(struct cgroup_root *dst_root, unsigned int ss_mask)
 		src_root->cgrp.subtree_control &= ~(1 << ssid);
 		cgroup_refresh_child_subsys_mask(&src_root->cgrp);
 
-		/* default hierarchy doesn't enable controllers by default */
 		dst_root->subsys_mask |= 1 << ssid;
-		if (dst_root != &cgrp_dfl_root) {
-			dst_root->cgrp.subtree_control |= 1 << ssid;
-			cgroup_refresh_child_subsys_mask(&dst_root->cgrp);
-		}
+		dst_root->cgrp.subtree_control |= 1 << ssid;
+		cgroup_refresh_child_subsys_mask(&dst_root->cgrp);
 
 		if (ss->bind)
 			ss->bind(css);
@@ -4990,6 +4987,8 @@ int __init cgroup_init(void)
 		}
 	}
 
+	cgrp_dfl_root.cgrp.subtree_control = cgrp_dfl_root.subsys_mask;
+
 	cgroup_kobj = kobject_create_and_add("cgroup", fs_kobj);
 	if (!cgroup_kobj)
 		return -ENOMEM;
-- 
1.8.4.2

