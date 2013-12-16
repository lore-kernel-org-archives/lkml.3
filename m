Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab3LPPMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:12:22 -0500
Received: from m59-178.qiye.163.com ([123.58.178.59]:54742 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3LPPKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:10:55 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Sage Weil <sage@inktank.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Li Wang <liwang@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: [PATCH 5/5] VFS: Extend drop_caches sysctl handler to allow directory level cache cleaning
Date: Mon, 16 Dec 2013 07:00:09 -0800
Message-Id: <612334c18d31f67fb41416638f40cdf090062140.1387205337.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1387205337.git.liwang@ubuntukylin.com>
References: <cover.1387205337.git.liwang@ubuntukylin.com>
In-Reply-To: <cover.1387205337.git.liwang@ubuntukylin.com>
References: <cover.1387205337.git.liwang@ubuntukylin.com>
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUlMVUNJQkJCQkJJSExLTUtOTldZCQ4XHghZQV
	koKz0kKDQ9Lz06MjckMjUkMz46Pz4pQUtVS0A2IyQiPigkMjUkMz46Pz4pQUtVS0ArLykkNTQkMj
	UkMz46Pz4pQUlVS0A4NC41LykiJDg1QUtVS0ApPjwyNDUkOigyOkFLVUtAKyk0LTI1OD4kMy41Oj
	VBS1VLQD8iNTo2MjgkMiskNTQkMjUkMz46Pz4pQUtVS0ApPjo3JDIrJDI1JCk5NyQyNSQzPjo*Pi
	lBSklVS0A2LjcvMiQpOCsvJD8yPT0#KT41LyQyNSQzPjo*PilBSVVLQDIrJC80PzoiJDg1LyRLJE
	pLS0FLVUtAMiskTiQ2MjUuLz4kODUvJEskSktBS1VLQDIrJEokNjI1Li8#JDg1LyRLJEpLQUtVS0
	AyKyRKJDM0LikkODUvJEskSktLQUtVS0AyKyRISyQ2MjUuLz4kODUvJEskTktBS1VLQDU0LyQ9Oj
	Y0LigkPzQ2OjI1JCgrPSQ9OjI3QUpLVUtAKC45JD5BSlVOTkA9NSQoLjkkPjUsNCk*KCQzNzEkSk
	tLSUtKQUtVSUNZBg++
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENM
	SUtNS05NT0xLVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUhOTkw3V1kSC1lBWU1KVUpDTFVOT1VCWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
---
 fs/drop_caches.c |   45 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 9fd702f..ab31393 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -8,10 +8,11 @@
 #include <linux/writeback.h>
 #include <linux/sysctl.h>
 #include <linux/gfp.h>
+#include <linux/fs_struct.h>
 #include "internal.h"
 
 /* A global variable is a bit ugly, but it keeps the code simple */
-int sysctl_drop_caches;
+char sysctl_drop_caches[PATH_MAX];
 
 static void drop_pagecache_sb(struct super_block *sb, void *unused)
 {
@@ -54,15 +55,43 @@ int drop_caches_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	int ret;
+	int command;
+	struct path path;
+	struct path root;
 
-	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
-	if (ret)
-		return ret;
-	if (write) {
-		if (sysctl_drop_caches & 1)
+	ret = proc_dostring(table, write, buffer, length, ppos);
+	if (ret || !write)
+		goto out;
+	ret = -EINVAL;
+	command = sysctl_drop_caches[0] - '0';
+	if (command < 1 || command > 3)
+		goto out;
+	if (sysctl_drop_caches[1] == '\0') {
+		if (command & 1)
 			iterate_supers(drop_pagecache_sb, NULL);
-		if (sysctl_drop_caches & 2)
+		if (command & 2)
 			drop_slab();
+		ret = 0;
+		goto out;
 	}
-	return 0;
+	if (sysctl_drop_caches[1] != ':' || sysctl_drop_caches[2] == '\0')
+		goto out;
+	if (sysctl_drop_caches[2] == '/')
+		get_fs_root(current->fs, &root);
+	else
+		get_fs_pwd(current->fs, &root);
+	ret = vfs_path_lookup(root.dentry, root.mnt,
+		&sysctl_drop_caches[2], 0, &path);
+	path_put(&root);
+	if (ret)
+		goto out;
+	if (command & 1)
+		shrink_pagecache_parent(path.dentry);
+	if (command & 2)
+		shrink_dcache_parent(path.dentry);
+	path_put(&path);
+out:
+	if (ret)
+		memset(sysctl_drop_caches, 0, PATH_MAX);
+	return ret;
 }
-- 
1.7.9.5

