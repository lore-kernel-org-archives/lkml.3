Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3CATqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:46:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3CATq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>
Subject: [ 35/46] cpuset: fix cpuset_print_task_mems_allowed() vs rename() race
Date: Fri,  1 Mar 2013 11:45:23 -0800
Message-Id: <20130301194435.984059113@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194432.263409302@linuxfoundation.org>
References: <20130301194432.263409302@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cpuset.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2479,8 +2479,16 @@ void cpuset_print_task_mems_allowed(stru
 
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


