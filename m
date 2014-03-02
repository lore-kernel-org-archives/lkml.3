Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaCBDA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 22:00:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19277 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbaCBDA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 22:00:28 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: tj@kernel.org, lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] cgroup: missing rcu read lock around task_css_set
Date: Sat,  1 Mar 2014 22:00:11 -0500
Message-Id: <1393729211-937-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu read lock should be held when calling and working with task_css_set.

This patch also fixes a related lockdep warning.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/cgroup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8f4ddbe..f638ad6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4361,6 +4361,7 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 	}
 
 	/* Reassign the task to the init_css_set. */
+	rcu_read_lock();
 	cset = task_css_set(tsk);
 	RCU_INIT_POINTER(tsk->cgroups, &init_css_set);
 
@@ -4378,6 +4379,7 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 
 	if (put_cset)
 		put_css_set(cset, true);
+	rcu_read_unlock();
 }
 
 static void check_for_release(struct cgroup *cgrp)
-- 
1.7.2.5

