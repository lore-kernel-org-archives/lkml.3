Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab3CMJoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:44:13 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:35644 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab3CMJoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:44:09 -0400
From: chenggang <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: chenggang <chenggang.qcg@taobao.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 2/8]Perf: Transform xyarray to linked list
Date: Wed, 13 Mar 2013 17:42:18 +0800
Message-Id: <1363167740-27735-7-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com>
References: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang <chenggang.qcg@taobao.com>

The 2-dimensional array cannot expand and shrink easily while we want to
perceive the thread's fork and exit events on-the-fly.
We transform xyarray to a 2-demesional linked list. The x dimension is cpus and
is still a array. The y dimension is threads of interest and is transformed to
linked list.
The interface to append and shrink a exist xyarray is provided.
1) xyarray__append()
   append a column for all rows.
2) xyarray__remove()
   remove a column for all rows.

Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

---
 tools/perf/util/xyarray.c |  125 +++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/xyarray.h |   68 ++++++++++++++++++++++--
 2 files changed, 185 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/xyarray.c b/tools/perf/util/xyarray.c
index 22afbf6..ddb3bff 100644
--- a/tools/perf/util/xyarray.c
+++ b/tools/perf/util/xyarray.c
@@ -1,20 +1,135 @@
 #include "xyarray.h"
 #include "util.h"
 
