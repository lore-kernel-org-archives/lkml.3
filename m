Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab3CDD6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:58:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32989 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756387Ab3CDDoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:08 -0500
Message-Id: <20130304033714.231956944@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:15 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Li Zefan <lizefan@huawei.com>,
        Tejun Heo <tj@kernel.org>
Subject: [ 068/153] cpuset: fix cpuset_print_task_mems_allowed() vs rename() race
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/cpuset.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2507,8 +2507,16 @@ void cpuset_print_task_mems_allowed(stru
 
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


