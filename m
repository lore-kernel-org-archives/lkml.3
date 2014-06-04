Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaFDItH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 04:49:07 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:63495 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaFDItE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 04:49:04 -0400
Message-ID: <538EDD4F.9010403@huawei.com>
Date: Wed, 4 Jun 2014 16:48:15 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v2] cgroup: don't destroy the default root
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default root is allocated and initialized at boot phase, so we
shouldn't destroy the default root when it's umounted, otherwise
it will lead to disaster.

Just try mount and then umount the default root, and the kernel will
crash immediately.

v2:
- No need to check for CSS_NO_REF in cgroup_get/put(). (Tejun)
- Better call cgroup_put() for the default root in kill_sb(). (Tejun)
- Add a comment.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a5f75ac..3f46165 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1780,8 +1780,11 @@ static void cgroup_kill_sb(struct super_block *sb)
 	 * If @root doesn't have any mounts or children, start killing it.
 	 * This prevents new mounts by disabling percpu_ref_tryget_live().
 	 * cgroup_mount() may wait for @root's release.
+	 *
+	 * And don't kill the default root.
 	 */
-	if (css_has_online_children(&root->cgrp.self))
+	if (css_has_online_children(&root->cgrp.self) ||
+	    root == &cgrp_dfl_root)
 		cgroup_put(&root->cgrp);
 	else
 		percpu_ref_kill(&root->cgrp.self.refcnt);
-- 
1.8.0.2
