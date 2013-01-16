Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab3APQCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:02:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36047 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978Ab3APQCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:02:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gao feng <gaofeng@cn.fujitsu.com>, Tejun Heo <tj@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 083/222] cgroup_rm_file: don't delete the uncreated files
Date: Wed, 16 Jan 2013 13:54:43 -0200
Message-Id: <1358351822-7675-84-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao feng <gaofeng@cn.fujitsu.com>

commit f33fddc2b9573d8359f1007d4bbe5cd587a0c093 upstream.

in cgroup_add_file,when creating files for cgroup,
some of creation may be skipped. So we need to avoid
deleting these uncreated files in cgroup_rm_file,
otherwise the warning msg will be triggered.

"cgroup_addrm_files: failed to remove memory_pressure_enabled, err=-2"

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Acked-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@redhat.com>
[ herton: unfuzz patch ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/cgroup.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1f2c8bf..963c956 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2682,12 +2682,6 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 	umode_t mode;
 	char name[MAX_CGROUP_TYPE_NAMELEN + MAX_CFTYPE_NAME + 2] = { 0 };
 
-	/* does @cft->flags tell us to skip creation on @cgrp? */
-	if ((cft->flags & CFTYPE_NOT_ON_ROOT) && !cgrp->parent)
-		return 0;
-	if ((cft->flags & CFTYPE_ONLY_ON_ROOT) && cgrp->parent)
-		return 0;
-
 	if (subsys && !test_bit(ROOT_NOPREFIX, &cgrp->root->flags)) {
 		strcpy(name, subsys->name);
 		strcat(name, ".");
@@ -2728,6 +2722,12 @@ static int cgroup_addrm_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 	int err, ret = 0;
 
 	for (cft = cfts; cft->name[0] != '\0'; cft++) {
+		/* does cft->flags tell us to skip this file on @cgrp? */
+		if ((cft->flags & CFTYPE_NOT_ON_ROOT) && !cgrp->parent)
+			continue;
+		if ((cft->flags & CFTYPE_ONLY_ON_ROOT) && cgrp->parent)
+			continue;
+
 		if (is_add)
 			err = cgroup_add_file(cgrp, subsys, cft);
 		else
-- 
1.7.9.5

