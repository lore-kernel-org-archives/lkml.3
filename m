Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaDAQT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:19:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44719 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbaDAQQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:16:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 31/86] cpuset: fix a race condition in __cpuset_node_allowed_softwall()
Date: Tue,  1 Apr 2014 09:07:44 -0700
Message-Id: <1396368519-12728-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 99afb0fd5f05aac467ffa85c36778fec4396209b upstream.

It's not safe to access task's cpuset after releasing task_lock().
Holding callback_mutex won't help.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index aa4ec01..47e7595 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2370,9 +2370,9 @@ int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
 
 	task_lock(current);
 	cs = nearest_hardwall_ancestor(task_cs(current));
+	allowed = node_isset(node, cs->mems_allowed);
 	task_unlock(current);
 
-	allowed = node_isset(node, cs->mems_allowed);
 	mutex_unlock(&callback_mutex);
 	return allowed;
 }
-- 
1.8.3.2

