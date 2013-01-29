Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3A2TIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:08:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab3A2TIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:08:04 -0500
Message-Id: <20130129190759.993951510@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Tue, 29 Jan 2013 14:08:04 -0500
From: aris@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH v3 5/9] devcg: prepare may_access() for hierarchy support
References: <20130129190759.117458287@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=strengthen-may_access.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently may_access() is only able to verify if an exception is valid for the
current cgroup, which has the same behavior. With hierarchy, it'll be also used
to verify if a cgroup local exception is valid towards its cgroup parent, which
might have different behavior.

v2:
- updated patch description
- rebased on top of a new patch to expand the may_access() logic to make it
  more clear
- fixed argument description order in may_access()

Cc: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 security/device_cgroup.c |   44 +++++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

--- github.orig/security/device_cgroup.c	2013-01-29 11:49:15.514669057 -0500
+++ github/security/device_cgroup.c	2013-01-29 11:49:15.795673240 -0500
@@ -354,9 +354,11 @@ 	return 0;
  *		verify if a certain access is allowed.
  * @dev_cgroup: dev cgroup to be tested against
  * @refex: new exception
+ * @behavior: behavior of the exception
  */
-static int may_access(struct dev_cgroup *dev_cgroup,
-		      struct dev_exception_item *refex)
+static bool may_access(struct dev_cgroup *dev_cgroup,
+		       struct dev_exception_item *refex,
+		       enum devcg_behavior behavior)
 {
 	struct dev_exception_item *ex;
 	bool match = false;
@@ -380,19 +382,27 @@ 		if (ex->minor != ~0 && ex->minor != re
 		break;
 	}
 
-	/*
-	 * In two cases we'll consider this new exception valid:
-	 * - the dev cgroup has its default policy to deny + exception list:
-	 *   the new exception *should* match the exceptions
-	 * - the dev cgroup has its default policy to allow + exception list:
-	 *   the new exception should *not* match any of the exceptions
-	 */
-	if (dev_cgroup->behavior == DEVCG_DEFAULT_DENY) {
-		if (match)
-			return 1;
+	if (dev_cgroup->behavior == DEVCG_DEFAULT_ALLOW) {
+		if (behavior == DEVCG_DEFAULT_ALLOW) {
+			/* the exception will deny access to certain devices */
+			return true;
+		} else {
+			/* the exception will allow access to certain devices */
+			if (match)
+				/*
+				 * a new exception allowing access shouldn't
+				 * match an parent's exception
+				 */
+				return false;
+			return true;
+		}
 	} else {
-		if (!match)
-			return 1;
+		/* only behavior == DEVCG_DEFAULT_DENY allowed here */
+		if (match)
+			/* parent has an exception that matches the proposed */
+			return true;
+		else
+			return false;
 	}
 	return 0;
 }
@@ -411,7 +421,7 @@ static int parent_has_perm(struct dev_cg
 	if (!pcg)
 		return 1;
 	parent = cgroup_to_devcgroup(pcg);
-	return may_access(parent, ex);
+	return may_access(parent, ex, childcg->behavior);
 }
 
 /**
@@ -445,7 +455,7 @@ static int devcgroup_update_access(struc
 {
 	const char *b;
 	char temp[12];		/* 11 + 1 characters needed for a u32 */
-	int count, rc;
+	int count, rc = 0;
 	struct dev_exception_item ex;
 	struct cgroup *p = devcgroup->css.cgroup;
 	struct dev_cgroup *parent = NULL;
@@ -663,7 +673,7 @@ 	memset(&ex, 0, sizeof(ex));
 
 	rcu_read_lock();
 	dev_cgroup = task_devcgroup(current);
-	rc = may_access(dev_cgroup, &ex);
+	rc = may_access(dev_cgroup, &ex, dev_cgroup->behavior);
 	rcu_read_unlock();
 
 	if (!rc)