+/*
+ * Add a column for all rows;
+ * @init_cont stores the initialize value for new entries.
+ * The return value is the array of new contents.
+ */
+char** xyarray__append(struct xyarray *xy, char *init_cont)
+{
+	struct xyentry *new_entry;
+	unsigned int x;
+	char **new_conts;
+
+	new_conts = zalloc(sizeof(char *) * xy->row_count);
+	if (new_conts == NULL)
+		return NULL;
+
+	for (x = 0; x < xy->row_count; x++) {
+		new_entry = zalloc(sizeof(*new_entry));
+		if (new_entry == NULL) {
+			free(new_conts);
+			return NULL;
+		}
+
+		new_entry->contents = zalloc(xy->entry_size);
+		if (new_entry->contents == NULL) {
+			free(new_entry);
+			free(new_conts);
+			return NULL;
+		}
+
+		if (init_cont)
+			memcpy(new_entry->contents, init_cont, xy->entry_size);
+
+		new_conts[x] = new_entry->contents;
+
+		list_add_tail(&new_entry->next, &xy->rows[x].head);
+	}
+
+	return new_conts;
+}
+
 struct xyarray *xyarray__new(int xlen, int ylen, size_t entry_size)
 {
-	size_t row_size = ylen * entry_size;
-	struct xyarray *xy = zalloc(sizeof(*xy) + xlen * row_size);
+	struct xyarray *xy = zalloc(sizeof(*xy) + xlen * sizeof(struct row));
+	int i;
+
+	if (xy == NULL)
+		return NULL;
+
+	xy->row_count = xlen;
+	xy->entry_size = entry_size;
 
-	if (xy != NULL) {
-		xy->entry_size = entry_size;
-		xy->row_size   = row_size;
+	for (i = 0; i < xlen; i++)
+		INIT_LIST_HEAD(&xy->rows[i].head);
+
+	for (i = 0; i< ylen; i++) {
+		if (xyarray__append(xy, NULL) == NULL) {
+			xyarray__delete(xy);
+			return NULL;
+		}
 	}
 
 	return xy;
 }
 
+static inline int xyarray__remove_last(struct xyarray *xy)
+{
+	struct xyentry *entry;
+	unsigned int x;
+
+	if (xy == NULL)
+		return -1; 
+
+	for (x = 0; x < xy->row_count; x++) {
+		if (!list_empty(&xy->rows[x].head)) {
+			entry = list_entry(xy->rows[x].head.prev,
+					   struct xyentry, next);
+			list_del(&entry->next);
+			free(entry);
+		}
+	}
+
+	return 0;
+}
+
+/*              
+ * remove a column for all rows;
+ */
+int xyarray__remove(struct xyarray *xy, int y)
+{
+	struct xyentry *entry, *tmp;
+	unsigned int x;
+	int count;
+
+	if (xy == NULL)
+		return -1;
+
+	if (y == -1)
+		return xyarray__remove_last(xy);
+
+	for (x = 0; x < xy->row_count; x++) {
+		count = 0;
+		list_for_each_entry_safe(entry, tmp, &xy->rows[x].head, next) {
+			if (count++ == y) {
+				list_del(&entry->next);
+				free(entry);
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * delete @xy and all its nodes.
+ */
 void xyarray__delete(struct xyarray *xy)
 {
+	unsigned int i;
+	struct xyentry *entry, *tmp;
+
+	if (!xy)
+		return;
+
+	for (i = 0; i < xy->row_count; i++) {
+		list_for_each_entry_safe(entry, tmp, &xy->rows[i].head, next) {
+			list_del(&entry->next);
+			free(entry);
+		}
+	}
+
 	free(xy);
 }
diff --git a/tools/perf/util/xyarray.h b/tools/perf/util/xyarray.h
index c488a07..b7a0819 100644
--- a/tools/perf/util/xyarray.h
+++ b/tools/perf/util/xyarray.h
@@ -2,19 +2,81 @@
 #define _PERF_XYARRAY_H_ 1
 
 #include <sys/types.h>
+#include <linux/list.h>
+
+struct row {
+	struct list_head head;
+};
+
+struct xyentry {
+	struct list_head next;
+	char *contents;
+};
 
 struct xyarray {
-	size_t row_size;
+	size_t row_count;
 	size_t entry_size;
-	char contents[];
+	struct row rows[];
 };
 
 struct xyarray *xyarray__new(int xlen, int ylen, size_t entry_size);
 void xyarray__delete(struct xyarray *xy);
+char** xyarray__append(struct xyarray *xy, char *init_cont);
+int xyarray__remove(struct xyarray *xy, int y);
+
+/*
+ * Avoid list walk while only the last entry is needed.
+ */
+static inline void *xyarray__last_entry(struct xyarray *xy, int x)
+{
+	struct xyentry *entry;
+
+	if (!list_empty(&xy->rows[x].head)) {
+		entry = list_entry(xy->rows[x].head.prev, struct xyentry, next);
+		return entry->contents;
+	}
+
+	return NULL;
+}
 
 static inline void *xyarray__entry(struct xyarray *xy, int x, int y)
 {
-	return &xy->contents[x * xy->row_size + y * xy->entry_size];
+	struct xyentry *entry;
+	int columns = 0;
+
+	if (y == -1)
+		return xyarray__last_entry(xy, x);
+
+	list_for_each_entry(entry, &xy->rows[x].head, next) {
+		if (columns++ == y)
+			return entry->contents;
+	}
+
+	return NULL;
 }
 
+static inline int xyarray__columns(struct xyarray *xy)
+{
+	struct xyentry *entry;
+	int columns = 0;
+
+	list_for_each_entry(entry, &xy->rows[0].head, next)
+		columns ++;
+
+	return columns;
+}
+
+/*
+ * @p points to xyentry->contents
+ * @head points to xyarray->rows[].head
+ * @type is the type of *p
+ */
+#define xyarray_for_each_content(pe, head, type) \
+	for (char **p = &(((struct xyentry*)list_entry((head)->next, struct xyentry, next))->contents); \
+	     &(((struct xyentry *)(container_of(p, struct xyentry, contents)))->next) != (head) \
+	     && (pe = (type *)(*p)); \
+	     p = (char **)container_of(p, struct xyentry, contents), \
+	     p = &(((struct xyentry *)list_entry(((struct xyentry *)p)->next.next, \
+		 struct xyentry, next))->contents))
+
 #endif /* _PERF_XYARRAY_H_ */
-- 
1.7.9.5

