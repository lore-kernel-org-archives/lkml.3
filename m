Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab3AXUOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:14:38 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54100
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755768Ab3AXUIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:51 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 73/74] perf tools: Allow passing a list to intlist__new
Date: Thu, 24 Jan 2013 17:08:22 -0300
Message-Id: <1359058103-31645-74-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just like strlist allows passing a list of entries to parse.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-em50vqvvmlnc6k9tw4xtixus@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c  |  2 +-
 tools/perf/util/intlist.c | 27 ++++++++++++++++++++++++++-
 tools/perf/util/intlist.h |  2 +-
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e05ba81..7978c81 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -694,7 +694,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 		static struct intlist *seen;
 
 		if (!seen)
-			seen = intlist__new();
+			seen = intlist__new(NULL);
 
 		if (!intlist__has_entry(seen, event->ip.pid)) {
 			pr_err("Can't find guest [%d]'s kernel information\n",
diff --git a/tools/perf/util/intlist.c b/tools/perf/util/intlist.c
index cbf0c32..11a8d86 100644
--- a/tools/perf/util/intlist.c
+++ b/tools/perf/util/intlist.c
@@ -73,7 +73,26 @@ struct int_node *intlist__find(struct intlist *ilist, int i)
 	return node;
 }
 
-struct intlist *intlist__new(void)
+static int intlist__parse_list(struct intlist *ilist, const char *s)
+{
+	char *sep;
+	int err;
+
+	do {
+		long value = strtol(s, &sep, 10);
+		err = -EINVAL;
+		if (*sep != ',' && *sep != '\0')
+			break;
+		err = intlist__add(ilist, value);
+		if (err)
+			break;
+		s = sep + 1;
+	} while (*sep != '\0');
+
+	return err;
+}
+
+struct intlist *intlist__new(const char *slist)
 {
 	struct intlist *ilist = malloc(sizeof(*ilist));
 
@@ -82,9 +101,15 @@ struct intlist *intlist__new(void)
 		ilist->rblist.node_cmp    = intlist__node_cmp;
 		ilist->rblist.node_new    = intlist__node_new;
 		ilist->rblist.node_delete = intlist__node_delete;
+
+		if (slist && intlist__parse_list(ilist, slist))
+			goto out_delete;
 	}
 
 	return ilist;
+out_delete:
+	intlist__delete(ilist);
+	return NULL;
 }
 
 void intlist__delete(struct intlist *ilist)
diff --git a/tools/perf/util/intlist.h b/tools/perf/util/intlist.h
index 6d63ab9..62351da 100644
--- a/tools/perf/util/intlist.h
+++ b/tools/perf/util/intlist.h
@@ -15,7 +15,7 @@ struct intlist {
 	struct rblist rblist;
 };
 
-struct intlist *intlist__new(void);
+struct intlist *intlist__new(const char *slist);
 void intlist__delete(struct intlist *ilist);
 
 void intlist__remove(struct intlist *ilist, struct int_node *in);
-- 
1.8.1.1.361.gec3ae6e

