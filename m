Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab3A3RNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:13:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866Ab3A3RLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:11:07 -0500
Message-Id: <20130130171102.253395279@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Wed, 30 Jan 2013 12:11:09 -0500
From: aris@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH v4 8/9] devcg: refactor dev_exception_clean()
References: <20130130171101.060853036@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=exception_clean.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is in preparation for hierarchy support.

This patch doesn't introduce any functional changes.

Acked-by: Tejun Heo <tj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 security/device_cgroup.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

--- github.orig/security/device_cgroup.c	2013-01-29 11:49:16.374681863 -0500
+++ github/security/device_cgroup.c	2013-01-29 11:49:16.653686016 -0500
@@ -212,32 +212,33 @@ static int dev_exception_add(struct dev_
 	return rc;
 }
 
-static void __dev_exception_clean(struct dev_cgroup *dev_cgroup)
+static void dev_exception_clean(struct list_head *exceptions)
 {
 	struct dev_exception_item *ex, *tmp;
 
-	list_for_each_entry_safe(ex, tmp, &dev_cgroup->exceptions, list) {
-		list_del_rcu(&ex->list);
-		kfree_rcu(ex, rcu);
-	}
-	list_for_each_entry_safe(ex, tmp, &dev_cgroup->local.exceptions,
-				 list) {
+	list_for_each_entry_safe(ex, tmp, exceptions, list) {
 		list_del_rcu(&ex->list);
 		kfree_rcu(ex, rcu);
 	}
 }
 
+static void __dev_exception_clean_all(struct dev_cgroup *dev_cgroup)
+{
+	dev_exception_clean(&dev_cgroup->exceptions);
+	dev_exception_clean(&dev_cgroup->local.exceptions);
+}
+
 /**
- * dev_exception_clean - frees all entries of the exception list
+ * dev_exception_clean_all - frees all entries of the exception list
  * @dev_cgroup: dev_cgroup with the exception list to be cleaned
  *
  * called under devcgroup_mutex
  */
-static void dev_exception_clean(struct dev_cgroup *dev_cgroup)
+static void dev_exception_clean_all(struct dev_cgroup *dev_cgroup)
 {
 	lockdep_assert_held(&devcgroup_mutex);
 
-	__dev_exception_clean(dev_cgroup);
+	__dev_exception_clean_all(dev_cgroup);
 }
 
 /**
@@ -303,7 +304,7 @@ static void devcgroup_css_free(struct cg
 	struct dev_cgroup *dev_cgroup;
 
 	dev_cgroup = cgroup_to_devcgroup(cgroup);
-	__dev_exception_clean(dev_cgroup);
+	__dev_exception_clean_all(dev_cgroup);
 	kfree(dev_cgroup);
 }
 
@@ -508,25 +509,22 @@ 	memset(&ex, 0, sizeof(ex));
 		case DEVCG_ALLOW:
 			if (!may_allow_all(parent))
 				return -EPERM;
-			dev_exception_clean(devcgroup);
+			dev_exception_clean_all(devcgroup);
 			if (parent)
 				rc = dev_exceptions_copy(&devcgroup->exceptions,
 							 &parent->exceptions);
 			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
 			devcgroup->local.behavior = DEVCG_DEFAULT_ALLOW;
-
-			if (rc)
-				return rc;
 			break;
 		case DEVCG_DENY:
-			dev_exception_clean(devcgroup);
+			dev_exception_clean_all(devcgroup);
 			devcgroup->behavior = DEVCG_DEFAULT_DENY;
 			devcgroup->local.behavior = DEVCG_DEFAULT_DENY;
 			break;
 		default:
-			return -EINVAL;
+			rc = -EINVAL;
 		}
-		return 0;
+		return rc;
 	case 'b':
 		ex.type = DEV_BLOCK;
 		break;

