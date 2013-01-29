Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab3A2TJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:09:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab3A2TIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:08:05 -0500
Message-Id: <20130129190759.321644928@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Tue, 29 Jan 2013 14:08:00 -0500
From: aris@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH v3 1/9] device_cgroup: prepare exception list handling functions for two lists
References: <20130129190759.117458287@napanee.usersys.redhat.com>
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

--- github.orig/security/device_cgroup.c	2013-01-29 11:48:50.603298122 -0500
+++ github/security/device_cgroup.c	2013-01-29 11:49:14.739657516 -0500
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

