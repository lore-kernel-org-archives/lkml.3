Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3A2TIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:08:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab3A2TIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:08:04 -0500
Message-Id: <20130129190800.291395350@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Tue, 29 Jan 2013 14:08:06 -0500
From: aris@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH v3 7/9] devcg: split single exception copy from dev_exceptions_copy()
References: <20130129190759.117458287@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=exceptions_copy.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is in preparation for hierarchy support

Cc: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 security/device_cgroup.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- github.orig/security/device_cgroup.c	2013-01-29 11:49:16.076677425 -0500
+++ github/security/device_cgroup.c	2013-01-29 11:49:16.374681863 -0500
@@ -89,20 +89,30 @@ static int devcgroup_can_attach(struct c
 	return 0;
 }
 
+static int dev_exception_copy(struct list_head *dest,
+			      struct dev_exception_item *ex)
+{
+	struct dev_exception_item *new;
+
+	new = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+	list_add_tail(&new->list, dest);
+	return 0;
+}
+
 /*
  * called under devcgroup_mutex
  */
 static int dev_exceptions_copy(struct list_head *dest, struct list_head *orig)
 {
-	struct dev_exception_item *ex, *tmp, *new;
+	struct dev_exception_item *ex, *tmp;
 
 	lockdep_assert_held(&devcgroup_mutex);
 
 	list_for_each_entry(ex, orig, list) {
-		new = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
-		if (!new)
+		if (dev_exception_copy(dest, ex))
 			goto free_and_exit;
-		list_add_tail(&new->list, dest);
 	}
 
 	return 0;

