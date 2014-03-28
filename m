Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbaC1ClT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 22:41:19 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:37210 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468AbaC1ClP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 22:41:15 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/12] cgroup: make css_next_child() skip missing csses
Date: Thu, 27 Mar 2014 22:40:53 -0400
Message-Id: <1395974461-12735-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395974461-12735-1-git-send-email-tj@kernel.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

css_next_child() walks the children of the specified css.  It does
this by finding the next cgroup and then returning the requested css.
On the default unified hierarchy, a cgroup may not have a css
associated with it even if the hierarchy has the subsystem enabled.
This patch updates css_next_child() so that it skips children without
the requested css associated.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2899a6f..9d2d6ef 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2690,10 +2690,19 @@ css_next_child(struct cgroup_subsys_state *pos_css,
 				break;
 	}
 
-	if (&next->sibling == &cgrp->children)
-		return NULL;
+	/*
+	 * @next, if not pointing to the head, can be dereferenced and is
+	 * the next sibling; however, it might have @ss disabled.  If so,
+	 * fast-forward to the next enabled one.
+	 */
+	while (&next->sibling != &cgrp->children) {
+		struct cgroup_subsys_state *next_css = cgroup_css(next, parent_css->ss);
 
-	return cgroup_css(next, parent_css->ss);
+		if (next_css)
+			return next_css;
+		next = list_entry_rcu(next->sibling.next, struct cgroup, sibling);
+	}
+	return NULL;
 }
 
 /**
-- 
1.8.5.3

