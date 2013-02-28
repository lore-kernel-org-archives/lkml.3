Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab3B1Osc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:48:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42175 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab3B1OsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:48:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 062/139] cpuset: fix cpuset_print_task_mems_allowed() vs rename() race
Date: Thu, 28 Feb 2013 14:43:32 +0000
Message-Id: <1362062689-2567-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 63f43f55c9bbc14f76b582644019b8a07dc8219a upstream.

rename() will change dentry->d_name. The result of this race can
be worse than seeing partially rewritten name, but we might access
a stale pointer because rename() will re-allocate memory to hold
a longer name.

It's safe in the protection of dentry->d_lock.

v2: check NULL dentry before acquiring dentry lock.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/cpuset.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 746d1ee..4611da5 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2468,8 +2468,16 @@ void cpuset_print_task_mems_allowed(struct task_struct *tsk)
 
 	dentry = task_cs(tsk)->css.cgroup->dentry;
 	spin_lock(&cpuset_buffer_lock);
-	snprintf(cpuset_name, CPUSET_NAME_LEN,
-		 dentry ? (const char *)dentry->d_name.name : "/");
+
+	if (!dentry) {
+		strcpy(cpuset_name, "/");
+	} else {
+		spin_lock(&dentry->d_lock);
+		strlcpy(cpuset_name, (const char *)dentry->d_name.name,
+			CPUSET_NAME_LEN);
+		spin_unlock(&dentry->d_lock);
+	}
+
 	nodelist_scnprintf(cpuset_nodelist, CPUSET_NODELIST_LEN,
 			   tsk->mems_allowed);
 	printk(KERN_INFO "%s cpuset=%s mems_allowed=%s\n",
-- 
1.8.1.2

