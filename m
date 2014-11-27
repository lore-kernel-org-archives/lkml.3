Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbaK0JWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:22:53 -0500
Received: from mail.kernel.org ([198.145.19.201]:41147 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347AbaK0IqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:23 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alban Crequy <alban.crequy@collabora.co.uk>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 12/91] cgroup: reject cgroup names with ' '
Date: Thu, 27 Nov 2014 16:41:55 +0800
Message-Id: <1417077794-9299-12-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alban Crequy <alban.crequy@collabora.co.uk>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 71b1fb5c4473a5b1e601d41b109bdfe001ec82e0 upstream.

/proc/<pid>/cgroup contains one cgroup path on each line. If cgroup names are
allowed to contain "\n", applications cannot parse /proc/<pid>/cgroup safely.

Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
Signed-off-by: Tejun Heo <tj@kernel.org>
[lizf: Backported to 3.4:
 - adjust context
 - s/name/dentry->d_name.name/]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 kernel/cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7c8f4f7..c776f89 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3838,6 +3838,11 @@ static int cgroup_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct cgroup *c_parent = dentry->d_parent->d_fsdata;
 
+	/* Do not accept '\n' to prevent making /proc/<pid>/cgroup unparsable.
+	 */
+	if (strchr(dentry->d_name.name, '\n'))
+		return -EINVAL;
+
 	/* the vfs holds inode->i_mutex already */
 	return cgroup_create(c_parent, dentry, mode | S_IFDIR);
 }
-- 
1.9.1

