Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaDALQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:16:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42174 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaDALQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 021/144] cpuset: fix a race condition in __cpuset_node_allowed_softwall()
Date: Tue,  1 Apr 2014 12:13:45 +0100
Message-Id: <1396350948-29910-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 99afb0fd5f05aac467ffa85c36778fec4396209b upstream.

It's not safe to access task's cpuset after releasing task_lock().
Holding callback_mutex won't help.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 84773c7..26e7a5d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2518,9 +2518,9 @@ int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
 
 	task_lock(current);
 	cs = nearest_hardwall_ancestor(task_cs(current));
+	allowed = node_isset(node, cs->mems_allowed);
 	task_unlock(current);
 
-	allowed = node_isset(node, cs->mems_allowed);
 	mutex_unlock(&callback_mutex);
 	return allowed;
 }
-- 
1.9.1

