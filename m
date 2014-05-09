Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbaEIVb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:31:59 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:58025 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360AbaEIVb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:31:56 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        Tejun Heo <tj@kernel.org>, Aristeu Rozanski <aris@redhat.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: [PATCH 13/14] device_cgroup: use css_has_online_children() instead of has_children()
Date: Fri,  9 May 2014 17:31:30 -0400
Message-Id: <1399671091-23867-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399671091-23867-1-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devcgroup_update_access() wants to know whether there are child
cgroups which are online and visible to userland and has_children()
may return false positive.  Replace it with css_has_online_children().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>
---
 security/device_cgroup.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 75b4b18..22de334 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -475,21 +475,6 @@ static int propagate_exception(struct dev_cgroup *devcg_root,
 	return rc;
 }
 
-static inline bool has_children(struct dev_cgroup *devcgroup)
-{
-	bool ret;
-
-	/*
-	 * FIXME: There may be lingering offline csses and this function
-	 * may return %true when there isn't any userland-visible child
-	 * which is incorrect for our purposes.
-	 */
-	rcu_read_lock();
-	ret = css_next_child(NULL, &devcgroup->css);
-	rcu_read_unlock();
-	return ret;
-}
-
 /*
  * Modify the exception list using allow/deny rules.
  * CAP_SYS_ADMIN is needed for this.  It's at least separate from CAP_MKNOD
@@ -522,7 +507,7 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 	case 'a':
 		switch (filetype) {
 		case DEVCG_ALLOW:
-			if (has_children(devcgroup))
+			if (css_has_online_children(&devcgroup->css))
 				return -EINVAL;
 
 			if (!may_allow_all(parent))
@@ -538,7 +523,7 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 				return rc;
 			break;
 		case DEVCG_DENY:
-			if (has_children(devcgroup))
+			if (css_has_online_children(&devcgroup->css))
 				return -EINVAL;
 
 			dev_exception_clean(devcgroup);
-- 
1.9.0

