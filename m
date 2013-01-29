Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3A2TIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:08:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319Ab3A2TIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:08:04 -0500
Message-Id: <20130129190800.123213034@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Tue, 29 Jan 2013 14:08:05 -0500
From: aris@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH v3 6/9] devcg: use css_online and css_offline
References: <20130129190759.117458287@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=online.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate resources and change behavior only when online.
This patch is in preparation for hierarchy support.

Cc: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 security/device_cgroup.c |   59 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 17 deletions(-)

--- github.orig/security/device_cgroup.c	2013-01-29 11:49:15.795673240 -0500
+++ github/security/device_cgroup.c	2013-01-29 11:49:16.076677425 -0500
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
 

