Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761960Ab3DBQ3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:29:44 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:32922 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758965Ab3DBQ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:29:13 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linuxram@us.ibm.com,
        tmac@hp.com, isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, jiang.liu@huawei.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 2/3] resource: Add release_mem_region_adjustable()
Date: Tue,  2 Apr 2013 10:17:29 -0600
Message-Id: <1364919450-8741-3-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364919450-8741-1-git-send-email-toshi.kani@hp.com>
References: <1364919450-8741-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added release_mem_region_adjustable(), which releases a requested
region from a currently busy memory resource.  This interface
adjusts the matched memory resource accordingly if the requested
region does not match exactly but still fits into.

This new interface is intended for memory hot-delete.  During
bootup, memory resources are inserted from the boot descriptor
table, such as EFI Memory Table and e820.  Each memory resource
entry usually covers the whole contigous memory range.  Memory
hot-delete request, on the other hand, may target to a particular
range of memory resource, and its size can be much smaller than
the whole contiguous memory.  Since the existing release interfaces
like __release_region() require a requested region to be exactly
matched to a resource entry, they do not allow a partial resource
to be released.

There is no change to the existing interfaces since their restriction
is valid for I/O resources.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 include/linux/ioport.h |    2 +
 kernel/resource.c      |   87 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 85ac9b9b..0fe1a82 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -192,6 +192,8 @@ extern struct resource * __request_region(struct resource *,
 extern int __check_region(struct resource *, resource_size_t, resource_size_t);
 extern void __release_region(struct resource *, resource_size_t,
 				resource_size_t);
+extern int release_mem_region_adjustable(struct resource *, resource_size_t,
+				resource_size_t);
 
 static inline int __deprecated check_region(resource_size_t s,
 						resource_size_t n)
diff --git a/kernel/resource.c b/kernel/resource.c
index ae246f9..789f160 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1021,6 +1021,93 @@ void __release_region(struct resource *parent, resource_size_t start,
 }
 EXPORT_SYMBOL(__release_region);
 
+/**
+ * release_mem_region_adjustable - release a previously reserved memory region
+ * @parent: parent resource descriptor
+ * @start: resource start address
+ * @size: resource region size
+ *
+ * The requested region is released from a currently busy memory resource.
+ * It adjusts the matched busy memory resource accordingly if the requested
+ * region does not match exactly but still fits into.  Existing children of
+ * the busy memory resource must be immutable in this request.
+ *
+ * Note, when the busy memory resource gets split into two entries, the code
+ * assumes that all children remain in the lower address entry for simplicity.
+ * Enhance this logic when necessary.
+ */
+int release_mem_region_adjustable(struct resource *parent,
+			resource_size_t start, resource_size_t size)
+{
+	struct resource **p;
+	struct resource *res, *new;
+	resource_size_t end;
+	int ret = 0;
+
+	p = &parent->child;
+	end = start + size - 1;
+
+	write_lock(&resource_lock);
+
+	while ((res = *p)) {
+		if (res->start > start || res->end < end) {
+			p = &res->sibling;
+			continue;
+		}
+
+		if (!(res->flags & IORESOURCE_MEM)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (!(res->flags & IORESOURCE_BUSY)) {
+			p = &res->child;
+			continue;
+		}
+
+		if (res->start == start && res->end == end) {
+			/* free the whole entry */
+			*p = res->sibling;
+			kfree(res);
+		} else if (res->start == start && res->end != end) {
+			/* adjust the start */
+			ret = __adjust_resource(res, end+1,
+						res->end - end);
+		} else if (res->start != start && res->end == end) {
+			/* adjust the end */
+			ret = __adjust_resource(res, res->start,
+						start - res->start);
+		} else {
+			/* split into two entries */
+			new = kzalloc(sizeof(struct resource), GFP_KERNEL);
+			if (!new) {
+				ret = -ENOMEM;
+				break;
+			}
+			new->name = res->name;
+			new->start = end + 1;
+			new->end = res->end;
+			new->flags = res->flags;
+			new->parent = res->parent;
+			new->sibling = res->sibling;
+			new->child = NULL;
+
+			ret = __adjust_resource(res, res->start,
+						start - res->start);
+			if (ret) {
+				kfree(new);
+				break;
+			}
+			res->sibling = new;
+		}
+
+		break;
+	}
+
+	write_unlock(&resource_lock);
+	return ret;
+}
+
 /*
  * Managed region resource
  */
