Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab3A3RLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:11:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab3A3RLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:11:09 -0500
Message-Id: <20130130171101.947461296@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Wed, 30 Jan 2013 12:11:07 -0500
From: aris@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH v4 6/9] devcg: use css_online and css_offline
References: <20130130171101.060853036@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=online.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate resources and change behavior only when online. This is needed in
order to determine if a node is suitable for hierarchy propagation or if it's
being removed.

Locking:
Both functions take devcgroup_mutex to make changes to device_cgroup structure.
Hierarchy propagation will also take devcgroup_mutex before walking the
tree while walking the tree itself is protected by rcu lock.

Acked-by: Tejun Heo <tj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 security/device_cgroup.c |   59 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 17 deletions(-)

--- github.orig/security/device_cgroup.c	2013-01-30 09:00:09.435351867 -0500
+++ github/security/device_cgroup.c	2013-01-30 09:09:12.572464122 -0500
@@ -230,14 +230,51 @@ static void dev_exception_clean(struct d
 	__dev_exception_clean(dev_cgroup);
 }
 
+/**
+ * devcgroup_online - initializes devcgroup's behavior and exceptions based on
+ * 		      parent's
+ * @cgroup: cgroup getting online
+ * returns 0 in case of success, error code otherwise
+ */
+static int devcgroup_online(struct cgroup *cgroup)
+{
+	struct dev_cgroup *dev_cgroup, *parent_dev_cgroup = NULL;
+	int ret = 0;
+
+	mutex_lock(&devcgroup_mutex);
+	dev_cgroup = cgroup_to_devcgroup(cgroup);
+	if (cgroup->parent)
+		parent_dev_cgroup = cgroup_to_devcgroup(cgroup->parent);
+
+	if (parent_dev_cgroup == NULL)
+		dev_cgroup->behavior = DEVCG_DEFAULT_ALLOW;
+	else {
+		ret = dev_exceptions_copy(&dev_cgroup->exceptions,
+					  &parent_dev_cgroup->exceptions);
+		if (!ret)
+			dev_cgroup->behavior = parent_dev_cgroup->behavior;
+	}
+	mutex_unlock(&devcgroup_mutex);
+
+	return ret;
+}
+
+static void devcgroup_offline(struct cgroup *cgroup)
+{
+	struct dev_cgroup *dev_cgroup = cgroup_to_devcgroup(cgroup);
+
+	mutex_lock(&devcgroup_mutex);
+	dev_cgroup->behavior = DEVCG_DEFAULT_NONE;
+	mutex_unlock(&devcgroup_mutex);
+}
+
 /*
  * called from kernel/cgroup.c with cgroup_lock() held.
  */
 static struct cgroup_subsys_state *devcgroup_css_alloc(struct cgroup *cgroup)
 {
-	struct dev_cgroup *dev_cgroup, *parent_dev_cgroup;
+	struct dev_cgroup *dev_cgroup;
 	struct cgroup *parent_cgroup;
-	int ret;
 
 	dev_cgroup = kzalloc(sizeof(*dev_cgroup), GFP_KERNEL);
 	if (!dev_cgroup)
@@ -245,23 +282,9 @@ static struct cgroup_subsys_state *devcg
 	INIT_LIST_HEAD(&dev_cgroup->exceptions);
 	INIT_LIST_HEAD(&dev_cgroup->local.exceptions);
 	dev_cgroup->local.behavior = DEVCG_DEFAULT_NONE;
+	dev_cgroup->behavior = DEVCG_DEFAULT_NONE;
 	parent_cgroup = cgroup->parent;
 
-	if (parent_cgroup == NULL)
-		dev_cgroup->behavior = DEVCG_DEFAULT_ALLOW;
-	else {
-		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
-		mutex_lock(&devcgroup_mutex);
-		ret = dev_exceptions_copy(&dev_cgroup->exceptions,
-					  &parent_dev_cgroup->exceptions);
-		dev_cgroup->behavior = parent_dev_cgroup->behavior;
-		mutex_unlock(&devcgroup_mutex);
-		if (ret) {
-			kfree(dev_cgroup);
-			return ERR_PTR(ret);
-		}
-	}
-
 	return &dev_cgroup->css;
 }
 
@@ -635,6 +658,8 @@ struct cgroup_subsys devices_subsys = {
 	.can_attach = devcgroup_can_attach,
 	.css_alloc = devcgroup_css_alloc,
 	.css_free = devcgroup_css_free,
+	.css_online = devcgroup_online,
+	.css_offline = devcgroup_offline,
 	.subsys_id = devices_subsys_id,
 	.base_cftypes = dev_cgroup_files,
 

