Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab3BOQ4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:56:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037Ab3BOQzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:55:48 -0500
Message-Id: <20130215165543.593955369@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Feb 2013 11:55:46 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH v5 3/4] devcg: use css_online and css_offline
References: <20130215165543.131282532@napanee.usersys.redhat.com>
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
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 security/device_cgroup.c |   59 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 17 deletions(-)

--- github.orig/security/device_cgroup.c	2013-02-14 10:47:12.411181646 -0500
+++ github/security/device_cgroup.c	2013-02-14 10:47:12.701185704 -0500
@@ -180,36 +180,59 @@ static void dev_exception_clean(struct d
 	}
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
 		return ERR_PTR(-ENOMEM);
 	INIT_LIST_HEAD(&dev_cgroup->exceptions);
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
 
@@ -584,6 +607,8 @@ struct cgroup_subsys devices_subsys = {
 	.can_attach = devcgroup_can_attach,
 	.css_alloc = devcgroup_css_alloc,
 	.css_free = devcgroup_css_free,
+	.css_online = devcgroup_online,
+	.css_offline = devcgroup_offline,
 	.subsys_id = devices_subsys_id,
 	.base_cftypes = dev_cgroup_files,
 

