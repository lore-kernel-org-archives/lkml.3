Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbaDGU7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 16:59:22 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:47562 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbaDGU7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 16:59:20 -0400
Date: Mon, 7 Apr 2014 16:59:16 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        cgroups@vger.kernel.org
Subject: [PATCH cgroup/for-3.15-fixes] cgroup: newly created dirs and files
 should be owned by the creator
Message-ID: <20140407205916.GD27461@htj.dyndns.org>
References: <20140403164911.GE24119@htj.dyndns.org>
 <CA+55aFyGz2q4iDEt56Bw+x_ri_-DQYLAKPJvk3Uxj9z-y+0uPw@mail.gmail.com>
 <CA+55aFy+Jt0B32kj=Ldz9Krp4DXcXSP4r-o3f-2LPcVs4udGVA@mail.gmail.com>
 <CA+55aFwM0aG1PHY7xOQbsFG+Ot4mL4=7yRnT7dssUaOyaLQ3GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwM0aG1PHY7xOQbsFG+Ot4mL4=7yRnT7dssUaOyaLQ3GQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to cgroup/for-3.15.  Will soon send pull request for this one
and the cgroup_root refcnt fix from Li.

Thanks.

------ 8< ------
>From 49957f8e2a43035a97d05bddefa394492a969c0d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Mon, 7 Apr 2014 16:44:47 -0400

While converting cgroup to kernfs, 2bd59d48ebfb ("cgroup: convert to
kernfs") accidentally dropped the logic which makes newly created
cgroup dirs and files owned by the current uid / gid.  This broke
cases where cgroup subtree management is delegated to !root as the sub
manager wouldn't be able to create more than single level of hierarchy
or put tasks into child cgroups it created.

Among other things, this breaks user session management in systemd and
one of the symptoms was 90s hang during shutdown.  User session
systemd running as the user creates a sub-service to initiate shutdown
and tries to put kill(1) into it but fails because cgroup.procs is
owned by root.  This leads to 90s hang during shutdown.

Implement cgroup_kn_set_ugid() which sets a kn's uid and gid to those
of the caller and use it from file and dir creation paths.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/cgroup.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0dfc732..9fcdaa7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2346,11 +2346,26 @@ static int cgroup_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	return ret;
 }
 
+/* set uid and gid of cgroup dirs and files to that of the creator */
+static int cgroup_kn_set_ugid(struct kernfs_node *kn)
+{
+	struct iattr iattr = { .ia_valid = ATTR_UID | ATTR_GID,
+			       .ia_uid = current_fsuid(),
+			       .ia_gid = current_fsgid(), };
+
+	if (uid_eq(iattr.ia_uid, GLOBAL_ROOT_UID) &&
+	    gid_eq(iattr.ia_gid, GLOBAL_ROOT_GID))
+		return 0;
+
+	return kernfs_setattr(kn, &iattr);
+}
+
 static int cgroup_add_file(struct cgroup *cgrp, struct cftype *cft)
 {
 	char name[CGROUP_FILE_NAME_MAX];
 	struct kernfs_node *kn;
 	struct lock_class_key *key = NULL;
+	int ret;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	key = &cft->lockdep_key;
@@ -2358,7 +2373,13 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cftype *cft)
 	kn = __kernfs_create_file(cgrp->kn, cgroup_file_name(cgrp, cft, name),
 				  cgroup_file_mode(cft), 0, cft->kf_ops, cft,
 				  NULL, false, key);
-	return PTR_ERR_OR_ZERO(kn);
+	if (IS_ERR(kn))
+		return PTR_ERR(kn);
+
+	ret = cgroup_kn_set_ugid(kn);
+	if (ret)
+		kernfs_remove(kn);
+	return ret;
 }
 
 /**
@@ -3753,6 +3774,10 @@ static long cgroup_create(struct cgroup *parent, const char *name,
 	 */
 	idr_replace(&root->cgroup_idr, cgrp, cgrp->id);
 
+	err = cgroup_kn_set_ugid(kn);
+	if (err)
+		goto err_destroy;
+
 	err = cgroup_addrm_files(cgrp, cgroup_base_files, true);
 	if (err)
 		goto err_destroy;
-- 
1.9.0

