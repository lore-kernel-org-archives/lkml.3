Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbaFIJcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:32:09 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932780AbaFIJ1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:27:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Aristeu Rozanski <aris@redhat.com>,
        cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Aristeu Rozanski <arozansk@redhat.com>, Tejun Heo <tj@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 085/146] device_cgroup: check if exception removal is allowed
Date: Mon,  9 Jun 2014 10:50:20 +0200
Message-Id: <b5b9b87f76e80cff1fbff43e0a47ba6ea2b30840.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aristeu Rozanski <aris@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d2c2b11cfa134f4fbdcc34088824da26a084d8de upstream.

[PATCH v3 1/2] device_cgroup: check if exception removal is allowed

When the device cgroup hierarchy was introduced in
	bd2953ebbb53 - devcg: propagate local changes down the hierarchy

a specific case was overlooked. Consider the hierarchy bellow:

	A	default policy: ALLOW, exceptions will deny access
	 \
	  B	default policy: ALLOW, exceptions will deny access

There's no need to verify when an new exception is added to B because
in this case exceptions will deny access to further devices, which is
always fine. Hierarchy in device cgroup only makes sure B won't have
more access than A.

But when an exception is removed (by writing devices.allow), it isn't
checked if the user is in fact removing an inherited exception from A,
thus giving more access to B.

Example:

	# echo 'a' >A/devices.allow
	# echo 'c 1:3 rw' >A/devices.deny
	# echo $$ >A/B/tasks
	# echo >/dev/null
	-bash: /dev/null: Operation not permitted
	# echo 'c 1:3 w' >A/B/devices.allow
	# echo >/dev/null
	#

This shouldn't be allowed and this patch fixes it by making sure to never allow
exceptions in this case to be removed if the exception is partially or fully
present on the parent.

v3: missing '*' in function description
v2: improved log message and formatting fixes

Cc: cgroups@vger.kernel.org
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 security/device_cgroup.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 70a76321fc4f..e34818192c8d 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -477,6 +477,37 @@ static int parent_has_perm(struct dev_cgroup *childcg,
 }
 
 /**
+ * parent_allows_removal - verify if it's ok to remove an exception
+ * @childcg: child cgroup from where the exception will be removed
+ * @ex: exception being removed
+ *
+ * When removing an exception in cgroups with default ALLOW policy, it must
+ * be checked if removing it will give the child cgroup more access than the
+ * parent.
+ *
+ * Return: true if it's ok to remove exception, false otherwise
+ */
+static bool parent_allows_removal(struct dev_cgroup *childcg,
+				  struct dev_exception_item *ex)
+{
+	struct dev_cgroup *parent = css_to_devcgroup(css_parent(&childcg->css));
+
+	if (!parent)
+		return true;
+
+	/* It's always allowed to remove access to devices */
+	if (childcg->behavior == DEVCG_DEFAULT_DENY)
+		return true;
+
+	/*
+	 * Make sure you're not removing part or a whole exception existing in
+	 * the parent cgroup
+	 */
+	return !match_exception_partial(&parent->exceptions, ex->type,
+					ex->major, ex->minor, ex->access);
+}
+
+/**
  * may_allow_all - checks if it's possible to change the behavior to
  *		   allow based on parent's rules.
  * @parent: device cgroup's parent
@@ -711,17 +742,21 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 
 	switch (filetype) {
 	case DEVCG_ALLOW:
-		if (!parent_has_perm(devcgroup, &ex))
-			return -EPERM;
 		/*
 		 * If the default policy is to allow by default, try to remove
 		 * an matching exception instead. And be silent about it: we
 		 * don't want to break compatibility
 		 */
 		if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
+			/* Check if the parent allows removing it first */
+			if (!parent_allows_removal(devcgroup, &ex))
+				return -EPERM;
 			dev_exception_rm(devcgroup, &ex);
-			return 0;
+			break;
 		}
+
+		if (!parent_has_perm(devcgroup, &ex))
+			return -EPERM;
 		rc = dev_exception_add(devcgroup, &ex);
 		break;
 	case DEVCG_DENY:
-- 
1.9.3

