Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3DMNBt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 09:01:49 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:48026 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab3DMNBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 09:01:46 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH PART3 v4 2/6] staging: ramster/debug: Use an array to initialize/use debugfs attributes
Date: Sat, 13 Apr 2013 21:01:28 +0800
Message-Id: <1365858092-21920-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1365858092-21920-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1365858092-21920-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041312-5490-0000-0000-000003458E6C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use an array to initialize/use debugfs attributes, it makes them 
neater as zcache/debug.c does.

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zcache/ramster/debug.c |   68 +++++++++++++++-----------------
 1 file changed, 32 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/zcache/ramster/debug.c b/drivers/staging/zcache/ramster/debug.c
index 76861e4..bf34133 100644
--- a/drivers/staging/zcache/ramster/debug.c
+++ b/drivers/staging/zcache/ramster/debug.c
@@ -3,8 +3,6 @@
 
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
-#define zdfs    debugfs_create_size_t
-#define zdfs64  debugfs_create_u64
 
 ssize_t ramster_eph_pages_remoted;
 ssize_t ramster_pers_pages_remoted;
@@ -20,48 +18,46 @@ ssize_t ramster_remote_object_flushes_failed;
 ssize_t ramster_remote_pages_flushed;
 ssize_t ramster_remote_page_flushes_failed;
 
+#define ATTR(x)  { .name = #x, .val = &ramster_##x, }
+static struct debug_entry {
+	const char *name;
+	ssize_t *val;
+} attrs[] = {
+	ATTR(eph_pages_remoted),
+	ATTR(pers_pages_remoted),
+	ATTR(eph_pages_remote_failed),
+	ATTR(pers_pages_remote_failed),
+	ATTR(remote_eph_pages_succ_get),
+	ATTR(remote_pers_pages_succ_get),
+	ATTR(remote_eph_pages_unsucc_get),
+	ATTR(remote_pers_pages_unsucc_get),
+	ATTR(pers_pages_remote_nomem),
+	ATTR(remote_objects_flushed),
+	ATTR(remote_pages_flushed),
+	ATTR(remote_object_flushes_failed),
+	ATTR(remote_page_flushes_failed),
+	ATTR(foreign_eph_pages),
+	ATTR(foreign_eph_pages_max),
+	ATTR(foreign_pers_pages),
+	ATTR(foreign_pers_pages_max),
+};
+#undef ATTR
+
 int __init ramster_debugfs_init(void)
 {
+	int i;
 	struct dentry *root = debugfs_create_dir("ramster", NULL);
 	if (root == NULL)
 		return -ENXIO;
 
-	zdfs("eph_pages_remoted", S_IRUGO, root, &ramster_eph_pages_remoted);
-	zdfs("pers_pages_remoted", S_IRUGO, root, &ramster_pers_pages_remoted);
-	zdfs("eph_pages_remote_failed", S_IRUGO, root,
-		&ramster_eph_pages_remote_failed);
-	zdfs("pers_pages_remote_failed", S_IRUGO, root,
-		&ramster_pers_pages_remote_failed);
-	zdfs("remote_eph_pages_succ_get", S_IRUGO, root,
-		&ramster_remote_eph_pages_succ_get);
-	zdfs("remote_pers_pages_succ_get", S_IRUGO, root,
-		&ramster_remote_pers_pages_succ_get);
-	zdfs("remote_eph_pages_unsucc_get", S_IRUGO, root,
-		&ramster_remote_eph_pages_unsucc_get);
-	zdfs("remote_pers_pages_unsucc_get", S_IRUGO, root,
-		&ramster_remote_pers_pages_unsucc_get);
-	zdfs("pers_pages_remote_nomem", S_IRUGO, root,
-		&ramster_pers_pages_remote_nomem);
-	zdfs("remote_objects_flushed", S_IRUGO, root,
-		&ramster_remote_objects_flushed);
-	zdfs("remote_pages_flushed", S_IRUGO, root,
-		&ramster_remote_pages_flushed);
-	zdfs("remote_object_flushes_failed", S_IRUGO, root,
-		&ramster_remote_object_flushes_failed);
-	zdfs("remote_page_flushes_failed", S_IRUGO, root,
-		&ramster_remote_page_flushes_failed);
-	zdfs("foreign_eph_pages", S_IRUGO, root,
-		&ramster_foreign_eph_pages);
-	zdfs("foreign_eph_pages_max", S_IRUGO, root,
-		&ramster_foreign_eph_pages_max);
-	zdfs("foreign_pers_pages", S_IRUGO, root,
-		&ramster_foreign_pers_pages);
-	zdfs("foreign_pers_pages_max", S_IRUGO, root,
-		&ramster_foreign_pers_pages_max);
+	for (i = 0; i < ARRAY_SIZE(attrs); i++)
+		if (!debugfs_create_size_t(attrs[i].name,
+				S_IRUGO, root, attrs[i].val))
+			goto out;
 	return 0;
+out:
+	return -ENODEV;
 }
-#undef  zdebugfs
-#undef  zdfs64
 #else
 static inline int ramster_debugfs_init(void)
 {
-- 
1.7.10.4

