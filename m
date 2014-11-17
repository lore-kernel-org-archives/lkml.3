Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaKQU45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 15:56:57 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63226 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaKQU4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 15:56:55 -0500
Date: Mon, 17 Nov 2014 15:56:52 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3 cgroup/for-3.19] cgroup: add cgroup_subsys->css_released()
Message-ID: <20141117205652.GA23126@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new cgroup subsys callback css_released().  This is called when
the reference count of the css (cgroup_subsys_state) reaches zero
before RCU scheduling free.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |    2 ++
 2 files changed, 3 insertions(+)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -612,6 +612,7 @@ struct cgroup_subsys {
 	struct cgroup_subsys_state *(*css_alloc)(struct cgroup_subsys_state *parent_css);
 	int (*css_online)(struct cgroup_subsys_state *css);
 	void (*css_offline)(struct cgroup_subsys_state *css);
+	void (*css_released)(struct cgroup_subsys_state *css);
 	void (*css_free)(struct cgroup_subsys_state *css);
 	void (*css_reset)(struct cgroup_subsys_state *css);
 
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4380,6 +4380,8 @@ static void css_release_work_fn(struct w
 	if (ss) {
 		/* css release path */
 		cgroup_idr_remove(&ss->css_idr, css->id);
+		if (ss->css_released)
+			ss->css_released(css);
 	} else {
 		/* cgroup release path */
 		cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
