Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab3ENLor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:44:47 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:56081 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab3ENLop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:44:45 -0400
Message-ID: <51922394.2020002@huawei.com>
Date: Tue, 14 May 2013 19:44:20 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LSM <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Ivan Bulatovic <combuster@archlinux.us>
Subject: [PATCH] cgroup: initialize xattr before calling d_instantiate()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_create_file() calls d_instantiate(), which may decide to look
at the xattrs on the file. Smack always does this and SELinux can be
configured to do so.

But cgroup_add_file() didn't initialize xattrs before calling
cgroup_create_file(), which finally leads to dereferencing NULL
dentry->d_fsdata.

This bug has been there since cgroup xattr was introduced.

Cc: <stable@vger.kernel.org> # 3.8.x
Reported-by: Ivan Bulatovic <combuster@archlinux.us>
Reported-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2a99262..38b1365 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2699,13 +2699,14 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 		goto out;
 	}
 
+	cfe->type = (void *)cft;
+	cfe->dentry = dentry;
+	dentry->d_fsdata = cfe;
+	simple_xattrs_init(&cfe->xattrs);
+
 	mode = cgroup_file_mode(cft);
 	error = cgroup_create_file(dentry, mode | S_IFREG, cgrp->root->sb);
 	if (!error) {
-		cfe->type = (void *)cft;
-		cfe->dentry = dentry;
-		dentry->d_fsdata = cfe;
-		simple_xattrs_init(&cfe->xattrs);
 		list_add_tail(&cfe->node, &parent->files);
 		cfe = NULL;
 	}
-- 
1.8.0.2
