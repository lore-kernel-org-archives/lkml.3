Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab3GWVKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:10:04 -0400
Received: from dupo.coraid.com ([208.71.232.133]:46286 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753211Ab3GWVKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:10:03 -0400
Message-Id: <1c323e57ec5644ed7415c143d4406c7ab037bdc5.1374610591.git.ecashin@coraid.com>
In-Reply-To: <cover.1374610591.git.ecashin@coraid.com>
References: <cover.1374610591.git.ecashin@coraid.com>
Subject: [PATCH 1/6] aoe: create and destroy debugfs directory for aoe
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Tue, 23 Jul 2013 17:09:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoeblk.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 916d9ed..cb508b7 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -17,11 +17,13 @@
 #include <linux/mutex.h>
 #include <linux/export.h>
 #include <linux/moduleparam.h>
+#include <linux/debugfs.h>
 #include <scsi/sg.h>
 #include "aoe.h"
 
 static DEFINE_MUTEX(aoeblk_mutex);
 static struct kmem_cache *buf_pool_cache;
+static struct dentry *aoe_debugfs_dir;
 
 /* GPFS needs a larger value than the default. */
 static int aoe_maxsectors;
@@ -351,6 +353,8 @@ err:
 void
 aoeblk_exit(void)
 {
+	debugfs_remove_recursive(aoe_debugfs_dir);
+	aoe_debugfs_dir = NULL;
 	kmem_cache_destroy(buf_pool_cache);
 }
 
@@ -362,7 +366,11 @@ aoeblk_init(void)
 					   0, 0, NULL);
 	if (buf_pool_cache == NULL)
 		return -ENOMEM;
-
+	aoe_debugfs_dir = debugfs_create_dir("aoe", NULL);
+	if (IS_ERR_OR_NULL(aoe_debugfs_dir)) {
+		pr_info("aoe: cannot create debugfs directory\n");
+		aoe_debugfs_dir = NULL;
+	}
 	return 0;
 }
 
-- 
1.7.1

