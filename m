Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056Ab3BZJVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 04:21:34 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:61455 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3BZJVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 04:21:32 -0500
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
Subject: [PATCH v2 1/4] Transform xyarray to linked list
Date: Tue, 26 Feb 2013 17:20:48 +0800
Message-Id: <1361870452-6143-2-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361870452-6143-1-git-send-email-chenggang.qin@gmail.com>
References: <1361870452-6143-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang <chenggang.qcg@taobao.com>

The 2-dimensional array cannot expand and shrink easily while we want to
response the thread's fork and exit events on-the-fly.
We transform xyarray to a 2-demesional linked list. The row is still a array,
but column is implemented as a list. The number of nodes in every row are same.
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
 tools/perf/util/xyarray.c |   85 +++++++++++++++++++++++++++++++++++++++++----
 tools/perf/util/xyarray.h |   25 +++++++++++--
 2 files changed, 101 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/xyarray.c b/tools/perf/util/xyarray.c
index 22afbf6..fc48bda 100644
--- a/tools/perf/util/xyarray.c
+++ b/tools/perf/util/xyarray.c
@@ -1,20 +1,93 @@
 #include "xyarray.h"
 #include "util.h"
 
-struct xyarray *xyarray__new(int xlen, int ylen, size_t entry_size)
+/*
+ * Add a column for all rows;
+ */
+int xyarray__append(struct xyarray *xy)
 {
-	size_t row_size = ylen * entry_size;
-	struct xyarray *xy = zalloc(sizeof(*xy) + xlen * row_size);
+	struct xyentry *new_entry;
+	unsigned int x;
+
+	for (x = 0; x < xy->row_count; x++) {
+		new_entry = zalloc(sizeof(*new_entry));
+		if (new_entry == NULL)
+			return -1;
+
+		new_entry->contents = zalloc(xy->entry_size);
+		if (new_entry->contents == NULL)
+			return -1;
 
-	if (xy != NULL) {
-		xy->entry_size = entry_size;
-		xy->row_size   = row_size;
+		list_add_tail(&new_entry->next, &xy->rows[x].head);
 	}
 
+	return 0;
+}
+
+struct xyarray *xyarray__new(int xlen, int ylen, size_t entry_size)
+{
+	struct xyarray *xy = zalloc(sizeof(*xy) + xlen * sizeof(struct row));
+	int i;
+
+	if (xy == NULL)
+		return NULL;
+
+	xy->row_count = xlen;
+	xy->entry_size = entry_size;
+
+	for (i = 0; i < xlen; i++)
+		INIT_LIST_HEAD(&xy->rows[i].head);
+
+	for (i = 0; i < ylen; i++)
+		if (xyarray__append(xy) < 0) {
+			xyarray__delete(xy);
+			return NULL;
+		}
+
 	return xy;
 }
 
+/*
+ * remove a column for all rows;
+ */
+int xyarray__remove(struct xyarray *xy, int y)
+{
+	struct xyentry *entry;
+	unsigned int x;
+	int count;
+
+	if (!xy)
+		return 0;
+
+	for (x = 0; x < xy->row_count; x++) {
+		count = 0;
+		list_for_each_entry(entry, &xy->rows[x].head, next)
+			if (count++ == y) {
+				list_del(&entry->next);
+				free(entry);
+				return 0;
+			}
+	}
+
+	return -1;
+}
+
+/*
+ * All nodes in every rows should be deleted before delete @xy.
+ */
 void xyarray__delete(struct xyarray *xy)
 {
+	unsigned int i;
+	struct xyentry *entry;
+
+	if (!xy)
+		return;
+
+	for (i = 0; i < xy->row_count; i++)
+		list_for_each_entry(entry, &xy->rows[i].head, next) {
+			list_del(&entry->next);
+			free(entry);
+		}
+
 	free(xy);
 }
diff --git a/tools/perf/util/xyarray.h b/tools/perf/util/xyarray.h
index c488a07..07fa370 100644
--- a/tools/perf/util/xyarray.h
+++ b/tools/perf/util/xyarray.h
@@ -2,19 +2,38 @@
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
+int xyarray__append(struct xyarray *xy);
+int xyarray__remove(struct xyarray *xy, int y);
 
 static inline void *xyarray__entry(struct xyarray *xy, int x, int y)
 {
-	return &xy->contents[x * xy->row_size + y * xy->entry_size];
+	struct xyentry *entry;
+	int columns = 0;
+
+	list_for_each_entry(entry, &xy->rows[x].head, next)
+		if (columns++ == y)
+			return entry->contents;
+
+	return NULL;
 }
 
 #endif /* _PERF_XYARRAY_H_ */
-- 
1.7.9.5

