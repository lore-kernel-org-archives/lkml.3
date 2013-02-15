Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab3BOQ4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:56:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab3BOQzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:55:48 -0500
Message-Id: <20130215165543.311073984@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Feb 2013 11:55:44 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH v5 1/4] devcg: expand may_access() logic
References: <20130215165543.131282532@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=split_may_access_logic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to make the next patch more clear, expand may_access() logic.

v2: may_access() returns bool now

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 security/device_cgroup.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- github.orig/security/device_cgroup.c	2013-02-14 10:46:45.717808064 -0500
+++ github/security/device_cgroup.c	2013-02-14 10:47:12.146177936 -0500
@@ -302,8 +302,8 @@ 	return 0;
  * @dev_cgroup: dev cgroup to be tested against
  * @refex: new exception
  */
-static int may_access(struct dev_cgroup *dev_cgroup,
-		      struct dev_exception_item *refex)
+static bool may_access(struct dev_cgroup *dev_cgroup,
+		       struct dev_exception_item *refex)
 {
 	struct dev_exception_item *ex;
 	bool match = false;
@@ -329,16 +329,19 @@ 		if (ex->minor != ~0 && ex->minor != re
 
 	/*
 	 * In two cases we'll consider this new exception valid:
-	 * - the dev cgroup has its default policy to allow + exception list:
-	 *   the new exception should *not* match any of the exceptions
-	 *   (behavior == DEVCG_DEFAULT_ALLOW, !match)
 	 * - the dev cgroup has its default policy to deny + exception list:
 	 *   the new exception *should* match the exceptions
-	 *   (behavior == DEVCG_DEFAULT_DENY, match)
+	 * - the dev cgroup has its default policy to allow + exception list:
+	 *   the new exception should *not* match any of the exceptions
 	 */
-	if ((dev_cgroup->behavior == DEVCG_DEFAULT_DENY) == match)
-		return 1;
-	return 0;
+	if (dev_cgroup->behavior == DEVCG_DEFAULT_DENY) {
+		if (match)
+			return true;
+	} else {
+		if (!match)
+			return true;
+	}
+	return false;
 }
 
 /*

