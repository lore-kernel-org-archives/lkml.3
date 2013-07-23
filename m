Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636Ab3GWSQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:16:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55594 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204Ab3GWSQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:16:13 -0400
Date: Tue, 23 Jul 2013 13:16:06 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [RFC PATCH 1/2] devices cgroup: allow can_attach() if ns_capable
Message-ID: <20130723181606.GA6342@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allow a task to change its own devices cgroup, or to change other tasks'
cgroups if it has CAP_SYS_ADMIN.

Also allow task A to change task B's cgroup if task A has CAP_SYS_ADMIN
with respect to task B - meaning A is root in the same userns, or A
created B's userns.

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
---
 security/device_cgroup.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 9760ecb6..8f5386ea 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -74,11 +74,14 @@ struct cgroup_subsys devices_subsys;
 static int devcgroup_can_attach(struct cgroup *new_cgrp,
 				struct cgroup_taskset *set)
 {
-	struct task_struct *task = cgroup_taskset_first(set);
+	struct task_struct *t = cgroup_taskset_first(set);
+	int ret = 0;
 
-	if (current != task && !capable(CAP_SYS_ADMIN))
-		return -EPERM;
-	return 0;
+	rcu_read_lock();
+	if (current != t && !ns_capable(__task_cred(t)->user_ns, CAP_SYS_ADMIN))
+		ret = -EPERM;
+	rcu_read_unlock();
+	return ret;
 }
 
 /*
-- 
1.7.9.5

