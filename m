Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaA0S66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:58:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbaA0S6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:58:48 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz, Vivek Goyal <vgoyal@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/11] resource: Provide new functions to walk through resources
Date: Mon, 27 Jan 2014 13:57:42 -0500
Message-Id: <1390849071-21989-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have added two more functions to walk through resources.
Current walk_system_ram_range() deals with pfn and /proc/iomem can contain
partial pages. By dealing in pfn, callback function loses the info that
last page of a memory range is a partial page and not the full page. So
I implemented walk_system_ran_res() which returns u64 values to callback
functions and now it properly return start and end address.

walk_system_ram_range() uses find_next_system_ram() to find the next
ram resource. This in turn only travels through siblings of top level
child and does not travers through all the nodes of the resoruce tree. I
also need another function where I can walk through all the resources,
for example figure out where "GART" aperture is. Figure out where
ACPI memory is.

So I wrote another function walk_ram_res() which walks through all
/proc/iomem resources and returns matches as asked by caller. Caller
can specify "name" of resource, start and end.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/ioport.h |   6 +++
 kernel/resource.c      | 108 +++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 110 insertions(+), 4 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 89b7c24..0ebf8b0 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -227,6 +227,12 @@ extern int iomem_is_exclusive(u64 addr);
 extern int
 walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 		void *arg, int (*func)(unsigned long, unsigned long, void *));
+extern int
+walk_system_ram_res(u64 start, u64 end, void *arg,
+				int (*func)(u64, u64, void *));
+extern int
+walk_ram_res(char *name, unsigned long flags, u64 start, u64 end, void *arg,
+				int (*func)(u64, u64, void *));
 
 /* True if any part of r1 overlaps r2 */
 static inline bool resource_overlaps(struct resource *r1, struct resource *r2)
diff --git a/kernel/resource.c b/kernel/resource.c
index 3f285dc..5e575e8 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -59,10 +59,8 @@ static DEFINE_RWLOCK(resource_lock);
 static struct resource *bootmem_resource_free;
 static DEFINE_SPINLOCK(bootmem_resource_lock);
 
-static void *r_next(struct seq_file *m, void *v, loff_t *pos)
+static struct resource *next_resource(struct resource *p)
 {
-	struct resource *p = v;
-	(*pos)++;
 	if (p->child)
 		return p->child;
 	while (!p->sibling && p->parent)
@@ -70,6 +68,13 @@ static void *r_next(struct seq_file *m, void *v, loff_t *pos)
 	return p->sibling;
 }
 
+static void *r_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct resource *p = v;
+	(*pos)++;
+	return (void *)next_resource(p);
+}
+
 #ifdef CONFIG_PROC_FS
 
 enum { MAX_IORES_LEVEL = 5 };
@@ -322,7 +327,71 @@ int release_resource(struct resource *old)
 
 EXPORT_SYMBOL(release_resource);
 
-#if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
+/*
+ * Finds the lowest iomem reosurce exists with-in [res->start.res->end)
+ * the caller must specify res->start, res->end, res->flags and "name".
+ * If found, returns 0, res is overwritten, if not found, returns -1.
+ * This walks through whole tree and not just first level children.
+ */
+static int find_next_iomem_res(struct resource *res, char *name)
+{
+	resource_size_t start, end;
+	struct resource *p;
+
+	BUG_ON(!res);
+
+	start = res->start;
+	end = res->end;
+	BUG_ON(start >= end);
+
+	read_lock(&resource_lock);
+	p = &iomem_resource;
+	while ((p = next_resource(p))) {
+		if (p->flags != res->flags)
+			continue;
+		if (name && strcmp(p->name, name))
+			continue;
+		if (p->start > end) {
+			p = NULL;
+			break;
+		}
+		if ((p->end >= start) && (p->start < end))
+			break;
+	}
+
+	read_unlock(&resource_lock);
+	if (!p)
+		return -1;
+	/* copy data */
+	if (res->start < p->start)
+		res->start = p->start;
+	if (res->end > p->end)
+		res->end = p->end;
+	return 0;
+}
+
+int walk_ram_res(char *name, unsigned long flags, u64 start, u64 end,
+		void *arg, int (*func)(u64, u64, void *))
+{
+	struct resource res;
+	u64 orig_end;
+	int ret = -1;
+
+	res.start = start;
+	res.end = end;
+	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+	orig_end = res.end;
+	while ((res.start < res.end) &&
+		(find_next_iomem_res(&res, name) >= 0)) {
+		ret = (*func)(res.start, res.end, arg);
+		if (ret)
+			break;
+		res.start = res.end + 1;
+		res.end = orig_end;
+	}
+	return ret;
+}
+
 /*
  * Finds the lowest memory reosurce exists within [res->start.res->end)
  * the caller must specify res->start, res->end, res->flags and "name".
@@ -367,6 +436,37 @@ static int find_next_system_ram(struct resource *res, char *name)
 /*
  * This function calls callback against all memory range of "System RAM"
  * which are marked as IORESOURCE_MEM and IORESOUCE_BUSY.
+ * Now, this function is only for "System RAM". This function deals with
+ * full ranges and not pfn. If resources are not pfn aligned, dealing
+ * with pfn can truncate ranges.
+ */
+int walk_system_ram_res(u64 start, u64 end, void *arg,
+				int (*func)(u64, u64, void *))
+{
+	struct resource res;
+	u64 orig_end;
+	int ret = -1;
+
+	res.start = start;
+	res.end = end;
+	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+	orig_end = res.end;
+	while ((res.start < res.end) &&
+		(find_next_system_ram(&res, "System RAM") >= 0)) {
+		ret = (*func)(res.start, res.end, arg);
+		if (ret)
+			break;
+		res.start = res.end + 1;
+		res.end = orig_end;
+	}
+	return ret;
+}
+
+#if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
+
+/*
+ * This function calls callback against all memory range of "System RAM"
+ * which are marked as IORESOURCE_MEM and IORESOUCE_BUSY.
  * Now, this function is only for "System RAM".
  */
 int walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
-- 
1.8.4.2

