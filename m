Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbaEIVOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:14:31 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:36082 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812AbaEIVNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:13:48 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/9] cgroup: bounce css release through css->destroy_work
Date: Fri,  9 May 2014 17:13:33 -0400
Message-Id: <1399670015-23463-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399670015-23463-1-git-send-email-tj@kernel.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

css release is planned to do more and would require process context.
Bounce it through css->destroy_work.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bb67acb..b382383 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4125,10 +4125,10 @@ static void css_free_rcu_fn(struct rcu_head *rcu_head)
 	queue_work(cgroup_destroy_wq, &css->destroy_work);
 }
 
-static void css_release(struct percpu_ref *ref)
+static void css_release_work_fn(struct work_struct *work)
 {
 	struct cgroup_subsys_state *css =
-		container_of(ref, struct cgroup_subsys_state, refcnt);
+		container_of(work, struct cgroup_subsys_state, destroy_work);
 	struct cgroup_subsys *ss = css->ss;
 
 	cgroup_idr_remove(&ss->css_idr, css->id);
@@ -4136,6 +4136,15 @@ static void css_release(struct percpu_ref *ref)
 	call_rcu(&css->rcu_head, css_free_rcu_fn);
 }
 
+static void css_release(struct percpu_ref *ref)
+{
+	struct cgroup_subsys_state *css =
+		container_of(ref, struct cgroup_subsys_state, refcnt);
+
+	INIT_WORK(&css->destroy_work, css_release_work_fn);
+	queue_work(cgroup_destroy_wq, &css->destroy_work);
+}
+
 static void init_and_link_css(struct cgroup_subsys_state *css,
 			      struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
-- 
1.9.0

