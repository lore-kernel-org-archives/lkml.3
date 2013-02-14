Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473Ab3BNQqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:46:46 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44237 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab3BNQqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:46:44 -0500
From: Jerry Snitselaar <jerry.snitselaar@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, serge.hallyn@canonical.com, tj@kernel.org,
        aris@redhat.com
Subject: [PATCH] device_cgroup: don't grab mutex in rcu callback
Date: Thu, 14 Feb 2013 09:46:03 -0700
Message-Id: <1360860363-2879-1-git-send-email-jerry.snitselaar@oracle.com>
X-Mailer: git-send-email 1.8.1.1.293.gfe73786
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 103a197 "security/device_cgroup: lock assert fails in
dev_exception_clean()" grabs devcgroup_mutex to fix assert failure,
but mutex can't be grabbed in rcu callback. Since there shouldn't be
any other references when css_free is called, mutex isn't needed for
list cleanup in devcgroup_css_free().

Signed-off-by: Jerry Snitselaar <jerry.snitselaar@oracle.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Aristeu Rozanski <aris@redhat.com>
---
 security/device_cgroup.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index d794abc..1c69e38 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -159,6 +159,16 @@ static void dev_exception_rm(struct dev_cgroup *dev_cgroup,
 	}
 }
 
+static void __dev_exception_clean(struct dev_cgroup *dev_cgroup)
+{
+	struct dev_exception_item *ex, *tmp;
+
+	list_for_each_entry_safe(ex, tmp, &dev_cgroup->exceptions, list) {
+		list_del_rcu(&ex->list);
+		kfree_rcu(ex, rcu);
+	}
+}
+
 /**
  * dev_exception_clean - frees all entries of the exception list
  * @dev_cgroup: dev_cgroup with the exception list to be cleaned
@@ -167,14 +177,9 @@ static void dev_exception_rm(struct dev_cgroup *dev_cgroup,
  */
 static void dev_exception_clean(struct dev_cgroup *dev_cgroup)
 {
-	struct dev_exception_item *ex, *tmp;
-
 	lockdep_assert_held(&devcgroup_mutex);
 
-	list_for_each_entry_safe(ex, tmp, &dev_cgroup->exceptions, list) {
-		list_del_rcu(&ex->list);
-		kfree_rcu(ex, rcu);
-	}
+	__dev_exception_clean(dev_cgroup);
 }
 
 /*
@@ -215,9 +220,7 @@ static void devcgroup_css_free(struct cgroup *cgroup)
 	struct dev_cgroup *dev_cgroup;
 
 	dev_cgroup = cgroup_to_devcgroup(cgroup);
-	mutex_lock(&devcgroup_mutex);
-	dev_exception_clean(dev_cgroup);
-	mutex_unlock(&devcgroup_mutex);
+	__dev_exception_clean(dev_cgroup);
 	kfree(dev_cgroup);
 }
 
-- 
1.8.1.1.293.gfe73786

