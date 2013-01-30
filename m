Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3A3Ovu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:51:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57838 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab3A3OrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:47:14 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/21] perf tools: Stop using 'self' in strlist
Date: Wed, 30 Jan 2013 11:46:43 -0300
Message-Id: <1359557222-17547-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359557222-17547-1-git-send-email-acme@infradead.org>
References: <1359557222-17547-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

As suggested by tglx, 'self' should be replaced by something that is
more useful.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-933537sxtcz47qs0e0ledmrp@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/strlist.c | 54 +++++++++++++++++++++++------------------------
 tools/perf/util/strlist.h | 42 ++++++++++++++++++------------------
 2 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
index 155d8b7..55433aa 100644
--- a/tools/perf/util/strlist.c
+++ b/tools/perf/util/strlist.c
@@ -35,11 +35,11 @@ out_delete:
 	return NULL;
 }
 
-static void str_node__delete(struct str_node *self, bool dupstr)
+static void str_node__delete(struct str_node *snode, bool dupstr)
 {
 	if (dupstr)
-		free((void *)self->s);
-	free(self);
+		free((void *)snode->s);
+	free(snode);
 }
 
 static
@@ -59,12 +59,12 @@ static int strlist__node_cmp(struct rb_node *rb_node, const void *entry)
 	return strcmp(snode->s, str);
 }
 
-int strlist__add(struct strlist *self, const char *new_entry)
+int strlist__add(struct strlist *slist, const char *new_entry)
 {
-	return rblist__add_node(&self->rblist, new_entry);
+	return rblist__add_node(&slist->rblist, new_entry);
 }
 
-int strlist__load(struct strlist *self, const char *filename)
+int strlist__load(struct strlist *slist, const char *filename)
 {
 	char entry[1024];
 	int err;
@@ -80,7 +80,7 @@ int strlist__load(struct strlist *self, const char *filename)
 			continue;
 		entry[len - 1] = '\0';
 
-		err = strlist__add(self, entry);
+		err = strlist__add(slist, entry);
 		if (err != 0)
 			goto out;
 	}
@@ -107,56 +107,56 @@ struct str_node *strlist__find(struct strlist *slist, const char *entry)
 	return snode;
 }
 
-static int strlist__parse_list_entry(struct strlist *self, const char *s)
+static int strlist__parse_list_entry(struct strlist *slist, const char *s)
 {
 	if (strncmp(s, "file://", 7) == 0)
-		return strlist__load(self, s + 7);
+		return strlist__load(slist, s + 7);
 
-	return strlist__add(self, s);
+	return strlist__add(slist, s);
 }
 
-int strlist__parse_list(struct strlist *self, const char *s)
+int strlist__parse_list(struct strlist *slist, const char *s)
 {
 	char *sep;
 	int err;
 
 	while ((sep = strchr(s, ',')) != NULL) {
 		*sep = '\0';
-		err = strlist__parse_list_entry(self, s);
+		err = strlist__parse_list_entry(slist, s);
 		*sep = ',';
 		if (err != 0)
 			return err;
 		s = sep + 1;
 	}
 
-	return *s ? strlist__parse_list_entry(self, s) : 0;
+	return *s ? strlist__parse_list_entry(slist, s) : 0;
 }
 
