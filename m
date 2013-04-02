Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924Ab3DBQ3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:29:14 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:32897 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761895Ab3DBQ3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:29:10 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linuxram@us.ibm.com,
        tmac@hp.com, isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, jiang.liu@huawei.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 1/3] resource: Add __adjust_resource() for internal use
Date: Tue,  2 Apr 2013 10:17:28 -0600
Message-Id: <1364919450-8741-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364919450-8741-1-git-send-email-toshi.kani@hp.com>
References: <1364919450-8741-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added __adjust_resource(), which is called by adjust_resource()
internally after the resource_lock is held.  There is no interface
change to adjust_resource().  This change allows other functions
to call __adjust_resource() internally while the resource_lock is
held.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 kernel/resource.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 73f35d4..ae246f9 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -706,24 +706,13 @@ void insert_resource_expand_to_fit(struct resource *root, struct resource *new)
 	write_unlock(&resource_lock);
 }
 
-/**
- * adjust_resource - modify a resource's start and size
- * @res: resource to modify
- * @start: new start value
- * @size: new size
- *
- * Given an existing resource, change its start and size to match the
- * arguments.  Returns 0 on success, -EBUSY if it can't fit.
- * Existing children of the resource are assumed to be immutable.
- */
-int adjust_resource(struct resource *res, resource_size_t start, resource_size_t size)
+static int __adjust_resource(struct resource *res, resource_size_t start,
+				resource_size_t size)
 {
 	struct resource *tmp, *parent = res->parent;
 	resource_size_t end = start + size - 1;
 	int result = -EBUSY;
 
-	write_lock(&resource_lock);
-
 	if (!parent)
 		goto skip;
 
@@ -751,6 +740,26 @@ skip:
 	result = 0;
 
  out:
+	return result;
+}
+
+/**
+ * adjust_resource - modify a resource's start and size
+ * @res: resource to modify
+ * @start: new start value
+ * @size: new size
+ *
+ * Given an existing resource, change its start and size to match the
+ * arguments.  Returns 0 on success, -EBUSY if it can't fit.
+ * Existing children of the resource are assumed to be immutable.
+ */
+int adjust_resource(struct resource *res, resource_size_t start,
+			resource_size_t size)
+{
+	int result;
+
+	write_lock(&resource_lock);
+	result = __adjust_resource(res, start, size);
 	write_unlock(&resource_lock);
 	return result;
 }
