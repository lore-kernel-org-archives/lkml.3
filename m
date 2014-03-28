Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbaC1Cmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 22:42:55 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:57514 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499AbaC1Cl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 22:41:27 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/12] cgroup: add css_set->dfl_cgrp
Date: Thu, 27 Mar 2014 22:40:58 -0400
Message-Id: <1395974461-12735-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395974461-12735-1-git-send-email-tj@kernel.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To implement the unified hierarchy behavior, we'll need to be able to
determine the associated cgroup on the default hierarchy from css_set.
Let's add css_set->dfl_cgrp so that it can be accessed conveniently
and efficiently.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 3 +++
 kernel/cgroup.c        | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index cbfd8be..b6f5e40 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -354,6 +354,9 @@ struct css_set {
 	 */
 	struct list_head cgrp_links;
 
+	/* the default cgroup associated with this css_set */
+	struct cgroup *dfl_cgrp;
+
 	/*
 	 * Set of subsystem states, one for each subsystem. This array is
 	 * immutable after creation apart from the init_css_set during
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 30f48b0..e714ccf 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -651,6 +651,10 @@ static void link_css_set(struct list_head *tmp_links, struct css_set *cset,
 	struct cgrp_cset_link *link;
 
 	BUG_ON(list_empty(tmp_links));
+
+	if (cgroup_on_dfl(cgrp))
+		cset->dfl_cgrp = cgrp;
+
 	link = list_first_entry(tmp_links, struct cgrp_cset_link, cset_link);
 	link->cset = cset;
 	link->cgrp = cgrp;
-- 
1.8.5.3

