Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab3AXTuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:50:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab3AXTuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:50:01 -0500
Message-Id: <20130124194957.375712635@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Thu, 24 Jan 2013 14:49:58 -0500
From: aris@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH v2 1/4] device_cgroup: prepare exception list handling functions for two lists
References: <20130124194957.198022148@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=dev_exception_helpers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the following patches, device_cgroup structure will have two sets of
behavior and exceptions list (actual one, another with the local settings)
so rework the functions to use exception list, not a device_cgroup.

Cc: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 security/device_cgroup.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- github.orig/security/device_cgroup.c	2013-01-24 10:40:32.814051897 -0500
+++ github/security/device_cgroup.c	2013-01-24 10:40:33.913068234 -0500
@@ -104,7 +104,7 @@ free_and_exit:
 /*
  * called under devcgroup_mutex
  */
-static int dev_exception_add(struct dev_cgroup *dev_cgroup,
+static int dev_exception_add(struct list_head *exceptions,
 			     struct dev_exception_item *ex)
 {
 	struct dev_exception_item *excopy, *walk;
@@ -115,7 +115,7 @@ static int dev_exception_add(struct dev_
 	if (!excopy)
 		return -ENOMEM;
 
-	list_for_each_entry(walk, &dev_cgroup->exceptions, list) {
+	list_for_each_entry(walk, exceptions, list) {
 		if (walk->type != ex->type)
 			continue;
 		if (walk->major != ex->major)
@@ -129,21 +129,21 @@ static int dev_exception_add(struct dev_
 	}
 
 	if (excopy != NULL)
-		list_add_tail_rcu(&excopy->list, &dev_cgroup->exceptions);
+		list_add_tail_rcu(&excopy->list, exceptions);
 	return 0;
 }
 
 /*
  * called under devcgroup_mutex
  */
-static void dev_exception_rm(struct dev_cgroup *dev_cgroup,
+static void dev_exception_rm(struct list_head *exceptions,
 			     struct dev_exception_item *ex)
 {
 	struct dev_exception_item *walk, *tmp;
 
 	lockdep_assert_held(&devcgroup_mutex);
 
-	list_for_each_entry_safe(walk, tmp, &dev_cgroup->exceptions, list) {
+	list_for_each_entry_safe(walk, tmp, exceptions, list) {
 		if (walk->type != ex->type)
 			continue;
 		if (walk->major != ex->major)
@@ -514,10 +514,10 @@ 		case '\0':
 		 * don't want to break compatibility
 		 */
 		if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
-			dev_exception_rm(devcgroup, &ex);
+			dev_exception_rm(&devcgroup->exceptions, &ex);
 			return 0;
 		}
-		return dev_exception_add(devcgroup, &ex);
+		return dev_exception_add(&devcgroup->exceptions, &ex);
 	case DEVCG_DENY:
 		/*
 		 * If the default policy is to deny by default, try to remove
@@ -525,10 +525,10 @@ 			return 0;
 		 * don't want to break compatibility
 		 */
 		if (devcgroup->behavior == DEVCG_DEFAULT_DENY) {
-			dev_exception_rm(devcgroup, &ex);
+			dev_exception_rm(&devcgroup->exceptions, &ex);
 			return 0;
 		}
-		return dev_exception_add(devcgroup, &ex);
+		return dev_exception_add(&devcgroup->exceptions, &ex);
 	default:
 		return -EINVAL;
 	}

