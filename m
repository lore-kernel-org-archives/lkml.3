Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610AbaLEB5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 20:57:49 -0500
Received: from mail-pd0-f201.google.com ([209.85.192.201]:38417 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506AbaLEB4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 20:56:36 -0500
From: Aditya Kali <adityakali@google.com>
To: tj@kernel.org, lizefan@huawei.com, serge.hallyn@ubuntu.com,
        luto@amacapital.net, ebiederm@xmission.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mingo@redhat.com
Cc: containers@lists.linux-foundation.org, jnagal@google.com,
        vgoyal@redhat.com, richard.weinberger@gmail.com,
        Aditya Kali <adityakali@google.com>
Subject: [PATCHv3 4/8] cgroup: export cgroup_get() and cgroup_put()
Date: Thu,  4 Dec 2014 17:55:46 -0800
Message-Id: <1417744550-6461-5-git-send-email-adityakali@google.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1417744550-6461-1-git-send-email-adityakali@google.com>
References: <adityakali-cgroupns>
 <1417744550-6461-1-git-send-email-adityakali@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move cgroup_get() and cgroup_put() into cgroup.h so that
they can be called from other places.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Aditya Kali <adityakali@google.com>
---
 include/linux/cgroup.h | 22 ++++++++++++++++++++++
 kernel/cgroup.c        | 22 ----------------------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index d6930de..6e7533b 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -521,6 +521,28 @@ static inline bool cgroup_on_dfl(const struct cgroup *cgrp)
 	return cgrp->root == &cgrp_dfl_root;
 }
 
+/* convenient tests for these bits */
+static inline bool cgroup_is_dead(const struct cgroup *cgrp)
+{
+	return !(cgrp->self.flags & CSS_ONLINE);
+}
+
+static inline void cgroup_get(struct cgroup *cgrp)
+{
+	WARN_ON_ONCE(cgroup_is_dead(cgrp));
+	css_get(&cgrp->self);
+}
+
+static inline bool cgroup_tryget(struct cgroup *cgrp)
+{
+	return css_tryget(&cgrp->self);
+}
+
+static inline void cgroup_put(struct cgroup *cgrp)
+{
+	css_put(&cgrp->self);
+}
+
 /* no synchronization, the result can only be used as a hint */
 static inline bool cgroup_has_tasks(struct cgroup *cgrp)
 {
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5d8fc84..e12d36e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -321,12 +321,6 @@ out_unlock:
 	return css;
 }
 
-/* convenient tests for these bits */
-static inline bool cgroup_is_dead(const struct cgroup *cgrp)
-{
-	return !(cgrp->self.flags & CSS_ONLINE);
-}
-
 struct cgroup_subsys_state *of_css(struct kernfs_open_file *of)
 {
 	struct cgroup *cgrp = of->kn->parent->priv;
@@ -1039,22 +1033,6 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
 	return mode;
 }
 
-static void cgroup_get(struct cgroup *cgrp)
-{
-	WARN_ON_ONCE(cgroup_is_dead(cgrp));
-	css_get(&cgrp->self);
-}
-
-static bool cgroup_tryget(struct cgroup *cgrp)
-{
-	return css_tryget(&cgrp->self);
-}
-
-static void cgroup_put(struct cgroup *cgrp)
-{
-	css_put(&cgrp->self);
-}
-
 /**
  * cgroup_calc_child_subsys_mask - calculate child_subsys_mask
  * @cgrp: the target cgroup
-- 
2.2.0.rc0.207.ga3a616c

