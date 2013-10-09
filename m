Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3JID13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 23:27:29 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:54992 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab3JID1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 23:27:05 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/3] perf util: Add findnew method to intlist - v2
Date: Tue,  8 Oct 2013 21:26:52 -0600
Message-Id: <1381289214-24885-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1381289214-24885-1-git-send-email-dsahern@gmail.com>
References: <1381289214-24885-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to other findnew based methods if the requested
object is not found, add it to the list.

v2: followed format of other findnew methods per acme's request

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/intlist.c |   22 ++++++++++++++++++----
 tools/perf/util/intlist.h |    1 +
 tools/perf/util/rblist.c  |   27 ++++++++++++++++++++++++---
 tools/perf/util/rblist.h  |    1 +
 4 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/intlist.c b/tools/perf/util/intlist.c
index 826d7b38c9a0..89715b64a315 100644
--- a/tools/perf/util/intlist.c
+++ b/tools/perf/util/intlist.c
@@ -58,22 +58,36 @@ void intlist__remove(struct intlist *ilist, struct int_node *node)
 	rblist__remove_node(&ilist->rblist, &node->rb_node);
 }
 
-struct int_node *intlist__find(struct intlist *ilist, int i)
+static struct int_node *__intlist__findnew(struct intlist *ilist,
+					   int i, bool create)
 {
-	struct int_node *node;
+	struct int_node *node = NULL;
 	struct rb_node *rb_node;
 
 	if (ilist == NULL)
 		return NULL;
 
-	node = NULL;
-	rb_node = rblist__find(&ilist->rblist, (void *)((long)i));
+	if (create)
+		rb_node = rblist__findnew(&ilist->rblist, (void *)((long)i));
+	else
+		rb_node = rblist__find(&ilist->rblist, (void *)((long)i));
+
 	if (rb_node)
 		node = container_of(rb_node, struct int_node, rb_node);
 
 	return node;
 }
 
+struct int_node *intlist__find(struct intlist *ilist, int i)
+{
+	return __intlist__findnew(ilist, i, false);
+}
+
+struct int_node *intlist__findnew(struct intlist *ilist, int i)
+{
+	return __intlist__findnew(ilist, i, true);
+}
+
 static int intlist__parse_list(struct intlist *ilist, const char *s)
 {
 	char *sep;
diff --git a/tools/perf/util/intlist.h b/tools/perf/util/intlist.h
index 0eb00ac39e01..aa6877d36858 100644
--- a/tools/perf/util/intlist.h
+++ b/tools/perf/util/intlist.h
@@ -24,6 +24,7 @@ int intlist__add(struct intlist *ilist, int i);
 
 struct int_node *intlist__entry(const struct intlist *ilist, unsigned int idx);
 struct int_node *intlist__find(struct intlist *ilist, int i);
+struct int_node *intlist__findnew(struct intlist *ilist, int i);
 
 static inline bool intlist__has_entry(struct intlist *ilist, int i)
 {
diff --git a/tools/perf/util/rblist.c b/tools/perf/util/rblist.c
index a16cdd2625ad..0dfe27d99458 100644
--- a/tools/perf/util/rblist.c
+++ b/tools/perf/util/rblist.c
@@ -48,10 +48,12 @@ void rblist__remove_node(struct rblist *rblist, struct rb_node *rb_node)
 	rblist->node_delete(rblist, rb_node);
 }
 
-struct rb_node *rblist__find(struct rblist *rblist, const void *entry)
+static struct rb_node *__rblist__findnew(struct rblist *rblist,
+					 const void *entry,
+					 bool create)
 {
 	struct rb_node **p = &rblist->entries.rb_node;
-	struct rb_node *parent = NULL;
+	struct rb_node *parent = NULL, *new_node = NULL;
 
 	while (*p != NULL) {
 		int rc;
@@ -67,7 +69,26 @@ struct rb_node *rblist__find(struct rblist *rblist, const void *entry)
 			return parent;
 	}
 
-	return NULL;
+	if (create) {
+		new_node = rblist->node_new(rblist, entry);
+		if (new_node) {
+			rb_link_node(new_node, parent, p);
+			rb_insert_color(new_node, &rblist->entries);
+			++rblist->nr_entries;
+		}
+	}
+
+	return new_node;
+}
+
+struct rb_node *rblist__find(struct rblist *rblist, const void *entry)
+{
+	return __rblist__findnew(rblist, entry, false);
+}
+
+struct rb_node *rblist__findnew(struct rblist *rblist, const void *entry)
+{
+	return __rblist__findnew(rblist, entry, true);
 }
 
 void rblist__init(struct rblist *rblist)
diff --git a/tools/perf/util/rblist.h b/tools/perf/util/rblist.h
index 6d0cae5ae83d..ff9913b994c2 100644
--- a/tools/perf/util/rblist.h
+++ b/tools/perf/util/rblist.h
@@ -32,6 +32,7 @@ void rblist__delete(struct rblist *rblist);
 int rblist__add_node(struct rblist *rblist, const void *new_entry);
 void rblist__remove_node(struct rblist *rblist, struct rb_node *rb_node);
 struct rb_node *rblist__find(struct rblist *rblist, const void *entry);
+struct rb_node *rblist__findnew(struct rblist *rblist, const void *entry);
 struct rb_node *rblist__entry(const struct rblist *rblist, unsigned int idx);
 
 static inline bool rblist__empty(const struct rblist *rblist)
-- 
1.7.10.1

