Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936740Ab3DICXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 22:23:49 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:34323 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933403Ab3DICXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 22:23:44 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, acme@ghostprotocols.net,
        eranian@google.com, namhyung.kim@lge.com, lizefan@huawei.com,
        mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3] cgroup: implement cgroup_is_descendant()
Date: Mon,  8 Apr 2013 19:23:32 -0700
Message-Id: <1365474213-13354-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365474213-13354-1-git-send-email-tj@kernel.org>
References: <1365474213-13354-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizefan@huawei.com>

A couple controllers want to determine whether two cgroups are in
ancestor/descendant relationship.  As it's more likely that the
descendant is the primary subject of interest and there are other
operations focusing on the descendants, let's ask is_descendent rather
than is_ancestor.

Implementation is trivial as the previous patch guarantees that all
ancestors of a cgroup stay accessible as long as the cgroup is
accessible.

tj: Removed depth optimization, renamed from cgroup_is_ancestor(),
    rewrote descriptions.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup.c        | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 515927e..45aee0f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -439,6 +439,7 @@ int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 int cgroup_rm_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 
 int cgroup_is_removed(const struct cgroup *cgrp);
+bool cgroup_is_descendant(struct cgroup *cgrp, struct cgroup *ancestor);
 
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d7dfa64..678a22c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -276,6 +276,26 @@ inline int cgroup_is_removed(const struct cgroup *cgrp)
 	return test_bit(CGRP_REMOVED, &cgrp->flags);
 }
 
+/**
+ * cgroup_is_descendant - test ancestry
+ * @cgrp: the cgroup to be tested
+ * @ancestor: possible ancestor of @cgrp
+ *
+ * Test whether @cgrp is a descendant of @ancestor.  It also returns %true
+ * if @cgrp == @ancestor.  This function is safe to call as long as @cgrp
+ * and @ancestor are accessible.
+ */
+bool cgroup_is_descendant(struct cgroup *cgrp, struct cgroup *ancestor)
+{
+	while (cgrp) {
+		if (cgrp == ancestor)
+			return true;
+		cgrp = cgrp->parent;
+	}
+	return false;
+}
+EXPORT_SYMBOL_GPL(cgroup_is_descendant);
+
 /* bits in struct cgroupfs_root flags field */
 enum {
 	ROOT_NOPREFIX,	/* mounted subsystems have no named prefix */
-- 
1.8.1.4

