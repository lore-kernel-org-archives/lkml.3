Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaFZUgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:36:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbaFZUf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:35:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/15] resource: Provide new functions to walk through resources
Date: Thu, 26 Jun 2014 16:33:35 -0400
Message-Id: <1403814824-7587-7-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have added two more functions to walk through resources.

Currently walk_system_ram_range() deals with pfn and /proc/iomem can contain
partial pages. By dealing in pfn, callback function loses the info that
last page of a memory range is a partial page and not the full page. So
I implemented walk_system_ram_res() which returns u64 values to callback
functions and now it properly return start and end address.

walk_system_ram_range() uses find_next_system_ram() to find the next
ram resource. This in turn only travels through siblings of top level
child and does not travers through all the nodes of the resoruce tree. I
also need another function where I can walk through all the resources,
for example figure out where "GART" aperture is. Figure out where
ACPI memory is.

So I wrote another function walk_iomem_res() which walks through all
/proc/iomem resources and returns matches as asked by caller. Caller
can specify "name" of resource, start and end and flags.

Got rid of find_next_system_ram_res() and instead implemented more
generic find_next_iomem_res() which can be used to traverse top level
children only based on an argument.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/ioport.h |   6 +++
 kernel/resource.c      | 101 ++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 98 insertions(+), 9 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 5e3a906..142ec54 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -237,6 +237,12 @@ extern int iomem_is_exclusive(u64 addr);
 extern int
 walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 		void *arg, int (*func)(unsigned long, unsigned long, void *));
+extern int
+walk_system_ram_res(u64 start, u64 end, void *arg,
+		    int (*func)(u64, u64, void *));
+extern int
+walk_iomem_res(char *name, unsigned long flags, u64 start, u64 end, void *arg,
+	       int (*func)(u64, u64, void *));
 
 /* True if any part of r1 overlaps r2 */
 static inline bool resource_overlaps(struct resource *r1, struct resource *r2)
diff --git a/kernel/resource.c b/kernel/resource.c
index 3c2237a..da14b8d 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -59,10 +59,12 @@ static DEFINE_RWLOCK(resource_lock);
 static struct resource *bootmem_resource_free;
 static DEFINE_SPINLOCK(bootmem_resource_lock);
 
-static void *r_next(struct seq_file *m, void *v, loff_t *pos)
+static struct resource *next_resource(struct resource *p, bool sibling_only)
 {
-	struct resource *p = v;
-	(*pos)++;
+	/* Caller wants to traverse through siblings only */
+	if (sibling_only)
+		return p->sibling;
+
 	if (p->child)
 		return p->child;
 	while (!p->sibling && p->parent)
@@ -70,6 +72,13 @@ static void *r_next(struct seq_file *m, void *v, loff_t *pos)
 	return p->sibling;
 }
 
+static void *r_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct resource *p = v;
+	(*pos)++;
+	return (void *)next_resource(p, false);
+}
+
 #ifdef CONFIG_PROC_FS
 
 enum { MAX_IORES_LEVEL = 5 };
@@ -322,16 +331,19 @@ int release_resource(struct resource *old)
 
 EXPORT_SYMBOL(release_resource);
 
-#if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
 /*
- * Finds the lowest memory reosurce exists within [res->start.res->end)
+ * Finds the lowest iomem reosurce exists with-in [res->start.res->end)
  * the caller must specify res->start, res->end, res->flags and "name".
  * If found, returns 0, res is overwritten, if not found, returns -1.
+ * This walks through whole tree and not just first level children
+ * until and unless first_level_children_only is true.
  */
-static int find_next_system_ram(struct resource *res, char *name)
+static int find_next_iomem_res(struct resource *res, char *name,
+			       bool first_level_children_only)
 {
 	resource_size_t start, end;
 	struct resource *p;
+	bool sibling_only = false;
 
 	BUG_ON(!res);
 
@@ -340,8 +352,14 @@ static int find_next_system_ram(struct resource *res, char *name)
 	BUG_ON(start >= end);
 
 	read_lock(&resource_lock);
-	for (p = iomem_resource.child; p ; p = p->sibling) {
-		/* system ram is just marked as IORESOURCE_MEM */
+
+	if (first_level_children_only) {
+		p = iomem_resource.child;
+		sibling_only = true;
+	} else
+		p = &iomem_resource;
+
+	while ((p = next_resource(p, sibling_only))) {
 		if (p->flags != res->flags)
 			continue;
 		if (name && strcmp(p->name, name))
@@ -353,6 +371,7 @@ static int find_next_system_ram(struct resource *res, char *name)
 		if ((p->end >= start) && (p->start < end))
 			break;
 	}
+
 	read_unlock(&resource_lock);
 	if (!p)
 		return -1;
@@ -365,6 +384,70 @@ static int find_next_system_ram(struct resource *res, char *name)
 }
 
 /*
+ * Walks through iomem resources and calls func() with matching resource
+ * ranges. This walks through whole tree and not just first level children.
+ * All the memory ranges which overlap start,end and also match flags and
+ * name are valid candidates.
+ *
+ * @name: name of resource
+ * @flags: resource flags
+ * @start: start addr
+ * @end: end addr
+ */
+int walk_iomem_res(char *name, unsigned long flags, u64 start, u64 end,
+		void *arg, int (*func)(u64, u64, void *))
+{
+	struct resource res;
+	u64 orig_end;
+	int ret = -1;
+
+	res.start = start;
+	res.end = end;
+	res.flags = flags;
+	orig_end = res.end;
+	while ((res.start < res.end) &&
+		(!find_next_iomem_res(&res, name, false))) {
+		ret = (*func)(res.start, res.end, arg);
+		if (ret)
+			break;
+		res.start = res.end + 1;
+		res.end = orig_end;
+	}
+	return ret;
+}
+
+/*
+ * This function calls callback against all memory range of "System RAM"
+ * which are marked as IORESOURCE_MEM and IORESOUCE_BUSY.
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
+		(!find_next_iomem_res(&res, "System RAM", true))) {
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
  * This function calls callback against all memory range of "System RAM"
  * which are marked as IORESOURCE_MEM and IORESOUCE_BUSY.
  * Now, this function is only for "System RAM".
@@ -382,7 +465,7 @@ int walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 	orig_end = res.end;
 	while ((res.start < res.end) &&
-		(find_next_system_ram(&res, "System RAM") >= 0)) {
+		(find_next_iomem_res(&res, "System RAM", true) >= 0)) {
 		pfn = (res.start + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		end_pfn = (res.end + 1) >> PAGE_SHIFT;
 		if (end_pfn > pfn)
-- 
1.9.0