-struct strlist *strlist__new(bool dupstr, const char *slist)
+struct strlist *strlist__new(bool dupstr, const char *list)
 {
-	struct strlist *self = malloc(sizeof(*self));
+	struct strlist *slist = malloc(sizeof(*slist));
 
-	if (self != NULL) {
-		rblist__init(&self->rblist);
-		self->rblist.node_cmp    = strlist__node_cmp;
-		self->rblist.node_new    = strlist__node_new;
-		self->rblist.node_delete = strlist__node_delete;
+	if (slist != NULL) {
+		rblist__init(&slist->rblist);
+		slist->rblist.node_cmp    = strlist__node_cmp;
+		slist->rblist.node_new    = strlist__node_new;
+		slist->rblist.node_delete = strlist__node_delete;
 
-		self->dupstr	 = dupstr;
-		if (slist && strlist__parse_list(self, slist) != 0)
+		slist->dupstr	 = dupstr;
+		if (slist && strlist__parse_list(slist, list) != 0)
 			goto out_error;
 	}
 
-	return self;
+	return slist;
 out_error:
-	free(self);
+	free(slist);
 	return NULL;
 }
 
-void strlist__delete(struct strlist *self)
+void strlist__delete(struct strlist *slist)
 {
-	if (self != NULL)
-		rblist__delete(&self->rblist);
+	if (slist != NULL)
+		rblist__delete(&slist->rblist);
 }
 
 struct str_node *strlist__entry(const struct strlist *slist, unsigned int idx)
diff --git a/tools/perf/util/strlist.h b/tools/perf/util/strlist.h
index dd9f922..5c7f870 100644
--- a/tools/perf/util/strlist.h
+++ b/tools/perf/util/strlist.h
@@ -17,34 +17,34 @@ struct strlist {
 };
 
 struct strlist *strlist__new(bool dupstr, const char *slist);
-void strlist__delete(struct strlist *self);
+void strlist__delete(struct strlist *slist);
 
-void strlist__remove(struct strlist *self, struct str_node *sn);
-int strlist__load(struct strlist *self, const char *filename);
-int strlist__add(struct strlist *self, const char *str);
+void strlist__remove(struct strlist *slist, struct str_node *sn);
+int strlist__load(struct strlist *slist, const char *filename);
+int strlist__add(struct strlist *slist, const char *str);
 
-struct str_node *strlist__entry(const struct strlist *self, unsigned int idx);
-struct str_node *strlist__find(struct strlist *self, const char *entry);
+struct str_node *strlist__entry(const struct strlist *slist, unsigned int idx);
+struct str_node *strlist__find(struct strlist *slist, const char *entry);
 
-static inline bool strlist__has_entry(struct strlist *self, const char *entry)
+static inline bool strlist__has_entry(struct strlist *slist, const char *entry)
 {
-	return strlist__find(self, entry) != NULL;
+	return strlist__find(slist, entry) != NULL;
 }
 
-static inline bool strlist__empty(const struct strlist *self)
+static inline bool strlist__empty(const struct strlist *slist)
 {
-	return rblist__empty(&self->rblist);
+	return rblist__empty(&slist->rblist);
 }
 
-static inline unsigned int strlist__nr_entries(const struct strlist *self)
+static inline unsigned int strlist__nr_entries(const struct strlist *slist)
 {
-	return rblist__nr_entries(&self->rblist);
+	return rblist__nr_entries(&slist->rblist);
 }
 
 /* For strlist iteration */
-static inline struct str_node *strlist__first(struct strlist *self)
+static inline struct str_node *strlist__first(struct strlist *slist)
 {
-	struct rb_node *rn = rb_first(&self->rblist.entries);
+	struct rb_node *rn = rb_first(&slist->rblist.entries);
 	return rn ? rb_entry(rn, struct str_node, rb_node) : NULL;
 }
 static inline struct str_node *strlist__next(struct str_node *sn)
@@ -59,21 +59,21 @@ static inline struct str_node *strlist__next(struct str_node *sn)
 /**
  * strlist_for_each      - iterate over a strlist
  * @pos:	the &struct str_node to use as a loop cursor.
- * @self:	the &struct strlist for loop.
+ * @slist:	the &struct strlist for loop.
  */
-#define strlist__for_each(pos, self)	\
-	for (pos = strlist__first(self); pos; pos = strlist__next(pos))
+#define strlist__for_each(pos, slist)	\
+	for (pos = strlist__first(slist); pos; pos = strlist__next(pos))
 
 /**
  * strlist_for_each_safe - iterate over a strlist safe against removal of
  *                         str_node
  * @pos:	the &struct str_node to use as a loop cursor.
  * @n:		another &struct str_node to use as temporary storage.
- * @self:	the &struct strlist for loop.
+ * @slist:	the &struct strlist for loop.
  */
-#define strlist__for_each_safe(pos, n, self)	\
-	for (pos = strlist__first(self), n = strlist__next(pos); pos;\
+#define strlist__for_each_safe(pos, n, slist)	\
+	for (pos = strlist__first(slist), n = strlist__next(pos); pos;\
 	     pos = n, n = strlist__next(n))
 
-int strlist__parse_list(struct strlist *self, const char *s);
+int strlist__parse_list(struct strlist *slist, const char *s);
 #endif /* __PERF_STRLIST_H */
-- 
1.8.1.1.361.gec3ae6e

