Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbaEIVbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:31:47 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:56701 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603AbaEIVbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:31:42 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        Tejun Heo <tj@kernel.org>, Aristeu Rozanski <aris@redhat.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: [PATCH 04/14] device_cgroup: remove direct access to cgroup->children
Date: Fri,  9 May 2014 17:31:21 -0400
Message-Id: <1399671091-23867-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399671091-23867-1-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, devcg::has_children() directly tests cgroup->children for
list emptiness.  The field is not a published field and scheduled to
go away.  In addition, the test isn't strictly correct as devcg should
only care about children which are visible to userland.

This patch converts has_children() to use css_next_child() instead.
The subtle incorrectness is noted and will be dealt with later.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>
---
 security/device_cgroup.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 3116015..75b4b18 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -477,9 +477,17 @@ static int propagate_exception(struct dev_cgroup *devcg_root,
 
 static inline bool has_children(struct dev_cgroup *devcgroup)
 {
-	struct cgroup *cgrp = devcgroup->css.cgroup;
+	bool ret;
 
-	return !list_empty(&cgrp->children);
+	/*
+	 * FIXME: There may be lingering offline csses and this function
+	 * may return %true when there isn't any userland-visible child
+	 * which is incorrect for our purposes.
+	 */
+	rcu_read_lock();
+	ret = css_next_child(NULL, &devcgroup->css);
+	rcu_read_unlock();
+	return ret;
 }
 
 /*
-- 
1.9.0

