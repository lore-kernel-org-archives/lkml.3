Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3DSFyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 01:54:32 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:63501 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3DSFya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 01:54:30 -0400
Message-ID: <5170DBC1.3020201@huawei.com>
Date: Fri, 19 Apr 2013 13:53:05 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Aristeu Rozanski <aris@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, <alexey.kodanev@oracle.com>,
        Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroup: fix broken file xattrs
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should store file xattrs in struct cfent instead of struct cftype,
because cftype is a type while cfent is object instance of cftype.

For example each cgroup has a tasks file, and each tasks file is
associated with a uniq cfent, but all those files share the same
struct cftype.

Alexey Kodanev reported a crash, which can be reproduced:

  # mount -t cgroup -o xattr /sys/fs/cgroup
  # mkdir /sys/fs/cgroup/test
  # setfattr -n trusted.value -v test_value /sys/fs/cgroup/tasks
  # rmdir /sys/fs/cgroup/test
  # umount /sys/fs/cgroup
  oops!

In this case, simple_xattrs_free() will free the same struct simple_xattrs
twice.

Cc: <stable@vger.kernel.org> # 3.8.x
Reported-by: Alexey Kodanev <alexey.kodanev@oracle.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---

This patch is based on 3.9-rcX. It conflicts a bit with
"cgroup: convert cgroupfs_root flag bits to masks and add CGRP_ prefix"

---
 include/linux/cgroup.h |  3 ---
 kernel/cgroup.c        | 10 ++++++----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 900af59..16d4d09 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -304,9 +304,6 @@ struct cftype {
 	/* CFTYPE_* flags */
 	unsigned int flags;
 
-	/* file xattrs */
-	struct simple_xattrs xattrs;
-
 	int (*open)(struct inode *inode, struct file *file);
 	ssize_t (*read)(struct cgroup *cgrp, struct cftype *cft,
 			struct file *file,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a32f943..5d7fbb2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -162,6 +162,9 @@ struct cfent {
 	struct list_head		node;
 	struct dentry			*dentry;
 	struct cftype			*type;
+
+	/* file xattrs */
+	struct simple_xattrs		xattrs;
 };
 
 /*
@@ -915,8 +918,8 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		WARN_ONCE(!list_empty(&cfe->node) &&
 			  cgrp != &cgrp->root->top_cgroup,
 			  "cfe still linked for %s\n", cfe->type->name);
+		simple_xattrs_free(&cfe->xattrs);
 		kfree(cfe);
-		simple_xattrs_free(&cft->xattrs);
 	}
 	iput(inode);
 }
@@ -2551,7 +2554,7 @@ static struct simple_xattrs *__d_xattrs(struct dentry *dentry)
 	if (S_ISDIR(dentry->d_inode->i_mode))
 		return &__d_cgrp(dentry)->xattrs;
 	else
-		return &__d_cft(dentry)->xattrs;
+		return &__d_cfe(dentry)->xattrs;
 }
 
 static inline int xattr_enabled(struct dentry *dentry)
@@ -2727,8 +2730,6 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 	umode_t mode;
 	char name[MAX_CGROUP_TYPE_NAMELEN + MAX_CFTYPE_NAME + 2] = { 0 };
 
-	simple_xattrs_init(&cft->xattrs);
-
 	if (subsys && !test_bit(ROOT_NOPREFIX, &cgrp->root->flags)) {
 		strcpy(name, subsys->name);
 		strcat(name, ".");
@@ -2753,6 +2754,7 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 		cfe->type = (void *)cft;
 		cfe->dentry = dentry;
 		dentry->d_fsdata = cfe;
+		simple_xattrs_init(&cfe->xattrs);
 		list_add_tail(&cfe->node, &parent->files);
 		cfe = NULL;
 	}
-- 
1.8.0.2
